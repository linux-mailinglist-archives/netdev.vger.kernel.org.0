Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00C827B54B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgI1T3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgI1T3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:29:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F59DC061755;
        Mon, 28 Sep 2020 12:29:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C72E61445C4E8;
        Mon, 28 Sep 2020 12:13:05 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:29:52 -0700 (PDT)
Message-Id: <20200928.122952.688062131867166420.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     saeedm@nvidia.com, leon@kernel.org, kuba@kernel.org,
        roid@mellanox.com, ozsh@mellanox.com, paulb@mellanox.com,
        elibr@mellanox.com, lariel@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Fix a use after free on error in
 mlx5_tc_ct_shared_counter_get()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928090556.GA377727@mwanda>
References: <20200928090556.GA377727@mwanda>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:13:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 28 Sep 2020 12:05:56 +0300

> This code frees "shared_counter" and then dereferences on the next line
> to get the error code.
> 
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Saeed, I assume you will pick this up.

Thank you.
