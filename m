Return-Path: <netdev+bounces-11286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF1D7326A6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D08BF2813F8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E25EA4;
	Fri, 16 Jun 2023 05:32:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D77C;
	Fri, 16 Jun 2023 05:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12ABC433C0;
	Fri, 16 Jun 2023 05:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686893572;
	bh=PN9t/weLXln32dqy7od/x1Y0vJmTaKsfTCBrLRWA/H0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l6AIqZzFlU5AN5tLzvZVEw2j9k4lw+c4XBvLiEcYyuN2yYs3+4/vH9Ru+2Ih76xju
	 h0x4rXJd1cj7sEdQelHWEyy6Uuy+YKcXolmyHX4itfNsDVmvGJA6GvOAYzft0G1FLp
	 5nsvBN0YudZPX6SXhranyAi2DZPUpbXjV+T4rTMktHuQFXQ+N3zisOfPqkkHdUL3cL
	 ecg4zavHd8LAuCjyuKRiRFU1Udw81lcA0cp6sDjG+uXUSPDVDpzmYajSYZispXmo+X
	 sImdrMBo1qkUjX9l3/ubLZRNFDddBRNtgwrNn5LPcguj40ntVvQer7D7V5XrV8NXMH
	 RsNPmJ6upBQGA==
Date: Thu, 15 Jun 2023 22:32:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] xdp_rxq_info_reg fixes for mlx5e
Message-ID: <20230615223250.422eb67a@kernel.org>
In-Reply-To: <20230614090006.594909-1-maxtram95@gmail.com>
References: <20230614090006.594909-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 12:00:04 +0300 Maxim Mikityanskiy wrote:
> Marked for net-next, as I'm not sure what the consensus was, but they
> can be applied cleanly to net as well.

Sorry for lack of clarity, you should drop the fixes tags.
If not implementing something was a bug most of the patches we merge
would have a fixes tag. That devalues the Fixes tag completely.
You can still ask Greg/Sasha to backport it later if you want.

