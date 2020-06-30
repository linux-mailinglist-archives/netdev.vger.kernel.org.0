Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2256820FDD6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgF3UjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgF3Ui7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:38:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3957C061755;
        Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 571841277F862;
        Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:38:58 -0700 (PDT)
Message-Id: <20200630.133858.836154523537769936.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        kuba@kernel.org, tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: fix memory leak of tls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630151646.517757-1-colin.king@canonical.com>
References: <20200630151646.517757-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 30 Jun 2020 16:16:46 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return path when create_singlethread_workqueue fails currently
> does not kfree tls and leads to a memory leak. Fix this by kfree'ing
> tls before returning -ENOMEM.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
