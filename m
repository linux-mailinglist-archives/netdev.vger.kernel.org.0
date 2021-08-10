Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2733E825B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhHJSHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239319AbhHJSFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 14:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A07860C3F;
        Tue, 10 Aug 2021 17:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628618167;
        bh=hTphWofcwmhv4y/QPpL80leJAprSLTNgUO0Meevwp1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcYVwzswX3e/hXHRTOnSU/F+s2Bd68cqknKcsPoh8p55uMJGMcItNIHBcTHosXaSa
         YNwlWYFIOKxdS7Zg4p/iR7/36IQmJiBSPad5oawJycY4E9tQLQgrwsIFNOPFUPgOWF
         3OXJ35rXVoftRxPNjIEa0Jx1ziqBXxyuXrpRS4sutSGNmh6I+tnMTNbn6SQqt4NBfq
         ojZF9lkTddGTcCG1R679M6ifkVpONX3Wgj5NMaP53/nSJP36M1UL6R2+RhEU18tAco
         ctfmkgpOIBBtboANW2sUW6l6MbX7IsDJZ/v7ejSvkM8j8yh/IaizdZopPWCedMiYQ1
         uh9/eYexRGDBQ==
Date:   Tue, 10 Aug 2021 19:55:50 +0200
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
Message-ID: <20210810195550.261189b3@thinkpad>
In-Reply-To: <20210810172927.GB3302@amd>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
        <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
        <20210727172828.1529c764@thinkpad>
        <8edcc387025a6212d58fe01865725734@walle.cc>
        <20210727183213.73f34141@thinkpad>
        <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
        <20210810172927.GB3302@amd>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 19:29:27 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> So "r8159-0300:green:activity" would be closer to the naming we want,
> but lets not do that, we really want this to be similar to what others
> are doing, and that probably means "ethphy3:green:activity" AFAICT.

Pavel, one point of the discussion is that in this case the LED is
controlled by MAC, not PHY. So the question is whether we want to do
"ethmacN" (in addition to "ethphyN").

Marek
