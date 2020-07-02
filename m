Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A47212EC8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgGBVYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:24:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B41C08C5C1;
        Thu,  2 Jul 2020 14:24:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21B44128448F0;
        Thu,  2 Jul 2020 14:24:34 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:24:33 -0700 (PDT)
Message-Id: <20200702.142433.1250386458271188648.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, tariqt@mellanox.com, kuba@kernel.org,
        vaibhavgupta40@gmail.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: Mark PM functions as __maybe_unused
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702091946.5144-1-weiyongjun1@huawei.com>
References: <20200702091946.5144-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:24:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Thu, 2 Jul 2020 17:19:46 +0800

> In certain configurations without power management support, the
> following warnings happen:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:4388:12:
>  warning: 'mlx4_resume' defined but not used [-Wunused-function]
>  4388 | static int mlx4_resume(struct device *dev_d)
>       |            ^~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx4/main.c:4373:12: warning:
>  'mlx4_suspend' defined but not used [-Wunused-function]
>  4373 | static int mlx4_suspend(struct device *dev_d)
>       |            ^~~~~~~~~~~~
>       
> Mark these functions as __maybe_unused to make it clear to the
> compiler that this is going to happen based on the configuration,
> which is the standard for these types of functions.
> 
> Fixes: 0e3e206a3e12 ("mlx4: use generic power management")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
