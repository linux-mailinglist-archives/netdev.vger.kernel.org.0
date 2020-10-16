Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C992290DE9
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404054AbgJPW4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392489AbgJPW4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 18:56:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85FB920874;
        Fri, 16 Oct 2020 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602888995;
        bh=/lXhp6rLF5lFUokrwfRiKmnmoHe+zKZ44ar1nzyDehs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qD0jkJbzDmDM92q2qHE/ZB1DB//9dR5lAihvHP9lClMKNhAx6LZVTeinM9Z2i+UrA
         0FTVCxqGc01Szmf4bf0np+Jz8SN6Wmu/0Qz4ZKW9mmrLTz97xUruR35zOiXRD4Q2E6
         Pq2ec+VtcFBwS6uWVpcO72Q1gENuVzj7XwgdenOU=
Date:   Fri, 16 Oct 2020 15:56:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, kernel test robot <lkp@intel.com>,
        Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        kbuild-all@lists.01.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016155632.395af75a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016213302.yeesw4jbw3rzfluf@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
        <202010170153.fwOuks52-lkp@intel.com>
        <20201016173317.4ihhiamrv5w5am6y@skbuf>
        <20201016201428.GI139700@lunn.ch>
        <20201016201930.2i2lw4aixklyg6j7@skbuf>
        <20201016210318.GL139700@lunn.ch>
        <20201016211628.mw7jlvqx3audzo76@skbuf>
        <20201016213302.yeesw4jbw3rzfluf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 00:33:02 +0300 Vladimir Oltean wrote:
> On Sat, Oct 17, 2020 at 12:16:28AM +0300, Vladimir Oltean wrote:
> > On Fri, Oct 16, 2020 at 11:03:18PM +0200, Andrew Lunn wrote:  
> > > 2ecbc1f684482b4ed52447a39903bd9b0f222898 does not have net-next, as
> > > far as i see,  
> > 
> > Not sure what you mean by that.  
> 
> Ah, I do understand what you mean now. In git, that is what I see as
> well. But in my cgit link, why would tail_tag be there?
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/include/net/dsa.h#n93?id=2ecbc1f684482b4ed52447a39903bd9b0f222898
> I think either cgit is plainly dumb at showing the kernel tree at a
> particular commit, or I'm plainly incapable of using it.

The link is bamboozled.

The #n93 needs to be after the ? parameters.

Like this:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/include/net/dsa.h?id=2ecbc1f684482b4ed52447a39903bd9b0f222898#n86
