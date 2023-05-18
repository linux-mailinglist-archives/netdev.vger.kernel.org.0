Return-Path: <netdev+bounces-3492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD957078E1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C76F2813B9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD79625;
	Thu, 18 May 2023 04:19:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAB4394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F76CC433D2;
	Thu, 18 May 2023 04:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684383555;
	bh=kWki9SBP3s3z9e8Ww/Dw19IuXFtpOy6XpwmIo0LWGkw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jXN2AmuBMiyJMvI5RI0B+cuSny06go0LAOC6U+JCDgICRH7ctjefRQ1B/F3WwoCvL
	 PuZ2uNKgsRKH55JTQ4b7Ws2nkGx3ZPCvar3CMN/OfmTbWRO1PizQfa3KNdneqiglJ4
	 /DGtc4esUf+EyeouPifs69w0zvijQBWcHSVbYk3JWbGfj1VjbWf8umlng2u9+w8H+0
	 nna42fyLwCwz9woW7mNkWoifn6dw9ZoOcNBLJrRq706/IddJocqdvOO3Uu+VysTS/e
	 YPKZ5gEj3mkka+HYpfs8c037MaCAVFnvbE9T/0lt+GkkcFjISVph4UZ3OGayAFLr6l
	 u/jH4EpApgefw==
Date: Wed, 17 May 2023 21:19:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/11] libie: add per-queue Page Pool stats
Message-ID: <20230517211913.773c1266@kernel.org>
In-Reply-To: <20230516161841.37138-11-aleksander.lobakin@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-11-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 18:18:40 +0200 Alexander Lobakin wrote:
> +static inline void libie_rq_stats_get_pp(u64 *sarr, struct page_pool *pool)
> +{
> +}

s/inline //

