Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B8E4EC959
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348643AbiC3QLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiC3QLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:11:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC82E2E091;
        Wed, 30 Mar 2022 09:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81868B81D7D;
        Wed, 30 Mar 2022 16:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B26C340F2;
        Wed, 30 Mar 2022 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648656595;
        bh=21ZfQCE6lFv2xdUGd7RWdSUk18b3sq09f75JVoYg9xo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hXn+p3Qmk9g4mvCFiW4Tle8hfxVOGLSS5z4hkO7kphe4pazZ5/oqKjcCnkbepLcK7
         rtCdAGPhwTfUD0SNdRmwSwggSXbSNGI+TI8OIVrz1qeb0mEO5yMZQ/L75iRroHDQB1
         Zilfq1SPtskA77Bf+xyN5m4hxZGfY9QtzzGfaTzfWSlef4dcMe84nvluQQB3zuHl+R
         IG6DUD5WNB5oHOTZzzp7iIuce+yxAE/1gP7a/Ib+MU4k5yGcGoXU2lYmxsndEbY5mR
         L8jq+vmmZ82rkkagjyL7JR1WVBYNxyttPGx+kc/3f+XE6gPBMyb89/21hELr6wOdW9
         ZyNQnunlBBAaw==
Received: by mail-il1-f169.google.com with SMTP id j15so14817065ila.13;
        Wed, 30 Mar 2022 09:09:55 -0700 (PDT)
X-Gm-Message-State: AOAM530O/q0Le4cWVrOtY5uESpdk0XGux6L3c4qRTpv28MA24chdVuB9
        5Z8q4Ja9YVPP+5u+8j4/YS90t1l/vEgtg1ueIw==
X-Google-Smtp-Source: ABdhPJxhkqh4ooQHwYBagobGFuZHzSOMyjAmHCcK+dH+J6YGaqBBaTfAGOi0r6zbej3wYUN9XIhwBBkrFoevDZuVOOU=
X-Received: by 2002:a05:6e02:2183:b0:2c7:fe42:7b07 with SMTP id
 j3-20020a056e02218300b002c7fe427b07mr10926526ila.302.1648656594284; Wed, 30
 Mar 2022 09:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com> <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com> <20220316101854.imevzoqk6oashrgg@skbuf>
 <YkR8tTWabfTRLarB@shell.armlinux.org.uk>
In-Reply-To: <YkR8tTWabfTRLarB@shell.armlinux.org.uk>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 30 Mar 2022 11:09:42 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKFbU6VyLu+as_bZxWsfHRf5mJGeExjZ2ZJQqOcJchC+g@mail.gmail.com>
Message-ID: <CAL_JsqKFbU6VyLu+as_bZxWsfHRf5mJGeExjZ2ZJQqOcJchC+g@mail.gmail.com>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
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

On Wed, Mar 30, 2022 at 10:52 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Wed, Mar 16, 2022 at 10:18:55AM +0000, Ioana Ciornei wrote:
> > On Wed, Mar 16, 2022 at 09:23:45AM +0100, Krzysztof Kozlowski wrote:
> > > On 15/03/2022 20:07, Ioana Ciornei wrote:
> > > > On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> > > >> On 15/03/2022 13:33, Ioana Ciornei wrote:
> > > >>> Convert the sff,sfp.txt bindings to the DT schema format.
> > > >>>
> > > >>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > >>> ---
> > > >
> > > > (..)
> > > >
> > > >>> +maintainers:
> > > >>> +  - Russell King <linux@armlinux.org.uk>
> > > >>> +
> > > >>> +properties:
> > > >>> +  compatible:
> > > >>> +    enum:
> > > >>> +      - sff,sfp  # for SFP modules
> > > >>> +      - sff,sff  # for soldered down SFF modules
> > > >>> +
> > > >>> +  i2c-bus:
> > > >>
> > > >> Thanks for the conversion.
> > > >>
> > > >> You need here a type because this does not look like standard property.
> > > >
> > > > Ok.
> > > >
> > > >>
> > > >>> +    description:
> > > >>> +      phandle of an I2C bus controller for the SFP two wire serial
> > > >>> +
> > > >>> +  maximum-power-milliwatt:
> > > >>> +    maxItems: 1
> > > >>> +    description:
> > > >>> +      Maximum module power consumption Specifies the maximum power consumption
> > > >>> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> > > >>> +      be up to 1W, 1.5W or 2W.
> > > >>> +
> > > >>> +patternProperties:
> > > >>> +  "mod-def0-gpio(s)?":
> > > >>
> > > >> This should be just "mod-def0-gpios", no need for pattern. The same in
> > > >> all other places.
> > > >>
> > > >
> > > > The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
> > > > gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
> > > > fail the check because they are using the "gpio" suffix.
> > > >
> > > > Why isn't this pattern acceptable?
> > >
> > > Because original bindings required gpios, so DTS are wrong, and the
> > > pattern makes it difficult to grep and read such simple property.
> > >
> > > The DTSes which do not follow bindings should be corrected.
> > >
> >
> > Russell, do you have any thoughts on this?
> > I am asking this because you were the one that added the "-gpios" suffix
> > in the dtbinding and the "-gpio" usage in the DT files so I wouldn't
> > want this to diverge from your thinking.
> >
> > Do you have a preference?
>
> SFP support predated (in my tree) the deprecation of the -gpio suffix,
> and despite the SFP binding doc being sent for review, it didn't get
> reviewed so the issue was never picked up.

Really?

https://lore.kernel.org/all/CAL_JsqL_7gG8FSEJDXu=37DFpHjfLhQuUhPFRKcScYTzM4cNyg@mail.gmail.com/


> My understanding is that GPIO will continue to accept either -gpio or
> -gpios for ever, so there shouldn't be any issue here - so converting
> all instances of -gpio to -gpios should be doable without issue.
>
> > If it's that unheard of to have a somewhat complete example why are
> > there multiple dtschema files submitted even by yourself with this same
> > setup?
> > As an example for a consumer device being listed in the provider yaml
> > file is 'gpio-pca95xx.yaml' and for the reverse (provider described in
> > the consumer) I can list 'samsung,s5pv210-clock.yaml',
> > 'samsung,exynos5260-clock.yaml' etc.
>
> My feels are it _is_ useful to show the consumer side in examples.

I think having it is fine here as long as the consumer has a schema.
This case is a bit different as there's really only 1 provider
instance and this is it.

It's the 100s of clock, gpio, interrupt, etc. schemas that we don't
need showing the consumer side over and over.

Rob
