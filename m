Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DBC528325
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbiEPLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243140AbiEPLY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:24:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7A038BD2;
        Mon, 16 May 2022 04:24:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so166585pjb.2;
        Mon, 16 May 2022 04:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=4jjOAwHVMxYy5ucNab2gGnGo0JwjZSdIbHnye9ibPOM=;
        b=Kuf+HQig6vaPQ7iYeZ+JJhv3sy+/ijEgl4GZuDhQ2hJtX6AkSJ+HROPwC3GP3qoyZO
         ZjBg5zAHBvIiV70K6h1Uk9xOW10UD6rsUzRDs73CbjFNheozeGfGeaqG0oyl0/v+WRwZ
         aL+pHMtBqBOUL8dfH1V7jP9KgHZ4CY9E3cVOM/td+JgGrCAfoxPZCwHEhZnkCMsKpfFD
         wzNxDBSd1IOWTKONYz9K9DWSYBnQa6TlEiPp7PyZAAXqDruiVb+ReDjT759S7pxEgr7t
         J41+J6PHzYCf3EnYZR+8DqzUDNwkIs6wRI8ZcveR8GM5XNF3f+OpfvgyY/ANgmKjnMaS
         q4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=4jjOAwHVMxYy5ucNab2gGnGo0JwjZSdIbHnye9ibPOM=;
        b=ur5qXVBfnyortc9guzP2kbzdrZBes0F28dnVHr7C1jFu0UyHSUyNfjSVLRHmAuViQm
         s01c1IYts9F5OU1MWLRO4s76VCCCnFdd+SWP/dZAVVaE5RGX85o8e/FK3bT4EWos7/M1
         87X4PCOhGQN83eCmzIwm0DuxLP7z0AUosw6R6A3Zfsq0B/VjPKzlwJJV64GdgW0D4Fb5
         S7Z9otSfS2mHVZpTGRbwFfuE3RouM2uygHFU3Vi6l22Mn/oVcd4Dpr6so/xKKyT5HsEd
         hd1Mlc6RrRr849hrQ6Em5k/DnJSE3XeUPEWt7upMk34nWhoXcKu0r75r5HNQsJjdnuPA
         zSOA==
X-Gm-Message-State: AOAM5334nsns1j2SjKigS544e0F8It+mR7UJNMx9TapzEybrp0LGiPsY
        +c6/YX2cNFCKgSHn+1wNHz8=
X-Google-Smtp-Source: ABdhPJx/nDODDK1IUaPyjRIH8x6zAaX/zb3uVRaCMQzS0aoWglarxRPXOehA7y9krIPlpJrt1fU2kA==
X-Received: by 2002:a17:903:2288:b0:15e:8da2:fcc0 with SMTP id b8-20020a170903228800b0015e8da2fcc0mr17530332plh.125.1652700295981;
        Mon, 16 May 2022 04:24:55 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id q17-20020a656851000000b003e4580cf645sm4758479pgt.17.2022.05.16.04.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 04:24:55 -0700 (PDT)
Message-ID: <38d102ab-d0b6-3467-4dce-4a9d4aa9e39d@gmail.com>
Date:   Mon, 16 May 2022 20:24:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v2] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
 <5986752a-1c2a-5d64-f91d-58b1e6decd17@gmail.com>
In-Reply-To: <5986752a-1c2a-5d64-f91d-58b1e6decd17@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 08:45:43 +0900, Akira Yokosawa wrote:
> Two issues were observed in the ReST doc added by commit c3a0addefbde
> ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.")
> with Sphinx versions 2.4.4 and 4.5.0.
>=20
> The plain "figure" directive broke "make pdfdocs" due to a missing
> PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
> directive, which is an extension for kernel documentation, should
> be used instead.
>=20
> The directive of "code:: raw" causes a warning from both
> "make htmldocs" and "make pdfdocs", which reads:
>=20
>     [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
>     'raw' is not known
>=20
> A plain literal-block marker should suffice where no syntax
> highlighting is intended.
>=20
> Fix the issues by using suitable directive and marker.
>=20
> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core do=
cumentation.")
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> Cc: Martin Jerabek <martin.jerabek01@gmail.com>
> Cc: Ondrej Ille <ondrej.ille@gmail.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Changes in v1 -> v2
>  - no change in diff
>  - added explicit Sphinx versions the issues were observed
>  - picked Pavel's Acked-by
>=20
Gentle ping to netdev maintainers.

I believe this one should go upstream together with the
offending commit.

If there is something I can do better, please let me know.

        Thanks, Akira

> --
>  .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++--=

>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-d=
river.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driv=
er.rst
> index 2fde5551e756..40c92ea272af 100644
> --- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.r=
st
> +++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.r=
st
> @@ -72,7 +72,7 @@ it is reachable (on which bus it resides) and its con=
figuration =E2=80=93
>  registers address, interrupts and so on. An example of such a device
>  tree is given in .
> =20
> -.. code:: raw
> +::
> =20
>             / {
>                 /* ... */
> @@ -451,7 +451,7 @@ the FIFO is maintained, together with priority rota=
tion, is depicted in
> =20
>  |
> =20
> -.. figure:: fsm_txt_buffer_user.svg
> +.. kernel-figure:: fsm_txt_buffer_user.svg
> =20
>     TX Buffer states with possible transitions
> =20
