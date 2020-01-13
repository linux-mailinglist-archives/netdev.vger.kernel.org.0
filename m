Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA55713922E
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgAMN3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:29:46 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49592 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728688AbgAMN3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:29:46 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9113658005A;
        Mon, 13 Jan 2020 13:29:45 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 13 Jan
 2020 13:29:42 +0000
Subject: Re: [PATCH] sfc/ethtool_common: Make some function to static
To:     Jakub Kicinski <kubakici@wp.pl>, <ecree@solarflare.com>,
        <amaftei@solarflare.com>
CC:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
 <20200113045846.3330b57c@cakuba>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <5c1a0337-3665-79bc-b275-6a2d0b8389c1@solarflare.com>
Date:   Mon, 13 Jan 2020 13:29:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200113045846.3330b57c@cakuba>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25164.003
X-TM-AS-Result: No-6.935200-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTwxP67pPeLzqo2fOuRT7aa2LlbtF/6zpDk1kyQDpEj8AQ9
        n8U23GDf0j/aaA4A9h5T2G1dRg9CQqH2g9syPs888Kg68su2wyFc1jwHBugxQJiQXtm0V8JTZYz
        ZgiJFzgqMW6CBWTEtxa28ztnoMfpdJ97RPj0PB2iSvRb8EMdYReuLFZZYlisfTX7PJ/OU3vKDGx
        /OQ1GV8mMVPzx/r2cb+gtHj7OwNO33FLeZXNZS4EZLVcXaUbdiux1MLwNfs3zt3zkVSKUtza9P1
        85isn9hMiv9FbDlLcCeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.935200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25164.003
X-MDID: 1578922186-xY3YFrf6PR8z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

The fix is good. Even when we reuse this code these functions can remain static.

Martin

On 13/01/2020 12:58, Jakub Kicinski wrote:
> On Mon, 13 Jan 2020 19:24:11 +0800, Zhang Xiaoxu wrote:
>> Fix sparse warning:
>>
>> drivers/net/ethernet/sfc/ethtool_common.c
>>   warning: symbol 'efx_fill_test' was not declared. Should it be static?
>>   warning: symbol 'efx_fill_loopback_test' was not declared.
>>            Should it be static?
>>   warning: symbol 'efx_describe_per_queue_stats' was not declared.
>>            Should it be static?
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> 
> Ed, Alex, since you were talking about reusing this code would you
> rather add a declaration for these function to a header? Or should 
> I apply the current fix?
> 
