Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C696BFB4E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 16:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCRPnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 11:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCRPnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 11:43:20 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258FB1A964;
        Sat, 18 Mar 2023 08:43:19 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id fy17so6151138qtb.2;
        Sat, 18 Mar 2023 08:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679154198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=83azAsLsNv6lIAaa/44pUgNbDjt9kE7NkMwa/ioRqlg=;
        b=d83uusW0G/mwN787AdzNErFHeJ23t0Ds715cf4Bvgj0jsIYYxLxibyJcQQzupn3zJG
         8k77NqHeTwAlJI0gj+swxb4V+Ed7yPhsfC4BS2yZi57TfzsXrSp0Sion9u7ZHgGOBawK
         EqcD1BByqof7cURiX5a1ccLX2uUaJ5SQvYoZA5D1UBaFo3lpwECjLvAguFpbQ6ZOFKV9
         8cG6FtcyeSxMSEoXLMvu3NDNCDIq0kyUQTiPVLq/QMSbsz0ZgUQbz2IX7p/ewHeR3y3g
         Rj+BsXaiY09In7xuTHsdcKCgix57EDruIkpPGGY9QezAQuO0UYatS6s1PcYkRApEpFCC
         glug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679154198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83azAsLsNv6lIAaa/44pUgNbDjt9kE7NkMwa/ioRqlg=;
        b=ycRiHAjtWjkBGAfjYmmBtWgyBR5i1jEGtOkEKEiB879LlFDePXTMstvmXlZ60CZCIJ
         L6wS2W0BlCSTvAfe5ql/8FNWOn8Rh4mktMNrpd1wsizThigvUMU05RtieG18MO2MqkG9
         zZRborAIX26UUXam2hDaI5z2p6cYBRckwH/VAmQDUFMHfvrPoy7EMrxb5FfolE1wzwMB
         WuFfomwu8h0mTcKeKk4SZTCVKzfKnhngzqRZxkvLBIzQ0tykdLg8+L5ut8yBevF1yUES
         YuDeQfU2erOD1WEzdHleQeDgtgrLOiemba1yGemNNQhRKP5IamfyXTBDSzg9bvG/HydT
         Ix2A==
X-Gm-Message-State: AO0yUKXPcvuz0jU4UUsxFakiQWhp3MxHaAAfXOzKWo2Kp/qFQOHkebnu
        jCtCRWW1N/mR9ZcW8GVoqPE=
X-Google-Smtp-Source: AK7set8v1aDLON8+cHTsGWTYZ1rj3siqD+d/qt/qKIoUbvYrQS6svga3YKTATlz5dhgNie/5UdRFIw==
X-Received: by 2002:a05:622a:1653:b0:3bf:db29:b79e with SMTP id y19-20020a05622a165300b003bfdb29b79emr17693986qtj.5.1679154198218;
        Sat, 18 Mar 2023 08:43:18 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id z72-20020a37654b000000b0074283b87a4esm3800225qkb.90.2023.03.18.08.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 08:43:17 -0700 (PDT)
Message-ID: <7389fef5-8fe8-4f24-f762-4f3597ad0943@gmail.com>
Date:   Sat, 18 Mar 2023 11:43:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 7/9] net: sunhme: Clean up mac address init
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-8-seanga2@gmail.com> <ZBV+cK8YAXI15tsL@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZBV+cK8YAXI15tsL@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/23 05:03, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:11PM -0400, Sean Anderson wrote:
>> Clean up some oddities suggested during review.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>> (no changes since v2)
>>
>> Changes in v2:
>> - New
>>
>>   drivers/net/ethernet/sun/sunhme.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index c2737f26afbe..1f27e99abf17 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2348,9 +2348,7 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
>>   		p += 6;
>>   
>>   		if (index == 0) {
>> -			int i;
>> -
>> -			for (i = 0; i < 6; i++)
>> +			for (int i = 0; i < 6; i++)
>>   				dev_addr[i] = readb(p + i);
>>   			return 1;
>>   		}
>> @@ -2362,9 +2360,10 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
>>   static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>>   						unsigned char *dev_addr)
>>   {
>> +	void __iomem *p;
>>   	size_t size;
>> -	void __iomem *p = pci_map_rom(pdev, &size);
>>   
>> +	p = pci_map_rom(pdev, &size);
>>   	if (p) {
>>   		int index = 0;
>>   		int found;
>> @@ -2386,7 +2385,7 @@ static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>>   	dev_addr[2] = 0x20;
>>   	get_random_bytes(&dev_addr[3], 3);
>>   }
>> -#endif /* !(CONFIG_SPARC) */
>> +#endif
> 
> Hi Sean,
> 
> I think this problem was added by patch 6/9,
> so perhaps best to squash it into that patch.

> Actually, I'd squash all these changes into 6/9.
> But I don't feel strongly about it.

6/9 just moves code around. I am keeping the modifications for other commits.

--Sean

> So in any case,
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I will pause my review here (again!) because I need to go to a football match.

