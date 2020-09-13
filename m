Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5665267D11
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 03:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgIMBXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 21:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgIMBXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 21:23:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E5C061573;
        Sat, 12 Sep 2020 18:23:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83A8D128FCF29;
        Sat, 12 Sep 2020 18:06:27 -0700 (PDT)
Date:   Sat, 12 Sep 2020 18:22:19 -0700 (PDT)
Message-Id: <20200912.182219.1013721666435098048.davem@davemloft.net>
To:     luojiaxing@huawei.com
Cc:     kuba@kernel.org, idos@mellanox.com, ogerlitz@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value
 to ring_cons but not used it anymore in mlx4_en_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
References: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 12 Sep 2020 18:06:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>
Date: Sat, 12 Sep 2020 16:08:15 +0800

> We found a set but not used variable 'ring_cons' in mlx4_en_xmit(), it will
> cause a warning when build the kernel. And after checking the commit record
> of this function, we found that it was introduced by a previous patch.
> 
> So, We delete this redundant assignment code.
> 
> Fixes: 488a9b48e398 ("net/mlx4_en: Wake TX queues only when there's enough room")
> 
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>

Looks good, applied, thanks.
