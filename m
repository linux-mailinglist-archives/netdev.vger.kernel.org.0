Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D44699BEF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBPSLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBPSLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:11:16 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11EB505F6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:11:13 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id i26so1045929ila.11
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RV2H7OHZFzM0mriIkerx4CXud9s9kARiZGLdQV9DYFw=;
        b=CCwh0Qxh3hbASgMOuhGbLxZto9yFwMQRl5gDrf6OiE+0aHFH9HrCj6jx+O1q65CVLj
         xB0VipcinWJos91qJx2R1Ho0L0tHOwDZcGHf1qCERdvMrbwOQCVkzlN28QFvJ8+r4Q3U
         9rIYJvUizTd0dX3g6xVVQc8hSnyQaHIY2nrkycH/mg1/J7zJLECZ5PKocWKxSYHrrLoD
         z7EMqOIziICbtOIuTxrdwXKWjhafhH28vP806S+0C9x75bLNOJgsJb8qVoEgD4eITXU/
         9mT2NkIfCAoraiOU/o/oGLGmKNrj6+AiqgJeSHa4kdjyci8Hd6uFQ0rp51PiY6ycMCx2
         1Iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RV2H7OHZFzM0mriIkerx4CXud9s9kARiZGLdQV9DYFw=;
        b=z+VgCdx5v/07QaltZJpcDIEUSUdL6ZpbLh1lcza9nGxvlnQ1mIyndSZfd53mkYJdf2
         VpCQU5ry9WWxlqDhjbC7Ybd5uUdzgNSHltQ9WnHTEX9N5MNWP7hONbD4AGStd2zzN6S0
         csEca0FSg+y43lHgiqS7YX7leyC+We6Ztx5LbN77qQncltBxw0mlF4Frg31rZ2UNglch
         PbYIgMs56fLPk4D5drv++a3p/s38jRR9fOfDiYHXKeaBLc4z6b0+Mc7OMAROvnaw9K9e
         yffZFN9w8JIEiMMYKBQllbS/1tZmrKrV3XpHgDMP5ls/Fn7LPc8JnZDQuuiS02eJpM26
         DjSQ==
X-Gm-Message-State: AO0yUKXkNWzgAgy2BN7MXudMTFWMq3nV60JhBCny3M9kDn7gra0xf60t
        RXFUnWZBmTCjnrKkEWjChQpP7w==
X-Google-Smtp-Source: AK7set95uYhVs9K5hmtvMd2Zh37vaJJtowEo3CwklWG2COM57wLEswzs3dtwenHS2+b3B2baBJ2RXQ==
X-Received: by 2002:a05:6e02:20e2:b0:311:d01:6018 with SMTP id q2-20020a056e0220e200b003110d016018mr7709342ilv.8.1676571072902;
        Thu, 16 Feb 2023 10:11:12 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id y8-20020a056e021be800b00315766ef15csm633559ilv.35.2023.02.16.10.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 10:11:12 -0800 (PST)
Message-ID: <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
Date:   Thu, 16 Feb 2023 12:11:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
 <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 11:51 AM, Alexander Lobakin wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Wed, 15 Feb 2023 13:53:48 -0600
