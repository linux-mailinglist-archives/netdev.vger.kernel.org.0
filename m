Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289729C068
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfHXVXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:23:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXVXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:23:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39C8215252E0E;
        Sat, 24 Aug 2019 14:22:59 -0700 (PDT)
Date:   Sat, 24 Aug 2019 14:22:58 -0700 (PDT)
Message-Id: <20190824.142258.1684009361732174753.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Use PTR_ERR_OR_ZERO in
 mlx5e_tc_add_nic_flow()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822065219.73945-1-yuehaibing@huawei.com>
References: <20190822065219.73945-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 14:22:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 22 Aug 2019 06:52:19 +0000

> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Saeed, please pick this up if you haven't already.

Thank you.
