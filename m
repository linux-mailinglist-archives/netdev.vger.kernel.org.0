Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA523AC87
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgHCSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCSj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 14:39:58 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D9322BF3;
        Mon,  3 Aug 2020 18:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596479997;
        bh=zWcmrODoC659JuP/iiZsSpUSDUdR2sde8bAIaMFKoV8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o9pgop9nFdv2UywbtTd+TEzTvskli8Uy02WdJCdEiAzCQv+vwv6nufMoqx2hLzcnO
         rPTLr1HCcWEUAbt/PybMf+Ptl7b+Pl1/rEWg4uNTxJr9rFE27QkN37gYbQvyGIY9qI
         Nt9s95W7L48vSlgF6ybNlExcvoy7DL+GdCc3zsZQ=
Received: by mail-ot1-f53.google.com with SMTP id q9so13010317oth.5;
        Mon, 03 Aug 2020 11:39:57 -0700 (PDT)
X-Gm-Message-State: AOAM533nvPtZTGs9RqUwL5WxvpY3pplWQeYz1qRRf7/KaMqtIgIOwQBJ
        PjU+qhFneHaiOZOCORfjeZW4QfNxvNJ07duJZQ==
X-Google-Smtp-Source: ABdhPJyLaMO5+UxidA5N3J8p/y+1jpOSmXbRuL/J/Xw+XiFNA8UOalgZJ86FLVjSZOdCuUY3SqiQe0gbUGXmqKcKPK0=
X-Received: by 2002:a9d:7f84:: with SMTP id t4mr6532982otp.192.1596479997122;
 Mon, 03 Aug 2020 11:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz> <20200103235359.GA23875@bogus>
 <202007290112.32007.pisa@cmp.felk.cvut.cz> <202008012327.02185.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202008012327.02185.pisa@cmp.felk.cvut.cz>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 3 Aug 2020 12:39:44 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKgzQRo4rn5eL0MKz_df5N2JbZmOo_mmJ05UufK8fsx0g@mail.gmail.com>
Message-ID: <CAL_JsqKgzQRo4rn5eL0MKz_df5N2JbZmOo_mmJ05UufK8fsx0g@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     c.emde@osadl.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 3:28 PM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
>
> Hello Rob ad others,
>
> On Wednesday 29 of July 2020 01:12:31 Pavel Pisa wrote:
> > On Saturday 04 of January 2020 00:53:59 Rob Herring wrote:
> > > On Sat, Dec 21, 2019 at 03:07:31PM +0100, pisa@cmp.felk.cvut.cz wrote:
> > > > From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > > >
> > > > Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > > > ---
> > > >  .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61
> > > > ++++++++++++++++++++++ 1 file changed, 61 insertions(+)
> > > >  create mode 100644
> > > > Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
> > >
> > > Bindings are moving DT schema format now. Not something I'd require on a
> > > respin I've already reviewed, but OTOH it's been 10 months to respin
> > > from v2. So:
> > >
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > >
> > > If you have a v4, then please convert to a schema.
> >
>
> ...
>
> > I am trying to resolve that only one review feedback which I have received
> > before v4 patches sending. I have spent half day to update and integrate
> > self build packages to my stable Debian to can run
> >
> >    make -k dt_binding_check
> >
> > but unfortunately, I have not achieved promissing result even when tested
> > on Linux kernel unpatched sources. I used actual git
> > dt-schema/dt-doc-validate with 5.4 kernel build but I get only long series
> > of
>
> I have succeed to run make dt_binding_check on stable Debian with 5.4
> kernel with only denumerable bunch of errors, probably normal one.
> Details to make dt_binding_check usable on stable Debian later.
>
> When invoked with base directory specified
>
> /usr/local/bin/dt-doc-validate -u /usr/src/linux-5.4/Documentation/devicetree/bindings/ net/can/ctu,ctucanfd.yaml
>
> then no problem is reported in ctu,ctucanfd.yaml .
> Please is the specification correct even after human check?
>
> > pi@baree:/usr/src/linux-5.4-rt/_build/arm/px6$ make dt_binding_check -k
> > GNUmakefile:40: *** mixed implicit and normal rules: deprecated syntax
> > make -C /usr/src/linux-5.4-rt O=/usr/src/linux-5.4-rt/_build/arm/px6/
> > ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- QTDIR=/usr/share/qt4
> > dt_binding_check CHKDT   Documentation/devicetree/bindings/arm/actions.yaml
> > /usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/actions.yaml:
> > found incompatible YAML document in "<unicode string>", line 2, column 1
> > make[3]: ***
>
> The remark to save time of others, actual stable Debian Buster provides package
> python3-ruamel.yaml in 0.15.34-1+b1 version. But use of make dt_binding_check
> and dt-doc-validate and dt-validate with this version lead to many errors
> "found incompatible YAML document". The validation tools can be make
> to work when next packages are added and replaced in stable Debian

pip/setup.py should check the dependencies which includes
'ruamel.yaml>0.15.69'. Did you not use pip?

> python3-pyrsistent 0.15.5-1
> python3-pyfakefs 4.0.2-1
> python3-zipp 1.0.0-3
> python3-importlib-metadata 1.6.0

These must all be indirect dependencies as I have no idea what they provide.

> python3-jsonschema 3.2.0-3
> python3-ruamel.yaml.clib 0.2.0-3
> python3-ruamel.yaml 0.16.10-2
>
> The dependencies and interdependence of the tools are really wide and that
> the tools are unusable in the actual regular Debian stable distribution
> should be described somewhere visible enough to save developers
> time.

I can't document distro specifics for what I don't have. Manually
documenting dependencies and their versions seems like a recipe for
inaccurate and out of date documentation.

Rob
