Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84B66134F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 04:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjAHDCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 22:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjAHDCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 22:02:18 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2558AF5B6
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 19:02:17 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s3so1292061pfd.12
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 19:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zUlHBUgzeP5suOmxYavk4khBbjcoA6aGc5dHNtPAwYA=;
        b=FXpeNcsTuLSFsbDbg61tzVBEm26bC7ZnU+Gxzzhfqq6NGOWR9cItB/MnRO5mZjims1
         MIa7vhS1FftqhyTm705bwrQD23zzEqPdqXqXgN8f7VdP0e5QmT4B0n8ZYZ7J4mN2oTLH
         K/V3qMHKcAhGXFBQNMcTcAxaLPsQ7xVZCtiMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zUlHBUgzeP5suOmxYavk4khBbjcoA6aGc5dHNtPAwYA=;
        b=uEfOMiz+4WTnDHX7xuMmjrczmT0P8my4hrDVZjcSULh1i8gQy4IMnyQXpuq/pqHXAd
         8ISSFaRYauVTFawUHRn12sQ58bT1s+GmmFplnIPn/4W/mqmES8/W8GFriJIlrbyOqDBF
         p9T02+DRZJqPpS+xxv5UI5kCe+3WoDfb8U9rG4qIckACVjuueS4A0ak9DPmxwpfyYA6g
         r656dtzUtj/NVBH3GDJJAhzUvoyRSs7SmZuesrxFsc1oe1sVgfbBiqX7AFD5jx1jAMLA
         7m5yZ70XLm8Qy6TyuOLGAijZWuxgPouQF2tW6ECPaPfEanGBNtKeQrious3ZhbT5K5tg
         CMAg==
X-Gm-Message-State: AFqh2kp1dvkXX7EMt6+T1RcVoRP6jgibSISsR7bLoDdIQRCxJRaH0l0x
        Y++RsXGfdix4e0ucVPFLOsxnWg==
X-Google-Smtp-Source: AMrXdXt6Ip54ke3Uy7L+Noa9ZN0NZbR8I9SJLqb6n3zk1IXsEgI0dZHQM62fm5QbK8KRYW2RHCP1Rw==
X-Received: by 2002:a05:6a00:2164:b0:581:2f69:87ed with SMTP id r4-20020a056a00216400b005812f6987edmr42497009pff.34.1673146936362;
        Sat, 07 Jan 2023 19:02:16 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:1caf:227a:5e9d:33c3])
        by smtp.gmail.com with ESMTPSA id 69-20020a621748000000b005810a54fdefsm3452148pfx.114.2023.01.07.19.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 19:02:14 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: [PATCH 0/8] Add Auxiliary driver support
Date:   Sat,  7 Jan 2023 19:02:00 -0800
Message-Id: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d4cd9c05f1b7e0aa"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d4cd9c05f1b7e0aa
Content-Transfer-Encoding: 8bit


Ajit Khaparde <ajit.khaparde@broadcom.com>
Dec 7, 2022, 9:53 AM
to me, andrew.gospodarek, davem, edumazet, jgg, kuba, leon, linux-kernel, linux-rdma, michael.chan, netdev, pabeni, selvin.xavier

Add auxiliary device driver for Broadcom devices.
The bnxt_en driver will register and initialize an aux device
if RDMA is enabled in the underlying device.
The bnxt_re driver will then probe and initialize the
RoCE interfaces with the infiniband stack.

We got rid of the bnxt_en_ops which the bnxt_re driver used to
communicate with bnxt_en.
Similarly  We have tried to clean up most of the bnxt_ulp_ops.
In most of the cases we used the functions and entry points provided
by the auxiliary bus driver framework.
And now these are the minimal functions needed to support the functionality.

We will try to work on getting rid of the remaining if we find any
other viable option in future.

v1->v2:
- Incorporated review comments including usage of ulp_id &
  complex function indirections.
- Used function calls provided by the auxiliary bus interface
  instead of proprietary calls.
- Refactor code to remove ROCE driver's access to bnxt structure.

v2->v3:
- Addressed review comments including cleanup of some unnecessary wrappers
- Fixed warnings seen during cross compilation

v3->v4:
- Cleaned up bnxt_ulp.c and bnxt_ulp.h further
- Removed some more dead code
- Sending the patchset as a standalone series

v4->v5:
- Removed the SRIOV config callback which bnxt_en driver was calling into
  bnxt_re driver.
- Removed excessive checks for rdev and other pointers.

v5->v6:
- Removed excessive checks for dev and other pointers
- Remove runtime interrupt vector allocation. bnxt_en preallocates
interrupt vectors for bnxt_re to use.

Please apply. Thanks.

Ajit Khaparde (7):
  bnxt_en: Add auxiliary driver support
  RDMA/bnxt_re: Use auxiliary driver interface
  bnxt_en: Remove usage of ulp_id
  bnxt_en: Use direct API instead of indirection
  bnxt_en: Use auxiliary bus calls over proprietary calls
  RDMA/bnxt_re: Remove the sriov config callback
  bnxt_en: Remove runtime interrupt vector allocation

Hongguang Gao (1):
  bnxt_en: Remove struct bnxt access from RoCE driver

 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |  10 +-
 drivers/infiniband/hw/bnxt_re/main.c          | 635 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 489 ++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  57 +-
 7 files changed, 494 insertions(+), 723 deletions(-)

-- 
2.37.1 (Apple Git-137.1)


--000000000000d4cd9c05f1b7e0aa
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGIvvl3udmEttJopmuIW
l8sok4PJrsViLjIKPD0TLeviMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDEwODAzMDIxNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQApWl0gfHbR5UIXbkjq+cOSrgv4nYcQj+SXgxE9
PqTjoAiq0kCAPRp1gcufTXOxmjrboflePgzTSniOgv8KrExnMJahd4t9nalvLWM2aqjBXanB0y9r
bs07V9TTGW/eyoSpZXyBZRU7PTDBC1xIJPvmx+rFVkFlcsApHTp3UDvXh/VONvvXh8pWT18NRo0E
3STUTny3bBkaSifCzfIzNY+gtPQYdKyOvhdGGo93C1Y+0hDcgly/5Ful5JoBbZwxhmG71Ss6hcA+
EMvnlcVX4KcFFt4Z838sOoFFwO5xjzk/6kmYotfeDxzVcUI3YJAEdBQWCTLxDqHbK2oVMg4MbPGI
--000000000000d4cd9c05f1b7e0aa--
