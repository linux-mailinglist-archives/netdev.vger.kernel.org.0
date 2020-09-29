Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1469527BA84
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgI2BxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:53:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B23EC0613CF
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:53:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2C91127C6C39;
        Mon, 28 Sep 2020 18:36:25 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:53:12 -0700 (PDT)
Message-Id: <20200928.185312.268794386024494946.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ethtool: mark netlink family as __ro_after_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929005841.3640817-1-kuba@kernel.org>
References: <20200929005841.3640817-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:36:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 28 Sep 2020 17:58:41 -0700

> Like all genl families ethtool_genl_family needs to not
> be a straight up constant, because it's modified/initialized
> by genl_register_family(). After init, however, it's only
> passed to genlmsg_put() & co. therefore we can mark it
> as __ro_after_init.
> 
> Since genl_family structure contains function pointers
> mark this as a fix.
> 
> Fixes: 2b4a8990b7df ("ethtool: introduce ethtool netlink interface")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
