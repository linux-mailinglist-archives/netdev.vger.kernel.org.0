Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04951882D1
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgCQMBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:01:10 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38700 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgCQMBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qxK0C9jTNnluhYNXzSgy9SFFooUP5xX2YpbUBq64+Ec=; b=JjOwHDpiPvfl/uKtY12YJiOmV
        Xht5bBMgG1XjYXKJRm2va9He0lHisj5cHPKBgVpun2++M9gIFDSKVt5skLEKgiqyFLh8nR8N0XPOw
        cj8rWjTzoyO6QCM39QMaBM/qJo4en83LkQqa1dINTXHKsMF3QlIK7b/yim2Lebl5mds8QnwCmoASo
        lXCGGx96yl5Ayiop0x6JMtIu0jsfxwC8LQ7adtCt2lLoUKmWIzpSo8w64nxowOogc3mS2XsVPcnBx
        kg63N0bwG99h3eiT6Oqco1E4zKoOTdAbXbL6hNHSVLdcVGKuHOGLgG93j5oyDG9DXHPocfth7TyoI
        56orBgweA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54216)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEAtt-0006sp-10; Tue, 17 Mar 2020 12:00:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEAto-0002mc-9K; Tue, 17 Mar 2020 12:00:44 +0000
Date:   Tue, 17 Mar 2020 12:00:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200317120044.GH5827@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316111524.GE5827@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 11:15:24AM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> > On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > > Let's get your patch series merged. If you re-spin while addressing
> > > Vivien's comment not to use the term "vtu", I think I would be fine with
> > > the current approach of having to go after each driver and enabling them
> > > where necessary.
> > 
> > The question then becomes what to call it.  "always_allow_vlans" or
> > "always_allow_vlan_config" maybe?
> 
> Please note that I still have this patch pending (i.o.w., the problem
> with vlans remains unfixed) as I haven't received a reply to this,
> although the first two patches have been merged.

Okay, I think three and a half weeks is way beyond a reasonable time
period to expect any kind of reply.

Since no one seems to have any idea what to name this, but can only
offer "we don't like the vtu" term, it's difficult to see what would
actually be acceptable.  So, I propose that we go with the existing
naming.

If you only know what you don't want, but not what you want, and aren't
even willing to discuss it, it makes it very much impossible to
progress.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
