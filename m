Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1B1DFBF4
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbgEWXrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEWXrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:47:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E7FC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 16:47:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59F381287363D;
        Sat, 23 May 2020 16:47:10 -0700 (PDT)
Date:   Sat, 23 May 2020 16:47:09 -0700 (PDT)
Message-Id: <20200523.164709.904369910078548954.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net 00/13] mlx5 fixes 2020-05-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:47:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 22 May 2020 17:40:36 -0700

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.13
>    ('net/mlx5: Add command entry handling completion')
> 
> For -stable v5.2
>    ('net/mlx5: Fix error flow in case of function_setup failure')
>    ('net/mlx5: Fix memory leak in mlx5_events_init')
> 
> For -stable v5.3
>    ('net/mlx5e: Update netdev txq on completions during closure')
>    ('net/mlx5e: kTLS, Destroy key object after destroying the TIS')
>    ('net/mlx5e: Fix inner tirs handling')
> 
> For -stable v5.6
>    ('net/mlx5: Fix cleaning unmanaged flow tables')
>    ('net/mlx5: Fix a race when moving command interface to events mode')

Queued up, thanks.
