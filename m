Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E27474ECB
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhLNXyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhLNXyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:54:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424DCC061574;
        Tue, 14 Dec 2021 15:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB32B81D7B;
        Tue, 14 Dec 2021 23:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A22C34600;
        Tue, 14 Dec 2021 23:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639526067;
        bh=NbVNYrferHfK7Et1tLU+6jHiQp8Yu5js3Qgqf8gRZ6w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=So5j1gY28yYedmfARaWH3xdXnuzVqawAwtFbovlmfZAbQPdwiJ8Kzrc0DUAqccodD
         +vCvksQ4y8UdS9RqJcCjHRh4oBlKbr8AyblSWHKevSlUrdAxt5Fpv4kXiSlV47oAx6
         l3jOvluU9M0flvnDnkaNuyS6F90UY8Av9KmTj6fqDMFv2WsnCdY5U95Ft7CSL2YLFp
         NmD0oVW1YP+kHTwR//XR2HbNI90O9Y0+yEti+Jr9sAfLiqsHdlpTQH15mES76oL70l
         4CyWlh10r1RkLjTeyxU/bFqqQ7/P97IVhirls5gDgVRnhDfR5wcFCBcXVHyAT3mEaK
         SkwNzXKCTgmkg==
Received: by mail-ed1-f45.google.com with SMTP id v1so69013257edx.2;
        Tue, 14 Dec 2021 15:54:27 -0800 (PST)
X-Gm-Message-State: AOAM5330r8jCF+OhuRfoDEnHk55JBSX6cIOlEwsPckn2W5oSZI/Aa/6k
        fcTBTKYtId2AWEA/rDnoAvsrrcj5P7GD9+SRXQ==
X-Google-Smtp-Source: ABdhPJzp/5VvUlwABGdKDrORoiAKsOFL9lfiyfvDlKLdyjmNKuH0Av0WZQ9j/LmjnxdTEMVKsH0dKrI/HjqdDOtI/UE=
X-Received: by 2002:a17:907:7b98:: with SMTP id ne24mr8557534ejc.14.1639526066241;
 Tue, 14 Dec 2021 15:54:26 -0800 (PST)
MIME-Version: 1.0
References: <20211214163315.3769677-1-davidm@egauge.net> <20211214163315.3769677-3-davidm@egauge.net>
 <1639512290.330041.3819896.nullmailer@robh.at.kernel.org> <e88e908e720172d8571d48bd1ebdab3617534f73.camel@egauge.net>
In-Reply-To: <e88e908e720172d8571d48bd1ebdab3617534f73.camel@egauge.net>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 14 Dec 2021 17:54:14 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLFyaAvTGQJc0GjYbXwyhpmfpRm3_rkGopD8cz6-ZX5zw@mail.gmail.com>
Message-ID: <CAL_JsqLFyaAvTGQJc0GjYbXwyhpmfpRm3_rkGopD8cz6-ZX5zw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] wilc1000: Document enable-gpios and reset-gpios properties
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, netdev <netdev@vger.kernel.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 5:30 PM David Mosberger-Tang <davidm@egauge.net> wrote:
>
> On Tue, 2021-12-14 at 14:04 -0600, Rob Herring wrote:
> > On Tue, 14 Dec 2021 16:33:22 +0000, David Mosberger-Tang wrote:
> > > Add documentation for the ENABLE and RESET GPIOs that may be needed by
> > > wilc1000-spi.
> > >
> > > Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> > > ---
> > >  .../net/wireless/microchip,wilc1000.yaml        | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > >
> >
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> >
> > yamllint warnings/errors:
> >
> > dtschema/dtc warnings/errors:
> > Error: Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.example.dts:30.37-38 syntax error
> > FATAL ERROR: Unable to parse input tree
> > make[1]: *** [scripts/Makefile.lib:373: Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.example.dt.yaml] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:1413: dt_binding_check] Error 2
>
> So this error appears due to GPIO_ACTIVE_HIGH and GPIO_ACTIVE_LOW in these
> lines:
>
>         enable-gpios = <&pioA 5 GPIO_ACTIVE_HIGH>;
>         reset-gpios = <&pioA 6 GPIO_ACTIVE_LOW>;
>
> I can replace those with 0 and 1 respectively, but I doubt a lot of people would
> recognize what those integers standard for.  Is there a better way to get this
> to pass?

Include the header(s) you use in the example.

Rob
