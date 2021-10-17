Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FCE43089C
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbhJQMUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:20:45 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45290 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbhJQMUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:20:44 -0400
Received: from madeliefje.horms.nl (120-114-128-083.dynamic.caiway.nl [83.128.114.120])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 9B95F25AEAA;
        Sun, 17 Oct 2021 23:18:33 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 8BC3D4421; Sun, 17 Oct 2021 14:18:31 +0200 (CEST)
Date:   Sun, 17 Oct 2021 14:18:31 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] netfilter: ipvs: make global sysctl readonly in
 non-init netns
Message-ID: <20211017121831.GD8292@vergenet.net>
References: <20211012145437.754391-1-atenart@kernel.org>
 <8e76869d-ae27-198a-e750-16cd26e63737@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e76869d-ae27-198a-e750-16cd26e63737@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 11:48:52PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 12 Oct 2021, Antoine Tenart wrote:
> 
> > Because the data pointer of net/ipv4/vs/debug_level is not updated per
> > netns, it must be marked as read-only in non-init netns.
> > 
> > Fixes: c6d2d445d8de ("IPVS: netns, final patch enabling network name space.")
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Likewise, thanks.

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider picking up this patch.

