Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE30584E98
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiG2KSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiG2KSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:18:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224A88245F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:18:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ha11so4448612pjb.2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SL2jinXZKbV1heGV3LoHvbJ/s1ECD4f257qw4IZhXSQ=;
        b=DWZApZwku1Vul+IukJXtSW/X2WeWqhE7U/jSAqyVYYtucxf/KAlHuDWYVGxQEVctVP
         8XQnUmCeAm90fwClAHhUymF6c3MQ/6FoyS3LTEriHF9OwVNvqfGQaMYvQ2OppKSAX8pe
         Y0nEw4S+t3aOVTJ48cp87W/1TiB6t/fQh6ljA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SL2jinXZKbV1heGV3LoHvbJ/s1ECD4f257qw4IZhXSQ=;
        b=6Vd0ATuOOwhTfbtwxncE/apCn0o3L46vyrT/N/XoKzn+iMcXXG/r3FO/SIRXVwuGKr
         jSsRdVWUP5v3Hq345JhFlx+ZyCkfdn7EefkLKoe4gluCWWT9VmacMOI0kkKN6zK5vFED
         TN0CcNHUmQw4k5OTu+htw48L3E9umAC4ALfEAM8EpTNw74u2pAVzDr+QMWfsELRS6RtN
         vBZwOkcBwDrHKYQ0sezylaTe37baW24KRibMmcb9UHlF8E1xsHqHetoT564ZxMCFe69O
         4Ajkp0iiiGyV033d8Q0mmH5WxIQdpMh6u+ygj6BDXgMABTFjTmOnR6PO2WwSu2LMIopE
         ZCGg==
X-Gm-Message-State: ACgBeo3UDHHjTr72iAj/sSV6Ou+kntUl/KO97dgoabQyp06Tvh1my/SD
        saqRmRXmj6tcTcbb/Grunf8+mw==
X-Google-Smtp-Source: AA6agR4syoJ7QdmOAXiNTotd63h7Z0qtEx3XQzvUS42Xu0+vptP3z5Ds+qegv0vpuzAMyz1/3Ii4Lw==
X-Received: by 2002:a17:902:7c88:b0:16c:5301:8a52 with SMTP id y8-20020a1709027c8800b0016c53018a52mr3250756pll.95.1659089925260;
        Fri, 29 Jul 2022 03:18:45 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ik24-20020a170902ab1800b0016dc6243bb2sm3141727plb.143.2022.07.29.03.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 03:18:44 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v4 3/3] devlink : update man page and bash-completion for new commands
Date:   Fri, 29 Jul 2022 15:48:21 +0530
Message-Id: <20220729101821.48180-4-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220729101821.48180-1-vikas.gupta@broadcom.com>
References: <20220729101821.48180-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ae144d05e4eef90b"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ae144d05e4eef90b

Update the man page for newly added selftests commands.
Examples:
 devlink dev selftests run pci/0000:03:00.0 id flash
 devlink dev selftests show pci/0000:03:00.0

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 bash-completion/devlink | 21 +++++++++++++++++-
 man/man8/devlink-dev.8  | 48 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 361be9fe..608a60d0 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -262,6 +262,25 @@ _devlink_dev_flash()
      esac
 }
 
+# Completion for devlink dev selftests
+_devlink_dev_selftests()
+{
+    case "$cword" in
+        3)
+            COMPREPLY=( $( compgen -W "show run" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "id" -- "$cur" ) )
+            return
+            ;;
+    esac
+}
+
 # Completion for devlink dev
 _devlink_dev()
 {
@@ -274,7 +293,7 @@ _devlink_dev()
             fi
             return
             ;;
-        eswitch|param)
+        eswitch|param|selftests)
             _devlink_dev_$command
             return
             ;;
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 6906e509..5a06682a 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -85,6 +85,20 @@ devlink-dev \- devlink device configuration
 .I ID
 ]
 
+.ti -8
+.B devlink dev selftests show
+[
+.I DEV
+]
+
+.ti -8
+.B devlink dev selftests run
+.I DEV
+[
+.B id
+.RI "{ " TESTNAME " }"
+]
+
 .SH "DESCRIPTION"
 .SS devlink dev show - display devlink device attributes
 
@@ -249,6 +263,30 @@ should match the component names from
 .B "devlink dev info"
 and may be driver-dependent.
 
+.SS devlink dev selftests show - shows supported selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device.
+If this argument is omitted all selftests for devlink devices are listed.
+
+.SS devlink dev selftests run - runs selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device to execute selftests.
+
+.B id
+{
+.RI { " ID " }
+}
+- The value of
+.I ID
+should match the selftests shown in
+.B "devlink dev selftests show".
+to execute a selftest on the devlink device.
+If this argument is omitted all selftets supported by devlink devices are executed.
+
 .SH "EXAMPLES"
 .PP
 devlink dev show
@@ -296,6 +334,16 @@ Flashing 100%
 .br
 Flashing done
 .RE
+.PP
+devlink dev selftests show pci/0000:01:00.0
+.RS 4
+Shows the supported selftests by the devlink device.
+.RE
+.PP
+devlink dev selftests run pci/0000:01:00.0 id flash
+.RS 4
+Perform a flash test on the devlink device.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.31.1


--000000000000ae144d05e4eef90b
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINsNAR6t2UNOy8glLPLrjgNi9EJ2WR0eLhq2
dwewRmYLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcyOTEw
MTg0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCbulSM1Uylg5aYh63tnMUqaziXjaJZOtmt+JDOuoBQz1GGb0aMvLge
f3vypsNLYkc9DhnaosCDVUvY+jY1VKmVbzQjVBMW9+PU1cE4Zo9jqm7M+Vzo2+Cm8Mq9SB8As2/T
oxQ3hzrn1hlpAXbNBRu4URKYTjNwAbILw+hE533A8Tnai/evTwilfP5elzfl4XpWtKOpnEBrzWtl
euEh2H4oN1r/lZq/iyT6zuHC2tuSYmg+DHePmnNqxePTLnJyz11gTLgbD4LQxtYpIUCgL5f34Zki
tZ2Qt23lcTGRsasEphU0pOUHXME46e3KjeA84IyBPdEFExf6lXbSxtTnYUZP
--000000000000ae144d05e4eef90b--
