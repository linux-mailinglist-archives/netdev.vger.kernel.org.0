Return-Path: <netdev+bounces-10791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DADA2730529
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C65A91C20D4A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABDF2EC0D;
	Wed, 14 Jun 2023 16:39:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269BD2EC04
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E154C433C0;
	Wed, 14 Jun 2023 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686760793;
	bh=TmHv5J6Rcfl/qR+WSHVFK/Ssk8PlAZw98J2D3lDQjjE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m/oqX4D3AIyjyV6bOwVp8ZAD1JcoIT2/vYBeXbg32YlAugbhGJ+6KujbVugGe3jLQ
	 stIP/DHKWZgkjIYS4tqjZjhQxxm5pvW5pvLuXerWYwu2ugrD8WKk4YPhSN0rhBGzXi
	 eodpKX3Ws43pCjGIWrfVYEfG5WQy3ySQnCSHrA5l/lPJjCLlaH/xpXZvGOaCaXVOH4
	 WIGIrV3HBSfbZu2MPaNPh3IJ0oaM2xYMyjXh17C1omQTo4TXj+TbS/SGUlt/T1+l4o
	 +E/ixWFub2Rh2HQ2vZWayt6i1MD75kFqxQmXyUchsRcCKmbEobc89BYwUqcs4mGeSh
	 e5W6pCZjXPjwg==
Date: Wed, 14 Jun 2023 09:39:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "Keller, Jacob E"
 <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>, Stephen
 Hemminger <stephen@networkplumber.org>, "David S. Miller"
 <davem@davemloft.net>, Michal Kubecek <mkubecek@suse.cz>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Edwin Peer
 <espeer@gmail.com>
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
Message-ID: <20230614093952.6e1eadc8@kernel.org>
In-Reply-To: <15de5df0-9a29-d592-0ac8-e2c470b17c83@gmail.com>
References: <20230611105108.122586-1-gal@nvidia.com>
	<20230611080655.35702d7a@hermes.local>
	<9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
	<CO1PR11MB50899E098BB3FFE0DE322222D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
	<a9d5cf824500c3a4d86f26bd18ec29b6dfd2daf8.camel@redhat.com>
	<15de5df0-9a29-d592-0ac8-e2c470b17c83@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 08:17:44 -0700 David Ahern wrote:
> > As it looks like the is substantial agreement on this approach being a
> > step in the right direction and I can't think of anything better, I
> > suggest to merge this as is, unless someone voices concerns very soon,
> > very loudly.
> 
> My only concern is that this "hot potato" stays in the air longer. This
> problem has been around for years, and someone needs to step up and
> propose an API.

The functionality is fully covered by devlink and tc. We're not
accepting any new drivers/implementations of the old SR-IOV NDOs
at all.

We try to put this potato in the grave and it keeps trying to grow :(

