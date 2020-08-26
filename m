Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F9D253165
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHZOew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgHZOes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:34:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AA6C061574;
        Wed, 26 Aug 2020 07:34:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 007001358CD6C;
        Wed, 26 Aug 2020 07:18:00 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:34:46 -0700 (PDT)
Message-Id: <20200826.073446.971357864812593855.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        mickeyr@marvell.com
Subject: Re: [net-next v5 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826081744.GA2729@plvision.eu>
References: <20200825122013.2844-2-vadym.kochan@plvision.eu>
        <20200825.172003.1417643181819895272.davem@davemloft.net>
        <20200826081744.GA2729@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 07:18:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Wed, 26 Aug 2020 11:17:44 +0300

> Initially there was (in RFC patch set), not locking, but _rcu list API
> used, because the port list is modified only by 1 writer when creating
> the port or deleting it on switch uninit (the really theoretical case
> which might happen is that event might be received at that time which
> causes to loop over this list to find the port), as I understand
> correctly list_add_rcu is safe to use with no additional locking if there is 1
> writer and many readers ? So can I use back this approach ?

Are you really certain only one writer can exist at one time?
