Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49E4322F9C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBWR1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:27:48 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49296 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231523AbhBWR1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 12:27:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EDE6D20547;
        Tue, 23 Feb 2021 18:26:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6aXO0KO6cYNh; Tue, 23 Feb 2021 18:26:58 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 74DD2200BB;
        Tue, 23 Feb 2021 18:26:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 23 Feb 2021 18:26:58 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 23 Feb
 2021 18:26:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 303C5318043C;
 Tue, 23 Feb 2021 18:26:57 +0100 (CET)
Date:   Tue, 23 Feb 2021 18:26:57 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Eyal Birger <eyal.birger@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec,v2] xfrm: interface: fix ipv4 pmtu check to honor
 ip header df
Message-ID: <20210223172657.GD62598@gauss3.secunet.de>
References: <20210219172127.2223831-1-eyal.birger@gmail.com>
 <20210220130115.2914135-1-eyal.birger@gmail.com>
 <YDUbYvCnRN/aBQrM@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YDUbYvCnRN/aBQrM@hog>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 04:12:34PM +0100, Sabrina Dubroca wrote:
> 2021-02-20, 15:01:15 +0200, Eyal Birger wrote:
> > Frag needed should only be sent if the header enables DF.
> > 
> > This fix allows packets larger than MTU to pass the xfrm interface
> > and be fragmented after encapsulation, aligning behavior with
> > non-interface xfrm.
> > 
> > Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > 
> > -----
> > 
> > v2: better align coding with ip_vti
> 
> LGTM. We also need to do the same thing in ip_vti and ip6_vti. Do you
> want to take care of it, or should I?
> 
> Either way, for this patch:
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks everyone!
