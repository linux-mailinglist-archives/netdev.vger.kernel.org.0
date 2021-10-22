Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33B4375F3
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhJVL2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 07:28:55 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60220 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhJVL2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 07:28:53 -0400
Received: from momiji.horms.nl (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        by kirsty.vergenet.net (Postfix) with ESMTPA id CF19825B7D9;
        Fri, 22 Oct 2021 22:26:33 +1100 (AEDT)
Received: by momiji.horms.nl (Postfix, from userid 7100)
        id AB49D9403A8; Fri, 22 Oct 2021 13:26:31 +0200 (CEST)
Date:   Fri, 22 Oct 2021 13:26:31 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: autoload ipvs on genl access
Message-ID: <20211022112629.GA22404@vergenet.net>
References: <20211021130255.4177-1-linux@weissschuh.net>
 <c473dd-51ee-4358-4496-61c9c75f875@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c473dd-51ee-4358-4496-61c9c75f875@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 09:24:34PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 21 Oct 2021, Thomas Weißschuh wrote:
> 
> > The kernel provides the functionality to automatically load modules
> > providing genl families. Use this to remove the need for users to
> > manually load the module.
> > 
> > Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> 
> 	Looks good to me for -next tree, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Acked-by: Simon Horman <horms@verge.net.au>

