Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7474F245B4B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHQEFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 00:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgHQEFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:05:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF10C061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 21:05:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81AA0125007F3;
        Sun, 16 Aug 2020 20:48:50 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:05:35 -0700 (PDT)
Message-Id: <20200816.210535.10133417009498191.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, rdunlap@infradead.org
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:48:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 16 Aug 2020 17:32:03 +0800

> When using ipv6_dev_find() in one module, it requires ipv6 not to
> work as a module. Otherwise, this error occurs in build:
> 
>   undefined reference to `ipv6_dev_find'.
> 
> So fix it by adding "depends on IPV6 || IPV6=n" to tipc/Kconfig,
> as it does in sctp/Kconfig.
> 
> Fixes: 5a6f6f579178 ("tipc: set ub->ifindex for local ipv6 address")
> Reported-by: kernel test robot <lkp@intel.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
