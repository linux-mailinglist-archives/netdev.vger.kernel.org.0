Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE8927B58E
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgI1TnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1TnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:43:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F7EC061755;
        Mon, 28 Sep 2020 12:43:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F4B4144E6D29;
        Mon, 28 Sep 2020 12:26:29 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:43:15 -0700 (PDT)
Message-Id: <20200928.124315.951830278511228749.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/2] net: phy: dp83869: support Wake on LAN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <95260621-a76e-aed3-9874-4e9bed5a401b@ti.com>
References: <20200928144623.19842-1-dmurphy@ti.com>
        <20200928144623.19842-2-dmurphy@ti.com>
        <95260621-a76e-aed3-9874-4e9bed5a401b@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:26:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Mon, 28 Sep 2020 09:47:24 -0500

> Hello
> 
> On 9/28/20 9:46 AM, Dan Murphy wrote:
>> This adds WoL support on TI DP83869 for magic, magic secure, unicast
>> and
>> broadcast.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>
>> v5 - Fixed 0-day warning for u16
>>
>>   arch/arm/configs/ti_sdk_omap2_debug_defconfig | 2335 +++++++++++++++++
> 
> I have to repost this patch as this got added when updating the
> patches when I was testing.

Next time, don't make it a "repost", make it 'v6' instead.

Thank you.
