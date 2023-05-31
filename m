Return-Path: <netdev+bounces-6937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFA7718E0D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A038281618
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1125F40766;
	Wed, 31 May 2023 22:07:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EC119E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954DEC433EF;
	Wed, 31 May 2023 22:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685570852;
	bh=7EjhTSxh5SY7b9ApyiBAysKr7233N2ER+oIwSKBbgSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iR/61cTw30Cwu+x71pfuEibL3AEEXR6oFsNAPnDrkiINUX8ZTeswXV5a+GDRRbO76
	 84ofQouyFlKQ+ZVfpvDUpMjq9RWosAkaZtbm6o0sPjGzJjPbBXEQQTaRrw9L63CrmY
	 Xbo3hicgWRpKzJMMC3qyTTTzXLbzYdF6pxqVya+2nOYPidTqS5P2DQ0rxC3h/12AAC
	 Yu++UCsY9MLNShSQw6HXXKyqVFG30qiXIpO5YwUUTNP5X+BY2ifxwJBDafsEtR7wkf
	 Qme3wtRNHZzT/lEGhR/rDHXIHac++DNhggG+cqRpZ7WQ309WUFjniIiNF1jfNHzw+t
	 pcnKsu5YqXI/w==
Date: Wed, 31 May 2023 15:07:31 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Remove a useless function call
Message-ID: <ZHfFI8Gby5HKgIkr@x130>
References: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>

On 29 May 10:34, Christophe JAILLET wrote:
>'handle' is known to be NULL here. There is no need to kfree() it.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>


Applied to net-next-mlx5.

Thanks

