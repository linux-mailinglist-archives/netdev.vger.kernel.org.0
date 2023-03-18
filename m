Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3F6BFAEB
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 15:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCROkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 10:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCROku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 10:40:50 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F952823F;
        Sat, 18 Mar 2023 07:40:49 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id t9so8604186qtx.8;
        Sat, 18 Mar 2023 07:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679150448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q9G0FvrgkjWRK1hTA7j4UZr/0beYu/ds7XI4Rl+67Co=;
        b=OP9VCPeUp/I4MMRhvatgg5LSb5P+yMRi51JCqeLlfLMyImF8irPk4MjelmlgeImKR9
         u90VCi68iRYla6dGMHCwM4kddaNZ3CCRT9SwSM9fU19y8MOCvXM8WGOw0RcVZOgp/DaK
         gwQLVppTbu42PN4wWmMFzU+87FmjFhGVj2VEsyWj+K9YyNcDNqK1dK5lE/zC4mRQVUed
         J848AEnUOPQVxfhAcyac8C6+rdrf/hKBTp81NNHLqR6JRHSBHUwIA5M/Fzs+q7XdmBV5
         AlRZrgLkFj0Nam4a9lHLhPIAWd1zW0/aCh4aDDei6kBTsAa+PvUg1k8OOxL+HmOx0A1w
         4Kig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679150448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9G0FvrgkjWRK1hTA7j4UZr/0beYu/ds7XI4Rl+67Co=;
        b=wHjsZU7bk2CI2UaTUNm96E3CEi7tXJ5FmKXekhrf2wlVMoHMIKquuqJ0G94AGF657J
         aCaVOIL7H1/T3woNZlcB6tpvF9TGil/ApKWbfe3NJmNHuys4KWkIjyeSFglu1HK45wlf
         BKU8WLN/FhmJ/mLRGOHZWd7zQUqx41OFLLVFPvYp4hO6xIPrSyuuzbotWk7IeO6bpL1S
         LkhBU6iYNqk12OluW91F+ceKZQzqjNwdWjZQ+4ZvL5JnuqiLZBy0FvT7lQgkrpgbOBc/
         z0w/0G+K7THZWsCtJ8yMOFtsaHM/DlHRoHH+KbjjKQI3wAhNYnh0+Te42I/XKhy1X8gk
         PF0g==
X-Gm-Message-State: AO0yUKXhfS9eLRy501CK7Kh/4YeSFV1nSsTjvrJ5ZvyMWpicGxkKZahb
        KqcWhNlNYtI9AjBM8NvieFA=
X-Google-Smtp-Source: AK7set/rfp345B44AxEmW2qmslJ6JcZKkUqbDjv4Bidq/HLJPhryfVWPstBlxmUZnm72WNuHJMiMwQ==
X-Received: by 2002:ac8:5bd6:0:b0:3bf:c431:ea6e with SMTP id b22-20020ac85bd6000000b003bfc431ea6emr17163478qtb.3.1679150448065;
        Sat, 18 Mar 2023 07:40:48 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id k18-20020ac84792000000b003ba19e53e43sm106750qtq.25.2023.03.18.07.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 07:40:47 -0700 (PDT)
Message-ID: <7bf5761c-abdd-a3cb-267c-5e61641b15f8@gmail.com>
Date:   Sat, 18 Mar 2023 10:40:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 9/9] net: sunhme: Consolidate common probe
 tasks
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-10-seanga2@gmail.com> <ZBXCWUm/1ffaD1B+@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZBXCWUm/1ffaD1B+@corigine.com>
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

