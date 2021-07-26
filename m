Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4503D5523
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhGZHdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:33:24 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:54776 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhGZHdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:33:23 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id D3CF7800053;
        Mon, 26 Jul 2021 10:13:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:13:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 26 Jul
 2021 10:13:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 25FF531801F6; Mon, 26 Jul 2021 10:13:50 +0200 (CEST)
Date:   Mon, 26 Jul 2021 10:13:50 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Corey Minyard <minyard@acm.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: IPSec questions and comments
Message-ID: <20210726081350.GM893739@gauss3.secunet.de>
References: <20210724010117.GA633665@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210724010117.GA633665@minyard.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 08:01:17PM -0500, Corey Minyard wrote:
> <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Bcc: 
> Subject: IPSec questions
> Reply-To: minyard@acm.org
> 
> I've been going through the XFRM code trying to understand it.  I've
> been documenting things in the code as I go.
> 
> I have a specific usage question, then a general question:
> 
> 1) In struct xfrm_dst, what is the difference between the route and path
> fields?  From what I can tell, in the first element of a bundle they
> will both point the route the packet will take after it has been
> transformed.  In the other elements of a bundle, route is the same as in
> the first element and path will be NULL.  Is this really the intent?
> Can path just be eliminated?

Eyal gave a good explanation of this.

> 
> 2) This code is really hard to understand.  Nobody should have to go
> through what I'm going through.  If I can convince my employer to allow
> me to submit the comments I'm adding, would that be something acceptable?
> It would obviously take a lot of time to review.  If nobody's going to
> have the time to review it, I don't need to put forth the extra effort
> to make it submittable.

Documentation is always welcome. If you submit your documentation
in small reviewable patches, then it should be accepted and merged
over time.
