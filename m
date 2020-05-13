Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFFF1D061D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 06:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgEMEml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 00:42:41 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33746 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMEml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 00:42:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5418E2052E;
        Wed, 13 May 2020 06:42:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8v8mXHfs3mbN; Wed, 13 May 2020 06:42:37 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E27020189;
        Wed, 13 May 2020 06:42:37 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 May 2020 06:42:37 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 13 May
 2020 06:42:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 649983180285; Wed, 13 May 2020 06:42:36 +0200 (CEST)
Date:   Wed, 13 May 2020 06:42:36 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH ipsec-next] xfrm: fix unused variable warning if
 CONFIG_NETFILTER=n
Message-ID: <20200513044236.GE19286@gauss3.secunet.de>
References: <20200511130325.44e65463@canb.auug.org.au>
 <20200511083346.24627-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200511083346.24627-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:33:42AM +0200, Florian Westphal wrote:
> After recent change 'x' is only used when CONFIG_NETFILTER is set:
> 
> net/ipv4/xfrm4_output.c: In function '__xfrm4_output':
> net/ipv4/xfrm4_output.c:19:21: warning: unused variable 'x' [-Wunused-variable]
>    19 |  struct xfrm_state *x = skb_dst(skb)->xfrm;
> 
> Expand the CONFIG_NETFILTER scope to avoid this.
> 
> Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian!
