Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE163F731
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiLASLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiLASLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:11:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B716EB71ED;
        Thu,  1 Dec 2022 10:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F8E8B81FD1;
        Thu,  1 Dec 2022 18:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124E4C433C1;
        Thu,  1 Dec 2022 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669918264;
        bh=abbxDko8xxIgN43TGD7PjO4ktuR8obKuUDRggHGcGh0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NI/gXF8N4bqL1rTkyPrfaWjTUpOEpjbrOjVnuEaPhoxgbEubRQpcGpo04jTvM5/g/
         nYelXUZzhXZOxzxn6B3J83OmdNeC2L5pk5uaiENG585sFVUIKWKPwO09SDgzWBuIF0
         r+hHQy9tLY2C3OYdp1eBljCI4oJBDDaUp/lXVOg3Du61yaGPDVwMg+4Noc1NBaYhx8
         WcB9LdbpH3HOgHbe5vBWw8YFl3enrHm1QWrBgI0FhmrmfwpYQP7pBgGFwwUKLMIKm/
         L0vopg3IjCpPQw8tcsXPJE9p8iQga7Eumwek9LmzeoK1EjJDIJKPhDKfmHIrgT8Dk8
         cD4YByX/98U0w==
Received: by mail-ua1-f45.google.com with SMTP id n9so866397uao.13;
        Thu, 01 Dec 2022 10:11:04 -0800 (PST)
X-Gm-Message-State: ANoB5pnBgr0vBOV0CO0ez6+vq/L2k8CWyzAUtMqvW3lW2SvzlnJL2Uxx
        OxNIBsnFSUswqtJgECKYqIVnE0Euk2Da5M7Gqw==
X-Google-Smtp-Source: AA0mqf4QIyT6VahcqDmI12MLMCc/vE3ASpYv1pzurU6CjB/p3SM54fi3Oi2LQpbXvk2AUCuGF9WAWcBZ/6x3KPapb4M=
X-Received: by 2002:a05:6130:83:b0:418:b849:8187 with SMTP id
 x3-20020a056130008300b00418b8498187mr41149171uaf.43.1669918262913; Thu, 01
 Dec 2022 10:11:02 -0800 (PST)
MIME-Version: 1.0
References: <20221125202008.64595-1-samuel@sholland.org> <20221125202008.64595-3-samuel@sholland.org>
 <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org> <20221126142735.47dcca6d@slackpad.lan>
 <99c3e666-ec26-07a0-be40-0177dd449d84@linaro.org> <20221201034557.GA2998157-robh@kernel.org>
In-Reply-To: <20221201034557.GA2998157-robh@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 1 Dec 2022 12:10:49 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+H0tLUJ+vWSkDHqjYdsAK2Rd3UCDEXv9uJ2v-ZR=XCAw@mail.gmail.com>
Message-ID: <CAL_Jsq+H0tLUJ+vWSkDHqjYdsAK2Rd3UCDEXv9uJ2v-ZR=XCAw@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml inheritance
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 9:45 PM Rob Herring <robh@kernel.org> wrote:
>
> On Sat, Nov 26, 2022 at 03:48:33PM +0100, Krzysztof Kozlowski wrote:
> > On 26/11/2022 15:28, Andre Przywara wrote:
> > > On Sat, 26 Nov 2022 14:26:25 +0100
> > > Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:
> > >
> > > Hi,
> > >
> > >> On 25/11/2022 21:20, Samuel Holland wrote:
> > >>> The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
> > >>> properties defined there, including "mdio", "resets", and "reset-names".
> > >>> However, validation currently fails for these properties because the
> > >>
> > >> validation does not fail:
> > >> make dt_binding_check -> no problems
> > >>
> > >> Maybe you meant that DTS do not pass dtbs_check?
> > >
> > > Yes, that's what he meant: If a board actually doesn't have Ethernet
> > > configured, dt-validate complains. I saw this before, but didn't find
> > > any solution.
> > > An example is: $ dt-validate ... sun50i-a64-pinephone-1.2.dtb
> > > arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-1.2.dtb:
> > >   ethernet@1c30000: Unevaluated properties are not allowed ('resets', 'reset-names', 'mdio' were unexpected)
> > >   From schema: Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > >
> > > Why exactly is beyond me, but this patch removes this message.
> >
> > I don't think this should be fixed like this. That's the problem of
> > dtschema (not ignoring fully disabled nodes) and such patch only moves
> > from one correct syntax to another correct syntax, which fixes dtschema
> > problem, but changes nothing here.
>
> Humm, it looks to me like the 'phy-mode' required in snps,dwmac.yaml
> causes the problem, but I can't get a minimized example to fail.
> Something in 'required' shouldn't matter. Definitely seems like an issue
> in the jsonschema package. I'll keep looking at it.

TLDR: A fix in dtschema for this will be in place soon.

I've simplified this down to:
{
    "$schema": "https://json-schema.org/draft/2019-09/schema",

    "unevaluatedProperties": false,
    "allOf":[
        {
            "properties": {
                "foo": true,
                "bar": true
            },
            "required": [ "foo" ]
        }
    ]
}

An instance { "bar": 1 } will fail due to the 'required' failing. When
you have a subschema (what's under 'allOf'), then it all has to pass
to be 'evaluated'. This seems inconsistent to me, but the json-schema
folks say it is operating as intended.

I've got 2 possible fixes. One is to just ignore unevaluatedProperties
errors on disabled nodes like is already done for 'required'. This
means disabled nodes can have any unknown property or child node added
which isn't great. The other way overrides 'required' validation to
always pass on disabled nodes. This would be better, but there are
some exceptions we need to still fail. 'oneOf' with N entries of
'required' to say 1 of N properties must be present for example.
Excluding each one of these cases will be fragile, so probably going
with the first fix.

Rob
