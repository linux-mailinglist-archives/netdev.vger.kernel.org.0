Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E81A1966
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgDHBIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:08:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDHBIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:08:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E9EA1210A3E3;
        Tue,  7 Apr 2020 18:08:27 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:08:24 -0700 (PDT)
Message-Id: <20200407.180824.1431055985187545880.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407222936.206295-1-pablo@netfilter.org>
References: <20200407222936.206295-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:08:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  8 Apr 2020 00:29:29 +0200

> The following patchset contains Netfilter fixes for net, they are:
> 
> 1) Fix spurious overlap condition in the rbtree tree, from Stefano Brivio.
> 
> 2) Fix possible uninitialized pointer dereference in nft_lookup.
> 
> 3) IDLETIMER v1 target matches the Android layout, from
>    Maciej Zenczykowski.
> 
> 4) Dangling pointer in nf_tables_set_alloc_name, from Eric Dumazet.
> 
> 5) Fix RCU warning splat in ipset find_set_type(), from Amol Grover.
> 
> 6) Report EOPNOTSUPP on unsupported set flags and object types in sets.
> 
> 7) Add NFT_SET_CONCAT flag to provide consistent error reporting
>    when users defines set with ranges in concatenations in old kernels.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
