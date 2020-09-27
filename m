Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB427A216
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgI0Rm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgI0Rmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5E1C0613D6
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so6213729pgl.10
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aZ1GbgOwH8omN2xFMiKB6PH3qhsausqP8sBTOpb13Ts=;
        b=a9Pl0vXTgA31Tjsv2Bbbieri429nC7iigiSvGwdmWXHrKv6cAXjPSLdsB3HUxy0wEy
         9GBIbh61VOvRAPwxf+uNYwlj+d1JQNNPkNN5E/AVU1+WupkzjcjiyFYVE8xPwPO39R1Z
         EsYLh8oH8zH0oBGgBjmcJFUpMU9e4FQUwuyDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aZ1GbgOwH8omN2xFMiKB6PH3qhsausqP8sBTOpb13Ts=;
        b=G61IEfFxQIqxGdF2pQWVpjGCKfnrzBHLy4bnDr1088wioCxiM1+U7FYWnTyZuRTA5Q
         FmH/Ps55rTLTpjmVnR7wRDxraSNPZ+kGF3tlSrolfqtwtCvn0LaACEhzUOh9sL5wKG7T
         tuzp1sqtrGq3noFMYjp7OuGsvIs8J6UoveHbDAVcSGidKsY1clvCS4NC1eDhV6kFXZva
         yxfHsM2E8mlx0Ssvs7Q+iPlwXcRZYuZQINjCTYuoTQ8J0xwFqw6nmJ+DZxai5osw2Atk
         maPQ2HCsyn5KHfNIbvX6QClMkOhbSaSqDG7ChmrfyXyGNYfEp+csLYEgYQqu2hm8i5dO
         ORHw==
X-Gm-Message-State: AOAM5304DcHwIWkD6AOIkqW+QU1TKIKv3rj/zM7rnYnAmbmEGNYGCMaY
        NgxOZjzCzDckbYZZgZTFXx8LTQ==
X-Google-Smtp-Source: ABdhPJzCfi8jPIa1J0TM0+8zwJvefk/ISGUM6rL1smbQKPq769Gd6OR6Hhlq1wJNkicLmfzB4XCJaA==
X-Received: by 2002:a63:5825:: with SMTP id m37mr6497183pgb.64.1601228574479;
        Sun, 27 Sep 2020 10:42:54 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/11] bnxt_en: Report FEC settings to ethtool.
Date:   Sun, 27 Sep 2020 13:42:17 -0400
Message-Id: <1601228540-20852-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000693e4d05b04f1420"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000693e4d05b04f1420

Implement .get_fecparam() method to report the configured and active FEC
settings.  Also report the supported and advertised FEC settings to
the .get_link_ksettings() method.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 18 +++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 89 +++++++++++++++++++
 3 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a76ae6a68ca2..ab3b36deaf66 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8960,9 +8960,10 @@ static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	}
 
 	link_info->fec_cfg = PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED;
-	if (bp->hwrm_spec_code >= 0x10504)
+	if (bp->hwrm_spec_code >= 0x10504) {
 		link_info->fec_cfg = le16_to_cpu(resp->fec_cfg);
-
+		link_info->active_fec_sig_mode = resp->active_fec_signal_mode;
+	}
 	/* TODO: need to add more logic to report VF link */
 	if (chng_link_state) {
 		if (link_info->phy_link_status == BNXT_LINK_LINK)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index fbbc30288fa6..8a4c842ad06d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1215,10 +1215,26 @@ struct bnxt_link_info {
 	u16			force_pam4_link_speed;
 	u32			preemphasis;
 	u8			module_status;
+	u8			active_fec_sig_mode;
 	u16			fec_cfg;
+#define BNXT_FEC_NONE		PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED
+#define BNXT_FEC_AUTONEG_CAP	PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_SUPPORTED
 #define BNXT_FEC_AUTONEG	PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_ENABLED
+#define BNXT_FEC_ENC_BASE_R_CAP	\
+	PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_SUPPORTED
 #define BNXT_FEC_ENC_BASE_R	PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ENABLED
-#define BNXT_FEC_ENC_RS		PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED
+#define BNXT_FEC_ENC_RS_CAP	\
+	PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_SUPPORTED
+#define BNXT_FEC_ENC_LLRS_CAP	\
+	(PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_1XN_SUPPORTED |	\
+	 PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_IEEE_SUPPORTED)
+#define BNXT_FEC_ENC_RS		\
+	(PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED |	\
+	 PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ENABLED |	\
+	 PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_IEEE_ENABLED)
+#define BNXT_FEC_ENC_LLRS	\
+	(PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_1XN_ENABLED |	\
+	 PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_IEEE_ENABLED)
 
 	/* copy of requested setting from ethtool cmd */
 	u8			autoneg;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 4fdb672a47a0..3dc5d084db35 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/stringify.h>
 #include <linux/ethtool.h>
+#include <linux/linkmode.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
@@ -1533,6 +1534,27 @@ u32 _bnxt_fw_to_ethtool_adv_spds(u16 fw_speeds, u8 fw_pause)
 		(fw_speeds) |= BNXT_LINK_PAM4_SPEED_MSK_200GB;		\
 }
 
+static void bnxt_fw_to_ethtool_advertised_fec(struct bnxt_link_info *link_info,
+				struct ethtool_link_ksettings *lk_ksettings)
+{
+	u16 fec_cfg = link_info->fec_cfg;
+
+	if ((fec_cfg & BNXT_FEC_NONE) || !(fec_cfg & BNXT_FEC_AUTONEG)) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+				 lk_ksettings->link_modes.advertising);
+		return;
+	}
+	if (fec_cfg & BNXT_FEC_ENC_BASE_R)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+				 lk_ksettings->link_modes.advertising);
+	if (fec_cfg & BNXT_FEC_ENC_RS)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
+				 lk_ksettings->link_modes.advertising);
+	if (fec_cfg & BNXT_FEC_ENC_LLRS)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
+				 lk_ksettings->link_modes.advertising);
+}
+
 static void bnxt_fw_to_ethtool_advertised_spds(struct bnxt_link_info *link_info,
 				struct ethtool_link_ksettings *lk_ksettings)
 {
@@ -1545,6 +1567,7 @@ static void bnxt_fw_to_ethtool_advertised_spds(struct bnxt_link_info *link_info,
 	BNXT_FW_TO_ETHTOOL_SPDS(fw_speeds, fw_pause, lk_ksettings, advertising);
 	fw_speeds = link_info->advertising_pam4;
 	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, advertising);
+	bnxt_fw_to_ethtool_advertised_fec(link_info, lk_ksettings);
 }
 
 static void bnxt_fw_to_ethtool_lp_adv(struct bnxt_link_info *link_info,
@@ -1562,6 +1585,27 @@ static void bnxt_fw_to_ethtool_lp_adv(struct bnxt_link_info *link_info,
 	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, lp_advertising);
 }
 
