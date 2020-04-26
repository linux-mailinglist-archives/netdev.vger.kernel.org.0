Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CF71B8BBD
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDZDoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgDZDoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:44:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA214C061A0C;
        Sat, 25 Apr 2020 20:44:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56CB6159FE794;
        Sat, 25 Apr 2020 20:44:13 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:44:12 -0700 (PDT)
Message-Id: <20200425.204412.985691894256332808.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/mlx4_core: Add missing iounmap() in error
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587736394-111502-1-git-send-email-zou_wei@huawei.com>
References: <1587736394-111502-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:44:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Date: Fri, 24 Apr 2020 21:53:14 +0800

> This fixes the following coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlx4/crdump.c:200:2-8: ERROR: missing iounmap;
> ioremap on line 190 and execution via conditional on line 198
> 
> Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Applied.
