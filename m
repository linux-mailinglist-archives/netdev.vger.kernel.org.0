Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51886BF9D3
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfIZTJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:09:27 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47156 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727920AbfIZTJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:09:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iDZ8m-0005VM-NX; Thu, 26 Sep 2019 21:09:25 +0200
Date:   Thu, 26 Sep 2019 21:09:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, paulb@mellanox.com,
        vladbu@mellanox.com
Subject: Re: [PATCH v2 net] sk_buff: drop all skb extensions on free and skb
 scrubbing
Message-ID: <20190926190920.GC9938@breakpoint.cc>
References: <20190926183705.16951-1-fw@strlen.de>
 <1ad4b9f0-c9d4-954b-eafe-8652ea6ce409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad4b9f0-c9d4-954b-eafe-8652ea6ce409@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > -	secpath_reset(skb);
> > +	skb_ext_reset(skb);
> >  	nf_reset(skb);
> >  	nf_reset_trace(skb);
> 
> 
> It is unfortunate nf_reset(skb) will call skb_ext_del(skb, SKB_EXT_BRIDGE_NF),
> which is useless after skb_ext_reset(skb) 
> 
> Maybe time for a nf_ct_reset() helper only dealing with nfct.

Agree, but that seems more like -next material?
