Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E4C4684DC
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384949AbhLDMqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhLDMqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 07:46:18 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7406AC061751;
        Sat,  4 Dec 2021 04:42:52 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x15so22992705edv.1;
        Sat, 04 Dec 2021 04:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2n1fNN+PJjJwaJjJvU82cMiwh7uZr6sJndttoiAU83w=;
        b=ZWtu+Jt9eah7JczO6qAyOkk+iI3ChP9qxjyzKPMExlYZMV/1kClCMPIZlITGEKyXY/
         zu/mAIO4Wsl2lafS5tRGgYNWffDrl8gma6G0v3ZpAp/6FkPEQtNAUE8GpbRc6we0NTum
         8+Rtye4sE8QTmbWsc86RmXwntSLQqsktlnMAfw3Gw/zA0bh8G9lC11IIX7tfwflQblix
         Sd6z4gqq0f08FZvWCzrOrRP6q0Pt1+qq5h/24hWgd7IQUL+SHxzk2HN8qVGoAtz8t9Rj
         V3NBcnQfu6/1bP+L0gU4j2Mhkc3f+6ttsiNoaNybGFQSTCS9h5wNruZSkhmWv9Moq5J8
         yOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2n1fNN+PJjJwaJjJvU82cMiwh7uZr6sJndttoiAU83w=;
        b=g2wKSLbqIgyNO8walX23RGG3OUZwEjbx2saWKD75spFqahFuB6YE+g3A5wZhWWJRiB
         nJIJlrZlRBOf2gb+rGcwxjuxxWuO1TDFewmONvbSAxnUBcwN1G6Rg9cr4N3xH9CMnHmH
         eTPH8T1FewkqfkppOeCS2Eq3ugEfyB+64g6wCwISlgvZvuS30GH/C8KG02O7qPRiO41W
         MpvF5doNAbpfjlTjF+FDH5N5wlW/MvsR9UfUXnHyF97XaIswTl+GAonX807L5imMOJmp
         t7T9uc9BEH+0p4mv6ADOuyY7/+4F4Cj+L4FuUPTgg15BXeI7aPWMpBSWuiPuMPVtekej
         pVBA==
X-Gm-Message-State: AOAM5308MWwED2Yq+u9LVp7OWVDIKgQyDJyDoPh3D8EWbqnYVNNx1MJH
        OzI6XspqqvEMAmXaEV7As41JcfREBaw=
X-Google-Smtp-Source: ABdhPJwsrSJDKXm/3ArbLb6lZtGfFZl8FCSdGtdDuyTXKo0CPpQrsfJbiWCPSfn4iTknPYlYWQJ02w==
X-Received: by 2002:a17:907:3e22:: with SMTP id hp34mr31297502ejc.491.1638621770817;
        Sat, 04 Dec 2021 04:42:50 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id x7sm4043317edd.28.2021.12.04.04.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 04:42:50 -0800 (PST)
Date:   Sat, 4 Dec 2021 14:42:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211204124249.uldyjnf44xgqoq4o@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
 <20211123212441.qwgqaad74zciw6wj@skbuf>
 <20211123232713.460e3241@thinkpad>
 <20211123225418.skpnnhnrsdqrwv5f@skbuf>
 <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
 <20211124120441.i7735czjm5k3mkwh@skbuf>
 <20211124131703.30176315@thinkpad>
 <20211124123135.wn4lef5iv2k26txb@skbuf>
 <20211202232550.05bda788@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211202232550.05bda788@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 11:25:50PM +0100, Marek Behún wrote:
> On Wed, 24 Nov 2021 14:31:35 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > > > To err is human, of course. But one thing I think we learned from the
> > > > old implementation of phylink_validate is that it gets very tiring to
> > > > keep adding PHY modes, and we always seem to miss some. When that array
> > > > will be described in DT, it could be just a tad more painful to maintain.
> > >
> > > The thing is that we will still need the `phy-mode` property, it can't
> > > be deprecated IMO.
> >
> > Wait a minute, who said anything about deprecating it? I just said
> > "let's not make it an array, in the actual device tree". The phy-mode
> > was, and will remain, the initial MII-side protocol, which can or cannot
> > be changed at runtime.
>
> Hello Vladimir,
>
> I was told multiple times that device-tree should not specify how the
> software should behave (given multiple HW options). This has not been
> always followed, but it is preferred.
>
> Now the 'phy-mode' property, if interpreted as "the initial MII-side
> protocol" would break this rule.

Isn't the rule already broken? Like it or not, this is exactly what the
phy-mode property is today. Even the compatibility mode added by your
patch right here _depends_ on that exact interpretation.

> This is therefore another reason why it should either be extended to an
> array,

The reason being what, exactly? To me it is still non sequitur.
I think you are saying that by listing all supported PHY modes, it
becomes less of a "hardware configuration" and more of a "hardware
description". But my point is that "all PHY modes" is a pretty moving
target, and it shouldn't be put in the device tree because that should
be rather stable.

> or, if we went with your proposal of 'num-lanes' + 'max-freq',
> deprecated (at least for serdes modes). But it can't be deprecated
> entirely, IMO (because of non serdes protocols).

