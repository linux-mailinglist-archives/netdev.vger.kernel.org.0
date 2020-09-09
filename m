Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB8626253A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIICe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIICe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:34:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A2C061573;
        Tue,  8 Sep 2020 19:34:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6956B11E3E4C2;
        Tue,  8 Sep 2020 19:18:11 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:34:57 -0700 (PDT)
Message-Id: <20200908.193457.2107801410242833339.davem@davemloft.net>
To:     trix@redhat.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: skip an unnecessay check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200907180438.11983-1-trix@redhat.com>
References: <20200907180438.11983-1-trix@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:18:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: trix@redhat.com
Date: Mon,  7 Sep 2020 11:04:38 -0700

> From: Tom Rix <trix@redhat.com>
> 
> Reviewing the error handling in tcf_action_init_1()
> most of the early handling uses
> 
> err_out:
> 	if (cookie) {
> 		kfree(cookie->data);
> 		kfree(cookie);
> 	}
> 
> before cookie could ever be set.
> 
> So skip the unnecessay check.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied to net-next, thank you.
