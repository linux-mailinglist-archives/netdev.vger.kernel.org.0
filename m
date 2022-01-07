Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED0487620
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiAGLDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:03:13 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:33280 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237611AbiAGLDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 06:03:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 74CF8201C7;
        Fri,  7 Jan 2022 12:03:07 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gMKdpjXO0lLp; Fri,  7 Jan 2022 12:03:06 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EF1C720185;
        Fri,  7 Jan 2022 12:03:06 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E922180004A;
        Fri,  7 Jan 2022 12:03:06 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 7 Jan 2022 12:03:06 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5FABD318057A; Fri,  7 Jan 2022 12:03:06 +0100 (CET)
Date:   Fri, 7 Jan 2022 12:03:06 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Raed Salem <raeds@nvidia.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <huyn@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] net/xfrm: IPsec tunnel mode fix inner_ipproto
 setting in sec_path
Message-ID: <20220107110306.GT3272477@gauss3.secunet.de>
References: <20220103111929.11563-1-raeds@nvidia.com>
 <20220106093223.GA2638190@gauss3.secunet.de>
 <20220107004726.unyuuu2qki4gskxv@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220107004726.unyuuu2qki4gskxv@sx1>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 04:47:26PM -0800, Saeed Mahameed wrote:
> On Thu, Jan 06, 2022 at 10:32:23AM +0100, Steffen Klassert wrote:
> > On Mon, Jan 03, 2022 at 01:19:29PM +0200, Raed Salem wrote:
> > > The inner_ipproto saves the inner IP protocol of the plain
> > > text packet. This allows vendor's IPsec feature making offload
> > > decision at skb's features_check and configuring hardware at
> > > ndo_start_xmit, current code implenetation did not handle the
> > > case where IPsec is used in tunnel mode.
> > > 
> > > Fix by handling the case when IPsec is used in tunnel mode by
> > > reading the protocol of the plain text packet IP protocol.
> > > 
> > > Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
> > > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > 
> > Applied, thanks Raed!
> 
> hmm, there are two mlx5 patches that depend on this patch, I thought Raed
> was planning to send them along with this.
> 
> Steffen, is it ok if I submit those two patches to you and so you would
> send them all at once in your next net PR ?

The pull request with that patch included is already merged into
the net tree. So if you pull the net tree, you can apply the
mlx5 patches yourself. But if you prefer, I can take them too.

