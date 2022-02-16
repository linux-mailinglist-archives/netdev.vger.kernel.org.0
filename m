Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C364B9127
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiBPT1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBPT1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:27:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9CD1A615F;
        Wed, 16 Feb 2022 11:27:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nKPx2-0007to-JQ; Wed, 16 Feb 2022 20:26:56 +0100
Date:   Wed, 16 Feb 2022 20:26:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kevmitch@arista.com
Subject: Re: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero
 checksum as CHECKSUM_UNNECESSARY
Message-ID: <20220216192656.GB20500@breakpoint.cc>
References: <20220209133616.165104-1-pablo@netfilter.org>
 <20220209133616.165104-2-pablo@netfilter.org>
 <7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com>
 <20220216152842.GA20500@breakpoint.cc>
 <Yg0gmE8y4mweUNj1@salvia>
 <3abe91c7-6558-4f1d-5e6b-e74e71c6c23b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3abe91c7-6558-4f1d-5e6b-e74e71c6c23b@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gal Pressman <gal@nvidia.com> wrote:
> >> Probably better to revert and patch nf_reject instead to
> >> handle 0 udp csum?
> > Agreed.
> 
> Thanks, should I submit a revert?

No need, its backed out now in nf-next.

Kevin, feel free to send a v2 that patches reject csum
to fix the issue you were seeing.
