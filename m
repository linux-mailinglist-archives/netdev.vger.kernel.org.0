Return-Path: <netdev+bounces-7275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3DDB71F740
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D2431C2114D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE30AEDE;
	Fri,  2 Jun 2023 00:46:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC64DEA8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FA7C433D2;
	Fri,  2 Jun 2023 00:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685666771;
	bh=zR/sLkaKZ4SOUbNFRoS296eVn2Zg3FLbTR94vJXNZgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Erzi9NlnIJH7tqfXU12Q2WNaWlXNNOGk8TrBARAioPR0O/ZUmFEXKVE3i7/RmKHqB
	 ro3Z43l5qxjLGwmSEyd5Nae4mAhFK0dC4dYx4QtSChA6y9b8X2yKiLl8tKhdpwVisw
	 IMggx4DZM57GPltoGCS9xKzpLSuplIpBsg7bRUOIpi6tJSDbu7i1tJNzWej2Kjc3oR
	 9nWv3TAQNQSAsya9II1IqFpv8CAyV6RHKo3jZfpOtgW4izUo981qj8HWUZR1+MxH+Y
	 xPvyL/MbO0hJkOY3g0eRz6TP7MWY6M3KQpegaqwUEisRlYsKqneLyTsTRGJZ7wdun1
	 u8JsUwql7JDag==
Message-ID: <7d28139c-c348-c5cc-1e5f-b58b99772905@kernel.org>
Date: Thu, 1 Jun 2023 18:46:10 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/2] net/ipv6: fix bool/int mismatch for
 skip_notify_on_dev_down
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, Matthieu Baerts <matthieu.baerts@tessares.net>,
 eric.dumazet@gmail.com
References: <20230601160445.1480257-1-edumazet@google.com>
 <20230601160445.1480257-2-edumazet@google.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230601160445.1480257-2-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/23 10:04 AM, Eric Dumazet wrote:
> skip_notify_on_dev_down ctl table expects this field
> to be an int (4 bytes), not a bool (1 byte).
> 
> Because proc_dou8vec_minmax() was added in 5.13,
> this patch converts skip_notify_on_dev_down to an int.
> 
> Following patch then converts the field to u8 and use proc_dou8vec_minmax().
> 
> Fixes: 7c6bb7d2faaf ("net/ipv6: Add knob to skip DELROUTE message on device down")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/net/netns/ipv6.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>


