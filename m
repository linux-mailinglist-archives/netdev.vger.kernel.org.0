Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FC127A218
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgI0RnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0Rm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D242C0613D8
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:57 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so2312705pjg.1
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P8moafohodvgUhgB227QeMXFdVJ1CEl9bGhUi/mqvgo=;
        b=IgX1OUS7hBrUu+eBGdEYfcjX30gfWNV6MaS4+xTMMsHBvp4t9Xdgt2bfPh3UAi6VfK
         icamnfViJdHqqG/BNobpPKwgfHLoF8FwxjPdKXQWVyUz4yjJO4Z5vIHVyst0HDTb5rAD
         ApMpQqH57A8+UpFQj+IDjVdMlN1/Vg72G+dRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P8moafohodvgUhgB227QeMXFdVJ1CEl9bGhUi/mqvgo=;
        b=XxPrxYtUzvbRZpbEwiCryKXuVojE4tpRl/Kns+b+VK6aVkptn/TfCZScFPCdKtOMIM
         xQgsqIL49AyOLaIVWSOpZnamyWkJSIkDtFJQdEwQKQs160feD+mm+1PNpL31W3jdSMio
         A9kmYjumvudXInKS9FvpLboHDGYVzDlrGqkizLEQxg1IW8mMbUTijLOzGVuy/G341Icz
         eq+Sqi/yvIYrWxEvD8l9m7RiAiNQ41+dGZAO6Qt6EpkYjJY+/a/1NtDThS2HbJxMSBO5
         +23as/6GMIGlloQaSvD3XlZJWhw7iSXOWPp/uzjaZbC6zpH5dPC9FiUih0xbBFj2DGNN
         dCCQ==
X-Gm-Message-State: AOAM533E4MFG3PM6C0jx16SYA5Ub+EhdyyL0YGZfOhAP87e+X3YXhGTO
        QU8F4KB4ae8XlY1iru1hYE2YWEmu3OhhDg==
X-Google-Smtp-Source: ABdhPJw25TdbHHJOUpKIeYxsRqkC9xxZYdzZcQN+ga1QSmMmauhqy75BOY0TV5SFmpKUr+2pY53jng==
X-Received: by 2002:a17:902:59c1:b029:d2:6392:3b76 with SMTP id d1-20020a17090259c1b02900d263923b76mr8248900plj.39.1601228576441;
        Sun, 27 Sep 2020 10:42:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:56 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/11] bnxt_en: Implement ethtool set_fec_param() method.
Date:   Sun, 27 Sep 2020 13:42:19 -0400
Message-Id: <1601228540-20852-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000087ddd705b04f147f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000087ddd705b04f147f

This feature allows the user to set the different FEC modes on the NIC
port.  Any new setting will take effect immediately after a link toggle.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 44 +++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 62 +++++++++++++++++++
 3 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 834f64f5f4d6..38bbd7631fca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8890,7 +8890,7 @@ static bool bnxt_support_dropped(u16 advertising, u16 supported)
 	return ((supported | diff) != supported);
 }
 
