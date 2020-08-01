Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D365723540F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHASr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 14:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHASr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 14:47:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F722C06174A;
        Sat,  1 Aug 2020 11:47:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81E7A1284DAE7;
        Sat,  1 Aug 2020 11:31:12 -0700 (PDT)
Date:   Sat, 01 Aug 2020 11:47:57 -0700 (PDT)
Message-Id: <20200801.114757.803597202095162623.davem@davemloft.net>
To:     brianvv@google.com
Cc:     brianvv.kernel@gmail.com, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] fib: fix another fib_rules_ops indirect call
 wrapper problem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200801030110.747164-1-brianvv@google.com>
References: <20200801030110.747164-1-brianvv@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 11:31:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>
Date: Fri, 31 Jul 2020 20:01:10 -0700

> It turns out that on commit 41d707b7332f ("fib: fix fib_rules_ops
> indirect calls wrappers") I forgot to include the case when
> CONFIG_IP_MULTIPLE_TABLES is not set.
> 
> Fixes: 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied.
