Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5FFBDD5F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbfIYLp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:45:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbfIYLp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:45:57 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE09E14649696;
        Wed, 25 Sep 2019 04:45:55 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:45:54 +0200 (CEST)
Message-Id: <20190925.134554.2101760650151955552.davem@davemloft.net>
To:     jeliantsurux@gmail.com
Cc:     gnault@redhat.com, paulus@samba.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ppp: Fix memory leak in ppp_write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190922074531.GA1450@DESKTOP>
References: <20190922074531.GA1450@DESKTOP>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:45:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>
Date: Sun, 22 Sep 2019 16:45:31 +0900

> When ppp is closing, __ppp_xmit_process() failed to enqueue skb
> and skb allocated in ppp_write() is leaked.
> 
> syzbot reported :
 ...
> Fix this by freeing skb, if ppp is closing.
> 
> Fixes: 6d066734e9f0 ("ppp: avoid loop in xmit recursion detection code")
> Reported-and-tested-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com
> Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>

Applied and queued up for -stable.
