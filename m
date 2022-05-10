Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB475210FE
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbiEJJil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiEJJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:38:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940B128F7D9;
        Tue, 10 May 2022 02:34:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d22so16227150plr.9;
        Tue, 10 May 2022 02:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=qaDh4Ckz8QrCcHoQ04UJEqXA1un3Pk43mgbPkIGVN1I=;
        b=KVEJAoTst/XMBdGnBfrFVplKvsiqSzit2RwnZ7YD0A3CpnQAafw/CLzObaclOYYcMR
         VY0VtGrEwffts3ooJ/aWd6Y3OiGHrKNnA+2TQfO5EbQLI2np25d2zdp36orDc7NCaDsy
         p7hnQ50UM/95iDTalSnkgGuGu31IAPd7odOCq8d2mz8IrW8+zS8ruIQw9H9NfmfdQOd1
         mKVOLdEvvAGLEyVhv1dAmbEwLRVfIT4MrEqmuQo8ozINm3iLE/uyN/W9dPE/FgQfpUfe
         pwXBYLO6p0XZrZ1+YZ6eGPqe1BsvHXXZPfIveHzDLlu+kC0RzTHrJNVb8894S6f+c5oe
         sfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=qaDh4Ckz8QrCcHoQ04UJEqXA1un3Pk43mgbPkIGVN1I=;
        b=6CIzvJzjXsjt/Tm5xisYKaZszkWE6lMZh9YuJYSBUxhBBW3oova3K3r5lnIJR5fDD/
         v35Ka9mnU7ceW3t7IbNjwAaSYS4qAO5bRaL5pjO47+mUFi34I8tdUud2DVSOtSzEDnEt
         XZZIuTIG/L9z1BfxL0PP8R3aFFhH2VmlzbhN0Synyw1QVEW3hHjQJbSrx7Rv/DeOw0xf
         tPWTK4MdMG7uYm+ezRp+aMnt/OcqeuUEDDP1hg8zz++Ezvug3E7zYb7ICHiJv4pPiMFk
         z5rnl5ASH3tilRJ38cul+a+rMnkE9/a1FWlpQDYFd/B/emCo5MfIdTgqvVx1D3E0meWQ
         ckeg==
X-Gm-Message-State: AOAM530WcDYwrhJmMKoXdB0Bi07ZH7krjhx4+QbevR+eFS50eafesf0G
        Xv7+ArbbbYKVSUGm4lk0I/4E+9BRIQOMIw==
X-Google-Smtp-Source: ABdhPJy/YUSbDEPTeKe1+Vh8Kbzycu5xwlQFcScA9EB0LpH/f0Zgcz/Kilxl0fL/79wxmIjbIQMvJg==
X-Received: by 2002:a17:902:d510:b0:15e:afc4:85a0 with SMTP id b16-20020a170902d51000b0015eafc485a0mr19918712plg.64.1652175282090;
        Tue, 10 May 2022 02:34:42 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id i8-20020aa796e8000000b0050dc762812bsm10176399pfq.5.2022.05.10.02.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 02:34:41 -0700 (PDT)
Message-ID: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
Date:   Tue, 10 May 2022 18:34:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Akira Yokosawa <akiyks@gmail.com>
Subject: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two issues were observed in the ReST doc added by commit c3a0addefbde
("docs: ctucanfd: CTU CAN FD open-source IP core documentation.").

The plain "figure" directive broke "make pdfdocs" due to a missing
PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
directive, which is an extension for kernel documentations, should
be used instead.

The directive of "code:: raw" causes a warning from both
"make htmldocs" and "make pdfdocs", which reads:

    [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
    'raw' is not known

A plain literal-block marker should suffice where no syntax
highlighting is intended.

Fix the issues by using suitable directive and marker.

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core docu=
mentation.")
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Martin Jerabek <martin.jerabek01@gmail.com>
Cc: Ondrej Ille <ondrej.ille@gmail.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-dri=
ver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver=
=2Erst
index 2fde5551e756..40c92ea272af 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst=

+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst=

@@ -72,7 +72,7 @@ it is reachable (on which bus it resides) and its confi=
guration =E2=80=93
 registers address, interrupts and so on. An example of such a device
 tree is given in .
=20
-.. code:: raw
+::
=20
            / {
                /* ... */
@@ -451,7 +451,7 @@ the FIFO is maintained, together with priority rotati=
on, is depicted in
=20
 |
=20
-.. figure:: fsm_txt_buffer_user.svg
+.. kernel-figure:: fsm_txt_buffer_user.svg
=20
    TX Buffer states with possible transitions
=20
--=20
2.25.1

