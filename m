Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363201871CD
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbgCPSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:01:08 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38091 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730437AbgCPSBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:01:07 -0400
Received: by mail-pj1-f68.google.com with SMTP id m15so8420285pje.3
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oP44zQZnO9PeHFK6uB887nO6uamzTgiSUc6Q6McbwCM=;
        b=n+r5HJvgnT+H3UEQ2x57vDaytsQ9ZMetnHERcsXplowQpsJZyrfO64GnPk4mlMzNR3
         QA1P+6ItBNFkhCE7SQOHVbbKMOeyqjfYTGLf6OPbsfWUsQ0oABWM2G61PwD5ipGc1K2R
         HgY/XXS/EAv6tyl6vcQd4gNP3ap+sFx4aW1oc/Ujt09v8qjMqNj9eB0qHtZwTXwSNYDO
         lNmI5sQUM4hFZoc2ynofZk3J5INgPLZrEGhJqvVXrZRfVwr8qJdzdzqwKYw5GHw9KPqU
         rWkJ6a7NQ3NZli1N6gPTufodogSJbiplSLogCDtJ0Cq4EtSKNs2ZthXJB3AS+MTN6e8T
         0SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oP44zQZnO9PeHFK6uB887nO6uamzTgiSUc6Q6McbwCM=;
        b=jNM2zjoiis52xs5JN40LenpjE/uHyJjAxn13mC1pYKg8hARK6/sgeIX54Y7XzAW7yD
         ctnBx/EML7Oabb4Bh8XgEWVzDtC0B9NCRTEVEYJgUsiJM+EVB5tULF+hqhX2qy45jPQ4
         1xTK8yXvJrmJsUSzlik9L5rnLqnbYaY0+q0VDH8dnO5zqJiq0SMzFVtA31DulZL7zZvX
         SSgm+VMURnrXTIQBu2UPwLoy01lgPB57fl4ds4pMxQTpDy8NZo/i15WV87hWZxRO2QiJ
         7FlGulUedfWCjgboS++APYDz5SWEqumfqS9db3Q1ZiN/tPMJiOVCTJYTj8ENsF/2Vkac
         wT2Q==
X-Gm-Message-State: ANhLgQ1dR/5r3SrScE3lTidq/XsW48UfZZcUN4EQfbphN2NlVJMMBuYO
        YsVZgMcEtnk3/M3FpTSTVbQFFg==
X-Google-Smtp-Source: ADFU+vtIsM53ZZQ0t1FmwioGQHRACSPqLuazHTeGho4lTaso61txoTnU6Q+j/CLRH9GM0fhR8jlOxA==
X-Received: by 2002:a17:90a:2ec7:: with SMTP id h7mr742668pjs.107.1584381666484;
        Mon, 16 Mar 2020 11:01:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 5sm543717pfw.98.2020.03.16.11.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 11:01:05 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] ionic: remove adminq napi instance
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200316021428.48919-1-snelson@pensando.io>
 <20200316021428.48919-4-snelson@pensando.io> <20200316065212.GC8510@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <8cd1862f-d5db-65a8-bf53-46092b89fda4@pensando.io>
Date:   Mon, 16 Mar 2020 11:01:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200316065212.GC8510@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/20 11:52 PM, Leon Romanovsky wrote:
> On Sun, Mar 15, 2020 at 07:14:26PM -0700, Shannon Nelson wrote:
>> Remove the adminq's napi struct when tearing down
>> the adminq.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
> It looks like a fix to me, and I would expect Fixes line here.

I suppose they all could include Fixes tags, so I'll re-tag them and add 
a description line to the last one.

Perhaps all but the first could be promoted to net but they're not 
serious issues so I wasn't going to worry about that.

Thanks,
sln

