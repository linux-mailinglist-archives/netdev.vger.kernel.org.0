Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39785F0C00
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfKFCXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:23:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbfKFCXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:23:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D313B15108141;
        Tue,  5 Nov 2019 18:23:32 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:23:32 -0800 (PST)
Message-Id: <20191105.182332.1475939627781274384.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        deepa.kernel@gmail.com
Subject: Re: [PATCH net] net: prevent load/store tearing on sk->sk_stamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105053843.181176-1-edumazet@google.com>
References: <20191105053843.181176-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:23:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  4 Nov 2019 21:38:43 -0800

> Add a couple of READ_ONCE() and WRITE_ONCE() to prevent
> load-tearing and store-tearing in sock_read_timestamp()
> and sock_write_timestamp()
> 
> This might prevent another KCSAN report.
> 
> Fixes: 3a0ed3e96197 ("sock: Make sock->sk_stamp thread-safe")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable.