You haven't exactly formulated why you think the implication is that
phy-mode could be deprecated, if kept "not an array". Because it can't.
If I understand you correctly, you are basically implying that in an
ideal world where all MAC drivers and all PHY drivers could list out all
their capabilities, a given MAC + PHY pair would just work out the
highest common SERDES protocol that can be electrically supported. But
as long as the Generic PHY driver is going to be a thing, this will be
technically impossible, because there isn't any IEEE standardized way of
determining SERDES protocols. So no, the phy-mode will continue to have
its role of specifying the initial MII-side protocol, which can or
cannot be changed at runtime.

Also, as a second point, my guess is that there will always be SERDES
blocks where changing the protocol at runtime is so complicated, or has
so many restrictions, that "wont't change" is indistinguishable from
"cant't change". And the network drivers that use these SERDES blocks
will therefore use the device tree to specify the phy-mode that the
SERDES lane is preconfigured for, which is not the same as describing
the capability, technically speaking, but is nonetheless virtually
indistinguishable. So I don't see that the phy-mode should become
deprecated either way.

>
> I thought more about your proposal of 'num-lanes' + 'max-freq' vs
> extending 'phy-mode'.
>
> - 'num-lanes' + 'max-freq' are IMO closer to the idea of device-tree,
>   since they describe exactly how the parts of the device are connected
>   to each other
> - otherwise I think your argument against extending 'phy-mode' because
>   of people declaring support for modes that weren't properly tested and
>   would later be found broken is invalid, since the same could happen
>   for 'num-lanes' + 'max-freq' properties

To reiterate my points:

- The worst cases of the phy-mode array vs the physical properties of
  the lanes are about just as bad, if you're set out to misuse them.
  I.e. you can first declare that a lane is capable of 1.125 GHz, then
  "oh, you know what, now I tested 3.125 GHz and that works too", then
  "as a matter of fact, 10.3125 GHz works too", then "hey, there are
  actually 4 lanes, not just one!". I'm sorry, nobody can help you if
  you do that.

- The best cases seem to be a bit more disproportionate on the other
  hand (i.e. when things are done "right" by device tree authors):
  With the phy-mode array, if you don't want to declare things that
  haven't been tested, it gets clunky: you'd have an ever increasing
  array of gibberish, and multiple versions of it in flight.
  On the other hand, doing the 'num-lanes' + 'max-freq' thing right
  would IMO mean that you validate the electrical parameters of the
  SERDES lane at the maximum intended and testable data rate and width.
  I truly believe this can be done orthogonally to actually testing an
  Ethernet protocol, which is why I'm actually suggesting it. This
  description can't bit rot no matter what you do, if it was done
  correctly (see above). It also appears easier to look at physical
  properties and say "yes, this looks about right", than looking at a
  potentially large phy-mode array where some modes are oddly missing
  and you don't really know why.

- If you discover that some phy-modes can't be supported despite the
  electrical parameters allowing it (your SMC firmware example), it
  becomes "not a device tree problem" if you don't put the phy-mode
  array there in the first place.

So my proposal simply comes from trying to optimize for the "doing
things right" case (hopefully this would also be the common case).
If we look at ways in which people will find ways to screw things up,
I'm sure that the sky is the limit.

> - the 'phy-mode' property already exists. I think if we went with the
>   'num-lanes' + 'max-freq' proposal, we would need to deprecate
>   'phy-mode' for serdes protocols (at least for situations where
>   multiple modes can be used, since then 'phy-mode' would go against
>   the idea of the rule I mentioned in first paragraph)

I don't understand this argument, I'm sorry. I only suggested that you
don't introduce a phy-mode array until there is a proven need for it.
You've said that your current use cases are fine with just the
"compatibility" mode where you extend the single phy-mode from the
device tree based on supported_interfaces. I don't think you _have_ to
introduce my suggested electrical parameters right now, either. It is
just an alternative solution to an unspecified problem.

But one other aspect that maybe should be considered is the fact that
your compatibility mode would introduce some weirdness: if the phy-mode
array in the device tree has exactly one element, then you say "oh, this
is an old device tree, let me fix this up based on supported_interfaces
and potentially change towards protocols that aren't present in the
device tree". But if the phy-mode array has more than one element, you
don't allow changing towards protocols outside of that array. That is
strange. I think _you_ are changing the meaning of the phy-mode property.
If you restrict the array of phy-modes via some other mechanism (like
dynamically through code that populates supported_interfaces based on
stuff like SMC firmware queries, lane electrical parameters), then
transforming the phy-mode property into an array has literally no benefits,
and there won't be any backwards compatibility problem to handle.

> Vladimir, Rob has now given R-B for the 'phy-mode' extension patch.
>
> I am wondering now what to do, since other people haven't given their
> opinions here. Whether to re-send the series, and maybe start discussing
> there, or waiting more.

Go with the approach you feel the most comfortable justifying, I have no
stake here. In fact I would be glad too if other people shared their opinion
on how to move things forward.
