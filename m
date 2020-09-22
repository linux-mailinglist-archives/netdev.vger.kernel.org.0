Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A73227378B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgIVAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgIVAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:36:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C784AC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:36:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10E95128514D1;
        Mon, 21 Sep 2020 17:20:00 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:36:46 -0700 (PDT)
Message-Id: <20200921.173646.487163009244680178.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net V2 00/15] mlx5 fixes-2020-09-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:20:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Mon, 21 Sep 2020 17:30:46 -0700

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v5.1
>  ('net/mlx5: Fix FTE cleanup')
> 
> For -stable v5.3
>  ('net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported')
>  ('net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported')
> 
> For -stable v5.7
>  ('net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready')
> 
> For -stable v5.8
>  ('net/mlx5e: Use RCU to protect rq->xdp_prog')
>  ('net/mlx5e: Fix endianness when calculating pedit mask first bit')
>  ('net/mlx5e: Use synchronize_rcu to sync with NAPI')

Queued up, thanks.
