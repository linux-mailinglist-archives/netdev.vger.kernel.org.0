Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB200E957D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJ3ECk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:02:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35262 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfJ3ECk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:02:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9179114B7A805;
        Tue, 29 Oct 2019 21:02:39 -0700 (PDT)
Date:   Tue, 29 Oct 2019 21:02:38 -0700 (PDT)
Message-Id: <20191029.210238.1548001880274221035.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net V2 00/11] Mellanox, mlx5 fixes 2019-10-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 21:02:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 29 Oct 2019 23:45:50 +0000

> This series introduces misc fixes to mlx5 driver.
> 
> v1->v2:
>  - Dropped the kTLS counter documentation patch, Tariq will fix it and
>    send it later.
>  - Added a new fix for link speed mode reporting.
>   ('net/mlx5e: Initialize link modes bitmap on stack')
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.14
>   ('net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget')
> 
> For -stable v4.19
>   ('net/mlx5e: Fix ethtool self test: link speed')
>  
> For -stable v5.2
>   ('net/mlx5: Fix flow counter list auto bits struct')
>   ('net/mlx5: Fix rtable reference leak')
> 
> For -stable v5.3
>   ('net/mlx5e: Remove incorrect match criteria assignment line')
>   ('net/mlx5e: Determine source port properly for vlan push action')
>   ('net/mlx5e: Initialize link modes bitmap on stack')

Queued up.

Thank you.
