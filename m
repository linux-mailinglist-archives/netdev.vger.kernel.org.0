Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309D6172A5D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 22:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgB0VoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 16:44:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgB0VoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 16:44:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fZFc+0S8sYEepVZW4GZPMQIK4ZGpZP8SRvgF2aedThU=; b=g8gZoHcAVzfIoToGyud33lLIj2
        ktrN+r6jQ5MNvKqxvAQLgnnRD5yr6t9KkDzBttPMEa+1owvFYboj/fMVTjESLkNTj1bfFiFaphMKi
        kMhCAeobsLDQwNJupK9h/ePbG6USimHiedkr3hbry3yDO4iDEoBmFa/G/6K4z2CmKvOA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7Qwn-0008Ah-O8; Thu, 27 Feb 2020 22:43:57 +0100
Date:   Thu, 27 Feb 2020 22:43:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Message-ID: <20200227214357.GB29979@lunn.ch>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200226155423.GC26061@nanopsycho>
 <20200227213150.GA9372@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227213150.GA9372@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please be consistent. Make your prefixes, name, filenames the same.
> > For example:
> > prestera_driver_kind[] = "prestera";
> > 
> > Applied to the whole code.
> > 
> So you suggested to use prestera_ as a prefix, I dont see a problem
> with that, but why not mvsw_pr_ ? So it has the vendor, device name parts
> together as a key. Also it is necessary to apply prefix for the static
> names ?

Although static names don't cause linker issues, you do still see them
in opps stack traces, etc. It just helps track down where the symbols
come from, if they all have a prefix.

     Andrew
