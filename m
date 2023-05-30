Return-Path: <netdev+bounces-6450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BFB71656C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 288CF281216
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCB623C87;
	Tue, 30 May 2023 14:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6717AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77879C43446;
	Tue, 30 May 2023 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685458717;
	bh=cBQ4dqX01OLJXHFuDNypBedsmL6W577e01tqCkXAfqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IqAQ41l4mPu0KJDKfLySQILKWq/N3cMx9QbtI17A5/x15p0r+axju5xlNHwpYXM8B
	 MYU8LKYT6crjsVnXvId72z6qh0dj4qy8cTkwsnChRutOt/Y70SNsKn7WZD8DQYTez3
	 Rmy4GQd2nmAhn+CXwpZ9stMTUCUnfnIAdQeVl41L4j7fi1+oma9LpWk0e+RZgRTg1I
	 EtQjJYPDqALB4ixeL5II5DM5NXhcHe11qUbzY8sPertDH3AD4bjxs/7vSfWXhi7Olp
	 sPyVXSjvXgIvmj1BxdQk1PQ0/FfN9KWqaD1Pqp5l1PT023ZQMbyBCRDPHWIXsLpCEJ
	 PB1zXEcEOZa3g==
Message-ID: <cd20364d-8b7d-bbc6-a962-185632cc6782@kernel.org>
Date: Tue, 30 May 2023 08:58:36 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/4] nexthop: Factor out neighbor validity check
Content-Language: en-US
To: Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 Ido Schimmel <idosch@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
 <20230529201914.69828-3-bpoirier@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230529201914.69828-3-bpoirier@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/23 2:19 PM, Benjamin Poirier wrote:
> For legacy nexthops, there is fib_good_nh() to check the neighbor validity.
> In order to make the nexthop object code more similar to the legacy nexthop
> code, factor out the nexthop object neighbor validity check into its own
> function.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



