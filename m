Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF3B3BE688
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGGKsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 06:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhGGKsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 06:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9183660FF0;
        Wed,  7 Jul 2021 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625654761;
        bh=kyqxNHmJSAIYbqjxYrXBO+RKuS7kk7ir1rJEqcLJe84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OzCkD0gL2N+7P1Lgag8ztsnjIS0GqiONGXd7PdI1+iXXY+FfcuggeMA1AiAy3if/+
         AJHG8OQMX59cc09KddPEjOSz0I/qGydAHivvWzGg1rJheBvOw9ZDdaisKJAXuIZn03
         m9zlbUjYAMNDefPLVV356Ee00/gzXs7wGIzScMHio7NCaDesYVqBBCKn71LVlPUyKJ
         iD1kFgnNn/ClukA1jpEUVcC64RNcEO4Dzsj9ZfCW8qkKNBTGh2EvVCr08RnKDxkUtC
         /HYZvtPkBAY91zyfS7hqCCjL6X0vW11iJVDStoHikgdJMyAIFwNdKLV8cYvXBByhrX
         hDKeTaoJ8SLqg==
Date:   Wed, 7 Jul 2021 06:46:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 159/189] net: dsa: b53: Create default VLAN
 entry explicitly
Message-ID: <YOWF6I/eBeH6IkOS@sashalap>
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-159-sashal@kernel.org>
 <57a4d4ba-be97-3e25-0d7b-e698cb7511cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <57a4d4ba-be97-3e25-0d7b-e698cb7511cf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 08:07:34AM -0700, Florian Fainelli wrote:
>
>
>On 7/6/2021 4:13 AM, Sasha Levin wrote:
>>From: Florian Fainelli <f.fainelli@gmail.com>
>>
>>[ Upstream commit 64a81b24487f0d2fba0f033029eec2abc7d82cee ]
>>
>>In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
>>b53 driver to ensure that the default PVID VLAN entry will be configured
>>with the appropriate untagged attribute towards the CPU port. We were
>>implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
>>instead make it explicit.
>>
>>Reported-by: Vladimir Oltean <olteanv@gmail.com>
>>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please discard back porting this patch from 5.13, 5.12 and 5.10 it is 
>part of a larger series and does not fix known uses until 5.14.

Will do, thanks!

-- 
Thanks,
Sasha
