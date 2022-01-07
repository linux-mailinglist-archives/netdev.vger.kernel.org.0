Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0BC4879A2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348062AbiAGPUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiAGPUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 10:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2954EC06173F;
        Fri,  7 Jan 2022 07:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E322EB8265E;
        Fri,  7 Jan 2022 15:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696EBC36AF5;
        Fri,  7 Jan 2022 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641568819;
        bh=JZSDTXn831jsHLaeMlhV91a2NBUCYRKTYU4k2JJ3SEY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aiW2Oo9rqnSvZMty9UZIT7Su6WRlpFZC4qB33eV+4HwGl+1IEQ29rltyVDfSbQmYo
         4e+xjseIQ4gjpJnncgYW0+GQl2lY/7Pc42gGUb0HiGc/0qpispy2oluvsAY69ZD+o/
         408clmpmDydeZ97b3Dy1O1mPHnlKDiJt28KxuXWVqXU8bN1D7Dnjh7+Li9+ax4mQwn
         gccb1AzgDKTqPVeTjGMCgkxl1J6N7g4Dn8aJG38k94S3wa9itzjU4IrMFrp6JrHwhB
         p5qTIQsCbQ19nz6d2GayyCfJucnwGsufy68qYS1iPodeLHrJ/P5hRUyh1a7woIqFWF
         MsuEB755uJd1w==
Received: by mail-ed1-f48.google.com with SMTP id q25so14714149edb.2;
        Fri, 07 Jan 2022 07:20:19 -0800 (PST)
X-Gm-Message-State: AOAM530nXhAQM++g7cqQKjyWOX0rHuAG7jLaR7WhDQxEgSMXBgK5evGh
        I+OM54GHhjymdPQD8WCrtFdbar0PsAREhQ4WuQ==
X-Google-Smtp-Source: ABdhPJz1jllAhtHnE/GCaPMpieaWkmlnAW2CajB4Bv3UzewhAkigmenmu4JVTDvGexXd518wf1HJZMvSArTFrZXD/Rw=
X-Received: by 2002:a05:6402:1e88:: with SMTP id f8mr57554194edf.2.1641568817622;
 Fri, 07 Jan 2022 07:20:17 -0800 (PST)
MIME-Version: 1.0
References: <20220107031905.2406176-1-robh@kernel.org> <cf75f1ee-8424-b6b2-f873-beea4676a29f@ti.com>
In-Reply-To: <cf75f1ee-8424-b6b2-f873-beea4676a29f@ti.com>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 7 Jan 2022 09:20:05 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL3PGqmzA0wW37G7TXhbRVgByznk==Q8GhA0_OFBKAycQ@mail.gmail.com>
Message-ID: <CAL_JsqL3PGqmzA0wW37G7TXhbRVgByznk==Q8GhA0_OFBKAycQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Drop required 'interrupt-parent'
To:     Suman Anna <s-anna@ti.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Michal Simek <michal.simek@xilinx.com>,
        - <patches@opensource.cirrus.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        netdev <netdev@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "Nagalla, Hari" <hnagalla@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 8:27 AM Suman Anna <s-anna@ti.com> wrote:
>
> Hi Rob,
>
> On 1/6/22 9:19 PM, Rob Herring wrote:
> > 'interrupt-parent' is never required as it can be in a parent node or a
> > parent node itself can be an interrupt provider. Where exactly it lives is
> > outside the scope of a binding schema.
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../devicetree/bindings/gpio/toshiba,gpio-visconti.yaml  | 1 -
> >  .../devicetree/bindings/mailbox/ti,omap-mailbox.yaml     | 9 ---------
> >  Documentation/devicetree/bindings/mfd/cirrus,madera.yaml | 1 -
> >  .../devicetree/bindings/net/lantiq,etop-xway.yaml        | 1 -
> >  .../devicetree/bindings/net/lantiq,xrx200-net.yaml       | 1 -
> >  .../devicetree/bindings/pci/sifive,fu740-pcie.yaml       | 1 -
> >  .../devicetree/bindings/pci/xilinx-versal-cpm.yaml       | 1 -
> >  7 files changed, 15 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> > index 9ad470e01953..b085450b527f 100644
> > --- a/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> > +++ b/Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
> > @@ -43,7 +43,6 @@ required:
> >    - gpio-controller
> >    - interrupt-controller
> >    - "#interrupt-cells"
> > -  - interrupt-parent
> >
> >  additionalProperties: false
> >
> > diff --git a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> > index e864d798168d..d433e496ec6e 100644
> > --- a/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> > +++ b/Documentation/devicetree/bindings/mailbox/ti,omap-mailbox.yaml
> > @@ -175,15 +175,6 @@ required:
> >    - ti,mbox-num-fifos
> >
> >  allOf:
> > -  - if:
> > -      properties:
> > -        compatible:
> > -          enum:
> > -            - ti,am654-mailbox
> > -    then:
> > -      required:
> > -        - interrupt-parent
> > -
>
> There are multiple interrupt controllers on TI K3 devices, and we need this
> property to be defined _specifically_ to point to the relevant interrupt router
> parent node.
>
> While what you state in general is true, I cannot have a node not define this on
> K3 devices, and end up using the wrong interrupt parent (GIC
> interrupt-controller). That's why the conditional compatible check.

But you could.

The parent node can have a default interrupt-parent and child nodes
can override that. It doesn't matter which one is the default though
typically you would want the one used the most to be the default.
Looking at your dts files, it looks like you all did the opposite. The
only way that wouldn't work is if the parent node is if the parent
node has its own 'interrupts' or you are just abusing
'interrupt-parent' where the standard parsing doesn't work.

You are also free to use 'interrupts-extended' anywhere 'interrupts'
is used and then interrupt-parent being present is an error. How you
structure all this is outside the scope of binding schemas which only
need to define how many interrupts and what are they. Ensuring parents
and cell sizes are correct is mostly done by dtc.

Rob
