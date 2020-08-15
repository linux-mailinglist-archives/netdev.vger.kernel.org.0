Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF54245361
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgHOWBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbgHOVvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B2BC0612F2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 20:45:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8081D127C339D;
        Fri, 14 Aug 2020 20:28:50 -0700 (PDT)
Date:   Fri, 14 Aug 2020 20:45:34 -0700 (PDT)
Message-Id: <20200814.204534.1768395928757280237.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     maximmi@mellanox.com, mkubecek@suse.cz, andrew@lunn.ch,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] ethtool-netlink bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <02b7cf0b-8c02-903e-6838-2108fb51f8ca@gmail.com>
References: <20200814131627.32021-1-maximmi@mellanox.com>
        <02b7cf0b-8c02-903e-6838-2108fb51f8ca@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 20:28:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 14 Aug 2020 07:58:29 -0700

> 
> 
> On 8/14/2020 6:16 AM, Maxim Mikityanskiy wrote:
>> This series contains a few bug fixes for ethtool-netlink. These bugs
>> are
>> specific for the netlink interface, and the legacy ioctl interface is
>> not affected. These patches aim to have the same behavior in
>> ethtool-netlink as in the legacy ethtool.
>> Please also see the sibling series for the userspace tool.
> 
> Since you are targeting the net tree, should not those changes also
> have corresponding Fixes tag?

Yes, they definitely should.
