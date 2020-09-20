Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7727182D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgITVSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgITVSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:18:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485B6C061755;
        Sun, 20 Sep 2020 14:18:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AA2213BCDB69;
        Sun, 20 Sep 2020 14:01:36 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:18:22 -0700 (PDT)
Message-Id: <20200920.141822.170349938899214349.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     thomas.petazzoni@bootlin.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mventa: remove unused variable 'dummy'
 in mvneta_mib_counters_clear()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600482411-15559-1-git-send-email-zhangchangzhong@huawei.com>
References: <1600482411-15559-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 14:01:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Sat, 19 Sep 2020 10:26:51 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/marvell/mvneta.c:754:6: warning:
>  variable 'dummy' set but not used [-Wunused-but-set-variable]
>   754 |  u32 dummy;
>       |      ^~~~~
> 
> This variable is not used in function mvneta_mib_counters_clear(), so
> remove it to avoid build warning.
> 
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
