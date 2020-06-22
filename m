Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3252040BC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgFVT5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgFVT5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 15:57:14 -0400
Received: from mail.bugwerft.de (mail.bugwerft.de [IPv6:2a03:6000:1011::59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ED22C0617BB
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 12:50:33 -0700 (PDT)
Received: from [192.168.178.106] (p57bc9787.dip0.t-ipconnect.de [87.188.151.135])
        by mail.bugwerft.de (Postfix) with ESMTPSA id BF03742B87B;
        Mon, 22 Jun 2020 19:50:31 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
 <20200622185837.GN1551@shell.armlinux.org.uk>
 <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
 <20200622194333.GO1551@shell.armlinux.org.uk>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <a4b43bf6-17b0-b390-77ac-9ea78a791d7c@zonque.org>
Date:   Mon, 22 Jun 2020 21:50:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622194333.GO1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 9:43 PM, Russell King - ARM Linux admin wrote:
> On Mon, Jun 22, 2020 at 09:16:59PM +0200, Daniel Mack wrote:
>> On 6/22/20 8:58 PM, Russell King - ARM Linux admin wrote:

>>> I don't see an issue here:
>>>
>>> # ethtool -s lan1 autoneg off speed 10 duplex half
>>
>> I've tried that of course, but that doesn't fix the problem here. Which
>> switch port does 'lan1' map to in your setup? My CPU port maps to port 4.
> 
> This is a clearfog, it maps to the port closest to the SFP port.
> 
>> Correct me if I'm mistaken, but speed and duplex settings are only being
>> communicated to the MAC driver through the aforementioned chain of
>> calls, right?
> 
> No, as I explained, the PPU (which is hardware inside the switch)
> takes care of keeping the switch port in sync with the internal
> PHY.

Right. Got it now. As Andrew also explained, the most plausible
explanation is that the PPU is off for that port for some reason. I'll
go digging in that direction.

Consider that patch dropped hence.


Thanks a lot for your time and help!
Daniel
