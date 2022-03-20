Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4E34E1D49
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245742AbiCTSEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 14:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245743AbiCTSEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 14:04:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4769E3A73F
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 11:03:14 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso7296112wmz.4
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 11:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Wur3Gr2lZCA8WSdLdjbJrUbR8JebUaR8BljbfzA1wHE=;
        b=Ggv9TffUnipbh1pKUc1k8M7NX5m0uX/GmuHOCDbRrQ3QE5BNe3mNiv4wSWrBiZlhQ+
         9rlVECFOklXwSB2tMOo4Yio67kyHT7EzRW+k8ESZRCFuN5Nx2qvMnxavIvaok0xbzfNb
         R57A2QGk01k0exi993vSHbj15PNmvvm3gUgcUW5xwUyIkMshF2KuZemP+UWh7t1KptMh
         NT9x/BcuQpjjpubJtBsZbEOsCrUpcgIgv6IouUQxlHS+uHV4F8UvOJ+5TjoUGJYLKkoN
         OswuTFxwPh7uHi6iy23mhAowAavWH4U8GDCJH5ILXRR8q1xZGXmSw+D07M5q+L9YPBsx
         G9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Wur3Gr2lZCA8WSdLdjbJrUbR8JebUaR8BljbfzA1wHE=;
        b=P+QjHV1Zeod4Jp4P9PZnlnxP3TfjT6ZY7y5YMqWsOq+JRnfX4RDXan4CmGZnYg06GW
         /2DKQHveOj9XTFRvuSZwNErGzlwtMIdgMGD8bdAyw2vXKIBAzXPbhQq1/X7/3lOedH9l
         QMBPpqmkXqCtUb0qQiOAjl8HbMXq9t/SRb/fKsUWYXVlP5Zcldf3N32INPEOIWjwHd9J
         5tCBkOTxJYZK47x+epG+zKsMQav1/zfP8H42za9g4fYHEy2JJ7wYL4ZoLN8muhaqX8kO
         3iXnwMKfP8y5LFj+kii24I0dk0/J5HFhKrTspTYJmzRYNRJYCkC7UfRWZYaM7hfmLTUj
         ezCA==
X-Gm-Message-State: AOAM533vBIX9QWHTKB7C7FgAujqTllZ3PMP6G09VcMayOsqSapAcCoZH
        BRIylbDERPFLtfCNgZ+q3XAz4A==
X-Google-Smtp-Source: ABdhPJxvHYeRUXTjFPf76c0NGheufnBvl4MJZkjFWLVW09XU/Gu4wlmGmU4t/Lys/fhzY+bO1UDWcA==
X-Received: by 2002:a05:600c:3506:b0:389:d567:e9fa with SMTP id h6-20020a05600c350600b00389d567e9famr16229794wmq.74.1647799392724;
        Sun, 20 Mar 2022 11:03:12 -0700 (PDT)
Received: from [192.168.0.69] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b00389cc36a3bfsm15630498wmp.6.2022.03.20.11.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 11:03:12 -0700 (PDT)
Message-ID: <cda7eaa6-fb99-0d32-24fb-758b9363ee6d@linaro.org>
Date:   Sun, 20 Mar 2022 18:03:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318195804.4169686-1-egagnon@squareup.com>
 <20220318195804.4169686-3-egagnon@squareup.com>
 <c8f31312-5356-704e-1f55-89c9f5888238@linaro.org>
In-Reply-To: <c8f31312-5356-704e-1f55-89c9f5888238@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2022 13:21, Bryan O'Donoghue wrote:
> On 18/03/2022 19:58, Edmond Gagnon wrote:
>> +    INIT_DELAYED_WORK(&wcn->get_stats_work, wcn36xx_get_stats_work);
> 
> Instead of forking a worker and polling we could add the relevant SMD 
> command to
> 
> static int wcn36xx_smd_tx_compl_ind(struct wcn36xx *wcn, void *buf, 
> size_t len)
> {
>      wcn36xx_smd_get_stats(wcn, 0xSomeMask);
> }
> 
> That way we only ever ask for and report a new TX data rate when we know 
> a TX event - and hence a potential TX data-rate update - has taken place.
> 
> ---
> bod
> 

Thinking a bit more

- Do the SMD get_stats in the tx completion
   This might be a problem initiating another SMD transaction inside
   of an SMD callback. But is the most straight forward way to
   get the data while avoiding alot of needless polling.

- Schedule your worker from the TX completion
   Again you should only care about gathering the data when you know
   something has happened which necessitates gathering that data
   like TX completion

- Schedule your worker from the RX indication routine
   Seems not as logical as the first two but it might be easier
   to schedule the worker in the RX data handler

Either way, I do think you should only gather this data on an event, not 
as a continuous poll.

---
bod
