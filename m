Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029BC26E9BE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRAER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRAEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:04:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9172DC06174A;
        Thu, 17 Sep 2020 17:04:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEECE136663ED;
        Thu, 17 Sep 2020 16:47:28 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:04:14 -0700 (PDT)
Message-Id: <20200917.170414.150393020289404711.davem@davemloft.net>
To:     liwei391@huawei.com
Cc:     luobin9@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        guohanjun@huawei.com
Subject: Re: [PATCH net v2] hinic: fix potential resource leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917122950.36878-1-liwei391@huawei.com>
References: <20200917122950.36878-1-liwei391@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:47:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Li <liwei391@huawei.com>
Date: Thu, 17 Sep 2020 20:29:50 +0800

> In rx_request_irq(), it will just return what irq_set_affinity_hint()
> returns. If it is failed, the napi and irq requested are not freed
> properly. So add exits for failures to handle these.
> 
> Signed-off-by: Wei Li <liwei391@huawei.com>
> ---
> v1 -> v2:
>  - Free irq as well when irq_set_affinity_hint() fails.

Applied, thank you.
