Return-Path: <netdev+bounces-6472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C562716648
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D0F31C20B4E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BD323D5E;
	Tue, 30 May 2023 15:10:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F9A17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74832C433D2;
	Tue, 30 May 2023 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685459451;
	bh=ZIClHKzhAJgMOmlMYYXoKf29s5q4go+EIM79BhbdN18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B4uwLPQLBceMh9XSxi9MMSDJK/Q7r6DX+mlV8Bd/NX5TRicIjR5eBUoaay3ceAIJl
	 0iXulsWzeS2Ga8+S1q8n8sYZ7akpizs5j8hHPvajnrR/kfHUjZhEbau2YKUWsQGclw
	 bpCoFhrsU2fjipYFCVQDfj7QFMaEoRZj/helCXwvMPusnHlPQlSbP3bEVw0MgojYon
	 jp1yPpqlEHCmSIL8cEj1vxRtxbfkyhKsOvSqOexs7e0Qa4Rrb1wRLhd28SAfK7Irca
	 ppzZ7aTczan6zylc52bKVAl+vqKEeKenj2JAnOQVmigKW/xOfA/NUeC5GUkq9YEJe5
	 R+q9yZyGMLJmA==
Message-ID: <797fd63a-38d5-c69e-3540-4eb6383f7abf@kernel.org>
Date: Tue, 30 May 2023 09:10:50 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 4/4] selftests: net: Add test cases for nexthop
 groups with invalid neighbors
Content-Language: en-US
To: Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 Ido Schimmel <idosch@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
 <20230529201914.69828-5-bpoirier@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230529201914.69828-5-bpoirier@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/23 2:19 PM, Benjamin Poirier wrote:
> Add test cases for hash threshold (multipath) nexthop groups with invalid
> neighbors. Check that a nexthop with invalid neighbor is not selected when
> there is another nexthop with a valid neighbor. Check that there is no
> crash when there is no nexthop with a valid neighbor.
> 
> The first test fails before the previous commit in this series.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 129 ++++++++++++++++++++
>  1 file changed, 129 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>




