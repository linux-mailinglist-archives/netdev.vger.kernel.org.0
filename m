Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F28232632
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgG2UbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2UbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:31:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA89C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 13:31:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30D8C12788C8E;
        Wed, 29 Jul 2020 13:14:39 -0700 (PDT)
Date:   Wed, 29 Jul 2020 13:31:23 -0700 (PDT)
Message-Id: <20200729.133123.1509018119855056861.davem@davemloft.net>
To:     dthompson@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        Asmaa@mellanox.com
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <DB7PR05MB4458D41E4B967BFEA30F6AC6DD700@DB7PR05MB4458.eurprd05.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
        <DB7PR05MB4458D41E4B967BFEA30F6AC6DD700@DB7PR05MB4458.eurprd05.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 13:14:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Thompson <dthompson@mellanox.com>
Date: Wed, 29 Jul 2020 19:41:30 +0000

> It's been pointed out to me that this section is incomplete, and I apologize.
 ...

David, do you have any idea what kind of burdon you create by quoting
an entire HUGE patch just to add some commentary to a small portion?

Take a look at:

	https://patchwork.ozlabs.org/project/netdev/patch/1596047355-28777-1-git-send-email-dthompson@mellanox.com/

I have to scroll through all of that quoted text just to get to the
patch itself.

Do NOT ever do this please!

I hate to beat on a dead horse, but I am continually surprised at how
lazy people are when quoting text.  Is it really that hard in modern
email clients to edit out the quoted text appropriately?

