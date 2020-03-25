Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3A191E15
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgCYA30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:29:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgCYA30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 20:29:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C015159FC56A;
        Tue, 24 Mar 2020 17:29:26 -0700 (PDT)
Date:   Tue, 24 Mar 2020 17:29:25 -0700 (PDT)
Message-Id: <20200324.172925.1546752299807440053.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 17:29:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 24 Mar 2020 14:52:52 -0700

> This series introduces some fixes to mlx5 driver.
> 
> From Aya, Fixes to the RX error recovery flows
> From Leon, Fix IB capability mask
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.5
>  ('net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection failure')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix ICOSQ recovery flow with Striding RQ')
>  ('net/mlx5e: Do not recover from a non-fatal syndrome')
>  ('net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset')
>  ('net/mlx5e: Enhance ICOSQ WQE info fields')

Queued up.

> The above patch ('net/mlx5e: Enhance ICOSQ WQE info fields')
> will fail to apply cleanly on v5.4 due to a trivial contextual conflict, 
> but it is an important fix, do I need to do something about it or just
> assume Greg will know how to handle this ?

I'll do my best to backport it and ask for your help if necessary.

Thanks.
