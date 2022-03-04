Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E44CD686
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiCDOib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:38:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41998 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiCDOib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:38:31 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 04EFB8419032;
        Fri,  4 Mar 2022 06:37:35 -0800 (PST)
Date:   Fri, 04 Mar 2022 14:37:30 +0000 (GMT)
Message-Id: <20220304.143730.2194933898132251429.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YiIYhDzOiRnLbzQy@lunn.ch>
References: <YiIO7lAMCkHhd11L@lunn.ch>
        <20220304.132121.856864783082151547.davem@davemloft.net>
        <YiIYhDzOiRnLbzQy@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 04 Mar 2022 06:37:38 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 4 Mar 2022 14:47:48 +0100

> On Fri, Mar 04, 2022 at 01:21:21PM +0000, David Miller wrote:
>> From: Andrew Lunn <andrew@lunn.ch>
>> Date: Fri, 4 Mar 2022 14:06:54 +0100
>> 
>> > On Fri, Mar 04, 2022 at 12:50:11PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
>> >> Hello:
>> >> 
>> >> This series was applied to netdev/net-next.git (master)
>> >> by David S. Miller <davem@davemloft.net>:
>> > 
>> > Hi David
>> > 
>> > Why was this merged?
>> 
>> Sorry, it seemed satraightforward to me, and I try to get the backlog under 40 patches before
>> I hand over to Jakub for the day.
>> 
>> If you want to review, reply to the thread immediately saying so, don't wait until you haver time for the
>> full review.
> 
> This patchset was on the list for less than 5 hours before it got
> merged. I tend to sleep for 8 to 10 hours. Making it impossible for me
> to react any faster. At an absolute minimum, you need to wait 12
> hours, if you expect anybody to have a fair chance of being able to
> say, hold on, i want to comment on this patchset.
> 
> I also don't like the metric of 40 patches backlog. Is the size of
> backlog more important than the quality of the patches? Don't we care
> about the quality of the code any more? Don't we care about getting
> code reviewed any more?

Ok, message received, I'll apply things less aggressively.

Thank you.
