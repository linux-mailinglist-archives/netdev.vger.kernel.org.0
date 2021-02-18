Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4215131ED40
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhBRRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhBRODn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:03:43 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F47BC0613D6
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:03:03 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id w1so1513981ilm.12
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AQCq51Tg/1SeOfoa+uxrlicnQ4lUT4BdKs1EA+O+j5A=;
        b=K4c6Sgtezftr+PqnzBKVs6LkPM93OTEBhTNsxmEc+RUHx2CCAoTFj9kdZo0JZWcHlC
         R/CCuRExlOQk7HkY3shFzz0rhInLITSPPIg81wH/U9pJ+PZFUvs04Ue/cD5pwAHzEbaJ
         w8M9z3S+b+zlOiIRspADhs1DLYBWzrSvIaV4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AQCq51Tg/1SeOfoa+uxrlicnQ4lUT4BdKs1EA+O+j5A=;
        b=uZ68PeXehoqO5lJkuF1T2ot/O8/2MFLkyi7NSHWOyWGfal7RVFv87vukHKpV0Nw0K9
         Wn4+A/ZGzz97F1wXvH3S2nWKUZMibZBLMn6Zn8r9VypSa9OoJlGfsIanZNnclx+DCUH3
         FvCMHUx8HL5EIVgF7uvWwiPiafgMSXa9CIALcOq/7buIeCGh5EWrxCdk/lEL4PGnoV1w
         OSUePthFiVgHpveFIHb7KWlhLivlFTJ/2u2VEFoWpbjPiF7VNsRlHVMiykfl22axfA76
         BV20SVzlcFn32Q9bNcN9hlmKQqADxzbOshQ3pt1X1Vy6YwUhrUPu/Ba0a1vKAKGHGFer
         J/Tw==
X-Gm-Message-State: AOAM532AfVTAa+2yLrtN3rQegjruu5AyiOm7RI1HP1Z0gK2vI9Gpzgve
        87RAvFYdIPnxrLFrll/t4r+wBQ==
X-Google-Smtp-Source: ABdhPJypDmUKD7+s1//4JSq/84zKYS+x9xKDjlAsUmNrZ4bBQ5/yaHrP3fzfw/HwvZ4XEBAkdV9/OA==
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr3902702ild.178.1613656982796;
        Thu, 18 Feb 2021 06:03:02 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y1sm4320764ilj.50.2021.02.18.06.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 06:03:01 -0800 (PST)
Subject: Re: [PATCH] Revert "ath9k: fix ath_tx_process_buffer() potential null
 ptr dereference"
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, nbd@nbd.name,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210217211801.22540-1-skhan@linuxfoundation.org>
 <20210218062333.37872C43462@smtp.codeaurora.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <18c2b014-406f-1976-d3aa-354dc285f134@linuxfoundation.org>
Date:   Thu, 18 Feb 2021 07:02:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210218062333.37872C43462@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 11:23 PM, Kalle Valo wrote:
> Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> This reverts commit a56c14bb21b296fb6d395164ab62ef2e419e5069.
>>
>> ath_tx_process_buffer() doesn't dereference or check sta and passes it
>> to ath_tx_complete_aggr() and ath_tx_complete_buf().
>>
>> ath_tx_complete_aggr() checks the pointer before use. No problem here.
>>
>> ath_tx_complete_buf() doesn't check or dereference sta and passes it on
>> to ath_tx_complete(). ath_tx_complete() doesn't check or dereference sta,
>> but assigns it to tx_info->status.status_driver_data[0]
>>
>> ath_tx_complete_buf() is called from ath_tx_complete_aggr() passing
>> null ieee80211_sta pointer.
>>
>> There is a potential for dereference later on, if and when the
>> tx_info->status.status_driver_data[0]is referenced. In addition, the
>> rcu read lock might be released before referencing the contents.
>>
>> ath_tx_complete_buf() should be fixed to check sta perhaps? Worth
>> looking into.
>>
>> Reverting this patch because it doesn't solve the problem and introduces
>> memory leak by skipping buffer completion if the pointer (sta) is NULL.
>>
>> Fixes: a56c14bb21b2 ("ath9k: fix ath_tx_process_buffer() potential null ptr dereference")
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Thanks. I added the commit id and Fixes tag to the commit log, see the new version above.
> 

Thanks. Sorry for forgetting the Fixes tag.

thanks,
-- Shuah
