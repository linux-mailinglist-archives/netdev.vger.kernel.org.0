Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E442316E2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgG2AnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730766AbgG2AnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:43:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6712C061794;
        Tue, 28 Jul 2020 17:43:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1D8B128D4942;
        Tue, 28 Jul 2020 17:26:35 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:43:20 -0700 (PDT)
Message-Id: <20200728.174320.263367752875525504.davem@davemloft.net>
To:     brianvv@google.com
Cc:     brianvv.kernel@gmail.com, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH V2 net-next] fib: use indirect call wrappers in the
 most common fib_rules_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200726224816.1819557-1-brianvv@google.com>
References: <20200726224816.1819557-1-brianvv@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:26:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>
Date: Sun, 26 Jul 2020 15:48:16 -0700

> This avoids another inderect call per RX packet which save us around
> 20-40 ns.
> 
> Changelog:
> 
> v1 -> v2:
> - Move declaraions to fib_rules.h to remove warnings
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied, thank you.
