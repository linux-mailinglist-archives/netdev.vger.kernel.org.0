Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1486E1F8A6D
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgFNTtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 15:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgFNTtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 15:49:42 -0400
X-Greylist: delayed 493 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 Jun 2020 12:49:42 PDT
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A3C08C5C2;
        Sun, 14 Jun 2020 12:49:42 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 1AA0E1B59A6;
        Sun, 14 Jun 2020 19:41:18 +0000 (UTC)
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: Good idea to rename files in include/uapi/ ?
Message-ID: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
Date:   Sun, 14 Jun 2020 21:41:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
X-Spam-Level: **
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello there!

At the moment one can't checkout a clean working directory w/o any 
changed files on a case-insensitive FS as the following file names have 
lower-case duplicates:

➜  linux git:(96144c58abe7) git ls-files |sort -f |uniq -id
include/uapi/linux/netfilter/xt_CONNMARK.h
include/uapi/linux/netfilter/xt_DSCP.h
include/uapi/linux/netfilter/xt_MARK.h
include/uapi/linux/netfilter/xt_RATEEST.h
include/uapi/linux/netfilter/xt_TCPMSS.h
include/uapi/linux/netfilter_ipv4/ipt_ECN.h
include/uapi/linux/netfilter_ipv4/ipt_TTL.h
include/uapi/linux/netfilter_ipv6/ip6t_HL.h
net/netfilter/xt_DSCP.c
net/netfilter/xt_HL.c
net/netfilter/xt_RATEEST.c
net/netfilter/xt_TCPMSS.c
tools/memory-model/litmus-tests/Z6.0+pooncelock+poonceLock+pombonce.litmus
➜  linux git:(96144c58abe7)

Also even on a case-sensitive one VIm seems to have trouble with editing 
both case-insensitively equal files at the same time.

I was going to make a patch renaming the respective duplicates, but I'm 
not sure:

*Is it a good idea to rename files in include/uapi/ ?*

Best,
AK