On 3/18/23 09:53, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:13PM -0400, Sean Anderson wrote:
>> Most of the second half of the PCI/SBUS probe functions are the same.
>> Consolidate them into a common function.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>> (no changes since v1)
>>
>>   drivers/net/ethernet/sun/sunhme.c | 183 ++++++++++++------------------
>>   1 file changed, 71 insertions(+), 112 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index a59b998062d9..a384b162c46d 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2430,6 +2430,71 @@ static void happy_meal_addr_init(struct happy_meal *hp,
>>   	}
>>   }
>>   
>> +static int happy_meal_common_probe(struct happy_meal *hp,
>> +				   struct device_node *dp, int minor_rev)
>> +{
>> +	struct net_device *dev = hp->dev;
>> +	int err;
>> +
>> +#ifdef CONFIG_SPARC
>> +	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
>> +	if (hp->hm_revision == 0xff)
>> +		hp->hm_revision = 0xc0 | minor_rev;
>> +#else
>> +	/* works with this on non-sparc hosts */
>> +	hp->hm_revision = 0x20;
>> +#endif
> 
> ...
> 
>> +#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
>> +	/* Hook up SBUS register/descriptor accessors. */
>> +	hp->read_desc32 = sbus_hme_read_desc32;
>> +	hp->write_txd = sbus_hme_write_txd;
>> +	hp->write_rxd = sbus_hme_write_rxd;
>> +	hp->read32 = sbus_hme_read32;
>> +	hp->write32 = sbus_hme_write32;
>> +#endif
> 
> This looks correct for the SBUS case.
> But I'm not sure about the PCIE case.
> 
> gcc 12 tells me when compiling with sparc allmodconfig that the following
> functions are now unused.
> 
>    pci_hme_read_desc32
>    pci_hme_write_txd
>    pci_hme_write_rxd
>    pci_hme_read32
>    pci_hme_write32

Oh, looks like I missed that these were different while refactoring.

That said, I haven't seen any issues here...

>> +
>> +	/* Grrr, Happy Meal comes up by default not advertising
>> +	 * full duplex 100baseT capabilities, fix this.
> b
>> +	 */
>> +	spin_lock_irq(&hp->happy_lock);
>> +	happy_meal_set_initial_advertisement(hp);
>> +	spin_unlock_irq(&hp->happy_lock);
>> +
>> +	err = devm_register_netdev(hp->dma_dev, dev);
>> +	if (err)
>> +		dev_err(hp->dma_dev, "Cannot register net device, aborting.\n");
>> +	return err;
>> +}
>> +
>>   #ifdef CONFIG_SBUS
>>   static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>>   {
> 
>> @@ -2511,70 +2576,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>>   		goto err_out_clear_quattro;
>>   	}
>>   
>> -	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
>> -	if (hp->hm_revision == 0xff)
>> -		hp->hm_revision = 0xa0;
> 
> It's not clear to me that the same value will be set by the call to
> happy_meal_common_probe(hp, dp, 0); where the logic is:
> 
> #ifdef CONFIG_SPARC
> 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> 	if (hp->hm_revision == 0xff)
> 		hp->hm_revision = 0xc0 | minor_rev;

OK, so maybe this should be xor, with sbus passing in 0x30.

> #else
> 	/* works with this on non-sparc hosts */
> 	hp->hm_revision = 0x20;
> #endif
> 
> I am assuming that the SPARC logic is run.
> But another question: is it strictly true that SBUS means SPARC?

Yes.

>> -
>> -#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
>> -	/* Hook up SBUS register/descriptor accessors. */
>> -	hp->read_desc32 = sbus_hme_read_desc32;
>> -	hp->write_txd = sbus_hme_write_txd;
>> -	hp->write_rxd = sbus_hme_write_rxd;
>> -	hp->read32 = sbus_hme_read32;
>> -	hp->write32 = sbus_hme_write32;
>> -#endif
> 
> ...
> 
>> @@ -2689,21 +2702,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   	hp->bigmacregs = (hpreg_base + 0x6000UL);
>>   	hp->tcvregs    = (hpreg_base + 0x7000UL);
>>   
>> -#ifdef CONFIG_SPARC
>> -	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
>> -	if (hp->hm_revision == 0xff)
>> -		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
>> -#else
>> -	/* works with this on non-sparc hosts */
>> -	hp->hm_revision = 0x20;
>> -#endif
> 
> ...
> 
>> -#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
>> -	/* Hook up PCI register/descriptor accessors. */
>> -	hp->read_desc32 = pci_hme_read_desc32;
>> -	hp->write_txd = pci_hme_write_txd;
>> -	hp->write_rxd = pci_hme_write_rxd;
>> -	hp->read32 = pci_hme_read32;
>> -	hp->write32 = pci_hme_write32;
>> -#endif
> 
> ...

--Sean
