Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C73FE298
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245025AbhIAS4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347177AbhIASyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:54:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584A2C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 11:53:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l3so238772pji.5
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 11:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=J29Lf+0hB2eYHDh6d9jblBEPSeeb0TyZUAXDMuNGCQE=;
        b=XjPjJClZ+i/UnPmNszKewyd+YmKwrKeOy6kE8EJIgvIvvNN1AZWtTHOFB09As0EM9V
         31l2cWQvKK1fSSCNczNBm3hN+267jFaFRjZJ/bJagV+8n5SEBsJOKnmzbJ/JVHIJLfWb
         Kcse7j3voqaA64X9KWQV5+02q/2tHcYF5kO3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=J29Lf+0hB2eYHDh6d9jblBEPSeeb0TyZUAXDMuNGCQE=;
        b=mpek6UUQtURfR6E9+Ep9q8a4qfXUWX5bHz7mVNcjb8UsCvTGJFlrRZSiD7xI5IXKvC
         J0Of0hKDYozckbme0eQt5Q/paWBl/yWIgJZr9H+JT5ipX/WhuDSk3qipZxAYtBE+Yrho
         j/5aQ6/CXWkdrlBxOsqI2BgC7nwj1HQQNbJcq5HMDF07fbdYGQiqCxtyiDekj8aAS6Pb
         5GneT4l4kIIjmyNyJLx3qZTKH6fSU8E3K8evK8GhAEVGM5KKe27T2dWv2Ua+fCj4TR7K
         qmLCZq1jVh5I6XibMM8x09Hr6rETVKiD0d8iwC6YJAlq3rH7k56rrtPK7Jrsfd6yCJVi
         VSFg==
X-Gm-Message-State: AOAM530hRz6G/B/OrM90NLxvYh4HizSHUgbYOA8NIz5pHzU7OQV8TAKO
        dly9zhZYGdj0+zru/7IgNw8qW38FcGKEaiQKqpN49ZbnS1lz8ePJp1//3EftRRb8RNYmqwpWeMZ
        NzyiA5908OenUEj36hm+z546bj/N9iaGFaW9OldlldDOGEnccd4kOuRm9PQ7w+HLZ66O17SyG
X-Google-Smtp-Source: ABdhPJyPSsJ+Zx0ewDk0uMzJpup9ZU/HSRRH7yPTGdksBhWwCN00S/+CxSIY0mz80rrU7tuGvmTXug==
X-Received: by 2002:a17:902:e9c6:b0:138:7942:a01a with SMTP id 6-20020a170902e9c600b001387942a01amr562339plk.14.1630522414447;
        Wed, 01 Sep 2021 11:53:34 -0700 (PDT)
Received: from hex.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p24sm449161pgm.54.2021.09.01.11.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 11:53:34 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        davem@davemloft.net, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net] bnxt_en: fix kernel doc warnings in bnxt_hwrm.c
Date:   Wed,  1 Sep 2021 11:53:15 -0700
Message-Id: <20210901185315.57137-1-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000057d48a05caf3951d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000057d48a05caf3951d
Content-Transfer-Encoding: 8bit

Parameter names in the comments did not match the function arguments.

Fixes: 213808170840 ("bnxt_en: add support for HWRM request slices")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index acef61abe35d..bb7327b82d0b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -145,11 +145,11 @@ void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout)
  * @bp: The driver context.
  * @req: The request for which calls to hwrm_req_dma_slice() will have altered
  *	allocation flags.
- * @flags: A bitmask of GFP flags. These flags are passed to
- *	dma_alloc_coherent() whenever it is used to allocate backing memory
- *	for slices. Note that calls to hwrm_req_dma_slice() will not always
- *	result in new allocations, however, memory suballocated from the
- *	request buffer is already __GFP_ZERO.
+ * @gfp: A bitmask of GFP flags. These flags are passed to dma_alloc_coherent()
+ *	whenever it is used to allocate backing memory for slices. Note that
+ *	calls to hwrm_req_dma_slice() will not always result in new allocations,
+ *	however, memory suballocated from the request buffer is already
+ *	__GFP_ZERO.
  *
  * Sets the GFP allocation flags associated with the request for subsequent
  * calls to hwrm_req_dma_slice(). This can be useful for specifying __GFP_ZERO
@@ -698,8 +698,8 @@ int hwrm_req_send_silent(struct bnxt *bp, void *req)
  * @bp: The driver context.
  * @req: The request for which indirect data will be associated.
  * @size: The size of the allocation.
- * @dma: The bus address associated with the allocation. The HWRM API has no
- *	knowledge about the type of the request and so cannot infer how the
+ * @dma_handle: The bus address associated with the allocation. The HWRM API has
+ *	no knowledge about the type of the request and so cannot infer how the
  *	caller intends to use the indirect data. Thus, the caller is
  *	responsible for configuring the request object appropriately to
  *	point to the associated indirect memory. Note, DMA handle has the
-- 
2.33.0


--00000000000057d48a05caf3951d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
CdFrNJPZh3pPkCH0IKX6CImmyf+CyRknDRWPFgQvGmDe4kLDdPKXPTfXE0pGT27moNdaDiXvUvxt
XeKr13glJBx57n5ozOGoTKmI3V/0Pm+lfngViwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUoRyjOYXxPkXMBZPbsbAaSBKr4MEwDQYJ
KoZIhvcNAQELBQADggEBALIQiUvJC5+niEMS+nj0JKY9DdbREqHy2QyKJokwEbvuTemRjzzAad8x
oFtYsqkKca5WMV9A7zKalx2I2pRFK7xU5CwvSmNyfULHPxHb9B9KPuZ0htbtYptYPuygXLS5UrU6
nAO/qVpSFm11J9qSg2Tf6jN7yyAx/HLoM8uxnF3csFNBVyLssCrOJIkzQfRVgccOkm4EheBIXZZ+
/rXxlnHpIINzM6psnEe5UxvnwD6al47UBF9KswS5uyI2kJWzVw2/5iDRmJn6dhhWah3W8KDsTBl0
Ubfa6OVikUM8sf9aZkU2j4JEpaSTHAAj6fRPAgBYM1E4CbU2QeL/wpDwlI4xggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwl1owS4QyKKm0xatYwDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJbDIYk903uWY1cNIVbvbRL/xXShkD4Vy/gBNe+Y
l/3HMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkwMTE4NTMz
NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQBZ9FpcCLXUzTjC6l3cViEaTXoPtsfzqCodS5kSbglAzVFegCExZA1fBFO8
zqQyNqNXxYS8vIPUOx7+3yqPQfizDG3d1U5ZmuJ0kvJZIEgLL3AXGZ+S6KCwPnw2ApF/KJEMAdZi
xJNyIX+k5BV5UvnCkYnRQS7GmeH+P8fXf9tKR09Z3O0i1LmCa0njvj9RxHUdhV8gurJsNZwHJoJf
aWAtm1tSZlzgFh22xBrOmZhDGBnzhReq43Uz07vhKbpm4bg9mSdnAOuYbWsyaa1I04r6ixg45W2/
5nIKYkQo33xyWBO4l7kRIdNW5nyzTgLyBLCE+11mvMi4uRFDIz0epxZm
--00000000000057d48a05caf3951d--
