Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638C666178
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 00:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfGKWIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 18:08:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfGKWIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 18:08:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5626514DB4EBA;
        Thu, 11 Jul 2019 15:08:44 -0700 (PDT)
Date:   Thu, 11 Jul 2019 15:08:43 -0700 (PDT)
Message-Id: <20190711.150843.2087730090655258229.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/6] Mellanox, mlx5 fixes 2019-07-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 15:08:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 11 Jul 2019 18:54:08 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.15
> ('net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn')
> 
> For -stable v5.1
> ('net/mlx5e: Fix port tunnel GRE entropy control')
> ('net/mlx5e: Rx, Fix checksum calculation for new hardware')
> ('net/mlx5e: Fix return value from timeout recover function')
> ('net/mlx5e: Fix error flow in tx reporter diagnose')
> 
> For -stable v5.2
> ('net/mlx5: E-Switch, Fix default encap mode')

Queued up.

> Conflict note: This pull request will produce a small conflict when
> merged with net-next.
> In drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> Take the hunk from net and replace:
> esw_offloads_steering_init(esw, vf_nvports, total_nvports);
> with:
> esw_offloads_steering_init(esw);

Thank you.
