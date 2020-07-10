Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43D21BEFE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgGJVGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgGJVGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:06:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1C5C08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 14:06:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F9A2128646DB;
        Fri, 10 Jul 2020 14:06:46 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:06:45 -0700 (PDT)
Message-Id: <20200710.140645.1294814958586840091.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net V2 0/9] mlx5 fixes 2020-07-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:06:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu,  9 Jul 2020 19:30:09 -0700

> This series introduces some fixes to mlx5 driver.
> 
> V1->v2:
>  - Drop "ip -s" patch and mirred device hold reference patch.
>  - Will revise them in a later submission.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.2
>  ('net/mlx5: Fix eeprom support for SFP module')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix 50G per lane indication')
> 
> For -stable v5.5
>  ('net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash')
>  ('net/mlx5e: Fix VXLAN configuration restore after function reload')
> 
> For -stable v5.7
>  ('net/mlx5e: CT: Fix memory leak in cleanup')

Queued up, thanks.
