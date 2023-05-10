Return-Path: <netdev+bounces-1560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F22256FE4AD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6927A281455
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6F21800E;
	Wed, 10 May 2023 19:57:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287916413
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A0AC433EF;
	Wed, 10 May 2023 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683748620;
	bh=DCbaf6xVpFEDtn0H7lDuPNgtj7JSCv0rwyzi3AwTjg4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LzQpL+4LP9d3GVhwXGOeQaNXtUMYBB8t+NORX9vmt1hf193JvWXJRgjvPg5+V7crn
	 Ab3x3CQk19I5VvbTxQY5TMR9AlLLiD2qtD1pgQJTBYuO+Du7qj/zbp9t2O4yVCMlqH
	 F2B4mFpllWNaOviTJiUWY0ifTir5vQwWNkH92RP0g78GAjnAkElHqr4IsjyxBwKhZw
	 y3VubZG0brs+vC+QTjXOYXFgHlqNB5jn9E9+yWTcAyafp6/1Lquljsei+DxARO8uEU
	 zRWn1u15DFmFru4fnJKPV1bwGt/mMOz2SEr/SX+nSIPjdnhziPeTif2E0s4PXu7k9j
	 x56C6kstXMtsA==
Message-ID: <ed579a55-c300-b89e-4741-efdc1f3b5ba5@kernel.org>
Date: Wed, 10 May 2023 13:56:59 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [net 2/2] selftets: seg6: disable rp_filter by default in
 srv6_end_dt4_l3vpn_test
Content-Language: en-US
To: Andrea Mayer <andrea.mayer@uniroma2.it>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Stefano Salsano <stefano.salsano@uniroma2.it>,
 Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
 Ahmed Abdelsalam <ahabdels.dev@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>
References: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
 <20230510111638.12408-3-andrea.mayer@uniroma2.it>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230510111638.12408-3-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/23 5:16 AM, Andrea Mayer wrote:
> On some distributions, the rp_filter is automatically set (=1) by
> default on a netdev basis (also on VRFs).
> In an SRv6 End.DT4 behavior, decapsulated IPv4 packets are routed using
> the table associated with the VRF bound to that tunnel. During lookup
> operations, the rp_filter can lead to packet loss when activated on the
> VRF.
> Therefore, we chose to make this selftest more robust by explicitly
> disabling the rp_filter during tests (as it is automatically set by some
> Linux distributions).
> 
> Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Tested-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../testing/selftests/net/srv6_end_dt4_l3vpn_test.sh  | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



