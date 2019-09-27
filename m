Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB5C0AE1
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfI0SQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:16:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfI0SQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:16:37 -0400
Received: from localhost (unknown [172.56.13.93])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76022153E867B;
        Fri, 27 Sep 2019 11:16:35 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:16:31 +0200 (CEST)
Message-Id: <20190927.201631.1601531186128089485.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925203003.20112-1-pablo@netfilter.org>
References: <20190925203003.20112-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:16:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 25 Sep 2019 22:29:58 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Add NFT_CHAIN_POLICY_UNSET to replace hardcoded -1 to
>    specify that the chain policy is unset. The chain policy
>    field is actually defined as an 8-bit unsigned integer.
> 
> 2) Remove always true condition reported by smatch in
>    chain policy check.
> 
> 3) Fix element lookup on dynamic sets, from Florian Westphal.
> 
> 4) Use __u8 in ebtables uapi header, from Masahiro Yamada.
> 
> 5) Bogus EBUSY when removing flowtable after chain flush,
>    from Laura Garcia Liebana.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
