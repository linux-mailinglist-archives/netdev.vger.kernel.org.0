Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E987E2696E4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgINUoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgINUo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:44:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DBEC06174A;
        Mon, 14 Sep 2020 13:44:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA3191279A98A;
        Mon, 14 Sep 2020 13:27:40 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:44:27 -0700 (PDT)
Message-Id: <20200914.134427.1470378665038529043.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: qlcnic: remove unused variable 'val' in
 qlcnic_83xx_cam_unlock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600089879-22944-1-git-send-email-zhangchangzhong@huawei.com>
References: <1600089879-22944-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:27:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Mon, 14 Sep 2020 21:24:39 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:661:6: warning:
>  variable 'val' set but not used [-Wunused-but-set-variable]
>   661 |  u32 val;
>       |      ^~~
> 
> After commit 7f9664525f9c ("qlcnic: 83xx memory map and HW access
> routines"), variable 'val' is never used in qlcnic_83xx_cam_unlock(), so
> removing it to avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
