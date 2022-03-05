Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8974CE3B5
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiCEI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiCEI4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:56:04 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B8B255F96
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:12 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q11so9755537pln.11
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ml7xun6dP/zJK3FYuN0f3n6jorU4OA2WLKALwDr2hms=;
        b=GMedcHfJ3BonoPIjeraOaqZDk+yzs54INvkqfGWaTjVV1d9Bef5cMUeJraBO2dXntc
         G5qvOva/tg7gLVWcEoIqArhp9+y/6z6IGD/+dIVSPAOGXAq5zPpayJLZBBdI7ngu4ad2
         LGjC8uxgHz58rJ6E+nF0HN93VT4D40qPX8ILI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ml7xun6dP/zJK3FYuN0f3n6jorU4OA2WLKALwDr2hms=;
        b=47zsDmNELLAgDx8SB9kHiNMH4AzaJ8Mt09HVADbIk8bU12TSPoIzA2sFecSVPVBXdM
         eCmMnUoDecY+ntp00jjxFYdrVUBZpg3Z/lDM+Em5J7wm91nX9RC8oYHRV1Zae8NZcHoj
         Htji4g1pTk6tiQuYcC+M0P2E4hQ+OzIZhpbcySIMwIzhSJPfA9bj/uZmWmQJZNHwo5nC
         AISPCVdUaC6Hxq0iRBr/tirz25qDE/aJzZhC7h/UaS3svuJsRGGXm8hZpb5H8BvA2Lbk
         ilymu4BG9K5GKNq1Bi9qXKhinzEAXSJNqxj06gObzTILK+H+ojWnJsGVHKHpU/pTHAGA
         Yrjw==
X-Gm-Message-State: AOAM533pzKG5fZEzw0TWVntemZmGaahNUjBE0hDh4mC+vGMWvuPllODy
        pASUeguuxd93TpUaoSwBg38HMA==
X-Google-Smtp-Source: ABdhPJzmCmwORmh32dycoT4UCN9gQ5Hz4fzpt5zmXkA0D82zk4iSmrpWOSoDjXcsRhHm6aqowqU3Ow==
X-Received: by 2002:a17:902:7805:b0:151:b8ec:202b with SMTP id p5-20020a170902780500b00151b8ec202bmr2406399pll.111.1646470511673;
        Sat, 05 Mar 2022 00:55:11 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:11 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 9/9] bnxt_en: add an nvm test for hw diagnose
Date:   Sat,  5 Mar 2022 03:54:42 -0500
Message-Id: <1646470482-13763-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000008e40f05d974ca07"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000008e40f05d974ca07

From: Vikas Gupta <vikas.gupta@broadcom.com>

Add an NVM test function for devlink hw reporter.
In this function an NVM VPD area is read followed by
a write. Test result is cached and if it is successful then
the next test can be conducted only after HW_RETEST_MIN_TIME to
avoid frequent writes to the NVM.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 20 ++++-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 82 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 22 ++---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  7 ++
 4 files changed, 113 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index fa0df43ddc1a..9dd878def3c2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1544,17 +1544,29 @@ struct bnxt_ctx_mem_info {
 };
 
 enum bnxt_hw_err {
-	BNXT_HW_STATUS_HEALTHY		= 0x0,
-	BNXT_HW_STATUS_NVM_WRITE_ERR	= 0x1,
-	BNXT_HW_STATUS_NVM_ERASE_ERR	= 0x2,
-	BNXT_HW_STATUS_NVM_UNKNOWN_ERR	= 0x3,
+	BNXT_HW_STATUS_HEALTHY			= 0x0,
+	BNXT_HW_STATUS_NVM_WRITE_ERR		= 0x1,
+	BNXT_HW_STATUS_NVM_ERASE_ERR		= 0x2,
+	BNXT_HW_STATUS_NVM_UNKNOWN_ERR		= 0x3,
+	BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR	= 0x4,
+	BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR	= 0x5,
+	BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR	= 0x6,
+	BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR	= 0x7,
 };
 
 struct bnxt_hw_health {
 	u32 nvm_err_address;
 	u32 nvm_write_errors;
 	u32 nvm_erase_errors;
+	u32 nvm_test_vpd_ent_errors;
+	u32 nvm_test_vpd_read_errors;
+	u32 nvm_test_vpd_write_errors;
+	u32 nvm_test_incmpl_errors;
 	u8 synd;
+	/* max a test in a day if previous test was successful */
+#define HW_RETEST_MIN_TIME	(1000 * 3600 * 24)
+	u8 nvm_test_result;
+	unsigned long nvm_test_timestamp;
 	struct devlink_health_reporter *hw_reporter;
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a802bbda1c27..77e55105d645 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -20,6 +20,7 @@
 #include "bnxt_ulp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_coredump.h"
+#include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
 
 static void __bnxt_fw_recover(struct bnxt *bp)
 {
@@ -263,20 +264,82 @@ static const char *hw_err_str(u8 synd)
 		return "nvm erase error";
 	case BNXT_HW_STATUS_NVM_UNKNOWN_ERR:
 		return "unrecognized nvm error";
+	case BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR:
+		return "nvm test vpd entry error";
+	case BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR:
+		return "nvm test vpd read error";
+	case BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR:
+		return "nvm test vpd write error";
+	case BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR:
+		return "nvm test incomplete error";
 	default:
 		return "unknown hw error";
 	}
 }
 
