Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF824720B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFOU2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:28:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58634 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOU2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6A4b9rx8CLH0chfFFM7PPLLefrP1u9qhcPoaJee6nns=; b=Oty43mvDIYpWNQ+RalJby5N39
        pzTZ9/f3/zpFi1do8ZwFojcEUTUNbWKs5XY6sWdBUCEfj3DoLiHQzn4WAaBVcNi3dGZu4GqzLaXsk
        Ou4nHiHy8XB2KnuNCPRos1N3/nizEB5pe4cPl02yObmaASV0XHRvLH9wbjAu62W7JePBzisXwxK48
        huq+0OUrUHmiQsYhGV2Mb53kBgA69KkOjV/ErPIjXhEGoPmB2cBiVsHCs8gk6+msCMjB6VqkXWYeY
        20LAd5McLUBatpI/Wyx3/qsNGglHoWwJx0LucGccALdkJ11TtTqOmT8AUttp65U9ZYjoBg1CdGr0M
        7MUZ+2+wA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56420)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hcFHZ-0001Qt-QA; Sat, 15 Jun 2019 21:28:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hcFHW-0003Mz-T5; Sat, 15 Jun 2019 21:28:10 +0100
Date:   Sat, 15 Jun 2019 21:28:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with
 unknown multicast
Message-ID: <20190615202810.m6ulgcv4uhffhd2a@shell.armlinux.org.uk>
References: <20190612223344.28781-1-vivien.didelot@gmail.com>
 <20190615.132555.265052877492424062.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615.132555.265052877492424062.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 01:25:55PM -0700, David Miller wrote:
> From: Vivien Didelot <vivien.didelot@gmail.com>
> Date: Wed, 12 Jun 2019 18:33:44 -0400
> 
> > The DSA ports must flood unknown unicast and multicast, but the switch
> > must not flood the CPU ports with unknown multicast, as this results
> > in a lot of undesirable traffic that the network stack needs to filter
> > in software.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> 
> Applied.

Hi Dave,

We found this breaks IPv6, so it shouldn't have been applied (which is
the point I raised when I replied to Vivien).  Vivien is now able to
reproduce that.

I guess you need a revert patch now?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
