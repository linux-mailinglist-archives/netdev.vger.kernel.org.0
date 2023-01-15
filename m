Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE6B66B3B2
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 20:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAOTmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 14:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjAOTmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 14:42:21 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655312865
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 11:42:20 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id z190so12495109vka.4
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 11:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=429LMFggIvhGz8qRMjmDSEe5DoMNlkqaMJ0R+hNU+2c=;
        b=OwF9NB3iAyHnblN+dOE6zNF5a+MZoJ0Knz4yoGLZ4ea5bpjDdN5VqzxhptF+IboX9w
         YWciG+7MqFpu1iSliTR48CSxflQ1UbEvZXsdo9lTJtktXiShigyg/57SFKhKg+0E+whe
         iGKtouuC67/cCmS49qrIqTdcgKJcYQjdKJH9g7weClh5pV3cZTdr68nUqBjiGx/2fAJ+
         AgqsrJ1uiPEwl/6v5SS9x9qQbLci9XeUwkA7jJQBYotKQE1A0KXAGP8i+pUOAbP9Q5kj
         hYf708OOqRmyFqsZyoHN+eU1ergOBqyCh9DL+eEBjpJSHJdaRZNN99UXu56yqSUL6Eg/
         U/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=429LMFggIvhGz8qRMjmDSEe5DoMNlkqaMJ0R+hNU+2c=;
        b=774rl6TMWshvqDGj9BkWnf/pxVGmiCDUhVfGVa03BSNX9fI5NDbpCK41XXkaGcpwfn
         h5aTtqaMwhRqOfqMpm5FnDHuJuItkMh41rW9oeJQMq4Cq3dUrq47YdY0JIFVruaykXUI
         5Op/Edt92WbR5oyS8fZyZF81WlnIHxwXVkOofaoGFlhrwL/WeIQUvEK8U4rc8pxs+MZF
         JNadYPcJPH9Q0MKXec4ZWuyTSRaOj70aj4TF3qVI0zX0cybQTuu7eVAZorgZcyZdqe3w
         rJ4nkKeqbQddJUKw6EX3lIDnYSjZOtELVQ2Oof1QhNuSfISdaS7UiLLQ3Pr42ifUN7k7
         qr3w==
X-Gm-Message-State: AFqh2kr6vgcMI+coQ6uS4WgRBqrx3D6Si7VJzzLOTXm7oisUwBSuTPft
        dM7deLGE9VFabjUiUE7+gKMseElnh4cycoA8+PrqCeRi
X-Google-Smtp-Source: AMrXdXvGlKZ8CATIwg9ngJFhAyYR9/MwVylkcpDl8ZJZ63x+t5eayYPVaH2OWTehJz4fKVpiIQOxxQ5yxcxGlcPunP0=
X-Received: by 2002:a05:6122:1689:b0:3c5:db35:9288 with SMTP id
 9-20020a056122168900b003c5db359288mr11291155vkl.32.1673811739388; Sun, 15 Jan
 2023 11:42:19 -0800 (PST)
MIME-Version: 1.0
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com> <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
In-Reply-To: <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Mon, 16 Jan 2023 01:12:02 +0530
Message-ID: <CANAwSgSfUPocbXuyBoytcgV5Yd+bfpn2DBzRNAkCAUmPnQQysQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Mon, 16 Jan 2023 at 00:14, Neil Armstrong <neil.armstrong@linaro.org> wr=
ote:
>
> Hi Heiner,
>
> Le 15/01/2023 =C3=A0 18:09, Heiner Kallweit a =C3=A9crit :
> > On 15.01.2023 17:57, Andrew Lunn wrote:
> >> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
> >>> On my SC2-based system the genphy driver was used because the PHY
> >>> identifies as 0x01803300. It works normal with the meson g12a
> >>> driver after this change.
> >>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
> >>
> >> Hi Heiner
> >>
> >> Are there any datasheets for these devices? Anything which documents
> >> the lower nibble really is a revision?
> >>
> >> I'm just trying to avoid future problems where we find it is actually
> >> a different PHY, needs its own MATCH_EXACT entry, and then we find we
> >> break devices using 0x01803302 which we had no idea exists, but got
> >> covered by this change.
> >>
> > The SC2 platform inherited a lot from G12A, therefore it's plausible
> > that it's the same PHY. Also the vendor driver for SC2 gives a hint
> > as it has the following compatible for the PHY:
> >
> > compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22"=
;
> >
> > But you're right, I can't say for sure as I don't have the datasheets.
>
> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
> please see:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-=
meson-g12a.c#L36
>
> So you should either add support for the PHY mux in SC2 or check
> what is in the ETH_PHY_CNTL0 register.
>

I you want to read the ethernet id, we can use the following tool

[0] https://github.com/wkz/mdio-tools

om my odroid-n2 it show
alarm@odroid-n2:~/mdio-tools$ sudo mdio mdio_mux-0.0
 DEV      PHY-ID  LINK
0x00  0x001cc916  down
0x01  0x001cc916  up

-Anand

> Neil
>
> >
> >>      Andrew
> >
> > Heiner
>
>
> _______________________________________________
> linux-amlogic mailing list
> linux-amlogic@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-amlogic
