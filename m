Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D245D735
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353832AbhKYJfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:35:09 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37078 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353839AbhKYJdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 04:33:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CECE420185;
        Thu, 25 Nov 2021 10:29:56 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lqDk3B0uvRZY; Thu, 25 Nov 2021 10:29:56 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6129E200BB;
        Thu, 25 Nov 2021 10:29:56 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 520E980004A;
        Thu, 25 Nov 2021 10:29:56 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 25 Nov 2021 10:29:56 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 25 Nov
 2021 10:29:55 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 747773180F41; Thu, 25 Nov 2021 10:29:55 +0100 (CET)
Date:   Thu, 25 Nov 2021 10:29:55 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Ghalem Boudour <ghalem.boudour@6wind.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH net v2] xfrm: fix policy lookup for ipv6 gre packets
Message-ID: <20211125092955.GC427717@gauss3.secunet.de>
References: <20211119170402.11213-1-nicolas.dichtel@6wind.com>
 <20211119172016.11610-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211119172016.11610-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 06:20:16PM +0100, Nicolas Dichtel wrote:
> From: Ghalem Boudour <ghalem.boudour@6wind.com>
> 
> On egress side, xfrm lookup is called from __gre6_xmit() with the
> fl6_gre_key field not initialized leading to policies selectors check
> failure. Consequently, gre packets are sent without encryption.
> 
> On ingress side, INET6_PROTO_NOPOLICY was set, thus packets were not
> checked against xfrm policies. Like for egress side, fl6_gre_key should be
> correctly set, this is now done in decode_session6().
> 
> Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ghalem Boudour <ghalem.boudour@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Patch applied, thanks a lot!
