Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D435381A76
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhEOSWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 14:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhEOSWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 14:22:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001F4C061573;
        Sat, 15 May 2021 11:20:52 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b25so3181151eju.5;
        Sat, 15 May 2021 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVcuYdJjYaIH0CSduT6HAJlxVW2hW2aJ4fiOlhrzpLM=;
        b=n1d/cQZ8JMDqWagHEfeqfXlnDquwpAC/QBCgusJbv5+DzwGOw36Fjx1UAcMzweuzGT
         kupFkBVNKY9lXRQLMzLUrt3dk99Wsc6dzVqnA6WcrLnTClWqtI1LGZ5bJbMaquXUhRGk
         15QK4neGxtKVufARrg6fELtRwXc1DgabCuu2Oa9ybXT7ntDXX16LLcaWsiu/vGKakk/A
         VVkoUhMYTlo0EGysOf1e8hFSrkpftOgmb0OAH5uKPi5OeQOqPkEc/D3GXewTNsy3DnEo
         efwRYxKqulWhftFGAL4RhubKA+qj73vtfVBTc96R/XUodR4YaozS05E+u2uZCT/z5Zn+
         ilaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVcuYdJjYaIH0CSduT6HAJlxVW2hW2aJ4fiOlhrzpLM=;
        b=NvGblUoWWKOL9jrdTQM00HiKn3t1nw9LXzl+HGBn+EF1Bi/2a03KnKb3L5TRxbFrAP
         Y3Gi50V399eNCD3LqnNf51D6vS46VYnxq0rugIdtFHv9F++4SuYT8QuVFUeFOMx5Gy/G
         QHmhze8vNKc5GUgUz5jRjBJKeP73NTSZS2ifDo2bkHfjBDEGgdVVRpdpu1iSryHEOsr1
         P0878PnrTmCDZapo9n+uOQyboDL7iLQUgJlg851UMr6PaeUwlXoIFOjSWDzHGcj+74YM
         sjCA7YqtDzOKtpoQIRFFDV36GxvAo5Zr6Kk4pDPtnGIuOEHYUv9FXbShCN3tLdD7Tp/1
         OtzA==
X-Gm-Message-State: AOAM530cOhk95B9Eo57RRO5d40k9qNSmhjwWOehvlOTwYJio5H9LrGti
        OHHQ60LZOgAXkcn4qDwGbRI=
X-Google-Smtp-Source: ABdhPJyyEFk3B31JPwBtE0sHhGvMBq5KzO/8u+GS7VObH7eoEWjBIBosTK0WFiW6yGa5jNAjs6eRxw==
X-Received: by 2002:a17:906:1957:: with SMTP id b23mr54298330eje.209.1621102851503;
        Sat, 15 May 2021 11:20:51 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id z4sm7256182edc.1.2021.05.15.11.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 11:20:51 -0700 (PDT)
Date:   Sat, 15 May 2021 20:20:40 +0200
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
Message-ID: <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515180856.GI11733@earth.li>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 07:08:57PM +0100, Jonathan McDowell wrote:
> On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> > On Sat, May 15, 2021 at 06:00:46PM +0100, Jonathan McDowell wrote:
> > > On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> > > > On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > > > > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > > > > Fix mixed whitespace and tab for define spacing.
> > > > > 
> > > > > Please add a patch [0/28] which describes the big picture of what
> > > > > these changes are doing.
> > > > > 
> > > > > Also, this series is getting big. You might want to split it into two,
> > > > > One containing the cleanup, and the second adding support for the new
> > > > > switch.
> > > > > 
> > > > > 	Andrew
> > > > 
> > > > There is a 0/28. With all the changes. Could be that I messed the cc?
> > > > I agree think it's better to split this for the mdio part, the cleanup
> > > > and the changes needed for the internal phy.
> > > 
> > > FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
> > > today. I currently use the GPIO MDIO driver because I saw issues with
> > > the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> > > both QCA8337 devices and traffic flows as expected, so no obvious
> > > regressions from your changes.
> > > 
> > > I also tried switching to the IPQ8064 MDIO driver for my first device
> > > (which is on the MDIO0 bus), but it's still not happy:
> > > 
> > > qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13
> > > 
> > 
> > Can you try the v6 version of this series?
> 
> Both the v6 qca8k series and the separate ipq806x mdio series, yes?
> 
> > Anyway the fact that 0 is produced instead of a wrong value let me
> > think that there is some problem with the mdio read. (on other device
> > there was a problem of wrong id read but nerver 0). Could be that the
> > bootloader on your board set the mdio MASTER disabled. I experienced
> > this kind of problem when switching from the dsa driver and the legacy
> > swconfig driver. On remove of the dsa driver, the swconfig didn't work
> > as the bit was never cleared by the dsa driver and resulted in your
> > case. (id 0 read from the mdio)
> > 
> > Do you want to try a quick patch so we can check if this is the case?
> > (about the cover letter... sorry will check why i'm pushing this
> > wrong)
> 
> There's definitely something odd going on here. I went back to mainline
> to see what the situation is there. With the GPIO MDIO driver both
> switches work (expected, as this is what I run with). I changed switch0
> over to use the IPQ MDIO driver and it wasn't detected (but switch1
> still on the GPIO MDIO driver was fine).
> 
> I then tried putting both switches onto the IPQ MDIO driver and in that
> instance switch0 came up fine, while switch1 wasn't detected.
> 

Oh wait, your board have 2 different switch? So they both use the master
bit when used... Mhhh I need to think about this if there is a clean way
to handle this. The idea would be that one of the 2 dsa switch should
use the already defined mdio bus.

The problem here is that to use the internal mdio bus, a bit must be
set or 0 is read on every value (as the bit actually disable the internal
mdio). This is good if one dsa driver is used but when 2 or more are
used I think this clash and only one of them work. The gpio mdio path is
not affected by this. Will check if I can find some way to address this.

> If there's a simple patch that might give more debug I can try it out.
> 
> J.
>
> -- 
>    "Reality Or Nothing!" -- Cold   |  .''`.  Debian GNU/Linux Developer
>               Lazarus              | : :' :  Happy to accept PGP signed
>                                    | `. `'   or encrypted mail - RSA
> |   `-    key on the keyservers.
