Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934143115A8
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBEWiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhBENhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 08:37:47 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAEAC061794
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 05:37:06 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id a16so5820048ilq.5
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 05:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zJIqK4oiGxD4mA82lsvyaEI4gUPeF1VfFpQthFbJ0uQ=;
        b=XZ9IiNE48Aran2h3YLooLj/xyuGoN0yF/jjYVvnW+tjTsJbL7JGksIB22cRKrR5ZeG
         aQ9MN9xH+yp2YHiyXy7Wvyayl7MhgqVeIWeAHlWBVLZ2g69qzPN8QjS0ry3Avk87kmbE
         mrS0Hmmx0vl+JNGq4zbWfS9gY5GZd9yB+fl8w/ztqYfULriPkzRSw0Jm8k7GBUqULgQP
         STmmB/bu+L88jSve1erdk+ZGfjq+gsXFfp1dl+CaD0RuA6Ng6JdyZzaSyJuk+chuB+F6
         e5qs83YQnuKRJ+ryLWyy5XwH7ksZV22NIBXxCYOWvQ6S7en6guxybxZYA0R+u2G2AnH/
         ZBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJIqK4oiGxD4mA82lsvyaEI4gUPeF1VfFpQthFbJ0uQ=;
        b=NZbfBLxEGM6NFqImBzfOlNSVoZ3uNIjatqPrKeb+apNsSbsMzN7BtlzqVo9rpJa/60
         IzVhFgTR1eMbaK75kdToATePzjodH3Ai//HerZJckAMqQW0XiGUHbkgEzoubQjToZBQK
         sdo9wynb8tcUiRmXIlbqiK6iQCe9kPatuKLRYppNrv+a9MUscTc286LRTqPhUBk4Y1h4
         DQ5k0G6LHFTPD2xaS4guRTtVMmJFM8Ua51oZDwlJ8KZ0p242Z4EEpz8lmoNO/ZLVuvie
         8f+mZuka4ljMgHtDx7D32Veqet0NbdsobYuGtM+sEFl+hPHi3crhoiMo7sQwKEXvNl9Y
         tJhA==
X-Gm-Message-State: AOAM531juSRSoNL8+vvCCnBiSjkVWJupiubB4CZJG5/4ANRyxtEnMZk7
        LqqwM1hbYLYuGmhNDAIAqIIP+A==
X-Google-Smtp-Source: ABdhPJwpLa4r6HWRIEy2ZuEJNr9XksrmXLFLgY9dF31jisYPBENUoWZIwHhCExxrIxl/sgXkgjR3hA==
X-Received: by 2002:a05:6e02:20ca:: with SMTP id 10mr3950429ilq.14.1612532225956;
        Fri, 05 Feb 2021 05:37:05 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l7sm4206824ils.48.2021.02.05.05.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 05:37:05 -0800 (PST)
Subject: Re: [PATCH net-next 1/7] net: ipa: restructure a few functions
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210203152855.11866-1-elder@linaro.org>
 <20210203152855.11866-2-elder@linaro.org>
 <20210204205059.4b218a6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <2946916e-9f1d-b73a-72b1-5f4ce8b2cc6c@linaro.org>
