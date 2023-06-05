Return-Path: <netdev+bounces-7919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C843272216A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09773280F80
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E55B134AC;
	Mon,  5 Jun 2023 08:51:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5394D125CD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:51:10 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD410C7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:51:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q65vT-00GsYK-Ey; Mon, 05 Jun 2023 16:50:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 Jun 2023 16:50:55 +0800
Date: Mon, 5 Jun 2023 16:50:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leon Romanovsky <leon@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-needed clear to zero of
 encap_oa
Message-ID: <ZH2h7xp7FFq/LOC4@gondor.apana.org.au>
References: <1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org>
 <ZH2dNy+PrhPuNsy9@gondor.apana.org.au>
 <20230605083456.GA22489@unreal>
 <ZH2ej5pcxwtVTW4N@gondor.apana.org.au>
 <20230605084829.GB22489@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605084829.GB22489@unreal>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:48:29AM +0300, Leon Romanovsky wrote:
>
> It is impossible to remove encap_oa because it is declared as UAPI.
> 
> Unless you want to support some out-of-tree code, uep->encap_oa will
> be always zero.

No we should keep it.  This has been a wart on our stack as it
basically breaks down when the peer shifts addresses.  We should
start using encap_oa in some way and fix this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

