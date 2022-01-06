Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA634486224
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbiAFJca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:32:30 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38530 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236552AbiAFJc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:32:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C82DE2063E;
        Thu,  6 Jan 2022 10:32:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QDyzLm0kPEq1; Thu,  6 Jan 2022 10:32:27 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 594E920627;
        Thu,  6 Jan 2022 10:32:27 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 5388B80004A;
        Thu,  6 Jan 2022 10:32:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:32:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:32:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E7FAB3182F75; Thu,  6 Jan 2022 10:32:23 +0100 (CET)
Date:   Thu, 6 Jan 2022 10:32:23 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Raed Salem <raeds@nvidia.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <huyn@nvidia.com>, <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] net/xfrm: IPsec tunnel mode fix inner_ipproto
 setting in sec_path
Message-ID: <20220106093223.GA2638190@gauss3.secunet.de>
References: <20220103111929.11563-1-raeds@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220103111929.11563-1-raeds@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 01:19:29PM +0200, Raed Salem wrote:
> The inner_ipproto saves the inner IP protocol of the plain
> text packet. This allows vendor's IPsec feature making offload
> decision at skb's features_check and configuring hardware at
> ndo_start_xmit, current code implenetation did not handle the
> case where IPsec is used in tunnel mode.
> 
> Fix by handling the case when IPsec is used in tunnel mode by
> reading the protocol of the plain text packet IP protocol.
> 
> Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
> Signed-off-by: Raed Salem <raeds@nvidia.com>

Applied, thanks Raed!
