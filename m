Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FF2202E
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfEQWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:19:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfEQWTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 18:19:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD0D414768DD7;
        Fri, 17 May 2019 15:19:33 -0700 (PDT)
Date:   Fri, 17 May 2019 15:19:33 -0700 (PDT)
Message-Id: <20190517.151933.1980369148725224144.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 00/11] Mellanox, mlx5 fixes 2019-05-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 15:19:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 17 May 2019 20:19:29 +0000

> This series introduces some fixes to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.19
>   net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled
>   net/mlx5: Imply MLXFW in mlx5_core
> 
> For -stable v5.0
>   net/mlx5e: Add missing ethtool driver info for representors
>   net/mlx5e: Additional check for flow destination comparison
> 
> For -stable v5.1
>   net/mlx5: Fix peer pf disable hca command

And queued up, thanks.
