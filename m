Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391AF44F862
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 15:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhKNOQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 09:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbhKNOQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 09:16:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F12D61167;
        Sun, 14 Nov 2021 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636899215;
        bh=GshcvNMl7nHoyVvs6uuk+cER4EyiAezsBOCfQqcH6RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HR1fLsgYhMx5dkhQLX3evgPr1XLzZ39upvlmCcy6ohosf21tg9KZpMh8/kwzEM3vC
         MeuJHtLyvp5XipCQ8+GFXSdKb0uJwoFLS8jv0udPck1fo34eVXhz8LKwm4DCdx5P45
         FjxqBzsrsibzmxXpQRS/xhbQSSAyKVqOTJfDy9r461Q7LJ5b3ES62qMUbCHDg5Aq6X
         XmAmEmh4nrrgV7xi0MWA0wlZYzz+NODD0GdZuJudq3pqPdn9+/P9B3gXoXlkQpcP3x
         nfOCMuLcbBUAcjlCxKA692IMRHFyBa0cJoAy4os2ZYDoOJnuDmp+GpYfhzAnS0Zivh
         HVlrrlQmJttRg==
Date:   Sun, 14 Nov 2021 09:13:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 10/47] NET: IPV4: fix error "do not
 initialise globals to 0"
Message-ID: <YZEZjZfsfbN2IKpA@sashalap>
References: <20211108175031.1190422-1-sashal@kernel.org>
 <20211108175031.1190422-10-sashal@kernel.org>
 <f527316e1ea4017af37857dd6d3eeecffc3bbce0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f527316e1ea4017af37857dd6d3eeecffc3bbce0.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 05:49:04PM -0800, Joe Perches wrote:
>On Mon, 2021-11-08 at 12:49 -0500, Sasha Levin wrote:
>> From: wangzhitong <wangzhitong@uniontech.com>
>>
>> [ Upstream commit db9c8e2b1e246fc2dc20828932949437793146cc ]
>>
>> this patch fixes below Errors reported by checkpatch
>>     ERROR: do not initialise globals to 0
>>     +int cipso_v4_rbm_optfmt = 0;
>>
>> Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/ipv4/cipso_ipv4.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
>> index e8b8dd1cb1576..75908722de47a 100644
>> --- a/net/ipv4/cipso_ipv4.c
>> +++ b/net/ipv4/cipso_ipv4.c
>> @@ -87,7 +87,7 @@ struct cipso_v4_map_cache_entry {
>>  static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
>>
>>  /* Restricted bitmap (tag #1) flags */
>> -int cipso_v4_rbm_optfmt = 0;
>> +int cipso_v4_rbm_optfmt;
>
>I think this is a silly thing to backport unless it's required
>for some other patch.

You're right - it's silly. I'll drop it.

-- 
Thanks,
Sasha
