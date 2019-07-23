Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8172071F4B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391455AbfGWS2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:28:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbfGWS2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:28:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB15B153B8310;
        Tue, 23 Jul 2019 11:28:52 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:28:50 -0700 (PDT)
Message-Id: <20190723.112850.610952032088764951.davem@davemloft.net>
To:     leon@kernel.org
Cc:     dledford@redhat.com, jgg@mellanox.com, edwards@mellanox.com,
        linux-rdma@vger.kernel.org, yishaih@mellanox.com,
        saeedm@mellanox.com, netdev@vger.kernel.org, leonro@mellanox.com
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723071255.6588-1-leon@kernel.org>
References: <20190723071255.6588-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:28:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 23 Jul 2019 10:12:55 +0300

> From: Edward Srouji <edwards@mellanox.com>
> 
> Fix modify_cq_in alignment to match the device specification.
> After this fix the 'cq_umem_valid' field will be in the right offset.
> 
> Cc: <stable@vger.kernel.org> # 4.19
> Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> Signed-off-by: Edward Srouji <edwards@mellanox.com>
> Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Very confusing submission on many levels.

Coming from a Mellanox developer using a kernel.org email address.

Targetting the mlx5-next tree, yet CC:'ing stable.

A networking change, for which stable submissions are handled by me by
hand and not via CC:'ing stable.
