Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9823D9012
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhG1OHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233439AbhG1OHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 10:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D77C660C3F;
        Wed, 28 Jul 2021 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627481256;
        bh=LFYS6sxKo4PXSjLsok+9iz45Dtwvy535c2NhhiC2Xns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lEGczgVx0B7ZJJb4fPb7mzKYbGQabtOleGviPcDuArvy1Ga2ORPEvjxIZSIanS1tl
         nOl3TnVAZKBxiS8x54uHzRUGYodTdTptKOMEl4qiWHQ0Y7SihkEL/7qhJ2ElCQr7dN
         voY36cffiVRpQBvdvltHLkAl4FWG5w8XIdaX/RZ1AVOhtrfXUwjGO2QdKI3w/TTi97
         7uR2fYcbhonBkAki/sAdgJ0qAZJEccqw3AvHaMNIT9nhzPTQKfUnu/NHeRnKymsS78
         Jacbpb3vtDNfJxFLD0GYE+FMG+ILJUcRIPSNFxiZbbf4PfA0Nr26WFM4vDYKEjhDDw
         53ATmgxqj2iHA==
Date:   Wed, 28 Jul 2021 10:07:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 07/19] ipv6: allocate enough headroom in
 ip6_finish_output2()
Message-ID: <YQFkpo140o/fy56p@sashalap>
References: <20210723035721.531372-1-sashal@kernel.org>
 <20210723035721.531372-7-sashal@kernel.org>
 <2b57c728-3ef2-aeba-2ff3-ff2555fb6ee3@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2b57c728-3ef2-aeba-2ff3-ff2555fb6ee3@virtuozzo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 09:03:33AM +0300, Vasily Averin wrote:
>this patch is incomplete, and requires following fixup
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d85a1b31dde84038ea07ad825c3d8d3e71f4344

I've grabbed it too, thanks!

-- 
Thanks,
Sasha
