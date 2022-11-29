Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59F863C603
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiK2RCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiK2RBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:01:40 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33B36CA27;
        Tue, 29 Nov 2022 08:59:48 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id a7-20020a056830008700b0066c82848060so9508926oto.4;
        Tue, 29 Nov 2022 08:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oOwITrigDk1OwF+Mi9TJDaYOfvuQYjStV/5P5QPsTVE=;
        b=Ph6g6yuPHSN6bBDrYCIA5FRELzz0eJnzTk99CfURB8VHM7YTSJ7KD+fu9ey6O0xebu
         SQtQE7tT52a5iLRxEpbcrn97WQ7RiD2/YBKTNOgj0M4IlbH32qYuiG4xlQgXDZ1qR25h
         GCOEemmkCPo+fvnbKMOvSSPQ/o9EwatS5JIRjx1mDUEQ/Lkotq+qtG/LrFAelXZ7XKxo
         ceOtH0+bsd/mHB78QTp0T/4O0SorX+H8mdRd8HdRcc8dNMupBs4pM3H+Q0Hb4dRURZnQ
         5FayDZh8E/Zur/2vBWT1L0xw24gz/5oE0JFoIOGZakmBt9Y6kIgfsAqPwpZeVUmbqE+c
         pRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oOwITrigDk1OwF+Mi9TJDaYOfvuQYjStV/5P5QPsTVE=;
        b=ImcDHszdr0jjYONSa9Aff+ci90eSGrBo/DnWMX2hpQkOF2We9oV6+vUjlLe4n9A/Mc
         NX69d6JAQGpBWnS0FCD1rTgJ3KGe/04kReNVrGF5683LqkubaKAASDQ81D7cy8rKl7HU
         umZ35OxBMwFTZd00jH2RPXVfP3JuSiE8t1L8yk/yTdzT4Fnj1NDNFzSURh71H/FVZZjE
         g1xq+/plL9iQYPHGT5wRIHoNRysqh0U1ju8lXTEOI1q89cutNXKy38YPMBd+03lw6SSq
         rhloC9kint44kPa61BQmPTn6lMpJ8ly+plT7+sha1bgvFFOyRfCfqMq/IgPa2tYj/TL5
         h4gA==
X-Gm-Message-State: ANoB5pkinCaOJD54uVQxzL1iN3IkqEpfcbtFJCs5yBRimWBDwJapvKnQ
        pDhMx2PdSN4znPotD3PNnNc=
X-Google-Smtp-Source: AA0mqf7Jfy6djaQXwh5cUseAZORmeDeYexzddszzZifjB5o47fSJLy1Sw8GZqrLlEg1dReTwXmAB5g==
X-Received: by 2002:a9d:6b8b:0:b0:66d:b1bf:dde8 with SMTP id b11-20020a9d6b8b000000b0066db1bfdde8mr18193666otq.18.1669741188001;
        Tue, 29 Nov 2022 08:59:48 -0800 (PST)
Received: from [192.168.0.158] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id x64-20020acae043000000b003458d346a60sm5718655oig.25.2022.11.29.08.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 08:59:47 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <d2113f20-d547-ce16-ff7f-2d1286321014@lwfinger.net>
Date:   Tue, 29 Nov 2022 10:59:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
To:     Jakub Kicinski <kuba@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
 <20221129100754.2753237-9-s.hauer@pengutronix.de>
 <20221129081753.087b7a35@kernel.org>
Content-Language: en-US
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20221129081753.087b7a35@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 10:17, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
>> +config RTW88_8821CU
>> +	tristate "Realtek 8821CU USB wireless network adapter"
>> +	depends on USB
>> +	select RTW88_CORE
>> +	select RTW88_USB
>> +	select RTW88_8821C
>> +	help
>> +	  Select this option will enable support for 8821CU chipset
>> +
>> +	  802.11ac USB wireless network adapter
> 
> Those kconfig knobs add so little code, why not combine them all into
> one? No point bothering the user with 4 different questions with amount
> to almost nothing.

I see only one knob there, name RTW88_8821CU. The other configuration variables 
select parts of the code that are shared with other drivers such as RTW88_8821CE 
and these parts must be there.

Larry

