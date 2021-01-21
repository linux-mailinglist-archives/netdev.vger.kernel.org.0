Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7A2FED2E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 15:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbhAUOmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 09:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731995AbhAUOly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 09:41:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FB0C06178C
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:39:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1l2b7Q-0003ca-0u; Thu, 21 Jan 2021 15:39:28 +0100
Subject: Re: [Linux-stm32] [PATCH AUTOSEL 5.10 28/45] net: stmmac: Fixed mtu
 channged by cache aligned
To:     Sasha Levin <sashal@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Wu <david.wu@rock-chips.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-28-sashal@kernel.org>
 <20210119220815.039ac330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210120142659.GC4035784@sasha-vm>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <7564ebe1-20e9-36d5-11a7-bcfe27f70987@pengutronix.de>
Date:   Thu, 21 Jan 2021 15:39:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120142659.GC4035784@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sasha,

On 20.01.21 15:26, Sasha Levin wrote:
> On Tue, Jan 19, 2021 at 10:08:15PM -0800, Jakub Kicinski wrote:
>> On Tue, 19 Jan 2021 20:25:45 -0500 Sasha Levin wrote:
>>> From: David Wu <david.wu@rock-chips.com>
>>>
>>> [ Upstream commit 5b55299eed78538cc4746e50ee97103a1643249c ]
>>>
>>> Since the original mtu is not used when the mtu is updated,
>>> the mtu is aligned with cache, this will get an incorrect.
>>> For example, if you want to configure the mtu to be 1500,
>>> but mtu 1536 is configured in fact.
>>>
>>> Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
>>> Signed-off-by: David Wu <david.wu@rock-chips.com>
>>> Link: https://lore.kernel.org/r/20210113034109.27865-1-david.wu@rock-chips.com
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> This was applied 6 days ago, I thought you said you wait two weeks.
>> What am I missing?
> 
> The "AUTOSEL" review cycle is an additional hurdle automatically
> selected patches need to clear before being queued up. There are 7 days
> between the day I sent the review for these and the first day I might
> queue them up.

I guess this could benefit from being documented in
Documentation/process/stable-kernel-rules.rst? Or is this documented
elsewhere?

> 
> This mail isn't an indication that the patch has been added to the
> queue, it's just an extra step to give folks time to object.
> 
> If you add up all the days you'll get >14 :)
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
