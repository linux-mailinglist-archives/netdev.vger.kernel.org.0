Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621B819BFFF
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbgDBLP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:15:26 -0400
Received: from m12-11.163.com ([220.181.12.11]:55697 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbgDBLP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 07:15:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=0PaAh
        njWFmotS9R6RTuiamZVZJ8AdFpuIg0iLTbmOJg=; b=DOdTlmI0hulcCn5nggIkX
        RzY0OJLNpWJ2iAvHrA2lBTfK6+/FXZGhOVVWot5LNWJagqRFpi3EtQ+fPQ/4oHlh
        bdD8OIRfZ9bRXxG506tKJgpnxi4S+x6KQzB51gcQ5IrY8mgkggHAdsTUU1zK58R2
        SX0NzbmqK/j+9wUg1AXFuo=
Received: from [192.168.0.6] (unknown [125.82.11.8])
        by smtp7 (Coremail) with SMTP id C8CowADX3enLyIVeOShNCQ--.1092S2;
        Thu, 02 Apr 2020 19:13:16 +0800 (CST)
Subject: Re: [PATCH] net/faraday: fix grammar in function
 ftgmac100_setup_clk() in ftgmac100.c
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        davem@davemloft.net, andrew@lunn.ch, mchehab+samsung@kernel.org,
        andrew@aj.id.au, corbet@lwn.net
Cc:     stfrench@microsoft.com, chris@chris-wilson.co.uk,
        xiubli@redhat.com, airlied@redhat.com, tglx@linutronix.de,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200401105624.17423-1-xianfengting221@163.com>
 <1947a3705a220ce14a2fda482c833b38a4d9fe9a.camel@kernel.crashing.org>
From:   Hu Haowen <xianfengting221@163.com>
Message-ID: <d146a02d-372e-0f54-39e7-3ebcd0c46e4f@163.com>
Date:   Thu, 2 Apr 2020 19:13:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1947a3705a220ce14a2fda482c833b38a4d9fe9a.camel@kernel.crashing.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: C8CowADX3enLyIVeOShNCQ--.1092S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr1kJw4kCF4xGF4xXr1xGrg_yoW8JFyUpr
        WUGFWxuF18Jw17W3ZrJa1FqF9xXa10vrWjgF1UK39a9rykKF15Xr1DKrZIkF97tFW8CF4a
        yr4UZ3WfKFn8C3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jtNVkUUUUU=
X-Originating-IP: [125.82.11.8]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiFQ35AF5mI+bnawAAsQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 6:43 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2020-04-01 at 18:56 +0800, Hu Haowen wrote:
>> "its not" is wrong. The words should be "it's not".
>>
>> Signed-off-by: Hu Haowen <xianfengting221@163.com>
> Typo more than grammer :-)


Emm...


In fact I just found the mistake by accident and decided to fix it up
because it is a standard in the kernel documention not to misspell
words :-)


>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>
>   (the offender)
>
>> ---
>>   drivers/net/ethernet/faraday/ftgmac100.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
>> index 835b7816e372..87236206366f 100644
>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>> @@ -1731,7 +1731,7 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
>>   	if (rc)
>>   		goto cleanup_clk;
>>   
>> -	/* RCLK is for RMII, typically used for NCSI. Optional because its not
>> +	/* RCLK is for RMII, typically used for NCSI. Optional because it's not
>>   	 * necessary if it's the AST2400 MAC, or the MAC is configured for
>>   	 * RGMII, or the controller is not an ASPEED-based controller.
>>   	 */

