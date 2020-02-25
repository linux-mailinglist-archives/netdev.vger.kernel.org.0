Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E9A16C3C3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgBYOXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:23:01 -0500
Received: from gateway20.websitewelcome.com ([192.185.55.25]:15787 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730449AbgBYOXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:23:00 -0500
X-Greylist: delayed 1277 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2020 09:22:59 EST
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id CB1AC400D074F
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 06:47:18 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6amFjXgP5Sl8q6amFjCY0E; Tue, 25 Feb 2020 08:01:35 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r8Lc+tZ9X8OdwKV6l2Zw8M7UkDdOOthqyCbUCkNpWms=; b=m0bJra4Lu5bIWxynx+Tefu91KF
        LY1aRxC3YPjxD0V0BN6jKbmjqD4gD9I5RqyoC3eJbRfHb5ePf5ftgdbP5VppvYH+aDuE9+jLA3ohu
        r2mGicqOKbZ7/kVg1pwOLqskOtGyYjZnYUNZlim82l2cQN3Gq+pGCyYBNCD4O+d0NEWjbqGGIW04U
        jTVERLg83c+VPuA+D8l1w2+Nn8dY0oIVbrinXq/gaK/GmnxnzxiJoYGOWt2EugzM+wL/TWeOQmKNM
        TgZftGRGvh7Z5q/jAEMhe57Vy7PhDtWt3tOZXYZrjYP+OujOdnXbd5A9TfUJRnaupFnWuwI3J9YeG
        K/Q0TFuA==;
Received: from [201.162.241.105] (port=10609 helo=[192.168.43.131])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6amE-001PC4-IN; Tue, 25 Feb 2020 08:01:34 -0600
Subject: Re: [PATCH][next] sfc: Replace zero-length array with flexible-array
 member
To:     Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225000647.GA17795@embeddedor>
 <6a100eb2-4ba1-32ac-35de-d02c38503785@solarflare.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Message-ID: <7963b6dc-cafe-f427-e634-a043c688c78a@embeddedor.com>
Date:   Tue, 25 Feb 2020 08:01:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6a100eb2-4ba1-32ac-35de-d02c38503785@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.241.105
X-Source-L: No
X-Exim-ID: 1j6amE-001PC4-IN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.43.131]) [201.162.241.105]:10609
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 33
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/20 07:42, Martin Habets wrote:
> On 25/02/2020 00:06, Gustavo A. R. Silva wrote:
>> The current codebase makes use of the zero-length array language
>> extension to the C90 standard, but the preferred mechanism to declare
>> variable-length types such as these ones is a flexible array member[1][2],
>> introduced in C99:
>>
>> struct foo {
>>         int stuff;
>>         struct boo array[];
>> };
>>
>> By making use of the mechanism above, we will get a compiler warning
>> in case the flexible array does not occur last in the structure, which
>> will help us prevent some kind of undefined behavior bugs from being
>> inadvertently introduced[3] to the codebase from now on.
>>
>> Also, notice that, dynamic memory allocations won't be affected by
>> this change:
>>
>> "Flexible array members have incomplete type, and so the sizeof operator
>> may not be applied. As a quirk of the original implementation of
>> zero-length arrays, sizeof evaluates to zero."[1]
> 
> These padding fields are only used to enforce alignment of the struct.
> But the patch is still ok.
> 

Correct.

>> This issue was found with the help of Coccinelle.
>>
>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>> [2] https://github.com/KSPP/linux/issues/21
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Acked-by: Martin Habets <mhabets@solarflare.com>
> 

Thanks, Martin.
--
Gustavo

>> ---
>>  drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
>>  drivers/net/ethernet/sfc/net_driver.h        | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
>> index a49ea2e719b6..a529ff395ead 100644
>> --- a/drivers/net/ethernet/sfc/falcon/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
>> @@ -288,7 +288,7 @@ struct ef4_rx_buffer {
>>  struct ef4_rx_page_state {
>>  	dma_addr_t dma_addr;
>>  
>> -	unsigned int __pad[0] ____cacheline_aligned;
>> +	unsigned int __pad[] ____cacheline_aligned;
>>  };
>>  
>>  /**
>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>> index 9f9886f222c8..392bd5b7017e 100644
>> --- a/drivers/net/ethernet/sfc/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>> @@ -336,7 +336,7 @@ struct efx_rx_buffer {
>>  struct efx_rx_page_state {
>>  	dma_addr_t dma_addr;
>>  
>> -	unsigned int __pad[0] ____cacheline_aligned;
>> +	unsigned int __pad[] ____cacheline_aligned;
>>  };
>>  
>>  /**
>>
