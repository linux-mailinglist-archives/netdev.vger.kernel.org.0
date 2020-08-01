Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671ED235099
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 07:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgHAFYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 01:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHAFYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 01:24:21 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AC5C06174A;
        Fri, 31 Jul 2020 22:24:21 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t6so10216311qvw.1;
        Fri, 31 Jul 2020 22:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V715tYEk/Zgi1im5m3O0h6sZw8JhvDcKruumX1zWpz8=;
        b=S3BDnKtw74sHJsZcOpaZos1xD9WB0tLnC8q0s5WG790JlXBy3t9hayccMV988frutz
         dwF0UWXUHCJiaLs1AUqVIdn95KvOtvF6/2sieKi8dj1c0B3K7crDcKHbv2G6by2eemsQ
         MM9iacf8cYVPw1TjDVzAI+5hAVTSeToCovWVLZB5pRfaGBBYs/FEhm6cY5B9HMUaGLR5
         pe77E4KUaLS12m7A9OGV4GpqhCNnV3vxeELaB3hCPP7RrunKBkelw6MTegnO75M2opse
         n/up6mPdKYwPoivWi1DORh3J3dYy56tAagNH8aDF+GgHGv+pJBexFx1VH/9cv1ee0GRs
         MmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V715tYEk/Zgi1im5m3O0h6sZw8JhvDcKruumX1zWpz8=;
        b=YZw7xjtrCHZM0hYDY7UZ/8aqzIEj9UyZDO8dUBeUUeuFYJpYyZ7IaTka17c5JuR7RP
         Tr2fgvsEgCN+rsXWRZ76rGy9EwxGa+fUIBv0udGtWz1IPVus5sFo9fx1ErwbQGluls1M
         PXhdWOFRbNSFdVRqvtPWcqDBTQbng6ncuDl5ZvbBjm4mbCxMI4UPST8tWJvrAIqroLrh
         BJy4uJM/gGRc0YiMZHPfBQip+PsNVf/rzkNnRrez3PlUWlqhDtZ8+QnVDwsIakcCMPw4
         mWOdGNeb/8AqLReVdlv2T06xpZO5Ept5nJpTZpwhdVc3llK9hks38L2B3wPhCuElwBOp
         4Dvg==
X-Gm-Message-State: AOAM533gvvUfBkSUr26D5FTriP7oVFA7ipzqHbwO+qmxFLGFEISISwVX
        BWYrsHxAznYWK7uBxEmBw/QHVFqO
X-Google-Smtp-Source: ABdhPJzRNLzhXovITxrID0ydZoaxo40Nu8MgY+3V/Cb83y7V0UK2Dsvda3IKOy9AlryoMQRxUVmeCg==
X-Received: by 2002:ad4:4302:: with SMTP id c2mr7155176qvs.246.1596259459939;
        Fri, 31 Jul 2020 22:24:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u21sm11183516qkk.1.2020.07.31.22.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 22:24:19 -0700 (PDT)
Subject: Re: [PATCH v2 0/3]
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
 <c6c5b3c5-f862-9cee-6863-24f666cc28f5@gmail.com>
 <000701d667c2$0782fe70$1688fb50$@codeaurora.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e96d720c-5a60-7535-b615-c186bc14b38f@gmail.com>
Date:   Fri, 31 Jul 2020 22:24:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000701d667c2$0782fe70$1688fb50$@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/2020 10:10 PM, Rakesh Pillai wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Saturday, August 1, 2020 12:17 AM
>> To: Rakesh Pillai <pillair@codeaurora.org>; ath10k@lists.infradead.org
>> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
>> kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH v2 0/3]
>>
>> On 7/31/20 11:27 AM, Rakesh Pillai wrote:
>>> The history recording will be compiled only if
>>> ATH10K_DEBUG is enabled, and also enabled via
>>> the module parameter. Once the history recording
>>> is enabled via module parameter, it can be enabled
>>> or disabled runtime via debugfs.
>>
>> Why not use trace prints and retrieving them via the function tracer?
>> This seems very ad-hoc.
> 
> Tracing needs to be enabled to capture the events.
> But these events can be turned on in some kind of a debug build and capture the history to help us debug in case there is a crash.
> It wont even allocate memory if not enabled via module parameter.

I would suggest researching what other drivers do and also considering
the benefits, for someone doing system analysis of plugging into the
kernel's general tracing mechanism to have all information in the same
place and just do filtering on the record/report side.
-- 
Florian
