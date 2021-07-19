Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991963CD126
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhGSJGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234913AbhGSJGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 05:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C266361165;
        Mon, 19 Jul 2021 09:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626688008;
        bh=rp6nUU6004j98duuqW06OqQelhgplfhouqH9v5qtLtI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ssMFAmlb4pm6YwlGUKZCOUbFar1mG3Zqc34IZfONTFemqa4I+leHCPgckCwXgEyFI
         jYvjGcfSOaOrcQU16uAij7dkS0u4/c8RzZSjZqn7M4lTeW11wEJrlfI+sk6H+QpTOH
         xar0OKAPfca/ZV5PAMfT0IzqMsconfwLZBGhOSsk04PIb9VClneN4oPLAIliXq7qXn
         30zuC3oI6Twmiisv7YhlUWeYXZc4PJfMbrTmMmwIPWovxZjRvOxSeCWLho7aopAQ1z
         lYo3nVvFtb9hxFVXyeiBhMAnKaYdYfJ8D3V+a+yQPYkfxEYFhjWFsDY/Y7MKEIqa7b
         omty89vru0eeg==
Date:   Mon, 19 Jul 2021 11:46:40 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210719114640.157a6f7d@cakuba>
In-Reply-To: <87sg0ahlof.fsf@kurt>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <YPIAnq6r3KgQ5ivI@lunn.ch>
        <f42099b8-5ba3-3514-e5fa-8d1be37192b5@gmail.com>
        <YPSsSL32QNBnx0xc@lunn.ch>
        <87sg0ahlof.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 08:17:36 +0200, Kurt Kanzenbach wrote:
> > If the brightness is being abused to represent the blink mode, this
> > patch is going to get my NACK.  Unfortunately, i cannot find a
> > datasheet for this chip to know what the LED control register actually
> > does. So i'm waiting for a reply to my question.
> >
> > There is a broad agreement between the LED maintainers and the PHYLIB
> > maintainers how Ethernet LEDs should be described with the hardware
> > blinking the LED for different reasons. The LED trigger mechanisms
> > should be used, one trigger per mode, and the trigger is then
> > offloaded to the hardware.  
> 
> OK. I'll look into it. Can you point me to an example maybe?
> 
> Unfortunately this patch seems to be merged already. I guess it should
> be reverted.

Yes, please send a revert patch saying in the commit message that Andrew
suggest a different interface etc.
