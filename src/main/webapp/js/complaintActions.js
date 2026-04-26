/**
 * complaintActions.js
 * Handles AJAX requests for updating complaint status and provides smooth UI transitions.
 */

async function updateStatus(form, actionType) {
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);
    
    // Add visual feedback
    const btn = form.querySelector('button');
    const originalContent = btn.innerHTML;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
    btn.disabled = true;

    try {
        const response = await fetch('updateComplaint', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        });

        const result = await response.json();
        
        if (result.success) {
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: actionType === 'resolve' ? 'Issue marked as resolved.' : 'Update successful.',
                timer: 2000,
                showConfirmButton: false,
                background: 'rgba(255, 255, 255, 0.9)',
                backdrop: 'blur(4px)'
            }).then(() => {
                // Smoothly refresh part of the UI or just reload for now
                location.reload(); 
            });
        } else {
            throw new Error('Failed to update status');
        }
    } catch (error) {
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Something went wrong! Please try again.',
            background: 'rgba(255, 255, 255, 0.9)',
            backdrop: 'blur(4px)'
        });
        btn.innerHTML = originalContent;
        btn.disabled = false;
    }
}

// Intercept form submissions
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('form[action="updateComplaint"]').forEach(form => {
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            const action = form.querySelector('input[name="action"]').value;
            updateStatus(form, action === 'admin_fix' ? 'resolve' : 'update');
        });
    });
});
