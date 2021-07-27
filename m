Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756D03D7E94
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhG0TmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhG0TmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:42:10 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD38C061757;
        Tue, 27 Jul 2021 12:42:10 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5AC9122234;
        Tue, 27 Jul 2021 21:42:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627414927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzFVsfZSO4uZtHb4fkNzOI7wDErPAVYJKpZ8MxrwgEE=;
        b=jF/6aHoZ5pJ+6QvMFePgvW+Ai/eFSpj3+c97r2vySxnCjY0qv3IdU1X8C91/SGaAlTq4WL
        3snQbhFgo8NNGOS8tAkKITBPVY5ugDNDLRl+y7mqDsYGuIBwAKSmP78nDtsviupvUV+7uC
        p2ULgDvsfdyCskYYAYe72G9fVDA1QTQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 27 Jul 2021 21:42:05 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <20210727183213.73f34141@thinkpad>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc> <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <3dbe3a7869dd7021f71467a53b6ac7f4@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-07-27 18:32, schrieb Marek Behún:
> On Tue, 27 Jul 2021 17:53:58 +0200
> Michael Walle <michael@walle.cc> wrote:
> 
>> > If we used the devicename as you are suggesting, then for the two LEDs
>> > the devicename part would be the same:
>> >   ledA -> macA -> ethernet0
>> >   ledB -> phyB -> ethernet0
>> > although they are clearly on different MACs.
>> 
>> Why is that the case? Why can't both the MAC and the PHY request a
>> unique name from the same namespace?
> 
> So all the network related devices should request a unique network
> relate device ID?  Should also wireless PHY devices do this? WWAN 
> modems?
> And all these should have the same template for devicename part withing
> /sys/class/leds? What should be the template for the devicename, if
> wireless PHYs and WWAN modems could also be part of this? It cannot be
> "ethernet" anymore.

I don't suggest using ethernet for everything. I just questioned
wether the distinction between ethmac and ethphy makes any sense from
a (human) user point of view; if the devicename part is visible to an
user at all.

-michael
