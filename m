Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE142650DB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIJUdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgIJUba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:31:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB739C061756;
        Thu, 10 Sep 2020 13:31:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F9DD134A573C;
        Thu, 10 Sep 2020 13:14:42 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:31:28 -0700 (PDT)
Message-Id: <20200910.133128.1001244214524502430.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     steffen.klassert@secunet.com, willemb@google.com,
        mstarovoitov@marvell.com, kuba@kernel.org,
        mchehab+huawei@kernel.org, antoine.tenart@bootlin.com,
        edumazet@google.com, Jason@zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix broken NETIF_F_CSUM_MASK spell in
 netdev_features.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910084640.55688-1-linmiaohe@huawei.com>
References: <20200910084640.55688-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 13:14:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 10 Sep 2020 04:46:40 -0400

> Remove the weird space inside the NETIF_F_CSUM_MASK.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
