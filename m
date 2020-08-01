Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6BB234ED4
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHAAHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgHAAHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:07:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF547C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:07:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A070C11E58FA8;
        Fri, 31 Jul 2020 16:51:03 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:07:47 -0700 (PDT)
Message-Id: <20200731.170747.2292371575847956743.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net 0/4] Mellanox, mlx5 fixes 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731015752.28665-1-saeedm@mellanox.com>
References: <20200731015752.28665-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:51:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 30 Jul 2020 18:57:48 -0700

> This small patchset introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.18:
>  ('net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq')
> 
> For -stable v5.7:
>  ('net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring')

Queued up, thanks.
