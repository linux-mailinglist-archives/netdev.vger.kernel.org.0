Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E0367B78
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhDVHuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhDVHuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 03:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B1561409;
        Thu, 22 Apr 2021 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619077817;
        bh=oVz/GFgZ9KvJa+9F4j0D/HVW9b3wepjzZ+ED8NDkqaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTxNflNTra8jiT7hMFb7srA0NaB7Qbn0wxg9HY0GmE+beyxkFP/NTsSwjM609k7Px
         zx0QO0X2YFFOyLdKfcGRI1yk2XZt3W6RPIJVbLsLWKbQSFXnf+y36WOySx/XizVrVQ
         FVOICQGEbJ4BFK0RVN7Rve1CgP0A7DU5P0YEt/7eSqbJev+bHfIHHDei1J98G1NqRG
         kkA6bmna/rc13JYIbH+oogYCO6KjhGMmHt3l08RNKa0vxYOc7j18EJ6aQUrezi6M/L
         rMoukPPa6EmwLbkHca02uss4oSyAiGIQoetJACPUULpR1F3zi7Sxo0UMAWEQ3dSiEj
         l8ffKJClucscg==
Date:   Thu, 22 Apr 2021 00:50:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Weikeng Chen <w.k@berkeley.edu>, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        dwysocha@redhat.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        pakki001@umn.edu, trond.myklebust@hammerspace.com
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIEqt8iAPVq8sG+t@sol.localdomain>
References: <CAHr+ZK-ayy2vku9ovuSB4egtOxrPEKxCdVQN3nFqMK07+K5_8g@mail.gmail.com>
 <YICB3wiptvvtTeA5@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YICB3wiptvvtTeA5@mit.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 03:49:51PM -0400, Theodore Ts'o wrote:
> 
> Of course, UMN researchers could just start using fake e-mail
> addresses, or start using personal gmail or yahoo or hotmail
> addresses.  (Hopefully at that point the ethics review boards at UMN
> will be clueful enough to realize that maybe, just maybe, UMN
> researchers have stepped over a line.)
> 

They are actually already doing (or did) that -- see page 9 of their paper
(https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf)
where they say they use "a random email account" to send patches.

I think that (two of?) the accounts they used were
James Bond <jameslouisebond@gmail.com>
(https://lore.kernel.org/lkml/?q=jameslouisebond%40gmail.com) and
George Acosta <acostag.ubuntu@gmail.com>
(https://lore.kernel.org/lkml/?q=acostag.ubuntu%40gmail.com).  Most of their
patches match up very closely with commits they described in their paper:

Figure 9 = https://lore.kernel.org/lkml/20200809221453.10235-1-jameslouisebond@gmail.com/
Figure 10 = https://lore.kernel.org/lkml/20200821034458.22472-1-acostag.ubuntu@gmail.com/
Figure 11 = https://lore.kernel.org/lkml/20200821031209.21279-1-acostag.ubuntu@gmail.com/

Unfortunately they obfuscated the code in their paper for some bizarre reason
and don't provide a proper list, so it's hard to know for sure though.  And
there could be more patches elsewhere.

Note that the "Figure 11" patch was actually accepted and is in mainline.
However it's not actually a bug; apparently they didn't realize that.

- Eric
