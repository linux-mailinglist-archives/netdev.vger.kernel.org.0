Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A5456AAD1
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiGGSeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbiGGSeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:34:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35BA6D554
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:31:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d10so7296286pfd.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bdWhUvZsEHMlEHRdhzlfauXiaooZJYX0hfg30tAVuic=;
        b=Z3F8Gh+6ICnSc22SZXo90kd+eQ7hNvV6dPJXRKYt7jLWkIZkaNFGCcVgRcYZzlnKpy
         4AAX/wpMSuvGP05ts9k0j+yoyGt7EtnQT7Rbrau7kT8OOFE48mL72EgvZUaJLQ1q8FBC
         lrfRSnSo0lcR2a7c8qSjmcT3b+5/iZOZHdRoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bdWhUvZsEHMlEHRdhzlfauXiaooZJYX0hfg30tAVuic=;
        b=3gWYrHoqBbRwIqk2xx5LOmwIk01IitCKrTao+R4Uj2KI02jZIORO5dTMcgAuajmzkO
         4NDO6GdF6UsUfayqTS2O7D3WaGJXKi7c33M2knr1gJ6vj5owu5onmDAQrrmxb5ui5tGQ
         SgEWvI/fmY+xsDO030cv/Pah78elng985soVi9jzVKpzXuK/l+FZMt386AUnW32eE0Bw
         Do0EHWQcX2gHKmAxiq7XEc1ccZ12Y6+sqQrWd3kELA7AdENM/DSSml0v+7UYroU0qjeG
         hq7ThCluoAEOWEwg15qRyoGigyXpk/snCKrDbbl1K0gthrvFBYx5q2zZlR1xW4NYPnag
         NdKg==
X-Gm-Message-State: AJIora975Y+W4v5zfe9BM3bU3x9S9CqyUwZ1MeA01AiqA2jipUM4wq5c
        is/QCX6SxduvH0hbpykwEtJ/RA==
X-Google-Smtp-Source: AGRyM1u9aO7Dv1f9iC+Nw2bulLwdZmrnaVnuopt32G17yY2G8dMRELtpNRsQk5gDYwSd+qP0YbfH8A==
X-Received: by 2002:a17:90b:384f:b0:1ef:e95d:de66 with SMTP id nl15-20020a17090b384f00b001efe95dde66mr153917pjb.174.1657218704028;
        Thu, 07 Jul 2022 11:31:44 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e80900b0016a163d1cd5sm28631949plg.253.2022.07.07.11.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 11:31:43 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v2 3/3] devlink : update man page for new commands
Date:   Fri,  8 Jul 2022 00:01:16 +0530
Message-Id: <20220707183116.29422-4-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220707183116.29422-1-vikas.gupta@broadcom.com>
References: <20220628164447.45202-1-vikas.gupta@broadcom.com>
 <20220707183116.29422-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000031533405e33b4cf5"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000031533405e33b4cf5

Update the man page for newly added selftests commands.
Examples:
 devlink dev selftests run pci/0000:03:00.0 test flash
 devlink dev selftests show pci/0000:03:00.0

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 man/man8/devlink-dev.8 | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 6906e509..057551a8 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -85,6 +85,16 @@ devlink-dev \- devlink device configuration
 .I ID
 ]
 
+.ti -8
+.B devlink dev selftests show
+.I DEV
+
+.ti -8
+.B devlink dev selftests run
+.I DEV
+.B test
+.I TESTNAME
+
 .SH "DESCRIPTION"
 .SS devlink dev show - display devlink device attributes
 
@@ -249,6 +259,32 @@ should match the component names from
 .B "devlink dev info"
 and may be driver-dependent.
 
+.SS devlink dev selftests show - shows supported selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device.
+
+.SS devlink dev selftests run - runs selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device to execute selftests.
+
+.B test
+{
+.BI " TESTNAME "
+|
+.B " all "
+}
+- The value of
+.I TESTNAME
+should match the test names from
+.B "devlink dev selftests show".
+OR Pass option
+.B "all"
+to execute all the selftests on the devlink device.
+
 .SH "EXAMPLES"
 .PP
 devlink dev show
@@ -296,6 +332,16 @@ Flashing 100%
 .br
 Flashing done
 .RE
+.PP
+devlink dev selftests show pci/0000:01:00.0
+.RS 4
+Shows the supported selftests by the devlink device.
+.RE
+.PP
+devlink dev selftests run pci/0000:01:00.0 test flash
+.RS 4
+Perform a flash test on the devlink device.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.31.1


--00000000000031533405e33b4cf5
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDnMHtqO2uHc1hiFydOZEVFzBJcxT6evwgDu
RxHuLaEdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwNzE4
MzE0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQB6rdGC2PGlvCqg63rrKGH/e+5+e/B387nu4zyABNDc1DfUqnTZs6wc
g/Nx2SbDl85OnKzCHeIEgnsK1esdTwdpa/JT9Mb1StUdzVtaou1k06kWOFNZarwgIQh8PAAxagqO
co79Jt0ID0SzhDMEU9CntXPt5eYr8TYSi0R7YZYmvn7ZeHhZ4KssbXFq2k/He634DkcRflhNMk8X
1hjKG1ceySoJtGxNqZlvRlfkf70wck42aHQPd1TShHisSL5udCuytEQ4gJ3Cg91Nx6haPgwgihce
gtoulugmiYwt/QHeWWiKHDMNuuGuND+VF+zMjyxRrICTMV45/BpSVbh+HRKF
--00000000000031533405e33b4cf5--
