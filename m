Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44D3D7E0F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhG0Syh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhG0Syg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 14:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23FF60FC2;
        Tue, 27 Jul 2021 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627412076;
        bh=NXbpGK7KzT41BbKTFGSWVcuOpTVgASHztETM7D6idk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRPWKX8bPLgZzWR/6X3pu6GvoPO2skHdyukspwNYRPJw+JB7VKTecGp/PasD3USgC
         /8KjLAN1z1cr0ak53qqrbzZLUcs3xlgzeYW92MChWEu6dfYJGO4YRpZtGFsBC0CY4O
         hheCR7WjBVqqUxMjUNnkKfEAhS+aTmeLhNASWfiq0eza/WdbX8T5eMQrhkgf4wtWLB
         8mUqpWSzvzNGsTNbuw2jYJCSzteFV5sFgUs+FYSga18fMLtDZRulRcUqZnl0qboREa
         UVpAQwBLcv0uPoFn/0HvGXOtTMU+Cej3Fag87KS3wMEUu1FFmfKkp9wjDmUW4hH1cy
         VV36gSw/oUA2g==
Date:   Tue, 27 Jul 2021 14:54:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Justin He <Justin.He@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lijian Zhang <Lijian.Zhang@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.13 09/21] qed: fix possible unpaired
 spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Message-ID: <YQBWaoWYYyFo6apS@sashalap>
References: <20210727131908.834086-1-sashal@kernel.org>
 <20210727131908.834086-9-sashal@kernel.org>
 <AM6PR08MB4376DF5C31C64EBFCB0276ECF7E99@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AM6PR08MB4376DF5C31C64EBFCB0276ECF7E99@AM6PR08MB4376.eurprd08.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:30:15PM +0000, Justin He wrote:
>Hi, Sasha
>
>> -----Original Message-----
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Tuesday, July 27, 2021 9:19 PM
>> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
>> Cc: Justin He <Justin.He@arm.com>; Lijian Zhang <Lijian.Zhang@arm.com>;
>> David S . Miller <davem@davemloft.net>; Sasha Levin <sashal@kernel.org>;
>> netdev@vger.kernel.org
>> Subject: [PATCH AUTOSEL 5.13 09/21] qed: fix possible unpaired
>> spin_{un}lock_bh in _qed_mcp_cmd_and_union()
>>
>> From: Jia He <justin.he@arm.com>
>If possible, please stop taking this commit to any stable version because
>it has been reverted by later commit.

Will do, thanks!

-- 
Thanks,
Sasha
