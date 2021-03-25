Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A434935C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCYNyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhCYNye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107E061A1F;
        Thu, 25 Mar 2021 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616680474;
        bh=9cCh/Ri/z2+Odfp8fgNhXZatXuIlfKT2e35U/11gViM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OIhAdEKeaPTNJBVu93gYKdMbSV5Tw07ueeAvGhnnK90bVV2lIxm+jzZisLdQBA7Vp
         JNHVmNuWj6AVDRXzsCtBSCzXidJrqiUtFy8ga+JYmotBT7wkV7QLvml8btnkf8uq09
         E33fNbIb6lOCNkZrY5kn4HNzGxcrhRZpZFkVw13ag/Ps+Dn15qLDYv1TCPPAW4fmfk
         8tpKNRC9TpjXf1zr5uUju82A5UvVUsQOH5Tw5H9dKnIxtgvyq4shrtUdEjsIfW9+qS
         f+QqNfWMbgCiozlQKi6gpP7l4QYOavoUPe0SEBf2w1TVGbrtRTGMgHn0QBUpedi67O
         2519mPJ63v9rw==
Received: by mail-ed1-f54.google.com with SMTP id x21so2516848eds.4;
        Thu, 25 Mar 2021 06:54:33 -0700 (PDT)
X-Gm-Message-State: AOAM533OnYqR4Laf7xteXo4atqrpfGnbayExa3kmWe21EDZc5SwTAfvQ
        MEOD+qlaYDXg0l8xmxanToGjmYxZZPJuoicmNg==
X-Google-Smtp-Source: ABdhPJx0cV0wVkph5mUWnXkmOeU9aKgZeiIm7OQv6WVwA/pSaJ+FPCIEbzNLc0D2XD53h0EXxaOZo/j7Jk81NKks7x8=
X-Received: by 2002:a05:6402:c88:: with SMTP id cm8mr9196883edb.62.1616680472700;
 Thu, 25 Mar 2021 06:54:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210312195214.4002847-1-robert.hancock@calian.com>
 <20210312195214.4002847-2-robert.hancock@calian.com> <20210324170806.GA3252450@robh.at.kernel.org>
 <9d9c8eb80f9b1573931a948e69ec0a44b65491b7.camel@calian.com>
In-Reply-To: <9d9c8eb80f9b1573931a948e69ec0a44b65491b7.camel@calian.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 25 Mar 2021 07:54:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKxVH+Z2m09+JFMON8DTeuK4kK73qWB-qxT=_AnZ_L0-g@mail.gmail.com>
Message-ID: <CAL_JsqKxVH+Z2m09+JFMON8DTeuK4kK73qWB-qxT=_AnZ_L0-g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 v3 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:19 AM Robert Hancock
<robert.hancock@calian.com> wrote:
>
> On Wed, 2021-03-24 at 11:08 -0600, Rob Herring wrote:
> > On Fri, Mar 12, 2021 at 01:52:13PM -0600, Robert Hancock wrote:
> > > Update DT bindings to describe all of the clocks that the axienet
> > > driver will now be able to make use of.
> > >
> > > Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> > > ---
> > >  .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++++++-----
> > >  1 file changed, 19 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > > b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > > index 2cd452419ed0..b8e4894bc634 100644
> > > --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > > +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > > @@ -42,11 +42,23 @@ Optional properties:
> > >               support both 1000BaseX and SGMII modes. If set, the phy-mode
> > >               should be set to match the mode selected on core reset (i.e.
> > >               by the basex_or_sgmii core input line).
> > > -- clocks   : AXI bus clock for the device. Refer to common clock bindings.
> > > -             Used to calculate MDIO clock divisor. If not specified, it is
> > > -             auto-detected from the CPU clock (but only on platforms where
> > > -             this is possible). New device trees should specify this - the
> > > -             auto detection is only for backward compatibility.
> > > +- clock-names:       Tuple listing input clock names. Possible clocks:
> > > +             s_axi_lite_clk: Clock for AXI register slave interface
> > > +             axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS
> > > interfaces
> > > +             ref_clk: Ethernet reference clock, used by signal delay
> > > +                      primitives and transceivers
> > > +             mgt_clk: MGT reference clock (used by optional internal
> > > +                      PCS/PMA PHY)
> >
> > '_clk' is redundant.
>
> True, but there are existing device trees which already referenced these names
> because those are what was used by the Xilinx version of this driver and hence
> the Xilinx device tree generation software. So for compatibility I think we are
> kind of stuck with those names..

upstream? If not, then it doesn't matter what downstream is doing.
However, this isn't that important, so it's fine.

Acked-by: Rob Herring <robh@kernel.org>
