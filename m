Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B67219179
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGHU1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGHU1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:27:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191D8C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:27:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s26so6827292pfm.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ToJzbdYs6xui2Ecf1WAzRUlAxl4aife6b607dTzimxw=;
        b=XU+WP2iYp+FLAs8byopqgt3gmQdT0Pza4tUKPy8Wnjoqw1jAFBHHuKvx3jgitCC/ON
         d+eUnSmaVIGh5qJXXOFm3M1cGhGht/ijNg2phhbZUd0df0ZsezwoaRHIYTm11JoUVZ5k
         9HvrCI3UBcdFjZgykaWLkPbK6S5iRfyclIOzazY72B1fpz+QmrpkWujl7/7jzlJDpMg5
         7k/T0J/04ya/OehQPEtQKqz0BNwLffI+sA88qQNHq8NLnpZADYU95s3Y0FTdwzMXrMIt
         +nU/t/0vAM5GXrPNGUM9v+MksXkH7jg9+spBGtBc+kJyo6rTYkFWauWh5Ik1d/Qc25Q0
         dsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ToJzbdYs6xui2Ecf1WAzRUlAxl4aife6b607dTzimxw=;
        b=N2HIL61f8/VqFq++/GfE2LWeAgvamlVkCcZCJwxfN3bLRenrI9+ffI2ItnUh1lKrZX
         d9OTyBjerAMdfyguo9CcvBi2hTiCvV8R1YlFntLvE6xdhWnfjsRjQ49IXJ4QQEvCEPrN
         kQqCVE0zbcYGyLSgs/XKbv+jRn+Dgc+RS/RZzgNVNkdFNFNAlwsEwXuNC53Gu4kHHDtV
         djMUqwrwZc7cpcHWEuwZt8MbDN+ze6BAkTvUOhGgTHYNwAtc9CRSomc/iadp0KmcF9yz
         42cX5H6b8KPz+kGbqPoHora8T1Kp6IZQbwiPeQOQjJldrVpN79voEsyR49OnKeMLXmY/
         TY0g==
X-Gm-Message-State: AOAM530owK80/aX4tDiu8BBJUCej9rEwkicLXGvMiEPc1AFTZdQFB0sv
        8jxADpxgBImMaNlgxGuueJJ3eGVp
X-Google-Smtp-Source: ABdhPJwIWvOky0mgQQ7BnPTAe7cCLMlmyCR/XRcYOaI6Bq4/dkGwxdFgy/8m1RIvphKU5nuz+k+2Kg==
X-Received: by 2002:aa7:8b4b:: with SMTP id i11mr55933196pfd.123.1594240033394;
        Wed, 08 Jul 2020 13:27:13 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t73sm586052pfc.78.2020.07.08.13.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 13:27:12 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
To:     David Miller <davem@davemloft.net>, xiangning.yu@alibaba-inc.com
Cc:     netdev@vger.kernel.org
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
 <20200708.123750.2177855708364007871.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e6ff5906-45a6-79c7-7f91-830eccea8a58@gmail.com>
Date:   Wed, 8 Jul 2020 13:27:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708.123750.2177855708364007871.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 12:37 PM, David Miller wrote:
> From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
> Date: Thu, 09 Jul 2020 00:38:16 +0800
> 
>> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>>  	return true;
>>  #endif /* CONFIG_SMP */
>>  }
>> -
>> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
> 
> You either removed the need for kthreads or you didn't.
> 
> If you are queueing IRQ work like this, you're still using kthreads.
> 
> That's why Eric is asking why you still need this export.
> 

I received my copy of the 2/2 patch very late, I probably misunderstood
the v2 changes.

It seems irq_work_queue_on() is till heavily used, and this makes me nervous.

Has this thing being tested on 256 cores platform ?