+static void bnxt_fw_to_ethtool_support_fec(struct bnxt_link_info *link_info,
+				struct ethtool_link_ksettings *lk_ksettings)
+{
+	u16 fec_cfg = link_info->fec_cfg;
+
+	if (fec_cfg & BNXT_FEC_NONE) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+				 lk_ksettings->link_modes.supported);
+		return;
+	}
+	if (fec_cfg & BNXT_FEC_ENC_BASE_R_CAP)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+				 lk_ksettings->link_modes.supported);
+	if (fec_cfg & BNXT_FEC_ENC_RS_CAP)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
+				 lk_ksettings->link_modes.supported);
+	if (fec_cfg & BNXT_FEC_ENC_LLRS_CAP)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
+				 lk_ksettings->link_modes.supported);
+}
+
 static void bnxt_fw_to_ethtool_support_spds(struct bnxt_link_info *link_info,
 				struct ethtool_link_ksettings *lk_ksettings)
 {
@@ -1579,6 +1623,7 @@ static void bnxt_fw_to_ethtool_support_spds(struct bnxt_link_info *link_info,
 	    link_info->support_pam4_auto_speeds)
 		ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
 						     Autoneg);
+	bnxt_fw_to_ethtool_support_fec(link_info, lk_ksettings);
 }
 
 u32 bnxt_fw_to_ethtool_speed(u16 fw_link_speed)
@@ -1836,6 +1881,49 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 	return rc;
 }
 
+static int bnxt_get_fecparam(struct net_device *dev,
+			     struct ethtool_fecparam *fec)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_link_info *link_info;
+	u8 active_fec;
+	u16 fec_cfg;
+
+	link_info = &bp->link_info;
+	fec_cfg = link_info->fec_cfg;
+	active_fec = link_info->active_fec_sig_mode &
+		     PORT_PHY_QCFG_RESP_ACTIVE_FEC_MASK;
+	if (fec_cfg & BNXT_FEC_NONE) {
+		fec->fec = ETHTOOL_FEC_NONE;
+		fec->active_fec = ETHTOOL_FEC_NONE;
+		return 0;
+	}
+	if (fec_cfg & BNXT_FEC_AUTONEG)
+		fec->fec |= ETHTOOL_FEC_AUTO;
+	if (fec_cfg & BNXT_FEC_ENC_BASE_R)
+		fec->fec |= ETHTOOL_FEC_BASER;
+	if (fec_cfg & BNXT_FEC_ENC_RS)
+		fec->fec |= ETHTOOL_FEC_RS;
+	if (fec_cfg & BNXT_FEC_ENC_LLRS)
+		fec->fec |= ETHTOOL_FEC_LLRS;
+
+	switch (active_fec) {
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_CLAUSE74_ACTIVE:
+		fec->active_fec |= ETHTOOL_FEC_BASER;
+		break;
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_CLAUSE91_ACTIVE:
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS544_1XN_ACTIVE:
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS544_IEEE_ACTIVE:
+		fec->active_fec |= ETHTOOL_FEC_RS;
+		break;
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_1XN_ACTIVE:
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE:
+		fec->active_fec |= ETHTOOL_FEC_LLRS;
+		break;
+	}
+	return 0;
+}
+
 static void bnxt_get_pauseparam(struct net_device *dev,
 				struct ethtool_pauseparam *epause)
 {
@@ -3741,6 +3829,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
+	.get_fecparam		= bnxt_get_fecparam,
 	.get_pause_stats	= bnxt_get_pause_stats,
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
-- 
2.18.1


--000000000000693e4d05b04f1420
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg9SqpNIZEfNHA
gVDyyLkKv1oPN/WXx2KSyJLQO+ZWlzwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjU0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE+IFtAPLR1NaVMj6vSGvDmX0rd7iEVv
D4Vpb8jvSenhqwzaAgrxD7dC7K4grrZp1NhAv+eov44MaIvLe4SZAJdJOzGpjV7LppciNr49E27L
NsM2MmqEyZ5mSCibLIsgSIvOrc/oaJCZSs+DVuZVLNot50G5LvseMR0Kbsn+LjcTWug+t4oMN5zC
KczR3/gOyPlBLm4Owda2lrl6P1VrZejn0ME+2fx00qCnpKQYgmP+/y1/8X163STipX784XFmoDAb
D+z93meKGjOJFgcwkz7PmmXNMCFhbIuoZ3LsH/637gCnO7vvqDLjw5sjtZj8e1E542CSB5Bz9sUA
qoUIkCs=
--000000000000693e4d05b04f1420--