> 
>> Starting at IPA v4.5, almost all GSI registers had their offsets
>> changed by a fixed amount (shifted downward by 0xd000).  Rather than
>> defining offsets for all those registers dependent on version, an
>> adjustment was applied for most register accesses.  This was
>> implemented in commit cdeee49f3ef7f ("net: ipa: adjust GSI register
>> addresses").  It was later modified to be a bit more obvious about
>> the adjusment, in commit 571b1e7e58ad3 ("net: ipa: use a separate
>> pointer for adjusted GSI memory").
> 
> [...]
> 
>> @@ -142,27 +127,17 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
>>   		return -EINVAL;
>>   	}
>>   
>> -	/* Make sure we can make our pointer adjustment if necessary */
>> -	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
>> -	if (res->start < adjust) {
>> -		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
>> -			adjust);
>> -		return -EINVAL;
>> -	}
>> -
>>   	gsi->regs = gsi_regs(gsi);
>>   	if (!gsi->regs) {
>>   		dev_err(dev, "unsupported IPA version %u (?)\n", gsi->version);
>>   		return -EINVAL;
>>   	}
>>   
>> -	gsi->virt_raw = ioremap(res->start, size);
>> -	if (!gsi->virt_raw) {
>> +	gsi->virt = ioremap(res->start, size);
> 
> Now that at least one check above went away and the second one might be
> or be not correct (I thought ioremap core takes care of this), can't
> just devm_platform_ioremap_resource_byname() be used here for simplicity?

Previously, virt_raw would be the "real" re-mapped pointer, and then
virt would be adjusted downward from that.  It was a weird thing to
do, because the result pointed to a non-mapped address.  But all uses
of the virt pointer added an offset that was enough to put the result
into the mapped range.

The new code updates all offsets to account for what the adjustment
previously did.  The test that got removed isn't necessary any more.

> 
>> +	if (!gsi->virt) {
>>   		dev_err(dev, "unable to remap \"gsi\" memory\n");
>>   		return -ENOMEM;
>>   	}
>> -	/* Most registers are accessed using an adjusted register range */
>> -	gsi->virt = gsi->virt_raw - adjust;
>>   
>>   	return 0;
>>   }
>> @@ -170,7 +145,7 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
>>   /* Inverse of gsi_reg_init() */
>>   void gsi_reg_exit(struct gsi *gsi)
>>   {
>> +	iounmap(gsi->virt);
> 
> (don't forget to remove this unmap if you decide to switch to devm_)

As far as devm_*() calls, I don't use those anywhere in the driver
currently.  If I were going to use them in one place I'd want do
it consistently, everywhere.  I don't want to do that.

>>   	gsi->virt = NULL;
>> -	iounmap(gsi->virt_raw);
>> -	gsi->virt_raw = NULL;
>> +	gsi->regs = NULL;
>>   }
> 
> [...]
> 
>> diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
>> index 651c8a7ed6116..8451d3f8e421e 100644
>> --- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
>> +++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
>> @@ -8,16 +8,12 @@
>>   #include "../reg.h"
>>   #include "../gsi_reg.h"
>>   
>> -/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
>> -
>>   REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
>>       0x0000c020 + 0x1000 * GSI_EE_AP);
>>   
>>   REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
>>       0x0000c024 + 0x1000 * GSI_EE_AP);
>>   
>> -/* All other register offsets are relative to gsi->virt */
>> -
>>   static const u32 reg_ch_c_cntxt_0_fmask[] = {
>>   	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
>>   	[CHTYPE_DIR]					= BIT(3),
>> @@ -66,10 +62,6 @@ static const u32 reg_error_log_fmask[] = {
>>   	[ERR_EE]					= GENMASK(31, 28),
>>   };
>>   
>> -REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
>> -
>> -REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
>> -
>>   REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
>>   	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
>>   
>> @@ -152,6 +144,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
>>   
>>   static const u32 reg_ch_cmd_fmask[] = {
>>   	[CH_CHID]					= GENMASK(7, 0),
>> +						/* Bits 8-23 reserved */
>>   	[CH_OPCODE]					= GENMASK(31, 24),
>>   };
>>   
>> @@ -159,6 +152,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
>>   
>>   static const u32 reg_ev_ch_cmd_fmask[] = {
>>   	[EV_CHID]					= GENMASK(7, 0),
>> +						/* Bits 8-23 reserved */
>>   	[EV_OPCODE]					= GENMASK(31, 24),
>>   };
>>   
> 
> [...]
> 
> (offtopic)
> 
> I hope all those gsi_reg-v*.c are autogenerated? They look pretty scary
> to be written and edited manually each time :D

I know they look scary, but no, they're manually generated and
it's a real pain to review them.  I try to be consistent enough
that a "diff" is revealing and helpful.  For the GSI registers,
most of them don't change (until IPA v5.0).  I intend to modify
this a bit further so that registers that are the same as the
previous version don't have to be re-stated (so each new version
only has to highlight the differences).

All that said, once created, they don't change.

Thanks.

					-Alex

> 
> Thanks,
> Olek

