Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824A520E037
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgF2UoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731611AbgF2TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40EDC08C5F4
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:38:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EFC7129CE205;
        Sun, 28 Jun 2020 21:38:09 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:38:06 -0700 (PDT)
Message-Id: <20200628.213806.308263445293695615.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, ap420073@gmail.com, dvyukov@google.com
Subject: Re: [Patch net] net: get rid of lockdep_set_class_and_subclass()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626182422.9647-1-xiyou.wangcong@gmail.com>
References: <20200626182422.9647-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:38:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 26 Jun 2020 11:24:22 -0700

> lockdep_set_class_and_subclass() is meant to reduce
> the _nested() annotations by assigning a default subclass.
> For addr_list_lock, we have to compute the subclass at
> run-time as the netdevice topology changes after creation.
> 
> So, we should just get rid of these
> lockdep_set_class_and_subclass() and stick with our _nested()
> annotations.
> 
> Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
> Suggested-by: Taehee Yoo <ap420073@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
