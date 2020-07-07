Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81C121787B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGGUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgGGUAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:00:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E8DC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:00:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E460120F93E0;
        Tue,  7 Jul 2020 13:00:46 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:00:45 -0700 (PDT)
Message-Id: <20200707.130045.950724959455027871.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, kuba@kernel.org, hkallweit1@gmail.com,
        leon@kernel.org, mhabets@solarflare.com, wu000273@umn.edu,
        mst@redhat.com, keescook@chromium.org, vaibhavgupta40@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sun/cassini: mark cas_resume() as
 __maybe_unused
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707105543.7256-1-weiyongjun1@huawei.com>
References: <20200707105543.7256-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:00:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 7 Jul 2020 18:55:43 +0800

> In certain configurations without power management support, gcc report
> the following warning:
> 
> drivers/net/ethernet/sun/cassini.c:5206:12: warning:
>  'cas_resume' defined but not used [-Wunused-function]
>  5206 | static int cas_resume(struct device *dev_d)
>       |            ^~~~~~~~~~
> 
> Mark cas_resume() as __maybe_unused to make it clear.
> 
> Fixes: f193f4ebde3d ("sun/cassini: use generic power management")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thanks.
