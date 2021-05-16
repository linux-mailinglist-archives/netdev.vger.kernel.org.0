Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5583381BD9
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 02:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhEPAYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 20:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbhEPAYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 20:24:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25111C061573;
        Sat, 15 May 2021 17:23:23 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r11so2639932edt.13;
        Sat, 15 May 2021 17:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e4L5XZ9wHdprc6B00u4nV3zACT6/N/2Up5tlE5GyavQ=;
        b=qq1sKIHwJ0nEnqhrgjv+3+vqZyBsWIqoKwC0O19Qb6P7XFVIwcRPlsIjtoG2aK6DeH
         96bjni90hjujNzI5+lVsvvMHBwjB1DarYQikqLyD8fGIlJexznIDz6SRahhVFooqKmvo
         rFr/EK+B5XFcUo07ITBA8Gc98XfBIz/R30hc/rXeZYTssEXjXwy+sI1Svkp5+1oIv+sE
         38XtufNPMesvEH7P07/D9Jcf3DvXjpjHo0YD0dbTWwjLgZr/or9hCKiJynsV+ivC9oRq
         8u8xl2skZp6xC5iXmRkwn3zzuvqVHvaxLp/B0IFkYsTHKGWGN3yO5JKc4X0g9BaS4nsR
         t8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e4L5XZ9wHdprc6B00u4nV3zACT6/N/2Up5tlE5GyavQ=;
        b=uhlfayTEQIMRulZKiRzy+GWNfWY7FPPEXgvvl89McP4EfvOH/m1FofDyIckC/2LqUE
         xZkynSxSj/fwWEY5g6lrf7aEu/bDNVMedAwJQRjuzD7Ty/2ITl/pPjwa9Kinduplkg63
         pnplttbytqPJZ58tGEE61YyEWJO02W4kXLC9+AJVLn5uVE7y8bM6Clq3KKb63WB2nO0k
         k52M2Sshl8TQ9A7ofwMnL5P6l8HV1hUuJTHRrlF3TppoJyS/EZEO+p7J8+UQc9PapHr0
         gRQwRjtWvVzyoZQoBte0DwtMY4BsfQpzcsQn7Ndzs/urfXS6CVuC6bL85feaCVnvT7Qi
         /5OQ==
X-Gm-Message-State: AOAM533enPYZCSGmqF2E1BT+RNHrx2ZuP3aa2vhPXtIZj6ozTEKjXsbI
        DXxbPLY/93ZOUqiymEi+488=
X-Google-Smtp-Source: ABdhPJzCq6V3iyjdASLJ44CJKfVroWLu9PvwDBrFYhnKqyeKPWz0CQDx+un1mnCFFQ48mLe60cxkhw==
X-Received: by 2002:a05:6402:124b:: with SMTP id l11mr5465700edw.137.1621124600140;
        Sat, 15 May 2021 17:23:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id y11sm7416554edd.91.2021.05.15.17.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 17:23:19 -0700 (PDT)
Date:   Sun, 16 May 2021 02:23:18 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <YKBl9kK3AvG1wWXZ@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
 <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
 <20210515194047.GJ11733@earth.li>
 <YKAlUEt/9MU8CwsQ@Ansuel-xps.localdomain>
 <YKBepW5Hu3FEG/JJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKBepW5Hu3FEG/JJ@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 01:52:05AM +0200, Andrew Lunn wrote:
> > > They're on 2 separate sets of GPIOs if that makes a difference - switch0
> > > is in gpio0/1 and switch1 is on gpio10/11. Is the internal MDIO logic
> > > shared between these? Also even if that's the case it seems odd that
> > > enabling the MDIO for just switch0 doesn't work?
> > > 
> > 
> > The dedicated internal mdio on ipq8064 is unique and present on the
> > gmac0 address so yes it's shared between them. And this seems to be the
> > problem... As you notice the fact that different gpio are used for the
> > different switch fix the problem. So think that to use the dedicated
> > mdio bus with both switch we need to introduce some type of
> > syncronization or something like that.
> 
> Please could you describe the hardware in a bit more details. Or point
> me at a datasheet. It sounds like you have an MDIO mux? Linux has this
> concept, so you might need to implement a mux driver.
> 
> 	 Andrew

Datasheet of ipq8064 are hard to find and pricey.
Will try hoping I don't write something very wrong.
Anyway on the SoC there are 4 gmac (most of the time 2 are used
and represent the 2 cpu port) and one mdio bus present on the gmac0
address. 
Normally on these SoC they add a qca8337 switch and it's common to use
2 gmac port as cpu port. The switch can be interfaced using UART or MDIO.
Normally the uart interface is used, but it's slower than using the mdio
dedicated interface. Only mdio or uart can be used as the switch use the
same pins.
So I think the problem here is that only one switch can use the mdio bus
exposed by gmac0 and any other must use a gpio slow path.
Anyway about the use of the MASTER path and all this mess, the 
qca8k: extend slave-bus implementations series contains lots of info
about this[1].

[1] http://patchwork.ozlabs.org/project/netdev/patch/20190319195419.12746-3-chunkeey@gmail.com/
