Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FAF20E03B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbgF2UoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731615AbgF2TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE5AC08C5F6
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:38:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CF8B129CE20B;
        Sun, 28 Jun 2020 21:38:41 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:38:40 -0700 (PDT)
Message-Id: <20200628.213840.2040654691583733987.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, ap420073@gmail.com, dvyukov@google.com
Subject: Re: [Patch net] net: explain the lockdep annotations for
 dev_uc_unsync()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626182527.9842-1-xiyou.wangcong@gmail.com>
References: <20200626182527.9842-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:38:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 26 Jun 2020 11:25:27 -0700

> The lockdep annotations for dev_uc_unsync() and dev_mc_unsync()
> are not easy to understand, so add some comments to explain
> why they are correct.
> 
> Similar for the rest netif_addr_lock_bh() cases, they don't
> need nested version.
> 
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
