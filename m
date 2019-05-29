Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423582E4E7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE2TBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfE2TBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 15:01:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A16240CC;
        Wed, 29 May 2019 19:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559156459;
        bh=kd7Y7FfCLAYSwzvsnRb5J2L+0bsyaRMCNKNkAsRUJOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R01z8qaVckH/VPyrYBi+bydS86gsJ5pJWooNtPVdL6mJ23v4IPASlA3DhrULU4IcS
         RdURDJw6yaBJRUFzTR8zSUb6ahm+e3gy7UVRn0oTAaIgHLANVlmu2We7uoGN9EnOBG
         essz7mjis1Oc1rsU86tM2ZEfXJ2aHUp2SUNbdn0k=
Date:   Wed, 29 May 2019 15:00:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.0 095/317] mlxsw: spectrum_router: Prevent ipv6
 gateway with v4 route via replace and append
Message-ID: <20190529190058.GK12898@sasha-vm>
References: <20190522192338.23715-1-sashal@kernel.org>
 <20190522192338.23715-95-sashal@kernel.org>
 <a953cd53-c396-f20d-73b4-9e06ada0e3ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a953cd53-c396-f20d-73b4-9e06ada0e3ad@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 01:27:41PM -0600, David Ahern wrote:
>On 5/22/19 1:19 PM, Sasha Levin wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> [ Upstream commit 7973d9e76727aa42f0824f5569e96248a572d50b ]
>>
>> mlxsw currently does not support v6 gateways with v4 routes. Commit
>> 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
>> prevents a route from being added, but nothing stops the replace or
>> append. Add a catch for them too.
>>     $ ip  ro add 172.16.2.0/24 via 10.99.1.2
>>     $ ip  ro replace 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
>>     Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.
>>     $ ip  ro append 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
>>     Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>
>Not needed for 5.0. IPv6 nexthops with an IPv4 gateway is a 5.2 feature.

Dropped, thanks!

--
Thanks,
Sasha
