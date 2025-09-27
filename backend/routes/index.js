const express = require('express');
const router = express.Router();

// 메인 랜딩 페이지
router.get('/', (req, res) => {
    res.render('landing_page', { layout: false });
});

// 메인 대시보드
router.get('/main', (req, res) => {
    res.render('main', {
        title: 'Pill Magician Dashboard',
        user: req.session.user
    });
});

// API 상태 확인
router.get('/health', (req, res) => {
    res.json({
        status: 'OK',
        timestamp: new Date().toISOString(),
        service: 'Pill Magician API'
    });
});

module.exports = router;