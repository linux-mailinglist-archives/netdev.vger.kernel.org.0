Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C01898C7
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgCRKCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:02:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58228 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727281AbgCRKCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:02:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEVWt-0003dS-V8; Wed, 18 Mar 2020 11:02:28 +0100
Date:   Wed, 18 Mar 2020 11:02:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
Message-ID: <20200318100227.GE979@breakpoint.cc>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> This reverts the following commits:
> 
>   8537f78647c0 ("netfilter: Introduce egress hook")
>   5418d3881e1f ("netfilter: Generalize ingress hook")
>   b030f194aed2 ("netfilter: Rename ingress hook include file")
> 
> From the discussion in [0], the author's main motivation to add a hook
> in fast path is for an out of tree kernel module, which is a red flag
> to begin with.

The author did post patches for nftables, i.e. you can hook up rulesets to
this new hook point.

> is on future extensions w/o concrete code in the tree yet. Revert as
> suggested [1] given the weak justification to add more hooks to critical
> fast-path.

Do you have an alternative suggestion on how to expose this?
