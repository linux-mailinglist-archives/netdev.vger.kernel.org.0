Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A653214975
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 03:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgGEBDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 21:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgGEBDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 21:03:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C91EC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 18:03:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42463157A9DBB;
        Sat,  4 Jul 2020 18:03:52 -0700 (PDT)
Date:   Sat, 04 Jul 2020 18:03:51 -0700 (PDT)
Message-Id: <20200704.180351.1244816152547109881.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] hsr: fix interface leak in error path of
 hsr_dev_finalize()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702170619.10378-1-ap420073@gmail.com>
References: <20200702170619.10378-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 18:03:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  2 Jul 2020 17:06:19 +0000

> To release hsr(upper) interface, it should release
> its own lower interfaces first.
> Then, hsr(upper) interface can be released safely.
> In the current code of error path of hsr_dev_finalize(), it releases hsr
> interface before releasing a lower interface.
> So, a warning occurs, which warns about the leak of lower interfaces.
> In order to fix this problem, changing the ordering of the error path of
> hsr_dev_finalize() is needed.
 ...
> Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
> Reported-by: syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for v5.7 -stable, thank you.
