Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97151381AD5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 21:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhEOTs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 15:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEOTs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 15:48:56 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38990C06174A;
        Sat, 15 May 2021 12:47:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id s22so3142227ejv.12;
        Sat, 15 May 2021 12:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+C4ZgeJsuuG+SlCOuV4BKpzOGzkED1R6EFpiv1Hw9yY=;
        b=t3/ufx9fzWVDB8lJ+HMGS4UQ0BKwfdhTWTxOM2663J9li/tBYtd29Dn5eE8Zs4cFdZ
         cYjlYLvywN1s7Hwr4dtitHXVEFUyv1P8WLDWft1zcW9aF5PUXNTzwjB6+E4gYstXUzl/
         3yTLwQUScX0UXRZRfT9tgLAFXWpLuZqzmvX1vW8Zm38OZ/6jCWKNMUrvFqy+6oS+UPiE
         VKUiNcw+S9JyyodvgAvREPDlU+BUev8jZlkWjhqACHaGbIZdGjKN1InoQV8to9VUFoov
         A28zbdemB3DagMmbCXTOFlI4I19RVGep97TPbJFOTY1LQzjo6OGNWXaHpkUS5JA3pFbA
         h1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+C4ZgeJsuuG+SlCOuV4BKpzOGzkED1R6EFpiv1Hw9yY=;
        b=qb+5UX5dpI/BvxLDUFP5qU+bhepdIOS89biBQFq433dHJuBfXvvJzHQIrtg/8j5j5a
         dTqnqym6mMKeqnTe0elucaFA5EEIHeCqJZo6CdBpdkIepLl24Xn2nH+1A/yICGUePqUW
         +BGk3zR2qEpnC90h2ZuMk1Cp8rv+2d3w5/oWFh6XCaCVvBYA9Xkf+rdTjQJpMZAgqm/n
         FOKnwMN9D7YsDsmIwQk5owfeHr5Jz63TfmYOSrrb4TG+tOv1bJHVbW6bUs8LMsDLwtCX
         +vMOBYwZOEHQhbSpaCEYeHDgUa9a8wkVFoyHkxa2NXWzqzITRzotKuPxSeK6Q4ojfTYB
         x+6A==
X-Gm-Message-State: AOAM532b5e1zQJQzAa6rmknreLeu7HNiWkjzuowTXXP1GDYGBEGmm082
        0/USNwoSTNvlUY9hqfBqBX8=
X-Google-Smtp-Source: ABdhPJw+krnJopIblIg67hBCqYadKTx2lyCZtb2eh2JN2rw05RtVb4YeuJsOr1FOJ61zF4o7lJzO2A==
X-Received: by 2002:a17:906:edaf:: with SMTP id sa15mr16414968ejb.174.1621108056438;
        Sat, 15 May 2021 12:47:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id v18sm5557860ejg.63.2021.05.15.12.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 12:47:36 -0700 (PDT)
Date:   Sat, 15 May 2021 21:47:28 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <YKAlUEt/9MU8CwsQ@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
 <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
 <20210515194047.GJ11733@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515194047.GJ11733@earth.li>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 08:40:47PM +0100, Jonathan McDowell wrote:
> On Sat, May 15, 2021 at 08:20:40PM +0200, Ansuel Smith wrote:
> > On Sat, May 15, 2021 at 07:08:57PM +0100, Jonathan McDowell wrote:
> > > On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> > > > Do you want to try a quick patch so we can check if this is the case?
> > > > (about the cover letter... sorry will check why i'm pushing this
> > > > wrong)
> > > 
> > > There's definitely something odd going on here. I went back to mainline
> > > to see what the situation is there. With the GPIO MDIO driver both
> > > switches work (expected, as this is what I run with). I changed switch0
> > > over to use the IPQ MDIO driver and it wasn't detected (but switch1
> > > still on the GPIO MDIO driver was fine).
> > > 
> > > I then tried putting both switches onto the IPQ MDIO driver and in that
> > > instance switch0 came up fine, while switch1 wasn't detected.
> > > 
> > 
> > Oh wait, your board have 2 different switch? So they both use the master
> > bit when used... Mhhh I need to think about this if there is a clean way
> > to handle this. The idea would be that one of the 2 dsa switch should
> > use the already defined mdio bus.
> > 
> > The problem here is that to use the internal mdio bus, a bit must be
> > set or 0 is read on every value (as the bit actually disable the internal
> > mdio). This is good if one dsa driver is used but when 2 or more are
> > used I think this clash and only one of them work. The gpio mdio path is
> > not affected by this. Will check if I can find some way to address this.
> 
> They're on 2 separate sets of GPIOs if that makes a difference - switch0
> is in gpio0/1 and switch1 is on gpio10/11. Is the internal MDIO logic
> shared between these? Also even if that's the case it seems odd that
> enabling the MDIO for just switch0 doesn't work?
> 

The dedicated internal mdio on ipq8064 is unique and present on the
gmac0 address so yes it's shared between them. And this seems to be the
problem... As you notice the fact that different gpio are used for the
different switch fix the problem. So think that to use the dedicated
mdio bus with both switch we need to introduce some type of
syncronization or something like that.
