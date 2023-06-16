Return-Path: <netdev+bounces-11557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7D17339C2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4795D281763
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818101E50B;
	Fri, 16 Jun 2023 19:23:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423491B914;
	Fri, 16 Jun 2023 19:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7179EC433C9;
	Fri, 16 Jun 2023 19:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686943405;
	bh=cnIqbuBX2ydMik110zH5Tr4xSps2iWYs5dGlM7iEC3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dfcPsEtoNltFBIdLiIzd92IOTx9MkDLZr2M/KPNy9MDUeUHxxSBzG+ACApIAyLoH+
	 n1PQEF/qlmFULl2i9Sil96YoHUEMePOHPWYeFTICx+Kw43nDOqliMMQcERtoskgHlz
	 mgEMfs6phCtbYWGyKWFhTfnIRFwNnBihLbr+d7kSCOu+trVsZMwxdeveL9NDnN/11z
	 MhEG5vDSNQmOWBjN8ocvT9ZhqCS2E/+HeJj7OAm/81f98aL3cWUrTTzRRNjhncvFvM
	 8pvjx2dRLpfcufBgvcOsUw9mlOcQnRgRXz32Ysr4xWL4NSw4cD3oxcmQuePuZsGdf4
	 yglAMf9sVzBug==
Date: Fri, 16 Jun 2023 12:23:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org, Saeed
 Mahameed <saeedm@nvidia.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Gal
 Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] xdp_rxq_info_reg fixes for mlx5e
Message-ID: <20230616122324.3ddff8c3@kernel.org>
In-Reply-To: <ZIyv3b+Cn2m+/Oi9@x130>
References: <20230614090006.594909-1-maxtram95@gmail.com>
	<20230615223250.422eb67a@kernel.org>
	<ZIyv3b+Cn2m+/Oi9@x130>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 11:54:21 -0700 Saeed Mahameed wrote:
> On 15 Jun 22:32, Jakub Kicinski wrote:
> >On Wed, 14 Jun 2023 12:00:04 +0300 Maxim Mikityanskiy wrote:  
> >> Marked for net-next, as I'm not sure what the consensus was, but they
> >> can be applied cleanly to net as well.  
> >
> >Sorry for lack of clarity, you should drop the fixes tags.
> >If not implementing something was a bug most of the patches we merge
> >would have a fixes tag. That devalues the Fixes tag completely.
> >You can still ask Greg/Sasha to backport it later if you want.
> 
> You don't think this should go to net ? 
> 
> The first 3 version were targeting net branch .. I don't know why Maxim
> decided to switch v4 to net-next, Maybe I missed an email ? 
> 
> IMHO, I think these are net worthy since they are fixing 
> issues with blabla, for commits claiming to add support for blabla.
> 
> I already applied those earlier to my net queue and was working on
> submission today, let me know if you are ok for me to send those two
> patches in my today's net PR.

If you already have them queued up for net, that's fine.

