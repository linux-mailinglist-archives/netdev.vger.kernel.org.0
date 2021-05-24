Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8A438F216
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhEXRO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 13:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhEXRO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 13:14:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5D5C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 10:13:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1llE8i-0007eN-JV; Mon, 24 May 2021 19:13:16 +0200
Date:   Mon, 24 May 2021 19:13:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pablo@netfilter.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: zero-initialize skb extensions on allocation
Message-ID: <20210524171316.GB3194@breakpoint.cc>
References: <20210524061959.2349342-1-vladbu@nvidia.com>
 <20210524100137.GA3194@breakpoint.cc>
 <ygnhy2c48jeb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhy2c48jeb.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad Buslov <vladbu@nvidia.com> wrote:
> So what would you suggest: provide a dedicated wrapper for TC skb
> extension that will memset resulting extension to zero or refactor my
> patch to zero-initialize specific skb extension in skb_ext_add() (only
> the extension requested and also when previously discarded extension is
> reused)?

I would go for A), but if you prefer B) I would not mind.
