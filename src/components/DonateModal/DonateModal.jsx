/**
 * DonateModal.jsx - simple modal for donate QR
 */
import React from "react";
import "./DonateModal.styles.css";

export function DonateModal({ isOpen, onClose }) {
  if (!isOpen) return null;
  const imageUrl = "https://raw.githubusercontent.com/lenzcomvth/Somethings/refs/heads/main/qr.jpg";
  const content = "Nếu cảm thấy ứng dụng phù hợp với bạn, vui lòng ủng hộ mình ly cafe nhé!!!";
  return (
    <div className="dh-modal-overlay" role="dialog" aria-modal="true">
      <div className="dh-modal">
        <h2>Dạ Hành Studio — Donate</h2>
        <p>{content}</p>
        <img src={imageUrl} alt="Donate QR" style={{width:220}} />
        <div><button onClick={onClose}>Close</button></div>
      </div>
    </div>
  );
}
export default DonateModal;
