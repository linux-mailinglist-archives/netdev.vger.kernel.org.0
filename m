Return-Path: <netdev+bounces-3488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D457078AC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29FC31C2102E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E28A39B;
	Thu, 18 May 2023 03:57:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A3C394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69EFC433EF;
	Thu, 18 May 2023 03:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684382226;
	bh=fEg8/325U2005AbgntETyCrW+YJgMPJvvQBV+djJOsk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WuLA5zR+gwH3h1l14V32L/SOKzakDf4NoUcuzjG5vx+GO/BBqkKQbPfhYfWnP2n1N
	 sNvylGOc2mdDeC0BQy5YxSD+ZB9oXJ2J7TLhSKjjqCIADa3CQgqYXeiqg4qx4gkcNa
	 K7sEA9IhGW8vEKdiEtrbsTmthjDAgRNqvvJLBgvuv5H9nWRYCk6YgddDsnzWWsSX3l
	 93s0BwuAjYGBsSSWfNZ1HvgimfsNhpV6Iccj22rUSRbJVP2PU4B1q38+9V4XXjPyoT
	 ukCOeH0AHZ6A6KE8l9eIOa+Ma3cxblMo9EM2YARiFPrWdWl40RQNtEIGmc9RYbkIdb
	 rA9aqBpXmlu8A==
Message-ID: <72b07d00-53f1-9da3-1663-24282f192d75@kernel.org>
Date: Wed, 17 May 2023 21:57:05 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: linux-next: Tree for May 15 (net/ipv4/ipconfig.c:)
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Martin Wetterwald <martin@wetterwald.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>
References: <20230515141235.0777c631@canb.auug.org.au>
 <81d74a8e-6bfb-5ed6-9851-faf120a6e9f8@infradead.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <81d74a8e-6bfb-5ed6-9851-faf120a6e9f8@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/23 8:23 PM, Randy Dunlap wrote:
> 
> 
> On 5/14/23 21:12, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20230512:
> 
> ../net/ipv4/ipconfig.c:177:12: warning: 'ic_nameservers_fallback' defined but not used [-Wunused-variable]
>   177 | static int ic_nameservers_fallback __initdata;
>       |            ^~~~~~~~~~~~~~~~~~~~~~~
> 

Martin: please send a followup. Most likely it needs to be moved under a
config option.

