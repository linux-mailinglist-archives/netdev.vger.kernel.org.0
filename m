Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6C28A6F0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgJKKXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 06:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbgJKKX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 06:23:29 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F53C0613D2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o3so1229497pgr.11
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9mj0libdtn4DjGlhqdg+VrW4jvFWBMOCt7yJVWC7hWQ=;
        b=UMLbOUmYZwVGPv0n8OrcFLTfHWWpcuGzurh323vgvWd9uJAV/strtsr/OUwHVY6PVL
         be+QQRisMWTUd7AHRQjjFFW3m/OkaNovv+OYLdvHgVNcceP+uYrvgORRIRxGUGqu7zE+
         OmyuFzq14+eLFNAUbSRjcyBWIdNMalWQ4veOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9mj0libdtn4DjGlhqdg+VrW4jvFWBMOCt7yJVWC7hWQ=;
        b=qmh9CUKnPfvzRzAtAFH4PcgO0vlb1a+NmvHhGmiwvExgO3ErtTtZZyFs38EPpgsBCW
         ayANoefRzeaPhKk0qM8PnJcgKLk2mr9dDqWfHiywvncFDYJhIANLm5Ktu8lp6/PZF32j
         OpEgq3BXXoHZ9jqaBfoVeXTbz3MLu8eJ2+mXk8AnygtoC8WLXZ9wUap99aFbJCUNlNm/
         D6ohJOYXIvF76ml6drsy96s63no/zjlOPjFxttmwKw7DSE9etJG5BZbEuGwXW1nMnWeg
         KtKA84XkID58KzY48i8wAAVO2gMG7KwZwYC9IAHzyRmp20Dw6QorUipwp2f+SkIyRUGE
         lqbQ==
X-Gm-Message-State: AOAM533DjzX1ebsrR9FSLupcT7voWsivIrYhcE0DejiAxjkXTCL5Md2T
        O6dupDhgS/rEcDtXP3OpogbUJwokIB7NNA==
X-Google-Smtp-Source: ABdhPJxyJo2ErydNA0f7gBbmiVybMM+us27YTsjFicIKXW+VCWJi4qkjAR2YqOmfJiP7OsbsgCTWxg==
X-Received: by 2002:aa7:9f0f:0:b029:155:ef07:6ae0 with SMTP id g15-20020aa79f0f0000b0290155ef076ae0mr2710348pfr.70.1602411808089;
        Sun, 11 Oct 2020 03:23:28 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i1sm20155057pjh.52.2020.10.11.03.23.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 03:23:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 7/9] bnxt_en: Add bnxt_hwrm_nvm_get_dev_info() to query NVM info.
Date:   Sun, 11 Oct 2020 06:22:59 -0400
Message-Id: <1602411781-6012-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a2d49a05b162925d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a2d49a05b162925d

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add a new bnxt_hwrm_nvm_get_dev_info() to query firmware version
information via NVM_GET_DEV_INFO firmware command.  Use it to
get the running version of the NVM configuration information.

This new function will also be used in subsequent patches to get the
stored firmware versions.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c        | 12 ++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h        |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c    | 16 ++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h    |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2d6ecf1adbc5..55d96e3a69da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7562,6 +7562,16 @@ static int bnxt_hwrm_func_reset(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_RESET_TIMEOUT);
 }
 
+static void bnxt_nvm_cfg_ver_get(struct bnxt *bp)
+{
+	struct hwrm_nvm_get_dev_info_output nvm_info;
+
+	if (!bnxt_hwrm_nvm_get_dev_info(bp, &nvm_info))
+		snprintf(bp->nvm_cfg_ver, FW_VER_STR_LEN, "%d.%d.%d",
+			 nvm_info.nvm_cfg_ver_maj, nvm_info.nvm_cfg_ver_min,
+			 nvm_info.nvm_cfg_ver_upd);
+}
+
 static int bnxt_hwrm_queue_qportcfg(struct bnxt *bp)
 {
 	int rc = 0;
@@ -11223,6 +11233,8 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 		if (rc)
 			return rc;
 	}
+	bnxt_nvm_cfg_ver_get(bp);
+
 	rc = bnxt_hwrm_func_reset(bp);
 	if (rc)
 		return -ENODEV;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b208ff7c5d14..21ef1c21f602 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1856,6 +1856,7 @@ struct bnxt {
 #define PHY_VER_STR_LEN         (FW_VER_STR_LEN - BC_HWRM_STR_LEN)
 	char			fw_ver_str[FW_VER_STR_LEN];
 	char			hwrm_ver_supp[FW_VER_STR_LEN];
+	char			nvm_cfg_ver[FW_VER_STR_LEN];
 	u64			fw_ver_code;
 #define BNXT_FW_VER_CODE(maj, min, bld, rsv)			\
 	((u64)(maj) << 48 | (u64)(min) << 32 | (u64)(bld) << 16 | (rsv))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dcbb7b70d60a..53687bc7fcf5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2072,6 +2072,22 @@ static u32 bnxt_get_link(struct net_device *dev)
 	return bp->link_info.link_up;
 }
 
+int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
+			       struct hwrm_nvm_get_dev_info_output *nvm_dev_info)
+{
+	struct hwrm_nvm_get_dev_info_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_nvm_get_dev_info_input req = {0};
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_DEV_INFO, -1, -1);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		memcpy(nvm_dev_info, resp, sizeof(*resp));
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static void bnxt_print_admin_err(struct bnxt *bp)
 {
 	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 34f44ddfad79..fa6fbde52bea 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -92,6 +92,8 @@ u32 bnxt_get_rxfh_indir_size(struct net_device *dev);
 u32 _bnxt_fw_to_ethtool_adv_spds(u16, u8);
 u32 bnxt_fw_to_ethtool_speed(u16);
 u16 bnxt_get_fw_auto_link_speeds(u32);
+int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
+			       struct hwrm_nvm_get_dev_info_output *nvm_dev_info);
 int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 				 u32 install_type);
 void bnxt_ethtool_init(struct bnxt *bp);
-- 
2.18.1


--000000000000a2d49a05b162925d
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgHSVaOY2QF4lG
6cqU7isBVa9ynB3SqsudANU06S5Q22UwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDExMTAyMzI4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJMTaG6bLMgkDJIWs//j3MD7ov+qwn4q
M9d76yBePvFFj+q3XCPgZEjSeF+VOBI+ywhQu/0yrdZGwdyVJFtFEQ/v1nRLqCfIdBqQ3JA6xf6n
j/dgIYhinlEKyEnJCgf0ihw3rGX5JBzGrGscKmPx2iia/9VnGRzDo1Yb00lrc28KcnoO5IPggAs4
VpNSF22OL087kakauvVSWPJDxNMp8+C4oG3jd34n+phBkU2r6Em3bE5q+a51O5+m0X3SzCPEIpDK
V+7oVv05dfIxgK6JJfmaoxeqqc9Z0jWJ78yW5ZJIL8RMCft41ftft4ukkagqDy9Bgf6ug+nhu+n1
XqOrwDY=
--000000000000a2d49a05b162925d--
