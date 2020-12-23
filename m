Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105572E1D46
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgLWOPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgLWOPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:15:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49D923159;
        Wed, 23 Dec 2020 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608732883;
        bh=KwOCRAIlT7Kx98f7TLXR6Mob/duwi21xCJsMOHNBw5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIaV3e3Dbo/54lFTWkVfg8ZAdYi23vEhNJ3c2TYplT71+CcQeD0DmA9NS1EvQ8AQp
         JXySB0GNDuMuk2X0Oy9mxV1MFlhdcpZa6hXsA+cyVORt7OaHNj8YVd/iIFU9pD/NOJ
         WzmUic3EgEXhvxqk9cSS1tL2RBPlmbgflYowg4VnwnH0HK2Z5rLrp8n38D5ZaG2TSs
         WCsrYsAv2qxSsZiGUPhv/vgdRdejt9ZWj7TzshLeoR9yzxuNDSvBtYTvEdZwKbOqzK
         IkfL7T4uY59SQjopGrn9h/K1AqzrngUtN+prHJYRCkSiefrOGyWPDcuUwbeNeyol1q
         V5dXygsSrG8aA==
Date:   Wed, 23 Dec 2020 09:14:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Saruhan Karademir <skarade@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 40/66] hv_netvsc: Validate number of
 allocated sub-channels
Message-ID: <20201223141441.GB2790422@sasha-vm>
References: <20201223022253.2793452-1-sashal@kernel.org>
 <20201223022253.2793452-40-sashal@kernel.org>
 <MW2PR2101MB1052FDCC72FE8D5735553E3CD7DE9@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20201223085931.GA2683@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201223085931.GA2683@andrea>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 09:59:31AM +0100, Andrea Parri wrote:
>On Wed, Dec 23, 2020 at 02:47:56AM +0000, Michael Kelley wrote:
>> From: Sasha Levin <sashal@kernel.org> Sent: Tuesday, December 22, 2020 6:22 PM
>> >
>> > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
>> >
>> > [ Upstream commit 206ad34d52a2f1205c84d08c12fc116aad0eb407 ]
>> >
>> > Lack of validation could lead to out-of-bound reads and information
>> > leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
>> > allocated sub-channels fits into the expected range.
>> >
>> > Suggested-by: Saruhan Karademir <skarade@microsoft.com>
>> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
>> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
>> > Acked-by: Jakub Kicinski <kuba@kernel.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: netdev@vger.kernel.org
>> > Link:
>> > https://lore.kernel.org/linux-hyperv/20201118153310.112404-1-parri.andrea@gmail.com/
>> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  drivers/net/hyperv/rndis_filter.c | 5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>>
>> Sasha -- This patch is one of an ongoing group of patches where a Linux
>> guest running on Hyper-V will start assuming that hypervisor behavior might
>> be malicious, and guards against such behavior.  Because this is a new
>> assumption,  these patches are more properly treated as new functionality
>> rather than as bug fixes.  So I would propose that we *not* bring such patches
>> back to stable branches.
>
>Thank you, Michael.  Just to confirm, I agree with Michael's assessment
>above and I join his proposal to *not* backport such patches to stable.

I'll drop it then, thanks.

-- 
Thanks,
Sasha
