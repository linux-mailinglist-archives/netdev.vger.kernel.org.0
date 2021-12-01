Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E4546556E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhLAScd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhLAScc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:32:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B190BC061574;
        Wed,  1 Dec 2021 10:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77886B820F7;
        Wed,  1 Dec 2021 18:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7C9C53FD4;
        Wed,  1 Dec 2021 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638383349;
        bh=Gn4s0yYJcCdTZW0pUo1N9BUlN3v2wBrSWSlLzly3FV0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MYEGIxeR5R3F9QL3vNUxbtHHPEvJvx04hOpkkTqCIWElDJU5uLRDez/Z1Hk7Bvp48
         uAGACV5GlVSIzsuLqvqJJgYPNTPk4CEtiz5+8pAk1k2J2hSIm2FGVDiprtZWqCE2nh
         uzLMX9kuL0H89YhF7OAubvcP39ByEeHo0Tcnk2M+tg42IV+3Q7UuTSjBD9D3OxZTWf
         hJSIe3NY6O8IDL0h4NNP60kgOlMaLbsJOiyum0M5Ki/JCqQlV7gH5RTgJA3frhJiWX
         0T5xaBlVY/89GS1q030MBl/icIVjSx18ySg1rJ7Q1JOTYIxeVdmh20YM1h6XpxECcW
         WR6HsnQrkSRbQ==
Received: by mail-ed1-f49.google.com with SMTP id x6so105254680edr.5;
        Wed, 01 Dec 2021 10:29:09 -0800 (PST)
X-Gm-Message-State: AOAM531b0XGNBDS+1LIdMVuBMgDmdqridyF7eIiDlKz1RxK1XOPhuPZ+
        lEO6XCNBjCy6G5SymbvzVFUNe08VRnEJKEEKPg==
X-Google-Smtp-Source: ABdhPJz0M9hONwYhapDgbKr1pBiOAqlDdueW1VKpz+27eyVJ9lUcLA/6diG99b9tulXoZY4rO5Q4CZ5Bn5+5Pw2c3HI=
X-Received: by 2002:a17:907:3f24:: with SMTP id hq36mr9044894ejc.390.1638383347204;
 Wed, 01 Dec 2021 10:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20211201041228.32444-1-f.fainelli@gmail.com> <20211201041228.32444-4-f.fainelli@gmail.com>
 <1638369202.233948.1684354.nullmailer@robh.at.kernel.org> <52926c88-a51d-d4e8-a6ab-7cf92e35c7ba@gmail.com>
In-Reply-To: <52926c88-a51d-d4e8-a6ab-7cf92e35c7ba@gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 1 Dec 2021 12:28:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJeO9eL-ygU-dEoV0DGOKwbM_i+PWaBTk2QCP6Wc69S5g@mail.gmail.com>
Message-ID: <CAL_JsqJeO9eL-ygU-dEoV0DGOKwbM_i+PWaBTk2QCP6Wc69S5g@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] dt-bindings: net: Document moca PHY interface
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 11:15 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 12/1/21 6:33 AM, Rob Herring wrote:
> > On Tue, 30 Nov 2021 20:12:24 -0800, Florian Fainelli wrote:
> >> MoCA (Multimedia over Coaxial) is used by the internal GENET/MOCA cores
> >> and will be needed in order to convert GENET to YAML in subsequent
> >> changes.
> >>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >
> > Running 'make dtbs_check' with the schema in this patch gives the
> > following warnings. Consider if they are expected or the schema is
> > incorrect. These may not be new warnings.
> >
> > Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> > This will change in the future.
> >
> > Full log is available here: https://patchwork.ozlabs.org/patch/1561996
> >
> >
> > ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var3-ads2.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dt.yaml
> >       arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dt.yaml
> >
> > ethernet@17020000: phy-handle: [[36], [37]] is too long
> >       arch/arm64/boot/dts/apm/apm-mustang.dt.yaml
> >
> > ethernet@30000: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
> >       arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dt.yaml
> >       arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dt.yaml
>
> These are all pre-existing warnings, but we should be documenting speed
> 2500 in ethernet-controller.yaml, so I will add a patch towards that end.

Thanks.

> The one for apm-mustand.dts however I am not sure how to best resolve
> since it looks like there was an intention to provide two Ethernet PHYs
> and presumably have the firmware prune the one that is not in use. I
> don't even know if that platform is supported mainline anymore.

Unfortunately it is, barely. I just fixed a breakage I caused 2 years
ago and just now noticed. I would not worry about it for now.

Rob
