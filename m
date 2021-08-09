Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBFC3E4E7E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhHIVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:30:06 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.33]:18914 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233898AbhHIVaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:30:05 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id C7A484D969
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 16:29:42 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id DCq6mOWgOrJtZDCq6mzIRf; Mon, 09 Aug 2021 16:29:42 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QgyrrxOHvP7M6fplZ52oJH8CjSBf+T8N9dmFTacakl0=; b=RJ5HVUfwJimK7r90lDMzMJc0bK
        kSZulCYMs8kEDYXa7fYxujML3b7F4zI94vIbs1yMfALNkuQpPtZ+y4Z7L7KkyZapPQq8str0VuE1d
        +k13Y54uSLP/mt2btGWXP/lX9b/sPI9IxSNOm5m7SQDUHhyy4vQqu7QHJh8IohRTBTlvNHkhNN3di
        9D/KDAvDLagoWUYImeYbxAvFmMcich7didzy0Sp8PEwQL0Hrg8xYkeycHQ8v/i1qyEG+UT9/u7yS5
        WBVSJ4c1OC+Jhbg0+e3jXKXSsu4cz+QB3VEHdDbtKXl/IRRZMGtotuI8tKb0prXVe9bRWIBkQjjEA
        /ELAzuUw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:36120 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mDCq5-000CXb-UH; Mon, 09 Aug 2021 16:29:41 -0500
Subject: Re: [PATCH][next] mwifiex: usb: Replace one-element array with
 flexible-array member
To:     Brian Norris <briannorris@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
References: <20210809211134.GA22488@embeddedor>
 <CA+ASDXO+GbP_WWVdO0=Uavh036ZhZiziE8DwGRKP-ooofd2QVw@mail.gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <533036d7-1a0e-21e8-5e40-2e807b32a215@embeddedor.com>
Date:   Mon, 9 Aug 2021 16:32:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXO+GbP_WWVdO0=Uavh036ZhZiziE8DwGRKP-ooofd2QVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mDCq5-000CXb-UH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:36120
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/21 16:24, Brian Norris wrote:
> On Mon, Aug 9, 2021 at 2:08 PM Gustavo A. R. Silva
> <gustavoars@kernel.org> wrote:
>>
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> This helps with the ongoing efforts to globally enable -Warray-bounds
>> and get us closer to being able to tighten the FORTIFY_SOURCE routines
>> on memcpy().
>>
>> This issue was found with the help of Coccinelle and audited and fixed,
>> manually.
>>
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
>>
>> Link: https://github.com/KSPP/linux/issues/79
>> Link: https://github.com/KSPP/linux/issues/109
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> An important part of your patch rationale should include determining
> that the 1-length wasn't actually important anywhere. I double checked
> for you, and nobody seemed to be relying on 'sizeof struct fw_data' at
> all, so this should be OK:

I always do that. That's the reason why I included this line in the
changelog text:

"This issue was found with the help of Coccinelle and audited and fixed,
manually."

Thanks for double-checking, though. :)

> Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks
--
Gustavo

