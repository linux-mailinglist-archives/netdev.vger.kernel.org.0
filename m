Return-Path: <netdev+bounces-3493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A057078E4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E8D328176E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF7A394;
	Thu, 18 May 2023 04:19:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51964137A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CF0C433D2;
	Thu, 18 May 2023 04:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684383595;
	bh=GeeqPPmpGf6jdAsXnyHhP0qzOCppSPPDHIviQQ+RUYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A98Fra/jyQMybi+nJKUXkCM2ckcK9Xm52ect40QmS/P1i3VpIFoYgl9bMnR3vHIoD
	 iI4pgRjRcVuoGO3AGzz1mx0Fb/30ikGf0DY2BAV90MD8IcpYT0HQJWTEkfCmcZ4rJT
	 X8gCHlYxiVf6k37PczzBBdqEbNkga48+e8gz3CJ0l6FJmXJ84f5VdcHugKqabP5S9U
	 GFUcGr7kgvREKQ5XjbQa0ShastY0EEzu0eTblw7YbAN/YIojCzLh707GvP5To3TEgG
	 XTCt9KuXsYmZf4G75Cp4jokf9vs6OZhB/M5xmH6C30VqCKoMNcQPSUaohNEmYRwtX3
	 4SzSAVmMvm9vg==
Date: Wed, 17 May 2023 21:19:53 -0700
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
Subject: Re: [PATCH net-next 07/11] net: page_pool: add DMA-sync-for-CPU
 inline helpers
Message-ID: <20230517211953.4b9073df@kernel.org>
In-Reply-To: <20230516161841.37138-8-aleksander.lobakin@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-8-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 18:18:37 +0200 Alexander Lobakin wrote:
> +/**
> + * page_pool_dma_sync_for_cpu - sync full Rx page for CPU
...
> +page_pool_dma_sync_full_for_cpu(const struct page_pool *pool,

kdoc name mismatch
-- 
pw-bot: cr

