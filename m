Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B384A17CC49
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 06:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgCGFii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 00:38:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCGFii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 00:38:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DED9B154936D9;
        Fri,  6 Mar 2020 21:38:37 -0800 (PST)
Date:   Fri, 06 Mar 2020 21:38:37 -0800 (PST)
Message-Id: <20200306.213837.1799293710122692299.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 21:38:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri,  6 Mar 2020 19:15:02 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Patches to bump position index from sysctl seq_next,
>    from Vasilin Averin.
> 
> 2) Release flowtable hook from error path, from Florian Westphal.
> 
> 3) Patches to add missing netlink attribute validation,
>    from Jakub Kicinski.
> 
> 4) Missing NFTA_CHAIN_FLAGS in nf_tables_fill_chain_info().
> 
> 5) Infinite loop in module autoload if extension is not available,
>    from Florian Westphal.
> 
> 6) Missing module ownership in inet/nat chain type definition.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
