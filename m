Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A661979F86
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfG3Dcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:32:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfG3Dcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 23:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4mF6Hbr7QczI5PcOmjlA7L0RwfQ/3SFLBSWGVwkXv38=; b=gl2jYAwRKtxW1hFrk0nYA0J6zJ
        VXk4mYKObWiOxItwiQkA0ZRZa/vns5vAAeVzGlYH5e1vUs3T5kyKnHtxGP9x+ISgb4y6Rm3mSnvcg
        Fjo7hOYf8XIHQ5z2wpIoit01PZFX3y5HFOpxmEyex+fVfykWCBO24O+s/A5WWlSz/9yg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsIsH-0005Te-Ox; Tue, 30 Jul 2019 05:32:29 +0200
Date:   Tue, 30 Jul 2019 05:32:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: phy_led_triggers: Fix a possible null-pointer
 dereference in phy_led_trigger_change_speed()
Message-ID: <20190730033229.GA20628@lunn.ch>
References: <20190729092424.30928-1-baijiaju1990@gmail.com>
 <20190729134553.GC4110@lunn.ch>
 <f603f3c3-f7c9-8dff-5f30-74174282819c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f603f3c3-f7c9-8dff-5f30-74174282819c@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 10:25:36AM +0800, Jia-Ju Bai wrote:
> 
> 
> On 2019/7/29 21:45, Andrew Lunn wrote:
> >On Mon, Jul 29, 2019 at 05:24:24PM +0800, Jia-Ju Bai wrote:
> >>In phy_led_trigger_change_speed(), there is an if statement on line 48
> >>to check whether phy->last_triggered is NULL:
> >>     if (!phy->last_triggered)
> >>
> >>When phy->last_triggered is NULL, it is used on line 52:
> >>     led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
> >>
> >>Thus, a possible null-pointer dereference may occur.
> >>
> >>To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
> >>LED_OFF) is called when phy->last_triggered is not NULL.
> >>
> >>This bug is found by a static analysis tool STCheck written by us.
> >Who is 'us'?
> 
> Me and my colleague...

Well, we can leave it very vague, giving no idea who 'us' is. But
often you want to name the company behind it, or the university, or
the sponsor, etc.

    Andrew
