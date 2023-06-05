Return-Path: <netdev+bounces-7917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F71F72215D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FA741C20BB1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23465AD22;
	Mon,  5 Jun 2023 08:48:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D03D84
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A3DC4339B;
	Mon,  5 Jun 2023 08:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685954913;
	bh=r7DZ8gVQGOOHQS36hOyXNHcgFOD1Ygtq9SHGWVHQGLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ch1tY9BXrV90YZ55bt/OC05fFxYK3sk8hK2Ju/+ic0JxDoIRWKkDgD1n7l2KDfDAE
	 IhfzgtuGpx3oHjLZxVZ6ac2TbjBNiib3tRGR3mGnlTpZGAA/ff1vpEvWcPs8HweE9C
	 TNbo265gT/ZtVcYq2MbUsUDRbhJfgbUO0oA6BWTey6X6qbc5/9y2vOe5kaqSGbmzSe
	 Qd9E2O4He7dHip7g1aXJId6+ZwZd5ytzfsHdfF2oCNfrMPVsnq7LYcVgvsRUWL9kV/
	 oe5I57mtd/llyHp3kNP4pypTZBwg1cYreiZa2Q4/UbQXpRdDv6ckDOHV7POBr/HXas
	 p5yAiB+QMk95Q==
Date: Mon, 5 Jun 2023 11:48:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-needed clear to zero of
 encap_oa
Message-ID: <20230605084829.GB22489@unreal>
References: <1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org>
 <ZH2dNy+PrhPuNsy9@gondor.apana.org.au>
 <20230605083456.GA22489@unreal>
 <ZH2ej5pcxwtVTW4N@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH2ej5pcxwtVTW4N@gondor.apana.org.au>

On Mon, Jun 05, 2023 at 04:36:31PM +0800, Herbert Xu wrote:
> On Mon, Jun 05, 2023 at 11:34:56AM +0300, Leon Romanovsky wrote:
> >
> > The line "memset(&natt->encap_oa, 0, sizeof(natt->encap_oa));" deleted
> > in this patch was the last reference to encap_oa.
> 
> I don't see the point since you're not removing the actual encap_oa
> field.

It is impossible to remove encap_oa because it is declared as UAPI.

Unless you want to support some out-of-tree code, uep->encap_oa will
be always zero.

Thanks

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

