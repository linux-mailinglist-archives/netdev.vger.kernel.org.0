Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501107737D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfGZVeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:34:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387437AbfGZVeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:34:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F8B412BFE6F4;
        Fri, 26 Jul 2019 14:34:10 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:34:09 -0700 (PDT)
Message-Id: <20190726.143409.1288621006515290199.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [pull request][net 0/9] Mellanox, mlx5 fixes 2019-07-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:34:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 25 Jul 2019 20:36:32 +0000

> This series introduces some fixes to mlx5 driver.
> 
> 1) Ariel is addressing an issue with enacp flow counter race condition
> 2) Aya fixes ethtool speed handling
> 3) Edward fixes modify_cq hw bits alignment 
> 4) Maor fixes RDMA_RX capabilities handling
> 5) Mark reverses unregister devices order to address an issue with LAG
> 6) From Tariq,
>   - wrong max num channels indication regression
>   - TLS counters naming and documentation as suggested by Jakub
>   - kTLS, Call WARN_ONCE on netdev mismatch
> 
> There is one patch in this series that touches nfp driver to align
> TLS statistics names with latest documentation, Jakub is CC'ed.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.9:
>   ('net/mlx5: Use reversed order when unregister devices')
> 
> For -stable v4.20
>   ('net/mlx5e: Prevent encap flow counter update async to user query')
>   ('net/mlx5: Fix modify_cq_in alignment')
> 
> For -stable v5.1
>   ('net/mlx5e: Fix matching of speed to PRM link modes')
> 
> For -stable v5.2
>   ('net/mlx5: Add missing RDMA_RX capabilities')

Queued up.
