Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F2955EA22
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbiF1QrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiF1QpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:45:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDABDB8
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:43:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d17so12492923pfq.9
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gJYbDrQtsrz10NvJCgg4qlJNoGji+EiG7PVKTBqO3HE=;
        b=IZVjRlYWh+z+UN55Xz9C+eR/40G/kOJB3q1eyMF8fhs2ZX/QQcN70PqfTturOatmJ0
         PkyiUY+oY23ZKbWIOzR7RSVDJqtQmGaTv8oKKbQSpi5CUoSuFvYboZNv+HZihliCXZ1f
         SH7H/JL2ZeR+MBkMQOmv+fD5SwA53yTQKDe9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gJYbDrQtsrz10NvJCgg4qlJNoGji+EiG7PVKTBqO3HE=;
        b=4QlXdXP5T2rodLl4LPaVuLitDg7+MNooGOH5E5KL59HPWpEru/r5MyncTCNZ7O3uyA
         h4JX4YgSwodzcLskJUEwDBn3toEDI/m/j8NbKWAQxWz56OGR3xPOUwcGj2phTdO5cBc4
         vCRuJwu07K0JI38lOZXTn24tYPiv0v2PUviJTWwgh19CP1eZrHjj/9iNBmO0Ht0flq/7
         n6KDIrdY8YdKvZsi/kbHA2SM/HT5TFwx3uL/1TME8Zcp3tcNZlXWFw0FskwLmOGR+S/a
         Ik3XEYRghppUuaj/PXrkAZC7TPmysdalr9H/7SVWu4M6oS+7lI4NJU6rCIcSl+hLHiJm
         +2cg==
X-Gm-Message-State: AJIora9dYlvniiRnBlF+KeHZRtPPG2Rhzf7TCOZIISiJSdaCrh4bqLU4
        lnXMxL+PoQCQZtliT3UMRHELFg==
X-Google-Smtp-Source: AGRyM1uNdejCd65WOzIt0ueML3WG9HUWGUiNllUk+OIAnoHBv+m+SWGXPG0YwH/Yp9G4680cQYjACA==
X-Received: by 2002:a05:6a00:2292:b0:525:6c57:8dd5 with SMTP id f18-20020a056a00229200b005256c578dd5mr4445514pfe.17.1656434621014;
        Tue, 28 Jun 2022 09:43:41 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id mn9-20020a17090b188900b001ec9d45776bsm38248pjb.42.2022.06.28.09.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:43:40 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next v1 3/3] bnxt_en: implement callbacks for devlink selftests
Date:   Tue, 28 Jun 2022 22:12:41 +0530
Message-Id: <20220628164241.44360-4-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220628164241.44360-1-vikas.gupta@broadcom.com>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000033f88805e284bd6b"
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

--00000000000033f88805e284bd6b

Add callbacks
=============
.selftests_show: populates flash test name.
.selftests_run: implements a flash selftest.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3528ce9849e6..232e9b1ff1a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -20,6 +20,8 @@
 #include "bnxt_ulp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_coredump.h"
+#include "bnxt_nvm_defs.h"
+#include "bnxt_ethtool.h"
 
 static void __bnxt_fw_recover(struct bnxt *bp)
 {
@@ -610,6 +612,67 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
 	return rc;
 }
 
+static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
+{
+	u32 datalen;
+	u16 index;
+	u8 *buf;
+
+	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
+				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
+				 &index, NULL, &datalen) || !datalen) {
+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd entry error");
+		return false;
+	}
+
+	buf = kzalloc(datalen, GFP_KERNEL);
+	if (!buf) {
+		NL_SET_ERR_MSG_MOD(extack, "not sufficient memory for nvm test");
+		return false;
+	}
+
+	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd read error");
+		goto err;
+	}
+
+	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
+			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd write error");
+		goto err;
+	}
+
+	return true;
+
+err:
+	kfree(buf);
+	return false;
+}
+
+static int bnxt_dl_selftests_show(struct devlink *dl, struct sk_buff *msg,
+				  struct netlink_ext_ack *extack)
+{
+	return devlink_selftest_name_put(msg, DEVLINK_SELFTEST_FLASH_TEST_NAME);
+}
+
+static int bnxt_dl_selftests_run(struct devlink *dl, struct sk_buff *msg,
+				 u32 test_mask, struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	struct devlink_selftest_exec_info test;
+	int rc;
+
+	if (test_mask & DEVLINK_SELFTEST_FLASH) {
+		test.name = DEVLINK_SELFTEST_FLASH_TEST_NAME;
+		test.result = bnxt_nvm_test(bp, extack);
+		rc = devlink_selftest_result_put(msg, &test);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
@@ -622,6 +685,8 @@ static const struct devlink_ops bnxt_dl_ops = {
 	.reload_limits	  = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down	  = bnxt_dl_reload_down,
 	.reload_up	  = bnxt_dl_reload_up,
+	.selftests_show	  = bnxt_dl_selftests_show,
+	.selftests_run	  = bnxt_dl_selftests_run,
 };
 
 static const struct devlink_ops bnxt_vf_dl_ops;
@@ -1091,6 +1156,7 @@ static int bnxt_dl_nvm_param_set(struct devlink *dl, u32 id,
 	return bnxt_hwrm_nvm_req(bp, id, req, &ctx->val);
 }
 
+
 static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 				 union devlink_param_value val,
 				 struct netlink_ext_ack *extack)
-- 
2.31.1


--00000000000033f88805e284bd6b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPJx+IWLo7m8fllyvW+aVQnDo1nE9LPrJMuF
pEuPTCGUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDYyODE2
NDM0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQC0VU6ZMMC1UfIQJptX7hO8JkCrCHSSSD8q7ccAJU5giOaJLt1N5i73
Hrk/E6kyQcnINffLCmPH+uiPK7d3Bv+K7JjHSZqn6l3mCIusd42kgUNKejADnxO03/C71+c/pCBn
nrIxLGKXQt3kVtlS3ouwynzPVLY0qBtzmAeOP5RqaMUJZq6xJnmE7KX7Sw2rhMtDe2kzlGcN1xl7
Z/W1DpJpMmxwPOH4TIF7ajS+UfXhowLCLTNLv1rv2qpFIZbVGFqY7ZhMhMcjTxp2IbIZFn7Cv0kf
jtFuYBCCcz7/z+c52+VgVehRgcMf0vsVg6FFCHHbSxSe2AVPX9pcaqrUiW2r
--00000000000033f88805e284bd6b--
