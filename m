Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23379281EFF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJBXUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:20:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18968C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 16:20:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 292AD11E58FD5;
        Fri,  2 Oct 2020 16:03:58 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:20:44 -0700 (PDT)
Message-Id: <20201002.162044.1724051542310947495.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net V3 00/14] mlx5 fixes 2020-09-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002180654.262800-1-saeed@kernel.org>
References: <20201002180654.262800-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 16:03:58 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Fri,  2 Oct 2020 11:06:40 -0700

> This series introduces some fixes to mlx5 driver.
> 
> v1->v2:
>  - Patch #1 Don't return while mutex is held. (Dave)
> 
> v2->v3:
>  - Drop patch #1, will consider a better approach (Jakub)
>  - use cpu_relax() instead of cond_resched() (Jakub)
>  - while(i--) to reveres a loop (Jakub)
>  - Drop old mellanox email sign-off and change the committer email
>    (Jakub)
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.15
>  ('net/mlx5e: Fix VLAN cleanup flow')
>  ('net/mlx5e: Fix VLAN create flow')
> 
> For -stable v4.16
>  ('net/mlx5: Fix request_irqs error flow')
> 
> For -stable v5.4
>  ('net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU')
>  ('net/mlx5: Avoid possible free of command entry while timeout comp handler')
> 
> For -stable v5.7
>  ('net/mlx5e: Fix return status when setting unsupported FEC mode')
> 
> For -stable v5.8
>  ('net/mlx5e: Fix race condition on nhe->n pointer in neigh update')

Queued up, thanks.
