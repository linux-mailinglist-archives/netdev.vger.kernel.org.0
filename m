Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34CB41804B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 10:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhIYI1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 04:27:33 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53566 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231516AbhIYI1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 04:27:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E670B2055E;
        Sat, 25 Sep 2021 10:08:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q-0ByIg4SxJd; Sat, 25 Sep 2021 10:08:47 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1D74B204FD;
        Sat, 25 Sep 2021 10:08:47 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 118DA80004A;
        Sat, 25 Sep 2021 10:08:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Sat, 25 Sep 2021 10:08:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Sat, 25 Sep
 2021 10:08:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3AA903183C35; Sat, 25 Sep 2021 10:08:46 +0200 (CEST)
Date:   Sat, 25 Sep 2021 10:08:46 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ipv4/xfrm4_tunnel.c: remove superfluous header files
 from xfrm4_tunnel.c
Message-ID: <20210925080846.GB3027429@gauss3.secunet.de>
References: <20210920115831.29802-1-liumh1@shanghaitech.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210920115831.29802-1-liumh1@shanghaitech.edu.cn>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 07:58:31PM +0800, Mianhan Liu wrote:
> xfrm4_tunnel.c hasn't use any macro or function declared in mutex.h and ip.h
> Thus, these files can be removed from xfrm4_tunnel.c safely without affecting
> the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

Applied, thanks!
