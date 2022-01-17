Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECD0490748
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiAQLqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:46:36 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39626 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239202AbiAQLqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 06:46:34 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 32E8D204FD;
        Mon, 17 Jan 2022 12:46:33 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lRs8tctdKHvn; Mon, 17 Jan 2022 12:46:32 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AA7B4200BC;
        Mon, 17 Jan 2022 12:46:32 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id A4B2080004A;
        Mon, 17 Jan 2022 12:46:32 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 17 Jan 2022 12:46:32 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 17 Jan
 2022 12:46:32 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C840F3183CD6; Mon, 17 Jan 2022 12:46:31 +0100 (CET)
Date:   Mon, 17 Jan 2022 12:46:31 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yan Yan <evitayan@google.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Nathan Harold <nharold@google.com>,
        Benedict Wong <benedictwong@google.com>
Subject: Re: [PATCH v1 1/2] xfrm: Check if_id in xfrm_migrate
Message-ID: <20220117114631.GG1223722@gauss3.secunet.de>
References: <20220108013230.56294-1-evitayan@google.com>
 <20220112073242.GA1223722@gauss3.secunet.de>
 <CADHa2dAaG4Pgxk7gmDbBnVSYJ_eBtJY3KaR94fY=wp+Pmt0EoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADHa2dAaG4Pgxk7gmDbBnVSYJ_eBtJY3KaR94fY=wp+Pmt0EoA@mail.gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yan,

On Wed, Jan 12, 2022 at 02:53:31PM -0800, Yan Yan wrote:
> Hi Steffen,
> 
> The Jan 7th patch fixes the following warning (reported by the kernel
> test robot) by adding parentheses.
>    net/xfrm/xfrm_policy.c: In function 'xfrm_migrate':
> >> net/xfrm/xfrm_policy.c:4403:21: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>     4403 |                 if (x = xfrm_migrate_state_find(mp, net, if_id)) {
>          |                     ^
> 
> In the Jan 7th patch, this line becomes "if ((x =
> xfrm_migrate_state_find(mp, net, if_id))) {"

I thought that was already fixed in the previous version.
Please mark updated patches as v2 etc. and describe the
changes you did in the new version.

Please resend your patchset and add a proper 'Fixes:'
tag to the patches.

Thanks!
