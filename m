Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA2614D806
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 09:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgA3I41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 03:56:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgA3I41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 03:56:27 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC35015380172;
        Thu, 30 Jan 2020 00:56:24 -0800 (PST)
Date:   Thu, 30 Jan 2020 09:56:19 +0100 (CET)
Message-Id: <20200130.095619.1080558867331721556.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     pabeni@redhat.com, fw@strlen.de, cpaasch@apple.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: Fix incorrect IPV6 dependency check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129180117.545-1-geert@linux-m68k.org>
References: <20200129180117.545-1-geert@linux-m68k.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jan 2020 00:56:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 29 Jan 2020 19:01:17 +0100

> If CONFIG_MPTCP=y, CONFIG_MPTCP_IPV6=n, and CONFIG_IPV6=m:
> 
>     net/mptcp/protocol.o: In function `__mptcp_tcp_fallback':
>     protocol.c:(.text+0x786): undefined reference to `inet6_stream_ops'
> 
> Fix this by checking for CONFIG_MPTCP_IPV6 instead of CONFIG_IPV6, like
> is done in all other places in the mptcp code.
> 
> Fixes: 8ab183deb26a3b79 ("mptcp: cope with later TCP fallback")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
