Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A2026AEBF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgIOUg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgIOUdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:33:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411D7C06178C
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:33:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54CF613684421;
        Tue, 15 Sep 2020 13:16:49 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:33:35 -0700 (PDT)
Message-Id: <20200915.133335.360296077767627215.davem@davemloft.net>
To:     luwei32@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] net: tipc: kerneldoc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915023955.331008-1-luwei32@huawei.com>
References: <20200915023955.331008-1-luwei32@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:16:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>
Date: Tue, 15 Sep 2020 10:39:55 +0800

> Fix parameter description of tipc_link_bc_create()
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
> Signed-off-by: Lu Wei <luwei32@huawei.com>

Applied, thanks.
