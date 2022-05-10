Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F695227C5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiEJXpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238430AbiEJXpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:45:50 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB0BCB8;
        Tue, 10 May 2022 16:45:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id bo5so504317pfb.4;
        Tue, 10 May 2022 16:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=BK8T3gjdK2roy+ApoukjEKkczl2YkXzC5XGidh4vu68=;
        b=IaZbJCKi3P+x1DPMKKxJ9ht+8zgO35UqmV0ieKRiY29ti3DVq4/cHolNSWogcKjMoR
         LPjAb6theVAl8O89PIxKFcpTdNnHoeA77vGVEu/gCWoHis50uG5phXBiGwqtnKmeHWfG
         QCDJVfQp/5CUuK/jgTSVtepIEdLYjLo2v0ieO0fXLmcY6osCPFgRxXUzxscAHwlJ7GWI
         bG8WPqBcoc7O2Z7qFpFzUDu7BthXEcoo41Mm1AsxgNFRuZxfOY4rwFXpXNAPMvBCWpec
         o/itJpQvDxPMRMLEYhMkDUNm6WGTBbk5x3lGn+1rhga4LnoQXWzv3FgQ7C05DOKTjT1m
         HoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=BK8T3gjdK2roy+ApoukjEKkczl2YkXzC5XGidh4vu68=;
        b=inQtkH3/PwkuCN1fgOLEsR4Nht8DAhIAv5HjQQxhR4Q7Mz1N5mvYm1fcIgWiPPRcJV
         UrhwFbAZGKemEbAnSJw3D1zBgvExt8CuDiBbRIPnyR1b4h2wt89wrMbYyf/A28EILDyA
         C58qvCsfUm9vC+Zfp7mPURLEA/fZtJtYH/sAjm8lDPYwZnfWSQv32qejfgJrFrHgbnUE
         WtZhuBfK65dgcuYCbu7Bpusy7d3hwyCtQPJmPNNMgpTyg/PdUNesN+VXBBvwWozcz3Re
         GaTR1NksrF0P9JimLk/c3cTrc31FOa4T2owNIAsgfJ99NNgM+cteT6nzm8aX4OpYGi5j
         0kgQ==
X-Gm-Message-State: AOAM531oVxbIScqcCKCvgYC3sndiPoSjg3hp5/KYgldHqW3v6kCBBQCq
        mqIir7FY9l5pybzmAc+CgpNFO53nu4o=
X-Google-Smtp-Source: ABdhPJwfw+X6CZliWaQWkQxeiaZ/PJ/sMBDXx2t1TsIVNkwteuolcWnhHY6lwMWLfrI19xaJ+n/ztQ==
X-Received: by 2002:a63:2b01:0:b0:3c2:4b0b:e1c6 with SMTP id r1-20020a632b01000000b003c24b0be1c6mr18365845pgr.288.1652226347694;
        Tue, 10 May 2022 16:45:47 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b0015edcdea308sm176645pla.233.2022.05.10.16.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 16:45:47 -0700 (PDT)
Message-ID: <5986752a-1c2a-5d64-f91d-58b1e6decd17@gmail.com>
Date:   Wed, 11 May 2022 08:45:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH net-next v2] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
In-Reply-To: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
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
("docs: ctucanfd: CTU CAN FD open-source IP core documentation.")
with Sphinx versions 2.4.4 and 4.5.0.

The plain "figure" directive broke "make pdfdocs" due to a missing
PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
directive, which is an extension for kernel documentation, should
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
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Martin Jerabek <martin.jerabek01@gmail.com>
Cc: Ondrej Ille <ondrej.ille@gmail.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
---
Changes in v1 -> v2
 - no change in diff
 - added explicit Sphinx versions the issues were observed
 - picked Pavel's Acked-by

--
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


