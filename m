Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB33CA883
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhGOTBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 15:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243030AbhGOTAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 15:00:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816B3C05BD38;
        Thu, 15 Jul 2021 11:54:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m46VT-0007Rr-8F; Thu, 15 Jul 2021 20:54:47 +0200
Date:   Thu, 15 Jul 2021 20:54:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Varad Gautam <varad.gautam@suse.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 5.4 097/122] xfrm: policy: Read seqcount outside of
 rcu-read side in xfrm_policy_lookup_bytype
Message-ID: <20210715185447.GC9904@breakpoint.cc>
References: <20210715182448.393443551@linuxfoundation.org>
 <20210715182517.994942248@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715182517.994942248@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> From: Varad Gautam <varad.gautam@suse.com>
> 
> commit d7b0408934c749f546b01f2b33d07421a49b6f3e upstream.

This patch has been reverted in the ipsec tree, the problem was then
addressed via 2580d3f40022642452dd8422bfb8c22e54cf84bb
("xfrm: Fix RCU vs hash_resize_mutex lock inversion").

AFAICS its not in mainline yet.
