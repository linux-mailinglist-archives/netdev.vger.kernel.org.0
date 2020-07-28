Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF260231685
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgG1X7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729819AbgG1X7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:59:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E76DC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 16:59:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BC5F128CEFCC;
        Tue, 28 Jul 2020 16:42:34 -0700 (PDT)
Date:   Tue, 28 Jul 2020 16:59:18 -0700 (PDT)
Message-Id: <20200728.165918.315057686453643487.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net V2 00/11] mlx5 fixes-2020-07-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:42:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 28 Jul 2020 12:59:24 -0700

> This series introduces some fixes to mlx5 driver.
> v1->v2:
>  - Drop the "Hold reference on mirred devices" patch, until Or's
>    comments are addressed.
>  - Imporve "Modify uplink state" patch commit message per Or's request.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -Stable:
> 
> For -stable v4.9
>  ('net/mlx5e: Fix error path of device attach')
> 
> For -stable v4.15
>  ('net/mlx5: Verify Hardware supports requested ptp function on a given
> pin')
> 
> For -stable v5.3
>  ('net/mlx5e: Modify uplink state on interface up/down')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev')
>  ('net/mlx5: E-switch, Destroy TSAR when fail to enable the mode')
> 
> For -stable v5.5
>  ('net/mlx5: E-switch, Destroy TSAR after reload interface')
> 
> For -stable v5.7
>  ('net/mlx5: Fix a bug of using ptp channel index as pin index')

Queued up, thanks.
