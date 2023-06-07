Return-Path: <netdev+bounces-8758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0DE7258F2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F3A1C20CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9A58F43;
	Wed,  7 Jun 2023 08:58:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57AF6AB9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:58:36 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAE91990
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:58:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id E99FA2083E;
	Wed,  7 Jun 2023 10:57:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UJ9Gqfqmjvrx; Wed,  7 Jun 2023 10:57:39 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 7181A207B0;
	Wed,  7 Jun 2023 10:57:39 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout1.secunet.com (Postfix) with ESMTP id 62F3480004A;
	Wed,  7 Jun 2023 10:57:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 10:57:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 10:57:38 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 9C95231844F3; Wed,  7 Jun 2023 10:57:38 +0200 (CEST)
Date: Wed, 7 Jun 2023 10:57:38 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, David George <David.George@sophos.com>, "Markus
 Trapp" <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIBGgjWwILqQziGe@gauss3.secunet.de>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
 <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
 <ZIBEMe8SXYMIuOqK@gauss3.secunet.de>
 <ZIBE62PYoLGzHgz7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIBE62PYoLGzHgz7@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:50:51PM +0800, Herbert Xu wrote:
> On Wed, Jun 07, 2023 at 10:47:45AM +0200, Steffen Klassert wrote:
> >
> > Hm, I thought about that one too. But x->sel.family can
> > also be AF_UNSPEC, in which case we used the address
> > family of the inner mode before your change.
> 
> It must not be AF_UNSPECT for BEET.  How would you even get the
> inner addresses if it were UNSPEC?
> 
> With BEET the inner addresses are stored in the IPsec SA rather
> than the actual packet.  So the family is also fixed for a given
> SA (which we call xfrm_state).

Right, Good point.

Thanks!

