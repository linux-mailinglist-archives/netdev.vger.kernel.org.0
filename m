Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9D263889
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgIIVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIVek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:34:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38342C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:34:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B036A1298C8C6;
        Wed,  9 Sep 2020 14:17:51 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:34:37 -0700 (PDT)
Message-Id: <20200909.143437.2197212350854154737.davem@davemloft.net>
To:     saeedm@nvidia.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, tariqt@mellanox.com,
        maximmi@mellanox.com
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode
 to en_tx.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
References: <20200908.202836.574556740303703917.davem@davemloft.net>
        <20200908.202913.497073980249985510.davem@davemloft.net>
        <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:17:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>
Date: Wed, 9 Sep 2020 19:22:02 +0000

> Maxim really tried here to avoid this without huge performance
> degradation (~6.4% reduce in packet rate), due to the refactoring
> patches gcc yields non optimal code, as we explained in the commit
> messages and cover-letter
> 
> Our other option is making the code very ugly with no code reuse in the
> tx path, so we would really appreciate if you could relax the no-inline 
> guideline for this series.

Submit a compiler bug report.

I'm standing firm on our policy.  If you don't follow it, there is zero
incentive to get the compiler fixed, which cures the problem in one
place and for everyone rather than just your special case.

Thanks.
