Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5309447E27
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfFQJUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:20:22 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55798 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfFQJUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 05:20:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3DBD7201C6;
        Mon, 17 Jun 2019 11:20:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zeqB7q0eqP-K; Mon, 17 Jun 2019 11:20:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 85EFF20096;
        Mon, 17 Jun 2019 11:20:20 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Jun 2019
 11:20:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2290C31805E2;
 Mon, 17 Jun 2019 11:20:20 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:20:20 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH ipsec-next] xfrm: fix bogus WARN_ON with ipv6
Message-ID: <20190617092020.GS17989@gauss3.secunet.de>
References: <20190612111144.757a8cea@canb.auug.org.au>
 <20190612083058.22230-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190612083058.22230-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 10:30:58AM +0200, Florian Westphal wrote:
> net/xfrm/xfrm_input.c:378:17: warning: this statement may fall through [-Wimplicit-fallthrough=]
> skb->protocol = htons(ETH_P_IPV6);
> 
> ... the fallthrough then causes a bogus WARN_ON().
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 4c203b0454b ("xfrm: remove eth_proto value from xfrm_state_afinfo")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian!
