Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83F63A5F89
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhFNJ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:57:13 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:42956 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhFNJ5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:57:12 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 531EF800051;
        Mon, 14 Jun 2021 11:55:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 11:55:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 14 Jun
 2021 11:55:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 563233180609; Mon, 14 Jun 2021 11:55:07 +0200 (CEST)
Date:   Mon, 14 Jun 2021 11:55:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next v2 0/5] xfrm: ipv6: remove hdr_off indirection
Message-ID: <20210614095507.GV40979@gauss3.secunet.de>
References: <20210611105014.4675-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210611105014.4675-1-fw@strlen.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 12:50:09PM +0200, Florian Westphal wrote:
> v2: fix build failure with MIP6=y in last patch.
> 
> IPV6 xfrm moves mutable extension headers to make space for the
> encapsulation header.
> 
> For Mobile ipv6 sake this uses an indirect call (ipv6 can be built
> as module).
> 
> These patches remove those indirections by placing a
> small parsing function in the xfrm core.
> 
> While at it, the merged dstopt/rt hdroff function is
> realigned with ip6_find_1stfragopt (where they were copied from).
> 
> ip6_find_1stfragopt received bug fixes that were missing from the
> cloned ones.
> 
> Florian Westphal (5):
>   xfrm: ipv6: add xfrm6_hdr_offset helper
>   xfrm: ipv6: move mip6_destopt_offset into xfrm core
>   xfrm: ipv6: move mip6_rthdr_offset into xfrm core
>   xfrm: remove hdr_offset indirection
>   xfrm: merge dstopt and routing hdroff functions

Series applied, thanks Florian!
