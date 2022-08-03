Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9558891F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiHCJKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiHCJKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:10:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB25BCBC
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:10:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so1415357pjf.2
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 02:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=9hoGk/+IzAG/JJltiRR4bqFur6ZxahyJH7/Y+XxFNUk=;
        b=D8xJ4UVpo/nUivjZ89AQ5OJFIN/rhlsi3qMkPyplvmBsQi6N6chLPdmOWtuv4bnQpo
         D070s8b/tWnR2USDnywLoiFzvWin+sibZ1kILxiUrNX1URaY2J67fGs9i/dewYooLOVD
         g13iBGVsWdKMczHq/J9xBxqOV2EUUhTUQmQVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=9hoGk/+IzAG/JJltiRR4bqFur6ZxahyJH7/Y+XxFNUk=;
        b=Fv2QM1x5hjnydo0E8BHjscA2at/qnUzfoyl7YY7awiUgIRMgvJCKTWfNJ8ch2bs7Ob
         Wx9+MXvYs0m6hQtv17lNGeS0lWsJu24Hs/uSovFWVHX51nSYNvJN+Vvoi1ROKCp8uuy6
         LaEwhRx6Rz/xpk0LzQwD/HZk4F2E9RVJRtkeHo96RaQp6wDLDrw3RRZ6J6+o02foWT5L
         AI88Z5rR1BTwq+o7E3DPw6MGDE8nxxRQh3NOG+MdVdpzougBLS0RCGiS5rF6yZQK1N5d
         mnapXXDsVBVP20c4fDLTtJKfhPfzypio91yQtuzQ9eNK7q1B8G3uk42N6K4CrviSHDG8
         HX+g==
X-Gm-Message-State: ACgBeo0H9AOudykj5RTMuo90mSivl8JUs/9bfqJEBvKhspVrvnM8whpF
        7lCOf+xun6yeQuw2BU6Lr0+R4A==
X-Google-Smtp-Source: AA6agR5OMylQT/MfACfa2buCZH1svFfOyYbek+RFCIeRSmXyAWuMBK6Y0+0YzS7WchxgUIuB5w0Sew==
X-Received: by 2002:a17:902:f652:b0:156:701b:9a2a with SMTP id m18-20020a170902f65200b00156701b9a2amr25172718plg.14.1659517841883;
        Wed, 03 Aug 2022 02:10:41 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ik25-20020a170902ab1900b0016d6963cb12sm1315960plb.304.2022.08.03.02.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 02:10:40 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v5 1/2] devlink: update the devlink.h
Date:   Wed,  3 Aug 2022 14:40:24 +0530
Message-Id: <20220803091025.30800-2-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220803091025.30800-1-vikas.gupta@broadcom.com>
References: <20220803091025.30800-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007d93b805e5529bfa"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007d93b805e5529bfa

update the devlink.h to comaptible with net-next kernel.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 include/uapi/linux/devlink.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index da0f1ba8..0224b8bd 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -136,6 +136,9 @@ enum devlink_command {
 	DEVLINK_CMD_LINECARD_NEW,
 	DEVLINK_CMD_LINECARD_DEL,
 
+	DEVLINK_CMD_SELFTESTS_GET,	/* can dump */
+	DEVLINK_CMD_SELFTESTS_RUN,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -276,6 +279,30 @@ enum {
 #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
 
+enum devlink_attr_selftest_id {
+	DEVLINK_ATTR_SELFTEST_ID_UNSPEC,
+	DEVLINK_ATTR_SELFTEST_ID_FLASH,	/* flag */
+
+	__DEVLINK_ATTR_SELFTEST_ID_MAX,
+	DEVLINK_ATTR_SELFTEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_ID_MAX - 1
+};
+
+enum devlink_selftest_status {
+	DEVLINK_SELFTEST_STATUS_SKIP,
+	DEVLINK_SELFTEST_STATUS_PASS,
+	DEVLINK_SELFTEST_STATUS_FAIL
+};
+
+enum devlink_attr_selftest_result {
+	DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
+	DEVLINK_ATTR_SELFTEST_RESULT,		/* nested */
+	DEVLINK_ATTR_SELFTEST_RESULT_ID,	/* u32, enum devlink_attr_selftest_id */
+	DEVLINK_ATTR_SELFTEST_RESULT_STATUS,	/* u8, enum devlink_selftest_status */
+
+	__DEVLINK_ATTR_SELFTEST_RESULT_MAX,
+	DEVLINK_ATTR_SELFTEST_RESULT_MAX = __DEVLINK_ATTR_SELFTEST_RESULT_MAX - 1
+};
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -576,6 +603,10 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_NESTED_DEVLINK,		/* nested */
+
+	DEVLINK_ATTR_SELFTESTS,			/* nested */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.31.1


--0000000000007d93b805e5529bfa
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIDEcONge0lN3rI5d2ptujrZYwGQ+j07blxl
B9ce3xzrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDgwMzA5
MTA0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQA81oog0pRB+W2nNFtkrFDdJQnWZg6x58sA75HLm434ZrWpB40IEevF
2hetQx0jzUzMySUEFXAMh+kERh00wJ+g9ynS3dKQm20eKEn27OwrHO6v1Q7cOu12QhzRmhxzW4Tf
TaNZgciz7/j7AnqaXqhdTKrpT8GQyzi65dzpXdQaafXmkG1zFTrMU6W7bIYXvszYRK8wu1o9+oOY
tpI1wR4Pd+Pi7g1D0dfkH7ZAhEZqctUEPo8x3QxQfVSLN/p63FT1ie0/xzb5LysovCoeVyxKJqj/
82uNpL0eDdS+Fey+ADCYly0Se1RMGpq8cllGFzZg4zpYF4Jb4qK3Kau5QGVC
--0000000000007d93b805e5529bfa--
