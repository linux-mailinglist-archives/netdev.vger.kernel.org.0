Return-Path: <netdev+bounces-137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D766F55BF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEBF280DFC
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288B7D2FB;
	Wed,  3 May 2023 10:15:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A10ED2F7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:15:54 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4402FCE;
	Wed,  3 May 2023 03:15:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pu9WM-004h6c-HL; Wed, 03 May 2023 18:15:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 May 2023 18:15:39 +0800
Date: Wed, 3 May 2023 18:15:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cai Huoqing <cai.huoqing@linux.dev>
Cc: Thomas Graf <tgraf@suug.ch>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable-test: Make use of rhashtable_walk_peek
Message-ID: <ZFI0S6T101+JPcYT@gondor.apana.org.au>
References: <20230425135617.77907-1-cai.huoqing@linux.dev>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425135617.77907-1-cai.huoqing@linux.dev>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 25, 2023 at 09:56:17PM +0800, Cai Huoqing wrote:
> Add an example usage of rhashtable_walk_peek to test_bucket_stats.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
>  lib/test_rhashtable.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

This is supposed to be testing rhashtable code, it's not meant
to be an example of how to use the API.

> @@ -192,6 +193,13 @@ static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
>  			break;
>  		}
>  
> +		/* Here's an example usage of rhashtable_walk_peek */
> +		obj = rhashtable_walk_peek(&hti);
> +		if (!obj) {
> +			pr_warn("Test failed: rhashtable_walk_peek() error\n");
> +			break;
> +		}
> +

What is this meant to test?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

