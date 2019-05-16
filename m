Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2047420FEF
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfEPVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:16:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfEPVQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:16:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B84AA12D6B6C0;
        Thu, 16 May 2019 14:16:10 -0700 (PDT)
Date:   Thu, 16 May 2019 14:16:07 -0700 (PDT)
Message-Id: <20190516.141607.1682504302871816565.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        sfr@canb.auug.org.au
Subject: Re: [PATCH net] xfrm: ressurrect "Fix uninitialized memory read in
 _decode_session4"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516092816.10296-1-fw@strlen.de>
References: <20190516092816.10296-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 14:16:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 16 May 2019 11:28:16 +0200

> This resurrects commit 8742dc86d0c7a9628
> ("xfrm4: Fix uninitialized memory read in _decode_session4"),
> which got lost during a merge conflict resolution between ipsec-next
> and net-next tree.
> 
> c53ac41e3720 ("xfrm: remove decode_session indirection from afinfo_policy")
> in ipsec-next moved the (buggy) _decode_session4 from
> net/ipv4/xfrm4_policy.c to net/xfrm/xfrm_policy.c.
> In mean time, 8742dc86d0c7a was applied to ipsec.git and fixed the
> problem in the "old" location.
> 
> When the trees got merged, the moved, old function was kept.
> This applies the "lost" commit again, to the new location.
> 
> Fixes: a658a3f2ecbab ("Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Steffen, I'm going to apply this directly, I hope that is OK with you.

Applied, thanks Florian.
