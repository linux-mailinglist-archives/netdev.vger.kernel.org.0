Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8860D3AD2F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfFJCrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:47:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfFJCrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:47:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 085F514EADF93;
        Sun,  9 Jun 2019 19:47:41 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:47:40 -0700 (PDT)
Message-Id: <20190609.194740.25393463073853490.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-06-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:47:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 7 Jun 2019 21:47:35 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.17
>   ('net/mlx5: Avoid reloading already removed devices')
> 
> For -stable v5.0
>   ('net/mlx5e: Avoid detaching non-existing netdev under switchdev mode')
> 
> For -stable v5.1
>   ('net/mlx5e: Fix source port matching in fdb peer flow rule')
>   ('net/mlx5e: Support tagged tunnel over bond')
>   ('net/mlx5e: Add ndo_set_feature for uplink representor')
>   ('net/mlx5: Update pci error handler entries and command translation')

Queued up.

Thanks.
