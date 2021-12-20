Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7254747A613
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhLTIfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:35:23 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51168 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhLTIfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 03:35:23 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5D8DB205A9;
        Mon, 20 Dec 2021 09:35:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Sp5MdHzHY7kJ; Mon, 20 Dec 2021 09:35:20 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E580220504;
        Mon, 20 Dec 2021 09:35:20 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id DF4B180004A;
        Mon, 20 Dec 2021 09:35:20 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 20 Dec 2021 09:35:20 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 09:35:20 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 822C33182F8D; Mon, 20 Dec 2021 09:35:18 +0100 (CET)
Date:   Mon, 20 Dec 2021 09:35:18 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 ipsec-next 1/2] xfrm: interface with if_id 0 should
 return error
Message-ID: <20211220083518.GN427717@gauss3.secunet.de>
References: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064087.git.antony.antony@secunet.com>
 <ef942164e62ba3ba5850cb9ddf9416fa00a0515b.1639304726.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ef942164e62ba3ba5850cb9ddf9416fa00a0515b.1639304726.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 11:34:30AM +0100, Antony Antony wrote:
> xfrm interface if_id = 0 would cause xfrm policy lookup errors since
> Commit 9f8550e4bd9d.
> 
> Now explicitly fail to create an xfrm interface when if_id = 0
> 
> With this commit:
>  ip link add ipsec0  type xfrm dev lo  if_id 0
>  Error: if_id must be non zero.
> 
> v1->v2 change:
>  - add Fixes: tag
> 
> Fixes: 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied the ipsec tree, thanks Antony!

