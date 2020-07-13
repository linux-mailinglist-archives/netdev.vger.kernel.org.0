Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175D32190DE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgGHThv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHThv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:37:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253B6C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 12:37:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E326C1276B34D;
        Wed,  8 Jul 2020 12:37:50 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:37:50 -0700 (PDT)
Message-Id: <20200708.123750.2177855708364007871.davem@davemloft.net>
To:     xiangning.yu@alibaba-inc.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:37:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Date: Thu, 09 Jul 2020 00:38:16 +0800

> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>  	return true;
>  #endif /* CONFIG_SMP */
>  }
> -
> +EXPORT_SYMBOL_GPL(irq_work_queue_on);

You either removed the need for kthreads or you didn't.

If you are queueing IRQ work like this, you're still using kthreads.

That's why Eric is asking why you still need this export.
