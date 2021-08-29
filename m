Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBD33FA9F9
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhH2Hgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhH2HgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B857C061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:33 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g22so16560630edy.12
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VxWKnh1dLp0dZoH9sLUrmEv+ZgBnJFbTlVC89TwKsWc=;
        b=Y8fvcb5WrhwN3PTKVQdNaB/88QEkrQrcQuoC6wmfCBoFqdbMVqlRqcGQp+oFNWndxW
         NeHYJhLR2CJL8Ypc1Co1Z0EjHzveGjXSuvZNbzazqSdMaAH/Ez/UeNm8JGLVEf+SADtc
         QwozHuHm35cok+y8c4RTeCs1T3SOits6vLFnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VxWKnh1dLp0dZoH9sLUrmEv+ZgBnJFbTlVC89TwKsWc=;
        b=uiY8BE9BDvdagR/MCl9f7gLRF4uqeQJYjIUXzavMUwXVCzmHMK37evZLKfh4olX2hI
         UbUQLotdPQbAbXI+/GvjSpMLs7ZV4vSNs8czNNt4iEbDFeYb0akZlEM9DKQK6j9IiODn
         0XY6jJD8VSNyYtQVMRPCLUZL27lltmoZrJHLuzBypd/zPrX2X2Ni18LBUrAWEGWDghf9
         A5R5VTlMOumQb4tzB+SCjsBtGJijMTO6uKNaPGmA7c4CxqTD6D5UcCSEigL58P5P6nMF
         spBTFqDiIK0hVazPwN5XqNsJX30NsnyEEJaXlhuiDTMFjYhs0KohSys7m/a4KU+5iaQh
         g5Bw==
X-Gm-Message-State: AOAM5323+J4B7XorEaw7Dv5hOeUHyxibQgP0RVyapuPIxi6EMwn9GZrQ
        0jBqZFs4fIYC9PYUU5hzwOhpnAopVfhGbw==
X-Google-Smtp-Source: ABdhPJxkFeG1w9Ywu25bDn59W363fCczVq5ssiNWjhN1oZ2fgZ/HizDugYSkai5GmnrvTLW0LV9MXQ==
X-Received: by 2002:a05:6402:2751:: with SMTP id z17mr18054443edd.290.1630222531541;
        Sun, 29 Aug 2021 00:35:31 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 06/11] bnxt_en: add HWRM request assignment API
Date:   Sun, 29 Aug 2021 03:35:01 -0400
Message-Id: <1630222506-19532-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000edd3c405caadc264"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000edd3c405caadc264

From: Edwin Peer <edwin.peer@broadcom.com>

hwrm_req_replace() provides an assignment like operation to replace a
managed HWRM request object with data from a pre-built source. This is
useful for handling request data provided by higher layer HWRM clients.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 55 +++++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |  1 +
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 621daf687a00..39ef65025e17 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -147,6 +147,61 @@ void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout)
 		ctx->timeout = timeout;
 }
 
+/**
+ * hwrm_req_replace() - Replace request data.
+ * @bp: The driver context.
+ * @req: The request to modify. A call to hwrm_req_replace() is conceptually
+ *	an assignment of new_req to req. Subsequent calls to HWRM API functions,
+ *	such as hwrm_req_send(), should thus use req and not new_req (in fact,
+ *	calls to HWRM API functions will fail if non-managed request objects
+ *	are passed).
+ * @len: The length of new_req.
+ * @new_req: The pre-built request to copy or reference.
+ *
+ * Replaces the request data in req with that of new_req. This is useful in
+ * scenarios where a request object has already been constructed by a third
+ * party prior to creating a resource managed request using hwrm_req_init().
+ * Depending on the length, hwrm_req_replace() will either copy the new
+ * request data into the DMA memory allocated for req, or it will simply
+ * reference the new request and use it in lieu of req during subsequent
+ * calls to hwrm_req_send(). The resource management is associated with
+ * req and is independent of and does not apply to new_req. The caller must
+ * ensure that the lifetime of new_req is least as long as req.
+ *
+ * Return: zero on success, negative error code otherwise:
+ *     E2BIG: Request is too large.
+ *     EINVAL: Invalid request to modify.
+ */
+int hwrm_req_replace(struct bnxt *bp, void *req, void *new_req, u32 len)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+	struct input *internal_req = req;
+	u16 req_type;
+
+	if (!ctx)
+		return -EINVAL;
+
+	if (len > BNXT_HWRM_CTX_OFFSET)
+		return -E2BIG;
+
+	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) || len > BNXT_HWRM_MAX_REQ_LEN) {
+		memcpy(internal_req, new_req, len);
+	} else {
+		internal_req->req_type = ((struct input *)new_req)->req_type;
+		ctx->req = new_req;
+	}
+
+	ctx->req_len = len;
+	ctx->req->resp_addr = cpu_to_le64(ctx->dma_handle +
+					  BNXT_HWRM_RESP_OFFSET);
+
+	/* update sentinel for potentially new request type */
+	req_type = le16_to_cpu(internal_req->req_type);
+	ctx->sentinel = hwrm_calc_sentinel(ctx, req_type);
+
+	return 0;
+}
+
 /**
  * hwrm_req_flags() - Set non internal flags of the ctx
  * @bp: The driver context.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 199c646f5e71..c58d84cc692a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -139,4 +139,5 @@ void hwrm_req_flags(struct bnxt *bp, void *req, enum bnxt_hwrm_ctx_flags flags);
 void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout);
 int hwrm_req_send(struct bnxt *bp, void *req);
 int hwrm_req_send_silent(struct bnxt *bp, void *req);
+int hwrm_req_replace(struct bnxt *bp, void *req, void *new_req, u32 len);
 #endif
-- 
2.18.1


--000000000000edd3c405caadc264
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDBB5T5jqFt6c/NEwmzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE0MTRaFw0yMjA5MjIxNDQzNDhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBANtwBQrLJBrTcbQ1kmjdo+NJT2hFaBFsw1IOi34uVzWz21AZUqQkNVktkT740rYuB1m1No7W
EBvfLuKxbgQO2pHk9mTUiTHsrX2CHIw835Du8Co2jEuIqAsocz53NwYmk4Sj0/HqAfxgtHEleK2l
CR56TX8FjvCKYDsIsXIjMzm3M7apx8CQWT6DxwfrDBu607V6LkfuHp2/BZM2GvIiWqy2soKnUqjx
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJn0HunH8xW52eg9go2fPTzqLLxLdzS+
Xox8Ie7T1Ic6MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzUzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCLPumsOK8wuJXKyVoqXHTm2iIPqKX3wTgA3hBJiFq39wT/OWT+
4mq4i94I134BFCjupqcmbs9DOi93nVZctmliqf5itUhaczIs5I2Kaofk6+Ju9qlTK2Mvo4r+Fu0j
ornvScvYdhLC3XovDdLbtS0pNf7zx5oGgiX0fPIhUk41USadprFZDOkyktEedb2FutjC8Kt/FnWw
9lu7ulvl42xe2rng+L4fmDQV2x9aIwPu8/lhWONAOZ1Z/MeAsPQtJWt+VktSdFGYdvd0sSwD/Nh9
5oxpQfFQqNyEkzhQAMqDVCht5Psz9YWcmWDlHt+BMvwBGWnYantr1TQ+flqgnNsv
--000000000000edd3c405caadc264--
