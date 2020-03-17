Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C71888C6
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCQPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:12:58 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41244 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgCQPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OFQdr3r0anSrSmKzgfABZ3/qHz38m4NvKJkIDNafMtE=; b=MxTLRVFiUr00lRIMIogzyawrH
        rSmgeC3++Rctz9veBeo2Ln5u1ybUwIHneNqPZS2uY0K+KhMk0twij/hXuMN5IKVT3i/PuvsXriBSO
        rhZqD2J9zj/TPOHi4Hsm2gMOjGFWW7GLaZN3eDiMIHh/QculpPupziGJ+nntNRmFBjybo3MV3NB+S
        fcMF7gsIP4JFIP7+QfQMOYx3PUXD18HAsVtnseCrZkG27ecDfHeXbj7lRCeF0Yp7bHOoMkI4vhhB9
        T9w6nGcwI/irMtGmtbzs2lV5uNbBF8PsRD8VSt2zMp99ksq80fv6BnMD4o0y1ySQIJBSPs+YGyj4b
        A2Iw61+tA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33558)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEDtZ-0007og-Sf; Tue, 17 Mar 2020 15:12:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEDtW-0002uK-5j; Tue, 17 Mar 2020 15:12:38 +0000
Date:   Tue, 17 Mar 2020 15:12:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200317151238.GQ25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk>
 <20200317120044.GH5827@shell.armlinux.org.uk>
 <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 04:21:00PM +0200, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Tue, 17 Mar 2020 at 14:00, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Mon, Mar 16, 2020 at 11:15:24AM +0000, Russell King - ARM Linux admin wrote:
> > > On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> > > > On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > > > > Let's get your patch series merged. If you re-spin while addressing
> > > > > Vivien's comment not to use the term "vtu", I think I would be fine with
> > > > > the current approach of having to go after each driver and enabling them
> > > > > where necessary.
> > > >
> > > > The question then becomes what to call it.  "always_allow_vlans" or
> > > > "always_allow_vlan_config" maybe?
> > >
> > > Please note that I still have this patch pending (i.o.w., the problem
> > > with vlans remains unfixed) as I haven't received a reply to this,
> > > although the first two patches have been merged.
> >
> > Okay, I think three and a half weeks is way beyond a reasonable time
> > period to expect any kind of reply.
> >
> > Since no one seems to have any idea what to name this, but can only
> > offer "we don't like the vtu" term, it's difficult to see what would
> > actually be acceptable.  So, I propose that we go with the existing
> > naming.
> >
> > If you only know what you don't want, but not what you want, and aren't
> > even willing to discuss it, it makes it very much impossible to
> > progress.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> 
> As I said, I know why I need this blocking of bridge vlan
> configuration for sja1105, but not more. For sja1105 in particular, I
> fully admit that the hardware is quirky, but I can work around that
> within the driver. The concern is for the other drivers where we don't
> really "remember" why this workaround is in place. I think, while your
> patch is definitely a punctual fix for one case that doesn't need the
> workaround, it might be better for maintenance to just see exactly
> what breaks, instead of introducing this opaque property.
> While I don't want to speak on behalf of the maintainers, I think that
> may be at least part of the reason why there is little progress being
> made. Introducing some breakage which is going to be fixed better next
> time might be the more appropriate thing to do.

The conclusion on 21st February was that all patches should be merged,
complete with the boolean control, but there was an open question about
the name of the boolean used to enable this behaviour.

That question has not been resolved, so I'm trying to re-open discussion
of that point.  I've re-posted the patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
