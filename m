Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A2381A2A
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhEORcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 13:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhEORb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 13:31:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FE9C061573;
        Sat, 15 May 2021 10:30:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r11so2030696edt.13;
        Sat, 15 May 2021 10:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kA0tpI1mUYHchALrWUvn/XBSkrDGvf6V2LCHoFETY8Y=;
        b=XaSeG+mMfX5GQIV0lhmV3971is6O22REZgGwub379qBAzA/hz6ecEvBgz/a1YrRp1R
         pnhXggJj/tXcawnNW4FaCdGry+uM0RlzCsv3MRaQgjbDIwTiesUxfQY5PTaUUwJXfhT7
         NgrjzoTDb/lZgq39H9cm8D+O1ayXsIjF8QrcmqgLvQgK2whEuSZpKsNQNnEqsNcYkzkO
         JcKBQu7b8M2rizqn+9tPTlgd7v3yMSJVuctU2BxrSN6JjyN9DrCGhUBgeXDM0BGw4Tj3
         RIEFy3nbJhZAQktQ66ZR2nRVOepaDl/U7iszLzUoXsyrqzLs6kYTuWzGzQ1dUUr4iqJW
         kM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kA0tpI1mUYHchALrWUvn/XBSkrDGvf6V2LCHoFETY8Y=;
        b=PYN7HtY3ZpuJJ0N2P/ETKgEhE1c8leaLfTANKrHzRODG1AdE5nd/x/zpZKuBKIW+Mi
         7fDkrS+haj3FKMulOBHWdi1LnIuu+JrxaIWzfo/D4wOp9krLGwoQXjbWCKoCg5Ki+Gji
         /ic6chcFB+/P7T9Agxqovnxy0rKmTU02FPi4HmJip2L6F6CGTstvTq1bz0rqiHkAkU0G
         /M6Cetrg5X4ClqCpNkMSY4HXSJHeHQNlXWOYRcUn0AJL/45fIEYXZSCHRiXRWGnlGGJx
         xBC8NgqNdqlB42s6kXyqKU6pKU3Lolmu4x+DuQuQP+JMgZxjcBygrCoSZDSsW9iWZMyg
         Sksg==
X-Gm-Message-State: AOAM530ueOn08yn32eNv4Nc9LhE0pDTzytgjnQNAxfL4jxXKzICxoMix
        cA9NHTfeBeoodjJwKKJ65uzRp5B5VR8aKg==
X-Google-Smtp-Source: ABdhPJxsvUE2fg9X8SPNeJaZQhmhAJEEurM4eNLZdMlYgQPmuZLmbqfofzet2aD5Gc410/iWptplWg==
X-Received: by 2002:aa7:d84e:: with SMTP id f14mr62161873eds.220.1621099840998;
        Sat, 15 May 2021 10:30:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id i19sm5480993ejd.114.2021.05.15.10.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 10:30:40 -0700 (PDT)
Date:   Sat, 15 May 2021 19:30:26 +0200
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
Message-ID: <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515170046.GA18069@earth.li>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 06:00:46PM +0100, Jonathan McDowell wrote:
> On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> > On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > > Fix mixed whitespace and tab for define spacing.
> > > 
> > > Please add a patch [0/28] which describes the big picture of what
> > > these changes are doing.
> > > 
> > > Also, this series is getting big. You might want to split it into two,
> > > One containing the cleanup, and the second adding support for the new
> > > switch.
> > > 
> > > 	Andrew
> > 
> > There is a 0/28. With all the changes. Could be that I messed the cc?
> > I agree think it's better to split this for the mdio part, the cleanup
> > and the changes needed for the internal phy.
> 
> FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
> today. I currently use the GPIO MDIO driver because I saw issues with
> the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> both QCA8337 devices and traffic flows as expected, so no obvious
> regressions from your changes.
> 
> I also tried switching to the IPQ8064 MDIO driver for my first device
> (which is on the MDIO0 bus), but it's still not happy:
> 
> qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13
> 
> J.
> 
> -- 
> One of the nice things about standards is that there are so many of
> them.

Can you try the v6 version of this series? Anyway the fact that 0 is
produced instead of a wrong value let me think that there is some
problem with the mdio read. (on other device there was a problem of
wrong id read but nerver 0). Could be that the bootloader on your board
set the mdio MASTER disabled. I experienced this kind of problem when
switching from the dsa driver and the legacy swconfig driver. On remove
of the dsa driver, the swconfig didn't work as the bit was never cleared
by the dsa driver and resulted in your case. (id 0 read from the mdio)

Do you want to try a quick patch so we can check if this is the case?
(about the cover letter... sorry will check why i'm pushing this wrong)
