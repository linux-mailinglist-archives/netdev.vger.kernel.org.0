Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2059326CC66
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgIPUns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgIPRD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:03:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7721AC0258FA;
        Wed, 16 Sep 2020 09:59:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l9so3790405wme.3;
        Wed, 16 Sep 2020 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1Cyg0WIppUnNjtSQjb5xzehZs4xNIP5GmeGygQdn4yo=;
        b=rvPzgDuJ+cVuZ5Hx+9BQPemjI1Y70qzwAVVQEeYKOtQjKMFR6beZHS+KEszMZdFjO6
         Aleit13kXaRzgU1wgxMoxMxGWKCrB/l/f5Kndr71xLi0+6371kqmSanFtiBKav6HRFe8
         68ximSA9OCEKJyaTMWMDLe4CryacLImZ3zWePzp+1apJ71Ll641acOahO6yJZxZuafh2
         cfiSAGzYMSdU/kZiLlES2qtE1EJ0ky+OjOm7JxgaGlgwndhkbiwUGGrNy8l7wVaK4vC7
         zcwvAUCWEZxBhnaAToiGgGKO7FHAB2jb+2Q2+Jo5S042zN5PIagJXiUikIN2NMyK2wg8
         gDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1Cyg0WIppUnNjtSQjb5xzehZs4xNIP5GmeGygQdn4yo=;
        b=lWMJrGeqxCUxzMsEXaRAGSqQOy+uVWhZecEWd7dC9xURyhCDjmgskVkPxf+NKvxPJj
         lZewqxxpbeizQdxAwq3uGesibQAYZml3uou4mIoPL5u5FdSH9jICNBHywyJgmH7xCQ/7
         ajuD5rxjZ+EiylvvDYgoJdSUi1U226PSfStwHXtyr9R2wLV8tj4Jw9CSTN7D+IdJRs7p
         ftf8E/tIAGkC8k1F35Ey752Gcy34gBm3tgcoAfp7bZ+2sbo9mLj0joe5io+/yTYPApyS
         qihFgjOh4ChUsDiSpGMag+gwgqHfuJO8hNDEP3IiPOtKLFBQCSX8WGkuq8qwS5JJMODI
         43fw==
X-Gm-Message-State: AOAM532mIFJJVLD2Uf7Gg5MjPLlpVwUuwUB9Pb2m0ldbPuEatENMH2yE
        D2xsOdMbiYgljF+0nmSAL3w=
X-Google-Smtp-Source: ABdhPJzCoxjasywHVAn6Hb2IHWmpF2ygM4DriiiSTBMx2ZYCjMTJNnY6K+2m4NlxnokqZwZ66/AgGw==
X-Received: by 2002:a1c:7502:: with SMTP id o2mr5552050wmc.29.1600275553009;
        Wed, 16 Sep 2020 09:59:13 -0700 (PDT)
Received: from [192.168.0.18] (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id s17sm35710235wrr.40.2020.09.16.09.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 09:59:12 -0700 (PDT)
Subject: Re: [PATCH] ath10k: sdio: remove reduntant check in for loop
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20200914191925.24192-1-alex.dewar90@gmail.com>
 <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
From:   Alex Dewar <alex.dewar90@gmail.com>
Message-ID: <57efff54-7aa4-8220-c705-1fdf35b0099e@gmail.com>
Date:   Wed, 16 Sep 2020 17:59:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[snip]
> 'i' is only referenced once inside the loop to check boundary,
>
> the loop is actually iterating over cur_section, so i would make it
> clear in the loop statement, e.g.:
> Remove the break condition and the cur_section assignment at the end of
> the loop and use the loop statement to do it for you
>
> for (; cur_section; cur_section = next_section)
>
>
>>   		section_size = cur_section->end - cur_section->start;
>>   
>>   		if (section_size <= 0) {
>> @@ -2318,7 +2318,7 @@ static int
>> ath10k_sdio_dump_memory_section(struct ath10k *ar,
>>   			break;
>>   		}
>>   
>> -		if ((i + 1) == mem_region->section_table.size) {
> And for i you can just increment it inline:
> if (++i == ...)

Good suggestions! I've sent a v2 with these changes.

>      
>
>> +		if (i == mem_region->section_table.size) {
>>   			/* last section */
>>   			next_section = NULL;
>>   			skip_size = 0;

