Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D888826E6E5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgIQUrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:47:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBA9C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:47:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j34so2054488pgi.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=53Yl9TmDalvpQhOhIQGibD5H7gsw81T9lS6PCvS70zs=;
        b=BA1BQGBhvzF8SxI2mkBK2kqx1PFKE/a1pHOHqHLwsQEXas7xd7i41vVC3eCKfrMenl
         q/RzKPmfo3EffVdnXXML3ZY2Hh3JQ5CmbCLoTobgvDFpe15Brh3xKXsQ/HHBa2uhx3Ip
         0+JMBd+T8EpJqMn92eM7/oFZIJZV6x6LVPCxBgi3Pm1Jhuw1MtxjlICrrutk5+H4U4G8
         i8C2zVhl0gCucSG21mmPk/yepMyAZ/8DPnkU6dqUoIXRGgbg5MdImGx/2AJ57lvW6K/6
         zujhomwEcIza/5r1YeG57S1NiNqJx7DLipTVZspC8wRd5OoIpNtIxEh+PIf8a4POjwcj
         R1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=53Yl9TmDalvpQhOhIQGibD5H7gsw81T9lS6PCvS70zs=;
        b=SlAvQ6hQy2ikBiDa2pC+5MdB2X+iluS38OC6jZtvA7cUEJdY8WXnPomR2+4kuAySIV
         sO+lIo+/sp34Gh1CwQcS0uHCAwqxeOlvQgCkSLFOAkN518+K1qxBA5Dmj9NBFRNSWbTM
         Vl4tXSvwvuAPTqThDB7Nrv5D9TYCyfzisnHA3eKP8T3cQChkbm6zd0HilzeuqVynbWTH
         29sI0llSj2RndMAfwi1l4UHGFlwOIbodOzMn0knvPEIWCDb9dhOKt8Ly2xItL6jn3Dkk
         +XLlg52GRyAumU/kzlarOBH1fTqjfX2u8653yaNK3khtOxRyLQ15ZzGSNJTNaEi08Ujb
         9qlg==
X-Gm-Message-State: AOAM532ivFbrEjlQKRhdZqzqSkZr2730eX6K5tlPR4Slx1ltJ3otf8Vz
        8d9p1gDreblJdPZyacrFY1YpQw==
X-Google-Smtp-Source: ABdhPJwiAzZMIUV0qSYifS2O0fkvffALmthjwNBw3nq86eQhbYMBOjX3j0egxtltudgBavB01ykDVw==
X-Received: by 2002:a62:7bc7:0:b029:138:9430:544e with SMTP id w190-20020a627bc70000b02901389430544emr29978911pfc.1.1600375630204;
        Thu, 17 Sep 2020 13:47:10 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 31sm486251pgs.59.2020.09.17.13.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:47:09 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 3/5] netdevsim: devlink flash timeout message
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-4-snelson@pensando.io>
 <20200917125017.70641be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <32b84713-7f35-e66b-e751-5feefe26c83f@pensando.io>
Date:   Thu, 17 Sep 2020 13:47:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917125017.70641be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:50 PM, Jakub Kicinski wrote:
> On Wed, 16 Sep 2020 20:02:02 -0700 Shannon Nelson wrote:
>> Add a simple devlink flash timeout message to exercise
>> the message mechanism.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/netdevsim/dev.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index 32f339fedb21..4123550e3f6e 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -768,6 +768,8 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
>>   						   component,
>>   						   NSIM_DEV_FLASH_SIZE,
>>   						   NSIM_DEV_FLASH_SIZE);
>> +		devlink_flash_update_timeout_notify(devlink, "Flash timeout",
>> +						    component, 81);
>>   		devlink_flash_update_status_notify(devlink, "Flashing done",
>>   						   component, 0, 0);
>>   		devlink_flash_update_end_notify(devlink);
> To mimic a more real scenario could we perhaps change the msg to "Flash
> select" ?
Sure.

sln

