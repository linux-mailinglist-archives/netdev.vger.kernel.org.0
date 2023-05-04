Return-Path: <netdev+bounces-268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F876F696F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0F651C210FA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021C0FBF4;
	Thu,  4 May 2023 11:03:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C2810EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A4BC433EF;
	Thu,  4 May 2023 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683198189;
	bh=FLtRpPUIYy+J9Zu770JjECMBsX3Dt02/FyopoTXBvIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ih836aWXfnTMepbV601cDnhFpRNg04rdAiZMTyjxx6uX+++kvNEOCQ5ltZADJlW3C
	 gNQPhbmMWHAgwg7HRWPnis1taFaAM6LeGTkSTDV1O+8o9DwKxQsSAxrcwkwZPw9vjG
	 PKVWjNacuB+w2Owe9uaLmgBzzX7xtDcQm4GjyiM2zxbJG4va7OABt99CiDcEx0wG/f
	 ACoFObw5ziWMKaET4K9NJ/idSSafWCeAn3gP48OQWGjUxI47jVscjrfSWcz+brUtJU
	 sdf2t/oa69QDiHf8IuS1Xj2FHZQ76wiHRxBJRWb0vMMREzckjh3pSNjOqBbrz7Mk1f
	 NnTsYyvI1LPNQ==
Date: Thu, 4 May 2023 14:03:04 +0300
From: Leon Romanovsky <leon@kernel.org>
To: wuych <yunchuan@nfschina.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, irusskikh@marvell.com, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] atlantic: Remove unnecessary (void*) conversions
Message-ID: <20230504110304.GX525452@unreal>
References: <20230504100253.74932-1-yunchuan@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504100253.74932-1-yunchuan@nfschina.com>

On Thu, May 04, 2023 at 06:02:53PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

There is same thing in drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c too.

Thanks

