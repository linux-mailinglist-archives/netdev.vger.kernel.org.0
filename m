Return-Path: <netdev+bounces-3871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2520B709572
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5598281B4D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396927480;
	Fri, 19 May 2023 10:54:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBF73D72
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:54:08 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A3110DF;
	Fri, 19 May 2023 03:54:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1pzxk4-0001lt-Fx; Fri, 19 May 2023 12:53:48 +0200
Date: Fri, 19 May 2023 12:53:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH net-next 3/9] netfilter: nft_exthdr: add boolean DCCP
 option matching
Message-ID: <20230519105348.GA24477@breakpoint.cc>
References: <20230518100759.84858-1-fw@strlen.de>
 <20230518100759.84858-4-fw@strlen.de>
 <20230518140450.07248e4c@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518140450.07248e4c@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 18 May 2023 12:07:53 +0200 Florian Westphal wrote:
> > From: Jeremy Sowden <jeremy@azazel.net>
> > 
> > The xt_dccp iptables module supports the matching of DCCP packets based
> > on the presence or absence of DCCP options.  Extend nft_exthdr to add
> > this functionality to nftables.
> 
> Someone is actually using DCCP ? :o

Don't know but its still seeing *some* activity.
When I asked the same question I was pointed at

https://multipath-dccp.org/

respectively the out-of-tree implementation at
https://github.com/telekom/mp-dccp/

There is also some ietf activity for dccp, e.g.
BBR-like CC:
https://www.ietf.org/archive/id/draft-romo-iccrg-ccid5-00.html

