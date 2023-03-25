Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BAC6C8F4D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjCYQGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCYQGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:06:47 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BBEFF09;
        Sat, 25 Mar 2023 09:06:44 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id l7so3682788qvh.5;
        Sat, 25 Mar 2023 09:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679760403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wVCSph/Zc1RNq1OirGOIH0MpgxECW2DNssMKlMd4kTU=;
        b=iQQwOMNFl8A0rcbey0CwzP+trnzwLdfzf/J51KdVRRKu6husTL/NB1qJuoDr4zDbGn
         61fEreOydUEib7GK/GTBKUreFL1TQ4drqpugAsO1UucZEIUtX0TkKVlVt8jHjdhzBYHY
         FBMYHi0/QrKKOH1PCvsLOj2ansoQOmwgIofzZdC2BJiqcNSidqzGzlTLpfI1ggpLu5qD
         Ra1vIZagNbfKE4gRthLvnyMJsm5Zfvk/XrO53aHuraWoOnERQ2Bx40qBFefGJVgWlOe+
         pn5hf5fcsukhHY6Tnj+/a0RyGLuZboerDCbTnnO6/Y9jHDZFU2pnwMDSeOzsIfIyRy64
         LkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679760403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVCSph/Zc1RNq1OirGOIH0MpgxECW2DNssMKlMd4kTU=;
        b=fJf0R8jg8OMerfi0dNFtUIC1ahKX7NDfahaTkoBYAJ++u1hoSgW0Epd7qP0+f4hUj8
         SBkn5aAoevj3Wd0ZuQwkO9XaTunhWQ9Nvd7dYyQXlcqZJYHeIQ6zeDRLRncQZaMIQKHY
         eupPJQ8x9H8JBx135x9Jbj3cYaYjcnLmhKR2bNSJ1i4zlhI5XDMD7TJk4ap7X9trfye2
         LHFjjd+TluIhwtrOibIJRaSMg4iUGuqx1dxAOSILj4xP6Q4hrN3eFlrBuZYw445zbYzY
         ZBhaj2WeH7JXCTjXlYOUzYpFD0jo4Klasyne57LbF4axLNNiq2MGCW7jUh3hhKvHjhrI
         66OQ==
X-Gm-Message-State: AAQBX9caLkZSXAtzcQjF5KpL4AzD8Rg9DWFXJ7CQ1jfdJxKRe2MBtpou
        qfNGB7MloTEI1ap+mBNoDDU=
X-Google-Smtp-Source: AKy350YBTrN/Ar9BYQm+khB5hD34JSWQ1ALaSWECXEB8WiWTXUmmkNeWrfpIuCD9Qenb6N88PKtxSg==
X-Received: by 2002:a05:6214:62e:b0:56e:a96a:2bdc with SMTP id a14-20020a056214062e00b0056ea96a2bdcmr8767554qvx.40.1679760403046;
        Sat, 25 Mar 2023 09:06:43 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id q26-20020a05620a025a00b00746a0672cf3sm5936787qkn.94.2023.03.25.09.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 09:06:42 -0700 (PDT)
Message-ID: <a4ecd20b-5d13-893b-2329-f6dd0c565ad5@gmail.com>
Date:   Sat, 25 Mar 2023 12:06:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 10/10] net: sunhme: Consolidate common probe
 tasks
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-11-seanga2@gmail.com> <ZB66hgG2+nn6CxS7@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZB66hgG2+nn6CxS7@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/23 05:10, Simon Horman wrote:
> On Fri, Mar 24, 2023 at 01:51:36PM -0400, Sean Anderson wrote:
>> Most of the second half of the PCI/SBUS probe functions are the same.
>> Consolidate them into a common function.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Hi Sean,
> 
> overall this looks good.
> But I (still?) have some concerns about handling hm_revision.
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index bd1925f575c4..ec85aef35bf9 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2430,6 +2430,58 @@ static void happy_meal_addr_init(struct happy_meal *hp,
>>   	}
>>   }
>>   
>> +static int happy_meal_common_probe(struct happy_meal *hp,
>> +				   struct device_node *dp)
>> +{
>> +	struct net_device *dev = hp->dev;
>> +	int err;
>> +
>> +#ifdef CONFIG_SPARC
>> +	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
> 
> Previously the logic, for SPARC for PCI went something like this:
> 
> 	/* in happy_meal_pci_probe() */
> 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> 	if (hp->hm_revision == 0xff)
> 		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
> 
> Now it goes something like this:
> 
> 	/* in happy_meal_pci_probe() */
> 	hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
> 	/* in happy_meal_common_probe() */
> 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
> 
> Is this intentional?
> 
> Likewise, for sbus (which implies SPARC) the logic was something like:
> 
> 	/* in happy_meal_sbus_probe_one() */
> 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> 	if (hp->hm_revision == 0xff)
> 		 hp->hm_revision = 0xa0;
> 
> And now goes something like this:
> 
> 	/* in happy_meal_pci_probe() */
> 	hp->hm_revision = 0xa0;
> 	/* in happy_meal_common_probe() */
> 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);

Yes, this is intentional. Logically, they are the same; we just set up the default
before calling of_getintprop_default instead of after.

>> +#endif
>> +
>> +	/* Now enable the feature flags we can. */
>> +	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
>> +		hp->happy_flags |= HFLAG_20_21;
>> +	else if (hp->hm_revision != 0xa0)
>> +		hp->happy_flags |= HFLAG_NOT_A0;
>> +
>> +	hp->happy_block = dmam_alloc_coherent(hp->dma_dev, PAGE_SIZE,
>> +					      &hp->hblock_dvma, GFP_KERNEL);
>> +	if (!hp->happy_block)
>> +		return -ENOMEM;
>> +
>> +	/* Force check of the link first time we are brought up. */
>> +	hp->linkcheck = 0;
>> +
>> +	/* Force timer state to 'asleep' with count of zero. */
>> +	hp->timer_state = asleep;
>> +	hp->timer_ticks = 0;
>> +
>> +	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
>> +
>> +	dev->netdev_ops = &hme_netdev_ops;
>> +	dev->watchdog_timeo = 5 * HZ;
>> +	dev->ethtool_ops = &hme_ethtool_ops;
>> +
>> +	/* Happy Meal can do it all... */
>> +	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
>> +	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
>> +
>> +
> 
> nit: one blank line is enough.

Ah, oops.

--Sean

>> +	/* Grrr, Happy Meal comes up by default not advertising
>> +	 * full duplex 100baseT capabilities, fix this.
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
> 
> ...