-static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
+int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 {
 	int rc = 0;
 	struct bnxt_link_info *link_info = &bp->link_info;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 8a4c842ad06d..74387259e1c6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1259,6 +1259,49 @@ struct bnxt_link_info {
 	struct hwrm_port_phy_qcfg_output phy_qcfg_resp;
 };
 
+#define BNXT_FEC_RS544_ON					\
+	 (PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_ENABLE |		\
+	  PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_IEEE_ENABLE)
+
+#define BNXT_FEC_RS544_OFF					\
+	 (PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_DISABLE |	\
+	  PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_IEEE_DISABLE)
+
+#define BNXT_FEC_RS272_ON					\
+	 (PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_1XN_ENABLE |		\
+	  PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_IEEE_ENABLE)
+
+#define BNXT_FEC_RS272_OFF					\
+	 (PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_1XN_DISABLE |	\
+	  PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_IEEE_DISABLE)
+
+#define BNXT_PAM4_SUPPORTED(link_info)				\
+	((link_info)->support_pam4_speeds)
+
+#define BNXT_FEC_RS_ON(link_info)				\
+	(PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE |		\
+	 PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE |		\
+	 (BNXT_PAM4_SUPPORTED(link_info) ?			\
+	  (BNXT_FEC_RS544_ON | BNXT_FEC_RS272_OFF) : 0))
+
+#define BNXT_FEC_LLRS_ON					\
+	(PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE |		\
+	 PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE |		\
+	 BNXT_FEC_RS272_ON | BNXT_FEC_RS544_OFF)
+
+#define BNXT_FEC_RS_OFF(link_info)				\
+	(PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_DISABLE |		\
+	 (BNXT_PAM4_SUPPORTED(link_info) ?			\
+	  (BNXT_FEC_RS544_OFF | BNXT_FEC_RS272_OFF) : 0))
+
+#define BNXT_FEC_BASE_R_ON(link_info)				\
+	(PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_ENABLE |		\
+	 BNXT_FEC_RS_OFF(link_info))
+
+#define BNXT_FEC_ALL_OFF(link_info)				\
+	(PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE |		\
+	 BNXT_FEC_RS_OFF(link_info))
+
 #define BNXT_MAX_QUEUE	8
 
 struct bnxt_queue_info {
@@ -2125,6 +2168,7 @@ int bnxt_get_avail_msix(struct bnxt *bp, int num);
 int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init);
 void bnxt_tx_disable(struct bnxt *bp);
 void bnxt_tx_enable(struct bnxt *bp);
+int bnxt_update_link(struct bnxt *bp, bool chng_link_state);
 int bnxt_hwrm_set_pause(struct bnxt *);
 int bnxt_hwrm_set_link_setting(struct bnxt *, bool, bool);
 int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 3dc5d084db35..0d9fe14646f7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1924,6 +1924,67 @@ static int bnxt_get_fecparam(struct net_device *dev,
 	return 0;
 }
 
+static u32 bnxt_ethtool_forced_fec_to_fw(struct bnxt_link_info *link_info,
+					 u32 fec)
+{
+	u32 fw_fec = PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE;
+
+	if (fec & ETHTOOL_FEC_BASER)
+		fw_fec |= BNXT_FEC_BASE_R_ON(link_info);
+	else if (fec & ETHTOOL_FEC_RS)
+		fw_fec |= BNXT_FEC_RS_ON(link_info);
+	else if (fec & ETHTOOL_FEC_LLRS)
+		fw_fec |= BNXT_FEC_LLRS_ON;
+	return fw_fec;
+}
+
+static int bnxt_set_fecparam(struct net_device *dev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct hwrm_port_phy_cfg_input req = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_link_info *link_info;
+	u32 new_cfg, fec = fecparam->fec;
+	u16 fec_cfg;
+	int rc;
+
+	link_info = &bp->link_info;
+	fec_cfg = link_info->fec_cfg;
+	if (fec_cfg & BNXT_FEC_NONE)
+		return -EOPNOTSUPP;
+
+	if (fec & ETHTOOL_FEC_OFF) {
+		new_cfg = PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE |
+			  BNXT_FEC_ALL_OFF(link_info);
+		goto apply_fec;
+	}
+	if (((fec & ETHTOOL_FEC_AUTO) && !(fec_cfg & BNXT_FEC_AUTONEG_CAP)) ||
+	    ((fec & ETHTOOL_FEC_RS) && !(fec_cfg & BNXT_FEC_ENC_RS_CAP)) ||
+	    ((fec & ETHTOOL_FEC_LLRS) && !(fec_cfg & BNXT_FEC_ENC_LLRS_CAP)) ||
+	    ((fec & ETHTOOL_FEC_BASER) && !(fec_cfg & BNXT_FEC_ENC_BASE_R_CAP)))
+		return -EINVAL;
+
+	if (fec & ETHTOOL_FEC_AUTO) {
+		if (!link_info->autoneg)
+			return -EINVAL;
+		new_cfg = PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_ENABLE;
+	} else {
+		new_cfg = bnxt_ethtool_forced_fec_to_fw(link_info, fec);
+	}
+
+apply_fec:
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_PHY_CFG, -1, -1);
+	req.flags = cpu_to_le32(new_cfg | PORT_PHY_CFG_REQ_FLAGS_RESET_PHY);
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	/* update current settings */
+	if (!rc) {
+		mutex_lock(&bp->link_lock);
+		bnxt_update_link(bp, false);
+		mutex_unlock(&bp->link_lock);
+	}
+	return rc;
+}
+
 static void bnxt_get_pauseparam(struct net_device *dev,
 				struct ethtool_pauseparam *epause)
 {
@@ -3830,6 +3891,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
 	.get_fecparam		= bnxt_get_fecparam,
+	.set_fecparam		= bnxt_set_fecparam,
 	.get_pause_stats	= bnxt_get_pause_stats,
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
-- 
2.18.1


--00000000000087ddd705b04f147f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgaEAqHAZ2UZmW
MxTp68wB+6dbASVLKkPIU+j1eG/rvEUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjU2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGJD6EfaMdCqoWZZR8QuqEO9IkAagumy
WLI8lwZvU9YB3dcRQ/+8mw3TAP5QUzV85jEfKl3wLDmtfGC/84YnOgxzcCXDZOF7QUwajCydWOXy
SCzQR0Q7eQ5MRyrucwEw48xL5TsEpNvd+kYZl439vet+lXjoBZPao8wPn9JvzabHhVlO6AWZpzPR
gJDgUI0oxcLwoGZpb5CZ9gy1t/Bn9ihtnbVDoVCWt8YwIfcSDkYna4ZUWruKTn5ZZpv+v0lwxI6z
aaDjomCiZLqwThYu/tv6kjGQAZJmYwLaBOAgGSggbYdrn09Y9cKEMWIXNoQoshbFWi7N/jr2Rbmf
4XMA5Go=
--00000000000087ddd705b04f147f--
