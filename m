Return-Path: <netdev+bounces-5853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD4B71327A
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 06:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 631A51C210E7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D41649;
	Sat, 27 May 2023 04:10:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1D646
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 04:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D645C4339B;
	Sat, 27 May 2023 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685160610;
	bh=KveAd6HICYaZUtjWDnk24as6KYOu/KVRuVwidcG7+aE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OuhS0OH0YKukKtVjz0sd3kF6KBr7allISNyDmJsxIT34KasqKKOZk6EikkJ75ZkAQ
	 R5N9YSVNwxsMv2maNxIoXLOK7Nf8LtlTfcNTj+WA585YbOs5VnNS8mOTCzAT1cgs26
	 j0gGmCGyQaCRyVH97ZjsNUjAVZN+5cBHz8H9+vUehorJ3NW1x1CW75qzHM6KOs9j+k
	 k7sARmFi4R6+vUzEM1WYNLLfpifwznqmKDiOZYGef/KVgcSuhm5giHrsdyefTQ2czJ
	 LcXuNTge4GcH9nr9mYvK0JSttLb+UxVj2Q/4c/g1EWKn2VTS2r2oLQU3sgyYxTrThQ
	 NbnbuXl6WmSOQ==
Date: Fri, 26 May 2023 21:10:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <20230526211008.7b06ac3e@kernel.org>
In-Reply-To: <20230526102841.2226553-15-jiri@resnulli.us>
References: <20230526102841.2226553-1-jiri@resnulli.us>
	<20230526102841.2226553-15-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 12:28:40 +0200 Jiri Pirko wrote:
> Move port_del() from devlink_ops into newly introduced devlink_port_ops.

I didn't think this thru last time, I thought port_new will move 
in another patch, but that's impossible (obviously?).

Isn't it kinda weird that the new callback is in one place and del
callback is in another? Asymmetric ?

