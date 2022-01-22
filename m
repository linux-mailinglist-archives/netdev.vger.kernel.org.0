Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AC496D8D
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiAVTNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAVTNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:13:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44EEC06173B;
        Sat, 22 Jan 2022 11:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E82260EA2;
        Sat, 22 Jan 2022 19:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4786AC004E1;
        Sat, 22 Jan 2022 19:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642878790;
        bh=roaOsHS3yEMHQgGC9vjjj/ZC8YlTg8c938hfa781kek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ghPly8QV9loDn9gLfS9QMPb0OvysBP3JOguSP1rmR4uRwbPU1BTeLP7zJBHHyAY5d
         wWxR2Gv22trSFpIag7qWG1SKGlC2EkT9ZjjtQHVWWcLKrkaxuO373cYury/adatkwO
         kC1wtqy+wZzt+1RmNbpM+/C0JgR8PLMFoU2hSrrqCaIbeo/Dmn6IjG4UyRP+/XCRCg
         3mCUVITCEF01N5sZAfGM6Gzzw1p8MHjgCzLWuVH/UM4V7MbN4cC1hRp//fWVeEa5HJ
         57VEBNaH2Xq09JxZaT+LGnVfCzl7DG2dEuh+jFQqnVJkXtS06HSpqzPTu+u+1vYkEG
         l3fvY1ZQDrE+g==
Date:   Sat, 22 Jan 2022 14:13:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xu xin <xu.xin16@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Joanne Koong <joannekoong@fb.com>,
        "David S . Miller" <davem@davemloft.net>, daniel@iogearbox.net,
        dsahern@kernel.org, roopa@nvidia.com, edumazet@google.com,
        chinagar@codeaurora.org, yajun.deng@linux.dev,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 118/217] net: Enable neighbor sysctls that
 is save for userns root
Message-ID: <YexXRLHClOPI/RkJ@sashalap>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-118-sashal@kernel.org>
 <20220118085940.6d7b4a88@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <04a436b8-3120-4671-a1e4-cf690ce8ec60@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <04a436b8-3120-4671-a1e4-cf690ce8ec60@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 08:46:47PM -0700, David Ahern wrote:
>On 1/18/22 9:59 AM, Jakub Kicinski wrote:
>>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>> Acked-by: Joanne Koong <joannekoong@fb.com>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Not a fix, IDK how the "Zeal Robot" "reported" that a sysctl is not
>> exposed under uesr ns, that's probably what throws off matchers :/
>> Anyway - it's a feature.
>
>A lot of these Reported-by from robots should be "Suggested-by".

Possibly... I'll drop this one, thanks!

-- 
Thanks,
Sasha
