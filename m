Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD5A589109
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiHCRLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbiHCRLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 13:11:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C61ADB3;
        Wed,  3 Aug 2022 10:11:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dc19so9883537ejb.12;
        Wed, 03 Aug 2022 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8oQ+hf3D0+Iz/d+O+xc/TfT4v6mJXLjzNBvcBlenzqY=;
        b=ov6hOt/BSeqHJycDTI4xQ8tHEssAK4e6pv8KL2MGFYp5an1I+hA2JKmORXNMnc/BC0
         JLzyM8gGPgfC0f/MbA19BRta3K0YAMCcNkhAuj1W1f1wBbhgRqbsVg/kzQvg1YyqK49K
         CnQKlSx/EYBXxsTJUbBnRhmHKQruwbpNZCcPSfHJpD7fw3czkgyD0E0mHiKFlijV7F7s
         8a+IVQcSRjjkiI9aPMrKiUSZPk3jQEBZOFN4quS8DPu1Q3X25Lf2rlYUl6dZ6bxfx8SX
         WcLv4WSddaqNFmrF39M5hln8GcLMf74Xv44vmCRoFzSM/KyBDJDIH2dyopAYijD6iiGM
         kOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8oQ+hf3D0+Iz/d+O+xc/TfT4v6mJXLjzNBvcBlenzqY=;
        b=4PO8SVjxlTLp3ow2MnFF1bd8Cg/39HFoF7/L1m5gWYf1PZzwK3AAiyGWLXKMoWFlg7
         fLx6EokIGcyZdlPqAeorPVlLvOHhDrN9UaAd9dtBYk+/zos2SVWnKhM8AMaS1QSB9bqi
         Apzn8+7x/x34z7vwkf4PX52TaGRLON0Uv3om954eSVWXShj2cavGL4sLtg7vyT6XFSRg
         /ykkfJzSN0Nb06A/1G/yLT1BaZjtH0y1yQ6VFhNNjPA0dX/VAGyibEOhi2tIEf+uMlBt
         hKMpd+nq92ZPlFHrG0cXyV9EMLLWR/rRRBIAH5uUW2qfrZBd1Gl0gWbqIB7VQRMnqVxo
         eCDQ==
X-Gm-Message-State: AJIora9yfro7XgEuQ+7blDT8xUD/4Da/ImI2C0ulUjI70S2MxI923kgD
        Am/qasr2upLt/n+rSielhbUc8NfYuDXZzHE6ldw=
X-Google-Smtp-Source: AGRyM1tTTR3G9549yX73eQmQTpxd1p9fgq0l/oy3EMq/u9/1sLQ+bNeKFbPKdFBm+Otw2j6/Zefjxq05v3uZxvWohXs=
X-Received: by 2002:a17:906:7950:b0:72f:d4a4:564d with SMTP id
 l16-20020a170906795000b0072fd4a4564dmr20739399ejo.479.1659546675350; Wed, 03
 Aug 2022 10:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com> <CAHp75Vc30VW_dYGodyw4mrMwFgTVyDFaMP2ZJXQEB2nFOB2RWw@mail.gmail.com>
 <YuqarB067s+rqFKe@euler>
In-Reply-To: <YuqarB067s+rqFKe@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 19:10:38 +0200
Message-ID: <CAHp75VeXtuR=CYyPE9VEE0+QoQ3hgVYCoSu4Yb8EycvChi86BQ@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 5:56 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
> On Wed, Aug 03, 2022 at 01:45:04PM +0200, Andy Shevchenko wrote:
> > On Wed, Aug 3, 2022 at 7:48 AM Colin Foster
> > <colin.foster@in-advantage.com> wrote:

...

> > > +       regmap_config.max_register = res->end - res->start;
> >
> > Hmm... First of all, resource_size() is for that (with - 1 to the
> > result). But don't you need to use stride in the calculations?
>
> DEFINE_RES_NAMED populates the resource .end with (_start) + (_size) - 1
> so I don't think resource_size is correct to use here.

Have you read what I put in parentheses? Basically it becomes very
well the same as a result, but in a cleaner manner (you calculate
resource size - 1 which will be exactly the last byte offset of the
register file), no?

> reg_stride gets handled at the top of regmap_read(), so I don't think
> that's really needed either.

Okay.

> For reference:
>
> #define VSC7512_DEVCPU_ORG_RES_START    0x71000000
> #define VSC7512_DEVCPU_ORG_RES_SIZE     0x38

Right, for 0x38 you supply 0x37, which is exactly resource_size() - 1.

> # cat range
> 0-34

-- 
With Best Regards,
Andy Shevchenko
