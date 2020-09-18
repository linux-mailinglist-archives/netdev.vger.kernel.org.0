Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF0626EA3F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIRBGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgIRBGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:06:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78FDC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:06:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39DF913684415;
        Thu, 17 Sep 2020 17:49:52 -0700 (PDT)
Date:   Thu, 17 Sep 2020 18:06:38 -0700 (PDT)
Message-Id: <20200917.180638.1649144159395837089.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next 1/2] net: mdio: mdio-bcm-unimac: Turn on PHY
 clock before dummy read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9d499cbc-9a6b-3543-1c28-0fd4689e13cc@gmail.com>
References: <20200916204415.1831417-2-f.fainelli@gmail.com>
        <20200917.164011.166801140665121114.davem@davemloft.net>
        <9d499cbc-9a6b-3543-1c28-0fd4689e13cc@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:49:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 17 Sep 2020 17:18:42 -0700

> 
> 
> On 9/17/2020 4:40 PM, David Miller wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Date: Wed, 16 Sep 2020 13:44:14 -0700
>> 
>>> @@ -160,6 +160,7 @@ static int unimac_mdio_reset(struct mii_bus *bus)
>>>   {
>>>   	struct device_node *np = bus->dev.of_node;
>>>   	struct device_node *child;
>>> +	struct clk *clk;
>>>   	u32 read_mask = 0;
>>>   	int addr;
>> Please preserve the reverse christmas tree ordering of these local
>> variables, thank you.
> 
> Looks like I used the same thread for all patches, the most recent is
> this one:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20200917020413.2313461-1-f.fainelli@gmail.com/
> 
> and is the one I would like to see you apply if you are happy with it.

Ok I'll just give Andrew a chance to reply to your most recent comment
in that thread.
