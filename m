Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD8F3EB5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKHEHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:07:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKHEHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:07:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12D8E14F4EEDC;
        Thu,  7 Nov 2019 20:07:50 -0800 (PST)
Date:   Thu, 07 Nov 2019 20:07:49 -0800 (PST)
Message-Id: <20191107.200749.349173827390952058.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] net: add annotations on hh->hh_len lockless
 accesses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108022911.183563-1-edumazet@google.com>
References: <20191108022911.183563-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 20:07:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 18:29:11 -0800

> KCSAN reported a data-race [1]
> 
> While we can use READ_ONCE() on the read sides,
> we need to make sure hh->hh_len is written last.
> 
> [1]
> 
> BUG: KCSAN: data-race in eth_header_cache / neigh_resolve_output
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.