Date:   Fri, 5 Feb 2021 07:37:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210204205059.4b218a6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/21 10:50 PM, Jakub Kicinski wrote:
> On Wed,  3 Feb 2021 09:28:49 -0600 Alex Elder wrote:
>> Make __gsi_channel_start() and __gsi_channel_stop() more structurally
>> and semantically similar to each other:
>>   - Restructure __gsi_channel_start() to always return at the end of
>>     the function, similar to the way __gsi_channel_stop() does.
>>   - Move the mutex calls out of gsi_channel_stop_retry() and into
>>     __gsi_channel_stop().
>>
>> Restructure gsi_channel_stop() to always return at the end of the
>> function, like gsi_channel_start() does.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/net/ipa/gsi.c | 45 +++++++++++++++++++++++--------------------
>>  1 file changed, 24 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
>> index 53640447bf123..2671b76ebcfe3 100644
>> --- a/drivers/net/ipa/gsi.c
>> +++ b/drivers/net/ipa/gsi.c
>> @@ -873,17 +873,17 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
>>  
>>  static int __gsi_channel_start(struct gsi_channel *channel, bool start)
>>  {
>> -	struct gsi *gsi = channel->gsi;
>> -	int ret;
>> +	int ret = 0;
>>  
>> -	if (!start)
>> -		return 0;
>> +	if (start) {
>> +		struct gsi *gsi = channel->gsi;
>>  
>> -	mutex_lock(&gsi->mutex);
>> +		mutex_lock(&gsi->mutex);
>>  
>> -	ret = gsi_channel_start_command(channel);
>> +		ret = gsi_channel_start_command(channel);
>>  
>> -	mutex_unlock(&gsi->mutex);
>> +		mutex_unlock(&gsi->mutex);
>> +	}
> 
> nit: I thought just recently Willem pointed out that keeping main flow
>      unindented is considered good style, maybe it doesn't apply here
>      perfectly, but I'd think it still applies. Why have the entire
>      body of the function indented?

I *like* keeping the main flow un-indented (the way
it was).

It's a little funny, because one of my motivations for
doing it this way was how I interpreted the comment
from Willem (and echoed by you).  He said, "...easier
to parse when the normal control flow is linear and
the error path takes a branch (or goto, if reused)."
And now that I read it again, I see that's what he
was saying.

But the way I interpreted it was "don't return early
for the success case," because that's what the code
in question that elicited that comment was doing.

In any case I concur with your comment and prefer the
code the other way.  I will post v2 that will fix this,
both here and in __gsi_channel_start().

Thanks.

					-Alex

> 
>>  	return ret;
>>  }
>> @@ -910,11 +910,8 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>>  static int gsi_channel_stop_retry(struct gsi_channel *channel)
>>  {
>>  	u32 retries = GSI_CHANNEL_STOP_RETRIES;
>> -	struct gsi *gsi = channel->gsi;
>>  	int ret;
>>  
>> -	mutex_lock(&gsi->mutex);
>> -
>>  	do {
>>  		ret = gsi_channel_stop_command(channel);
>>  		if (ret != -EAGAIN)
>> @@ -922,19 +919,26 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
>>  		usleep_range(3 * USEC_PER_MSEC, 5 * USEC_PER_MSEC);
>>  	} while (retries--);
>>  
>> -	mutex_unlock(&gsi->mutex);
>> -
>>  	return ret;
>>  }
>>  
>>  static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
>>  {
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	/* Wait for any underway transactions to complete before stopping. */
>>  	gsi_channel_trans_quiesce(channel);
>>  
>> -	ret = stop ? gsi_channel_stop_retry(channel) : 0;
>> +	if (stop) {
>> +		struct gsi *gsi = channel->gsi;
>> +
>> +		mutex_lock(&gsi->mutex);
>> +
>> +		ret = gsi_channel_stop_retry(channel);
>> +
>> +		mutex_unlock(&gsi->mutex);
>> +	}
>> +
>>  	/* Finally, ensure NAPI polling has finished. */
>>  	if (!ret)
>>  		napi_synchronize(&channel->napi);
>> @@ -948,15 +952,14 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
>>  	struct gsi_channel *channel = &gsi->channel[channel_id];
>>  	int ret;
>>  
>> -	/* Only disable the completion interrupt if stop is successful */
>>  	ret = __gsi_channel_stop(channel, true);
>> -	if (ret)
>> -		return ret;
>> +	if (ret) {
> 
> This inverts the logic, right? Is it intentional?
> 
>> +		/* Disable the completion interrupt and NAPI if successful */
>> +		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>> +		napi_disable(&channel->napi);
>> +	}
>>  
>> -	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
>> -	napi_disable(&channel->napi);
>> -
>> -	return 0;
>> +	return ret;
>>  }
>>  
>>  /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
> 

