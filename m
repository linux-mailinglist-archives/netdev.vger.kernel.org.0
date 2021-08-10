Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2227D3E84D1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhHJUy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234621AbhHJUyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 16:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C45A610A8;
        Tue, 10 Aug 2021 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628628864;
        bh=a1hcVlS9ayKmC6aKiH2nkpr0LIYgxms5D2y06po5R0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=phjnfFekaQQX+VlAmdZF4C+UVy5Wr5JLi+7xyexn8z1X+uGITMJXmZYaHKkiphV6t
         3+fi4/2u187sOgSG3CYvfiiQ70Ccip3eumpca39RfX28zXJvFdA7w9+0Cmppr4WxLY
         cfH7dVGWlp2wbUBpE+twn0xwLwMJbCAMTcu9BfR0TsKTSBSNoGsl+ajfEKYDO2W8mE
         Tl6nUUffbdf9IZE+EnkPBTGJ8j6h6LwYV3Ykdu1zNslHwiyg1x+w/P0yd6h8HYn7hz
         pH982QqZrMy9/FkH2K9YQw1tgH9AmA88WIeIfkb5JV1CAyv6c+EQifBID010rH1N1x
         v9tchQ73PBBdg==
Date:   Tue, 10 Aug 2021 22:53:53 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210810225353.6a19f772@thinkpad>
In-Reply-To: <20210810195335.GA7659@duo.ucw.cz>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
        <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
        <20210727172828.1529c764@thinkpad>
        <8edcc387025a6212d58fe01865725734@walle.cc>
        <20210727183213.73f34141@thinkpad>
        <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
        <20210810172927.GB3302@amd>
        <20210810195550.261189b3@thinkpad>
        <20210810195335.GA7659@duo.ucw.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 21:53:35 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> > Pavel, one point of the discussion is that in this case the LED is
> > controlled by MAC, not PHY. So the question is whether we want to do
> > "ethmacN" (in addition to "ethphyN").  
> 
> Sorry, I missed that. I guess that yes, ethmacX is okay, too.
> 
> Even better would be to find common term that could be used for both
> ethmacN and ethphyN and just use that. (Except that we want to avoid
> ethX). Maybe "ethportX" would be suitable?

See
  https://lore.kernel.org/linux-leds/YQAlPrF2uu3Gr+0d@lunn.ch/
and
  https://lore.kernel.org/linux-leds/20210727172828.1529c764@thinkpad/

Marek
