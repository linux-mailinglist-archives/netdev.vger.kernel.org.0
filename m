Return-Path: <netdev+bounces-4428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 654D870CC11
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0579328107B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD0F174D9;
	Mon, 22 May 2023 21:15:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0908F7A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 21:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F0BC4339C;
	Mon, 22 May 2023 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684790146;
	bh=GP16ANKN/6WX+M2ns/0UpM6U4qez1PZwKZGT089Rnto=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B6PHa8cbtBWNKhD028Ta/0adeLYfPsaefoaQBDAJOdkvgUi61D4eewX+24f+JJjmV
	 zz4uM/POJN5nrK/9Dw2nQmo6oMOi9vB6YUXEMwKKQrsSk5ly8rtNb+5Qf5n0hETJuW
	 1NeRr8Xiydb4oHHVwjZZqNM61qXZoPMK6jrhj9fSMxzMDKpE8tAKNR7zAOy8eG8eIR
	 7YgU8eUAwYLsnWLutgYURYUzGmdJydG3hm0r60TkJL31YxOd+I0/g5EkLZ7K0lUolk
	 ebHA1Zu81huHVzhI2nOhzZjSCnbzNtkWsh5bx2fOEevLC1vdX/rnU4u4wlPo3OOULq
	 ZqKnoeXbZHYzQ==
Date: Mon, 22 May 2023 14:15:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shay Drory <shayd@nvidia.com>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Introduce SF direction
Message-ID: <20230522141545.408f61b0@kernel.org>
In-Reply-To: <89831a73-89c5-c5b6-d345-72908d8db304@nvidia.com>
References: <20230519183044.19065-1-saeed@kernel.org>
	<20230519214101.2452af83@kernel.org>
	<89831a73-89c5-c5b6-d345-72908d8db304@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 15:47:15 +0300 Shay Drory wrote:
> > What does it mean that an SF is "facing" the network?  
> 
> Facing the physical wire, like an UPLINK vport.
> 
> > Why can't the device automatically "optimize" the hairpin?  
> 
> Our FW/HW can do steering optimization if we know the direction in advance.
> 
> > Or SF1 / SF2 will be uni-directional after this patch?  
> 
> No. every SF will continue to be bi-directional. the change will only 
> affect steering optimization.

I'm not going to claw the details out of you. AFAICT this sounds like
a lazy knob forcing the user to configure something that could be done
automatically. Consider it rejected.

