Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565EDF2457
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732757AbfKGBgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:36:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbfKGBgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:36:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F6E9150301AD;
        Wed,  6 Nov 2019 17:36:08 -0800 (PST)
Date:   Wed, 06 Nov 2019 17:36:07 -0800 (PST)
Message-Id: <20191106.173607.54986119128433453.davem@davemloft.net>
To:     fruggeri@arista.com
Cc:     dsahern@gmail.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v2] selftest: net: add some traceroute tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105224835.D134F95C0C6F@us180.sjc.aristanetworks.com>
References: <20191105224835.D134F95C0C6F@us180.sjc.aristanetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 17:36:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fruggeri@arista.com (Francesco Ruggeri)
Date: Tue, 05 Nov 2019 14:48:35 -0800

> Added the following traceroute tests.
> 
> IPV6:
> Verify that in this scenario
> 
>        ------------------------ N2
>         |                    |
>       ------              ------  N3  ----
>       | R1 |              | R2 |------|H2|
>       ------              ------      ----
>         |                    |
>        ------------------------ N1
>                  |
>                 ----
>                 |H1|
>                 ----
> 
> where H1's default route goes through R1 and R1's default route goes
> through R2 over N2, traceroute6 from H1 to H2 reports R2's address
> on N2 and not N1.
> 
> IPV4:
> Verify that traceroute from H1 to H2 shows 1.0.1.1 in this scenario
> 
>                    1.0.3.1/24
> ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
> |H1|--------------------------|R1|--------------------------|H2|
> ----            N1            ----            N2            ----
> 
> where net.ipv4.icmp_errors_use_inbound_ifaddr is set on R1 and
> 1.0.3.1/24 and 1.0.1.1/24 are respectively R1's primary and secondary
> address on N1.
> 
> v2: fixed some typos, and have bridge in R1 instead of R2 in IPV6 test.
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

Applied, thank you.
