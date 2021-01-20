Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E472FD6FC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbhATOsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbhATO1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 09:27:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826062336D;
        Wed, 20 Jan 2021 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611152820;
        bh=DSvaDm4XhrGo3TRVwU920cVaThyOHtM52UGaxj6lzG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=asZRWy2LQeD3p9pnCwJMVoE2tk+lUdWhaMha6sb6wpIaR0+yUhRRLp9cvMHR6Ibx4
         0E+mFHl4rcQc1NnlgHMVIIRy68M0zJtFD4GXM31M3xvX5FabIWzw2GGI+/lHf9+SYY
         M0/bhQFr4fdx9l/ww8K0dbr5DpIcV4kWDcAsIWbjLBKDxbmwp1kiJQfZIKVZVgOuNX
         I4vACTktGjyioDWRdsXxu2S6g0X8a+629+4WKr7V9ifq87Bjx/r0xKcnR6g595na+0
         a7d38+Vt6fYZkjZlfKidL6KUWXyiS4ZMZ2Od2eRbihtcW3BA8h7BJVm/ZCic9dYQ2C
         0nwn87Xszi6BA==
Date:   Wed, 20 Jan 2021 09:26:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 28/45] net: stmmac: Fixed mtu channged by
 cache aligned
Message-ID: <20210120142659.GC4035784@sasha-vm>
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-28-sashal@kernel.org>
 <20210119220815.039ac330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210119220815.039ac330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 10:08:15PM -0800, Jakub Kicinski wrote:
>On Tue, 19 Jan 2021 20:25:45 -0500 Sasha Levin wrote:
>> From: David Wu <david.wu@rock-chips.com>
>>
>> [ Upstream commit 5b55299eed78538cc4746e50ee97103a1643249c ]
>>
>> Since the original mtu is not used when the mtu is updated,
>> the mtu is aligned with cache, this will get an incorrect.
>> For example, if you want to configure the mtu to be 1500,
>> but mtu 1536 is configured in fact.
>>
>> Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
>> Signed-off-by: David Wu <david.wu@rock-chips.com>
>> Link: https://lore.kernel.org/r/20210113034109.27865-1-david.wu@rock-chips.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This was applied 6 days ago, I thought you said you wait two weeks.
>What am I missing?

The "AUTOSEL" review cycle is an additional hurdle automatically
selected patches need to clear before being queued up. There are 7 days
between the day I sent the review for these and the first day I might
queue them up.

This mail isn't an indication that the patch has been added to the
queue, it's just an extra step to give folks time to object.

If you add up all the days you'll get >14 :)

-- 
Thanks,
Sasha
