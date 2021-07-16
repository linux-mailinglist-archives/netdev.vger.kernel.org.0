Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0526E3CBEC7
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbhGPV7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:59:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhGPV7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 17:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LH+XWUb1+rxyjWluzbREIJmji8qmoGYWEyx0wHhJwd4=; b=GDsdjORHwHz2Hcuw0prTSIUBkd
        pduE4ONnmHEUp2/U8K1vvVmBri/ZV6Cul9CLcbuM1gpYD+/v1gYQWR6nOBUsZx+5L6uxjJjvAgy2d
        SLCX9GrUDZWH+qfGVIFjA/nMrmzco5CWxbyKFZzpNzbtrLfON/0I4Xt2Rza4YmFpUEIU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4Vp8-00DfsX-25; Fri, 16 Jul 2021 23:56:46 +0200
Date:   Fri, 16 Jul 2021 23:56:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPIAnq6r3KgQ5ivI@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716212427.821834-6-anthony.l.nguyen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 02:24:27PM -0700, Tony Nguyen wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
> 
> Each i225 has three LEDs. Export them via the LED class framework.
> 
> Each LED is controllable via sysfs. Example:
> 
> $ cd /sys/class/leds/igc_led0
> $ cat brightness      # Current Mode
> $ cat max_brightness  # 15
> $ echo 0 > brightness # Mode 0
> $ echo 1 > brightness # Mode 1
> 
> The brightness field here reflects the different LED modes ranging
> from 0 to 15.

What do you mean by mode? Do you mean blink mode? Like On means 1G
link, and it blinks for packet TX?

    Andrew
