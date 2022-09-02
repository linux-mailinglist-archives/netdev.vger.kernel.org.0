Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E45AB4CC
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbiIBPPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiIBPOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4086012DA05;
        Fri,  2 Sep 2022 07:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAB43B82C4E;
        Fri,  2 Sep 2022 14:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540AEC433D6;
        Fri,  2 Sep 2022 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662129989;
        bh=twCq4L5d3vlzAeCsNCl4PJSXLjKOaJZ0A4O4iMXSBpo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dMg4a4KMo+iHy1mOVMxe1pxd4INzedd3EJHWfWCuLtDIi7OQczgSBWgspdACa0dqL
         uuCwCNkaEzR4O6aUADzYVuISOlWz1TGhGbKTfauoJ5pX87mqUgfNqlBP6+AOlbwjzP
         9lSxWVv7uc8uh4MWBU3HkU2Q4/dY41MpUVTTdUWICpwY+wxNunuf5JL8era8+OyBDe
         D0A9krV8ySP+8c4aU75Y53eX7wwR74P+53s42L7riUFIcs93K89FVAKWZweV6YoEkM
         TyLzeGJJRLMgqNDj+GJ8iq8doXQgC4fnWqrKKmgOU8Jp3yI+kmQCL6FuY6WQTLBeJn
         DC6aKQ0Zcp/CA==
Received: by mail-ua1-f53.google.com with SMTP id q21so865286uam.13;
        Fri, 02 Sep 2022 07:46:29 -0700 (PDT)
X-Gm-Message-State: ACgBeo2KS+LbfHTrdkkVBJte952PvzWb0ME+pfIBbBIAIlC2D88FEhP/
        uFYy9UiKKrGvwQm9/+0XKG8JLRRWHsMh6Ecmmw==
X-Google-Smtp-Source: AA6agR52Kh0Dbhi3VztuJbeK42EbCe4sUJNFg+rKAUbLSf4r+sTjrEN5l2h5PdQUIkLNHkfWz735OBuroaDYeDSvV2k=
X-Received: by 2002:ab0:32d1:0:b0:3ab:7f86:2121 with SMTP id
 f17-20020ab032d1000000b003ab7f862121mr267135uao.86.1662129988100; Fri, 02 Sep
 2022 07:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220825214423.903672-1-michael@walle.cc> <20220825214423.903672-9-michael@walle.cc>
 <20220831214809.GA282739-robh@kernel.org> <60308ba420cdd072ea19e11e2e5e7d4b@walle.cc>
In-Reply-To: <60308ba420cdd072ea19e11e2e5e7d4b@walle.cc>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 2 Sep 2022 09:46:16 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKFf4Op-4X0_4CF9xKSCLwrWBEYQ6oe3MgAKs6rRRUDng@mail.gmail.com>
Message-ID: <CAL_JsqKFf4Op-4X0_4CF9xKSCLwrWBEYQ6oe3MgAKs6rRRUDng@mail.gmail.com>
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible string
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 5:30 PM Michael Walle <michael@walle.cc> wrote:
>
> Am 2022-08-31 23:48, schrieb Rob Herring:
> > On Thu, Aug 25, 2022 at 11:44:17PM +0200, Michael Walle wrote:
> >> The "user-otp" and "factory-otp" compatible string just depicts a
> >> generic NVMEM device. But an actual device tree node might as well
> >> contain a more specific compatible string. Make it possible to add
> >> more specific binding elsewere and just match part of the compatibles
> >> here.
> >>
> >> Signed-off-by: Michael Walle <michael@walle.cc>
> >> ---
> >>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > In hindsight it looks like we are mixing 2 different purposes of 'which
> > instance is this' and 'what is this'. 'compatible' is supposed to be
> > the
> > latter.
> >
> > Maybe there's a better way to handle user/factory? There's a similar
> > need with partitions for A/B or factory/update.
>
> I'm not sure I understand what you mean. It has nothing to with
> user and factory provisionings.
>
> SPI flashes have a user programmable and a factory programmable
> area, some have just one of them. Whereas with A/B you (as in the
> user or the board manufacturer) defines an area within a memory device
> to be either slot A or slot B. But here the flash dictates what's
> factory and what's user storage. It's in the datasheet.

Ah, right. Nevermind...

Rob
