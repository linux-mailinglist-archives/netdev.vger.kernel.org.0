Return-Path: <netdev+bounces-7944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD607222DD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A54E281213
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97C4156CB;
	Mon,  5 Jun 2023 10:05:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF675684
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3BDC4339C;
	Mon,  5 Jun 2023 10:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685959528;
	bh=jEtgtS7vHG/jGpRb7VioeqiejQfUDBAosf4JNsdPgg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZUO/hjxBJKeaytcuU91V137SaHvJM0pZ7J6DJT27wFSo0UtG6Fi2GzQMZMbgNhX2
	 40KhHZ2UsbtxZ5ozbOBNIQdXWqbBsKqpT5s1hEtoNB1fTIN5C15AfF0Na71+Z9Klit
	 ao2RQKht43wk/iB1XwL28Tmc/9n8Kl43G1oIQCvNmkrHRBrvFhxu4yowmItAaogtaT
	 1NOVIvDD9BdHAUAhHfMfiaor9XhhI20QrHGtqGaLqB3ptqJVTkam3/+3ALvpGIh+z+
	 CF3y+W5GFhI7+WHmSe/5uNRIu7HtKpfa4X9ouGHFg8cfOviBjb4lqXupABFcc4ZoeS
	 kdE+oohrWW/8g==
Date: Mon, 5 Jun 2023 13:05:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-needed clear to zero of
 encap_oa
Message-ID: <20230605100524.GC22489@unreal>
References: <1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org>
 <ZH2dNy+PrhPuNsy9@gondor.apana.org.au>
 <20230605083456.GA22489@unreal>
 <ZH2ej5pcxwtVTW4N@gondor.apana.org.au>
 <20230605084829.GB22489@unreal>
 <ZH2h7xp7FFq/LOC4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH2h7xp7FFq/LOC4@gondor.apana.org.au>

On Mon, Jun 05, 2023 at 04:50:55PM +0800, Herbert Xu wrote:
> On Mon, Jun 05, 2023 at 11:48:29AM +0300, Leon Romanovsky wrote:
> >
> > It is impossible to remove encap_oa because it is declared as UAPI.
> > 
> > Unless you want to support some out-of-tree code, uep->encap_oa will
> > be always zero.
> 
> No we should keep it.  This has been a wart on our stack as it
> basically breaks down when the peer shifts addresses.  We should
> start using encap_oa in some way and fix this.

ok, I'll drop the disputed line from commit and resubmit.

Thanks

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

