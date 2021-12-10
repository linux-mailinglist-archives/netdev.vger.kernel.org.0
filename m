Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52AE4700BB
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 13:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbhLJMgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 07:36:50 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:42948 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241059AbhLJMgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 07:36:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C604320504;
        Fri, 10 Dec 2021 13:33:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ELpT-BhApzhP; Fri, 10 Dec 2021 13:33:13 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5C1872019D;
        Fri, 10 Dec 2021 13:33:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 5649680004A;
        Fri, 10 Dec 2021 13:33:13 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 10 Dec 2021 13:33:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 10 Dec
 2021 13:33:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 99B123182FDF; Fri, 10 Dec 2021 13:33:11 +0100 (CET)
Date:   Fri, 10 Dec 2021 13:33:11 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] xfrm: fix a small bug in frm_sa_len()
Message-ID: <20211210123311.GK3272477@gauss3.secunet.de>
References: <20211208202019.3423010-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211208202019.3423010-1-eric.dumazet@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 12:20:19PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> copy_user_offload() will actually push a struct struct xfrm_user_offload,
> which is different than (struct xfrm_state *)->xso
> (struct xfrm_state_offload)
> 
> Fixes: d77e38e612a01 ("xfrm: Add an IPsec hardware offloading API")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

Applied to the ipsec tree, thanks Eric!

Note: I fixed a typo in the subject 'frm_sa_len -> xfrm_sa_len'
