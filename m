Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569C7232623
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgG2U11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2U11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:27:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE49C061794;
        Wed, 29 Jul 2020 13:27:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E97812786F12;
        Wed, 29 Jul 2020 13:10:41 -0700 (PDT)
Date:   Wed, 29 Jul 2020 13:27:25 -0700 (PDT)
Message-Id: <20200729.132725.1930680593526585407.davem@davemloft.net>
To:     brianvv@google.com
Cc:     brianvv.kernel@gmail.com, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] fib: fix fib_rules_ops indirect calls wrappers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729181018.3221288-1-brianvv@google.com>
References: <20200729181018.3221288-1-brianvv@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 13:10:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>
Date: Wed, 29 Jul 2020 11:10:18 -0700

> This patch fixes:
> commit b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
> fib_rules_ops") which didn't consider the case when
> CONFIG_IPV6_MULTIPLE_TABLES is not set.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rules_ops")
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied, thanks Brian.
