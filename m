Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6F2247DC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgGRBnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:43:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54170C0619D2;
        Fri, 17 Jul 2020 18:43:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E211511E45914;
        Fri, 17 Jul 2020 18:43:15 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:43:15 -0700 (PDT)
Message-Id: <20200717.184315.165673962018031073.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bna: Remove unused variable 't'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594981384-30489-1-git-send-email-zhangchangzhong@huawei.com>
References: <1594981384-30489-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:43:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Fri, 17 Jul 2020 18:23:04 +0800

> Gcc report warning as follows:
> 
> drivers/net/ethernet/brocade/bna/bfa_ioc.c:1538:6: warning:
>  variable 't' set but not used [-Wunused-but-set-variable]
>  1538 |  u32 t;
>       |      ^
> 
> After commit c107ba171f3d ("bna: Firmware Patch Simplification"),
> 't' is never used, so removing it to avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied, thanks.
