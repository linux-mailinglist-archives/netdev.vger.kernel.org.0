Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CEA1045B5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKTVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:24:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60478 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfKTVY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:24:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4106014C3B20D;
        Wed, 20 Nov 2019 13:24:58 -0800 (PST)
Date:   Wed, 20 Nov 2019 13:24:56 -0800 (PST)
Message-Id: <20191120.132456.312016037901463888.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-11-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 13:24:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 20 Nov 2019 20:35:41 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.9:
>  ('net/mlx5e: Fix set vf link state error flow')
> 
> For -stable v4.14
>  ('net/mlxfw: Verify FSM error code translation doesn't exceed array size')
> 
> For -stable v4.19
>  ('net/mlx5: Fix auto group size calculation')
> 
> For -stable v5.3
>  ('net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/6')
>  ('net/mlx5e: Do not use non-EXT link modes in EXT mode')
>  ('net/mlx5: Update the list of the PCI supported devices')

Queued up.
