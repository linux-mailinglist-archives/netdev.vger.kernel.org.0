Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4025114958B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAYMtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:49:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAYMtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:49:13 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5788715B1BF75;
        Sat, 25 Jan 2020 04:49:12 -0800 (PST)
Date:   Sat, 25 Jan 2020 13:49:07 +0100 (CET)
Message-Id: <20200125.134907.81338433085133777.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/9] Mellanox, mlx5 fixes 2020-01-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 04:49:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 24 Jan 2020 20:20:50 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> Merge conflict: once merge with net-next, a contextual conflict will
> appear in drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> since the code moved in net-next.
> To resolve, just delete ALL of the conflicting hunk from net.
> So sorry for the small mess .. 

Thanks for the heads up.

> For -stable v5.4:
>  ('net/mlx5: Update the list of the PCI supported devices')
>  ('net/mlx5: Fix lowest FDB pool size')
>  ('net/mlx5e: kTLS, Fix corner-case checks in TX resync flow')
>  ('net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path')
>  ('net/mlx5: Eswitch, Prevent ingress rate configuration of uplink rep')
>  ('net/mlx5e: kTLS, Remove redundant posts in TX resync flow')
>  ('net/mlx5: DR, Enable counter on non-fwd-dest objects')
>  ('net/mlx5: DR, use non preemptible call to get the current cpu number')

Queued up.
