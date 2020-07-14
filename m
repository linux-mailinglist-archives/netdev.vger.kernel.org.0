Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7A21E477
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGNAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgGNAZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:25:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6CC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:25:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C28B12983200;
        Mon, 13 Jul 2020 17:25:03 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:25:02 -0700 (PDT)
Message-Id: <20200713.172502.1672894326824222911.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        jiri@mellanox.com, edumazet@google.com, ap420073@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: make symbol 'flush_works' static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713142344.50110-1-weiyongjun1@huawei.com>
References: <20200713142344.50110-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:25:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 13 Jul 2020 22:23:44 +0800

> The sparse tool complains as follows:
> 
> net/core/dev.c:5594:1: warning:
>  symbol '__pcpu_scope_flush_works' was not declared. Should it be static?
> 
> 'flush_works' is not used outside of dev.c, so marks
> it static.
> 
> Fixes: 41852497a9205 ("net: batch calls to flush_all_backlogs()")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
