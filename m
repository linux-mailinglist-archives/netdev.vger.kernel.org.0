Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175F62625A9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIIDJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIIDJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:09:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854FCC061573;
        Tue,  8 Sep 2020 20:09:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA1D911E3E4C3;
        Tue,  8 Sep 2020 19:52:53 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:09:39 -0700 (PDT)
Message-Id: <20200908.200939.1142797095204355615.davem@davemloft.net>
To:     brianvv@google.com
Cc:     brianvv.kernel@gmail.com, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        svenjoac@gmx.de, rdunlap@infradead.org
Subject: Re: [PATCH] fib: fix fib_rule_ops indirect call wrappers when
 CONFIG_IPV6=m
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908161812.723044-1-brianvv@google.com>
References: <20200908161812.723044-1-brianvv@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:52:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>
Date: Tue,  8 Sep 2020 09:18:12 -0700

> If CONFIG_IPV6=m, the IPV6 functions won't be found by the linker:
> 
> ld: net/core/fib_rules.o: in function `fib_rules_lookup':
> fib_rules.c:(.text+0x606): undefined reference to `fib6_rule_match'
> ld: fib_rules.c:(.text+0x611): undefined reference to `fib6_rule_match'
> ld: fib_rules.c:(.text+0x68c): undefined reference to `fib6_rule_action'
> ld: fib_rules.c:(.text+0x693): undefined reference to `fib6_rule_action'
> ld: fib_rules.c:(.text+0x6aa): undefined reference to `fib6_rule_suppress'
> ld: fib_rules.c:(.text+0x6bc): undefined reference to `fib6_rule_suppress'
> make: *** [Makefile:1166: vmlinux] Error 1
> 
> Reported-by: Sven Joachim <svenjoac@gmx.de>
> Fixes: b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rules_ops")
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied, thanks.
