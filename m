Return-Path: <netdev+bounces-6936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E5D718DFF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67B6C1C20F8C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5666840763;
	Wed, 31 May 2023 22:04:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E20919E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AF6C4339B;
	Wed, 31 May 2023 22:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685570652;
	bh=SO57Xmd1x9TbpSODSt8GMhS5MbXpLDr4RlIx0s069Ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a80Ba1WbFvfMvW663xFfTRQK6cb5Kney1tdY9hzq1i0OKbd0yDsTTX0TfKBvClZrL
	 gSZYhtgqY/QPgViq4BYYwfW359VX0eZJphAOQ0EDbvvlpTDP/kzjHf/a/NexryKMRH
	 azUBA5GfKKPkr4w57sg/C7S37iWgzzphQyhgQ9a6UduB1UEFfMWuVOrSE137F2WDri
	 ykid6FYxOqOGzll7tjAsYeTXhrGOm3PxklA/2rxGBvpnvXTtD5Fk5c6Pb8F+rKSHKA
	 OdqzGgI0lu4IXkscLVMrP9qyFjF4THPIwsgSlfTnBGjyG39gxT8B0D0xBviEagWykj
	 ImgGxPjALwQVw==
Date: Wed, 31 May 2023 15:04:10 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Rahul Rameshbabu <rrameshbabu@nvidia.com>, saeedm@nvidia.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: simplify condition after napi budget
 handling change
Message-ID: <ZHfEWnhQfrEKOgOe@x130>
References: <20230531020051.52655-1-kuba@kernel.org>
 <87sfbd9p4z.fsf@nvidia.com>
 <20230530221943.63300b4c@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230530221943.63300b4c@kernel.org>

On 30 May 22:19, Jakub Kicinski wrote:
>reminder: please avoid top posting on the list
>
>On Tue, 30 May 2023 20:05:32 -0700 Rahul Rameshbabu wrote:
>> You might want to clean up
>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c as well in the
>> mlx5e_ptp_napi_poll function as well.
>>
>>   static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
>
>This is a separate NAPI instance, I don't think I should be touching
>this. I can remove a check from TLS, tho, it seems:
>

I will apply this to net-next-mlx5 as is, Rahul and Tariq can follow up on
PTP and TLS if necessary 


