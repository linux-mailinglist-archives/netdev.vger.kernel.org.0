Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8E1D6C4A
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEQTaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:30:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6DC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:30:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC70E128A076E;
        Sun, 17 May 2020 12:30:15 -0700 (PDT)
Date:   Sun, 17 May 2020 12:30:14 -0700 (PDT)
Message-Id: <20200517.123014.104345884367246585.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     lukas@wunner.de, marex@denx.de, netdev@vger.kernel.org,
        ynezz@true.cz, yuehaibing@huawei.com
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517191635.GE606317@lunn.ch>
References: <20200516.190225.342589110126932388.davem@davemloft.net>
        <20200517071355.ww5xh7fgq7ymztac@wunner.de>
        <20200517191635.GE606317@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:30:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 17 May 2020 21:16:35 +0200

>> Nevertheless I was going to repeat the performance measurements on a
>> recent kernel but haven't gotten around to that yet because the
>> measurements need to be performed with CONFIG_PREEMPT_RT_FULL to
>> be reliable (a vanilla kernel is too jittery), so I have to create
>> a new branch with RT patches on the test machine, which is fairly
>> involved and time consuming.
> 
> I assume you will then mainline the changes, so you don't need to do
> it again? That is the problem with doing development work on a dead
> kernel.

I think the limitation is outside of his control as not all of the RT
patches are in mainline yet.
