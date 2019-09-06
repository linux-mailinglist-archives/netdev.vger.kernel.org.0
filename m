Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11F5ABF89
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406102AbfIFSn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:43:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43273 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406099AbfIFSn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:43:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id u72so3943239pgb.10
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 11:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pa8io9yXJMs/zOZWzmW6P51ix6IEO/atvnU4K0NBvTg=;
        b=NX36fLxet+JT2o48hgNq8YwExuid7q+z1p5SvDh3rLCw8WxYcQXLUKRSR6yXXbKm3G
         y3u1mnnZWrQfMA2zdoovHqdwreAXH/G9Uz9+WMs6bVnYCNcbRn87mZciWfPS57p+tXzC
         ikhCeb9VEPg+r0r3aZ81mAxyUADU5JognSx3HLP9kaOrKpnyXuA3i2Q1SRd4l4TX+h9S
         UHKtyrBFPwBmh3+FEhLEPxJT0OHrqZ2jNkYEU6iLMQ4wem9rwirWEn1qLvSeqVcVXdRK
         amw9KNj7qDLZs2r5Xw9m3IdFpZ4MkBTIXVWuQGjgoDCCRdfxerVuTh823U6d/A4AnSJ+
         ulRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pa8io9yXJMs/zOZWzmW6P51ix6IEO/atvnU4K0NBvTg=;
        b=WIGGgX3W+mHE/qOu0nblTyNq89gyxXiNPupGdTyG4b4KffRXO1lxna7O7A16PQ37fT
         sUlDcSiD/cNy0iba7NDxYHJx8reQMK7UJdyrXzhFE+ylKk4FzmvhylrPl0qPMEi+sbUI
         xxT0+gqygEKnkK1ZlvfMPdjvZTAlf7pDq5+x5g0I9XxOuwHrnfzww8El9H86FubWOB9V
         iMrzqDYfuRGpn9nvisrEhL9f2akLUc9BjhKqnbbJp9jnkK3ix32Imfapi8il5dDtM0kx
         efkh+Z/YB2+gcDHaPiL0MKufubeBeZ6czkNqKRP/iAuld4g/LDrOj5PM2T/GmPA2oU1i
         C2LA==
X-Gm-Message-State: APjAAAVQriZlsH8mqtxqLv9UzT9EDVa8aGjfV/418yB0rm5buuqJHeSR
        /gXz0ZVgWGTQ7Sa6z1erVDMl5A==
X-Google-Smtp-Source: APXvYqyditRalYrgDOwSGTgtRj6uP+sO+7byEced+WRXvUDWXRYc+HCqEyjkeY1VjDX2Dkr2Nubs5w==
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr8646795pja.26.1567795405805;
        Fri, 06 Sep 2019 11:43:25 -0700 (PDT)
Received: from [172.22.3.211] ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c11sm14647213pfj.114.2019.09.06.11.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:43:24 -0700 (PDT)
Subject: Re: [net-next 02/11] devlink: add 'reset_dev_on_drv_probe' param
To:     Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
References: <20190906160101.14866-1-simon.horman@netronome.com>
 <20190906160101.14866-3-simon.horman@netronome.com>
 <20190906183106.GA3223@nanopsycho.orion>
From:   Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Message-ID: <8066ba35-2f9b-c175-100f-e754b4ca65be@netronome.com>
Date:   Fri, 6 Sep 2019 11:40:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190906183106.GA3223@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/19 11:31 AM, Jiri Pirko wrote:
> Fri, Sep 06, 2019 at 06:00:52PM CEST, simon.horman@netronome.com wrote:
>> From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
>>
>> Add the 'reset_dev_on_drv_probe' devlink parameter, controlling the
>> device reset policy on driver probe.
>>
>> This parameter is useful in conjunction with the existing
>> 'fw_load_policy' parameter.
>>
>> Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
>> Signed-off-by: Simon Horman <simon.horman@netronome.com>
>> ---
>> Documentation/networking/devlink-params.txt | 14 ++++++++++++++
>> include/net/devlink.h                       |  4 ++++
>> include/uapi/linux/devlink.h                |  7 +++++++
>> net/core/devlink.c                          |  5 +++++
>> 4 files changed, 30 insertions(+)
>>
>> diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
>> index fadb5436188d..f9e30d686243 100644
>> --- a/Documentation/networking/devlink-params.txt
>> +++ b/Documentation/networking/devlink-params.txt
>> @@ -51,3 +51,17 @@ fw_load_policy		[DEVICE, GENERIC]
>> 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
>> 			  Load firmware currently available on host's disk.
>> 			Type: u8
>> +
>> +reset_dev_on_drv_probe	[DEVICE, GENERIC]
>> +			Controls the device's reset policy on driver probe.
>> +			Valid values:
>> +			* DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN (0)
>> +			  Unknown or invalid value.
> Why do you need this? Do you have usecase for this value?


I added this in to avoid having the entire netlink dump fail when there 
are invalid values read from hardware.

This way, it can report an unknown or invalid value instead of failing 
the operation.


>
>
>> +			* DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS (1)
>> +			  Always reset device on driver probe.
>> +			* DEVLINK_PARAM_RESET_DEV_VALUE_NEVER (2)
>> +			  Never reset device on driver probe.
>> +			* DEVLINK_PARAM_RESET_DEV_VALUE_DISK (3)
>> +			  Reset only if device firmware can be found in the
>> +			  filesystem.
>> +			Type: u8
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 460bc629d1a4..d880de5b8d3a 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -398,6 +398,7 @@ enum devlink_param_generic_id {
>> 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MAX,
>> 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
>> 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
>> +	DEVLINK_PARAM_GENERIC_ID_RESET_DEV,
>>
>> 	/* add new param generic ids above here*/
>> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>> @@ -428,6 +429,9 @@ enum devlink_param_generic_id {
>> #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME "fw_load_policy"
>> #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE DEVLINK_PARAM_TYPE_U8
>>
>> +#define DEVLINK_PARAM_GENERIC_RESET_DEV_NAME "reset_dev_on_drv_probe"
> The name of the define and name of the string should be the same. Please
> adjust.


Sure, I will make the change.

Thanks for the review.