+static void bnxt_nvm_test(struct bnxt *bp)
+{
+	struct bnxt_hw_health *h = &bp->hw_health;
+	u32 datalen;
+	u16 index;
+	u8 *buf;
+
+	if (!h->nvm_test_result) {
+		if (!h->nvm_test_timestamp ||
+		    time_after(jiffies, h->nvm_test_timestamp +
+					msecs_to_jiffies(HW_RETEST_MIN_TIME)))
+			h->nvm_test_timestamp = jiffies;
+		else
+			return;
+	}
+
+	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
+				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
+				 &index, NULL, &datalen) || !datalen) {
+		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR;
+		h->nvm_test_vpd_ent_errors++;
+		return;
+	}
+
+	buf = kzalloc(datalen, GFP_KERNEL);
+	if (!buf) {
+		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR;
+		h->nvm_test_incmpl_errors++;
+		return;
+	}
+
+	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
+		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR;
+		h->nvm_test_vpd_read_errors++;
+		goto err;
+	}
+
+	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
+			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
+		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR;
+		h->nvm_test_vpd_write_errors++;
+	}
+
+err:
+	kfree(buf);
+}
+
 static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
 			    struct devlink_fmsg *fmsg,
 			    struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 	struct bnxt_hw_health *h = &bp->hw_health;
+	u8 synd = h->synd;
 	int rc;
 
-	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(h->synd));
+	bnxt_nvm_test(bp);
+	if (h->nvm_test_result) {
+		synd = h->nvm_test_result;
+		devlink_health_report(h->hw_reporter, hw_err_str(synd), NULL);
+	}
+
+	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(synd));
 	if (rc)
 		return rc;
 	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_write_errors", h->nvm_write_errors);
@@ -285,6 +348,23 @@ static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
 	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_erase_errors", h->nvm_erase_errors);
 	if (rc)
 		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_ent_errors",
+				       h->nvm_test_vpd_ent_errors);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_read_errors",
+				       h->nvm_test_vpd_read_errors);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_write_errors",
+				       h->nvm_test_vpd_write_errors);
+	if (rc)
+		return rc;
+	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_incomplete_errors",
+				       h->nvm_test_incmpl_errors);
+	if (rc)
+		return rc;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index eadaca42ed96..178074795b27 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2168,14 +2168,10 @@ static void bnxt_print_admin_err(struct bnxt *bp)
 	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
 }
 
-static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
-				u16 ext, u16 *index, u32 *item_length,
-				u32 *data_length);
-
-static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
-			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
-			    u32 dir_item_len, const u8 *data,
-			    size_t data_len)
+int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+		     u32 dir_item_len, const u8 *data,
+		     size_t data_len)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_nvm_write_input *req;
@@ -2819,8 +2815,8 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	return rc;
 }
 
-static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
-			       u32 length, u8 *data)
+int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
+			u32 length, u8 *data)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
@@ -2854,9 +2850,9 @@ static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
 	return rc;
 }
 
-static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
-				u16 ext, u16 *index, u32 *item_length,
-				u32 *data_length)
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+			 u16 ext, u16 *index, u32 *item_length,
+			 u32 *data_length)
 {
 	struct hwrm_nvm_find_dir_entry_output *output;
 	struct hwrm_nvm_find_dir_entry_input *req;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 6aa44840f13a..2593e0049582 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -56,6 +56,13 @@ int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type);
 int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
+int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal, u16 ext,
+			 u16 *index, u32 *item_length, u32 *data_length);
+int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
+			u32 length, u8 *data);
+int bnxt_flash_nvram(struct net_device *dev, u16 dir_type, u16 dir_ordinal,
+		     u16 dir_ext, u16 dir_attr, u32 dir_item_len,
+		     const u8 *data, size_t data_len);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
 
-- 
2.18.1


--00000000000008e40f05d974ca07
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILKTx6EQSZQdVIglq9N09ZHw7wJv9gBV
ksfdZKMsoKtpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAhR8P6mF7/dGXgZmcfFt+s1wff/u2RPAyV9n20MkwgdQv4uonf
1/xKv92Q+Q0RrvrqMW334Qd7bPHI+xn4bJNDHrZqg5RvjTUMSKMCsjBZx9m9IXiaa//UNpWSVVu/
pWBWZqB5YMofb1Cq00lFowwJd1DMbp53nhCXWQlviSYKenIeb73/6QdkMqwykpdil6BMcVrbGxgP
1JBBJsII+CW/y8cDJHl0B+Gev+H2zNNCgvicY/pKeHC8J0m0vfaUpA05rppythHGqVGxbyjqtjYp
/yvGbf6GpRIFc+FhngAlWU5bt2UUIlqjCemOIHqPtFWu8SXfSbn3Kr5yWXDHwZB/
--00000000000008e40f05d974ca07--
