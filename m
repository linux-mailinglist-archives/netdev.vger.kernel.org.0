Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE099ED6EA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfKDB1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:27:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfKDB1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 20:27:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7735150306B8;
        Sun,  3 Nov 2019 17:27:45 -0800 (PST)
Date:   Sun, 03 Nov 2019 17:27:45 -0800 (PST)
Message-Id: <20191103.172745.1001182008988884958.davem@davemloft.net>
To:     fruggeri@arista.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: icmp6: provide input address for
 traceroute6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031004004.2FC7695C0964@us180.sjc.aristanetworks.com>
References: <20191031004004.2FC7695C0964@us180.sjc.aristanetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 17:27:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fruggeri@arista.com (Francesco Ruggeri)
Date: Wed, 30 Oct 2019 17:40:02 -0700

> traceroute6 output can be confusing, in that it shows the address
> that a router would use to reach the sender, rather than the address
> the packet used to reach the router.
> Consider this case:
> 
>         ------------------------ N2
>          |                    |
>        ------              ------  N3  ----
>        | R1 |              | R2 |------|H2|
>        ------              ------      ----
>          |                    |
>         ------------------------ N1
>                   |
>                  ----
>                  |H1|
>                  ----
> 
> where H1's default route is through R1, and R1's default route is
> through R2 over N2.
> traceroute6 from H1 to H2 shows R2's address on N1 rather than on N2.
> 
> The script below can be used to reproduce this scenario.
 ...
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> Original-patch-by: Honggang Xu <hxu@arista.com>

Applied.
