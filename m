Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738431F71A5
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 03:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgFLBX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 21:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgFLBX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 21:23:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDA2C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 18:23:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63354128B13D5;
        Thu, 11 Jun 2020 18:23:27 -0700 (PDT)
Date:   Thu, 11 Jun 2020 18:23:26 -0700 (PDT)
Message-Id: <20200611.182326.1387553567386071693.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net 00/10] mlx5 fixes 2020-06-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 18:23:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 11 Jun 2020 15:46:58 -0700

> This series introduces some fixes to mlx5 driver.
> For more information please see tag log below.

Tag log is basically empty :-)

> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.2
>   ('net/mlx5: drain health workqueue in case of driver load error')
> 
> For -stable v5.3
>   ('net/mlx5e: Fix repeated XSK usage on one channel')
>   ('net/mlx5: Fix fatal error handling during device load')
> 
> For -stable v5.5
>  ('net/mlx5: Disable reload while removing the device')
> 
> For -stable v5.7
>   ('net/mlx5e: CT: Fix ipv6 nat header rewrite actions')

Queued up, thanks.
