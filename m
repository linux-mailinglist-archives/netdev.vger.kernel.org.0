Return-Path: <netdev+bounces-1710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2300A6FEF97
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 641202815FC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A361C75C;
	Thu, 11 May 2023 10:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1761C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:03:49 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A41E8A40
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:03:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id A79D92085F;
	Thu, 11 May 2023 12:03:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e3FhzDIw-toZ; Thu, 11 May 2023 12:03:38 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2B8922085B;
	Thu, 11 May 2023 12:03:38 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout2.secunet.com (Postfix) with ESMTP id 263A780004A;
	Thu, 11 May 2023 12:03:38 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 12:03:37 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 11 May
 2023 12:03:37 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 873BB3182BB4; Thu, 11 May 2023 12:03:37 +0200 (CEST)
Date: Thu, 11 May 2023 12:03:37 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Tobias Brunner <tobias@strongswan.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>, "David
 S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Reject optional tunnel/BEET mode templates
 in outbound policies
Message-ID: <ZFy9eTcWtts2rZfj@gauss3.secunet.de>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
 <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
 <ZFiPyZvW2PhPZHlv@gauss3.secunet.de>
 <c29e3424-f6ef-4d38-e150-fcf82d364ad2@strongswan.org>
 <ZFnLmakCaADGVGV3@gauss3.secunet.de>
 <95604760-0ea0-859c-a898-c0a6b548cf8e@strongswan.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <95604760-0ea0-859c-a898-c0a6b548cf8e@strongswan.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:59:58AM +0200, Tobias Brunner wrote:
> xfrm_state_find() uses `encap_family` of the current template with
> the passed local and remote addresses to find a matching state.
> If an optional tunnel or BEET mode template is skipped in a mixed-family
> scenario, there could be a mismatch causing an out-of-bounds read as
> the addresses were not replaced to match the family of the next template.
> 
> While there are theoretical use cases for optional templates in outbound
> policies, the only practical one is to skip IPComp states in inbound
> policies if uncompressed packets are received that are handled by an
> implicitly created IPIP state instead.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks a lot Tobias!

