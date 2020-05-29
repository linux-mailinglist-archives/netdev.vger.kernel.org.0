Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FBD1E8C1E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgE2XgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgE2XgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:36:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E92C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:36:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A110F128672AA;
        Fri, 29 May 2020 16:36:16 -0700 (PDT)
Date:   Fri, 29 May 2020 16:36:15 -0700 (PDT)
Message-Id: <20200529.163615.2132901446979122833.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net V2 0/7] mlx5 fixes 2020-05-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:36:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 29 May 2020 13:46:03 -0700

> This series introduces some fixes to mlx5 driver.
> 
> v1->v2:
>  - Fix bad sha1, Jakub.
>  - Added one more patch by Pablo.
>    net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()
> 
> 
> Nothing major, the only patch worth mentioning is the suspend/resume crash
> fix by adding the missing pci device handlers, the fix is very straight
> forward and as Dexuan already expressed, the patch is important for Azure
> users to avoid crash on VM hibernation, patch is marked for -stable v4.6
> below.
> 
> Conflict note:
> ('net/mlx5e: Fix MLX5_TC_CT dependencies') has a trivial one line conflict
> with current net-next, which can be resolved by simply using the line from
> net-next.
> 
> Please pull and let me know if there is any problem.

Pulled, and thanks for the conflict info.

> For -stable v4.6
>  ('net/mlx5: Fix crash upon suspend/resume')
> 
> For -stable v5.6
>  ('net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()')

Queued up.
