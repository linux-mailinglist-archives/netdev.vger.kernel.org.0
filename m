Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D831F18F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 22:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhBRVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 16:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhBRVJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 16:09:54 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC155C061574;
        Thu, 18 Feb 2021 13:09:04 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E74FB4D30C708;
        Thu, 18 Feb 2021 13:09:02 -0800 (PST)
Date:   Thu, 18 Feb 2021 13:08:58 -0800 (PST)
Message-Id: <20210218.130858.1480136584674158754.davem@davemloft.net>
To:     michael@walle.cc
Cc:     olteanv@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: phy: at803x: paging support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <15a6833c0db85fc3871a1d926d6636d6@walle.cc>
References: <20210218185240.23615-1-michael@walle.cc>
        <20210218192647.m5l4wkboxms47urw@skbuf>
        <15a6833c0db85fc3871a1d926d6636d6@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 18 Feb 2021 13:09:03 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Thu, 18 Feb 2021 20:46:10 +0100

> Am 2021-02-18 20:26, schrieb Vladimir Oltean:
>> On Thu, Feb 18, 2021 at 07:52:38PM +0100, Michael Walle wrote:
>>> Add paging support to the QCA AR8031/33 PHY. This will be needed if we
>>> add support for the .config_inband_aneg callback, see series [1].
>>> The driver itself already accesses the fiber page (without proper
>>> locking).
>>> The former version of this patchset converted the access to
>>> phy_read_paged(), but Vladimir Oltean mentioned that it is dead code.
>>> Therefore, the second patch will just remove it.
>>> changes since v1:
>>>  - second patch will remove at803x_aneg_done() altogether
>> I'm pretty sure net-next is closed now, since David sent the pull
>> request, and I didn't come to a conclusion yet regarding the final
>> form of the phy_config_inband_aneg method either.
> 
> Yeah I wasn't sure. http://vger.kernel.org/~davem/net-next.html says
> it is still open. But anyway, if not, I'll resend the patch after
> the merge window. I've also thought about splitting it into two
> individual patches, because they aren't dependent on each other
> anymore.

It is closed now, so this will have to be deferred.

Thanks.

