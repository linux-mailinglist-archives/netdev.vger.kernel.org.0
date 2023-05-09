Return-Path: <netdev+bounces-1030-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA296FBE2E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4648B1C20AB5
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B4C17F1;
	Tue,  9 May 2023 04:27:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFD1137A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:27:12 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C880D19B3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:27:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id D75672082B;
	Tue,  9 May 2023 06:27:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ekW6IVoyRIP0; Tue,  9 May 2023 06:27:06 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 5AC0D206E9;
	Tue,  9 May 2023 06:27:06 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout2.secunet.com (Postfix) with ESMTP id 485D680004A;
	Tue,  9 May 2023 06:27:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 06:27:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 9 May
 2023 06:27:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 5494E3182C4B; Tue,  9 May 2023 06:27:05 +0200 (CEST)
Date: Tue, 9 May 2023 06:27:05 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Tobias Brunner <tobias@strongswan.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>, "David
 S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Reject optional tunnel/BEET mode templates
 in outbound policies
Message-ID: <ZFnLmakCaADGVGV3@gauss3.secunet.de>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
 <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
 <ZFiPyZvW2PhPZHlv@gauss3.secunet.de>
 <c29e3424-f6ef-4d38-e150-fcf82d364ad2@strongswan.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c29e3424-f6ef-4d38-e150-fcf82d364ad2@strongswan.org>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:03:36AM +0200, Tobias Brunner wrote:
> On 08.05.23 07:59, Steffen Klassert wrote:
> > On Fri, May 05, 2023 at 12:16:16PM +0200, Tobias Brunner wrote:
> >> xfrm_state_find() uses `encap_family` of the current template with
> >> the passed local and remote addresses to find a matching state.
> >> If an optional tunnel or BEET mode template is skipped in a mixed-family
> >> scenario, there could be a mismatch causing an out-of-bounds read as
> >> the addresses were not replaced to match the family of the next template.
> >>
> >> While there are theoretical use cases for optional templates in outbound
> >> policies, the only practical one is to skip IPComp states in inbound
> >> policies if uncompressed packets are received that are handled by an
> >> implicitly created IPIP state instead.
> >>
> >> Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> > 
> > Your patch seems to be corrupt:
> > 
> > warning: Patch sent with format=flowed; space at the end of lines might be lost.
> > Applying: af_key: Reject optional tunnel/BEET mode templates in outbound policies
> > error: corrupt patch at line 18
> 
> Sorry about that, I'll resend.
> 
> > Also, please add a 'Fixes' tag, so that it can be backported.
> 
> What should the target commit be?  I saw you used 1da177e4c3f4
> ("Linux-2.6.12-rc2") in your fix, but maybe the more recent 8444cf712c5f
> ("xfrm: Allow different selector family in temporary state") would fit
> better as that changed `family` to `encap_family` in
> `xfrm_state_find()`?  (I guess it doesn't matter in practice as 2.6.36
> is way older than any LTS kernel this will get backported to.)

I think it was broken, even before 8444cf712c5f "xfrm: Allow different
selector family in temporary state"), so I used 1da177e4c3f4.
But as you said, it doesn't really matter. Both commits are
much older than any currently active LTS kernel.

