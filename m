Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393B41F55CB
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 15:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgFJN3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 09:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgFJN3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 09:29:33 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB7AC08C5C2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 06:29:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g1so1393609edv.6
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 06:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3e8bC/Ax9BOA2Qqmdvlceg2Mrom20tLBb9FMDRoA6eo=;
        b=EqyUKU7po/7+hPZYV1Dj3uiGUPJ5ITBTEk/rMgp6ak0CGVbHBllGnUD5h/aqefJnxj
         /fIenwtADhXRg1T8lK0QzyOetyHvPME+edY3lZDbqiiddexxk7FqSyrB6KT3Qz+LL9tv
         CEG3hyWmOtXRTyiK8VrNvo0sde7JNe1hyGs3nxdvvFhkhah1MlEnqi8R3OElWDeKgQiv
         jrkDOtnAiou8e0oZMOgOJrJVRgD049QpA+kMw5tIZfGt2xfbCLsVJPy3VmBYZjQPDNXE
         X2uJTGCrp2u13QWmsHWxc5x3UMBmW9+ewZ+bPoMzvBOfVh2qsrSkuR3v6bv7bgw1mvqW
         mgLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3e8bC/Ax9BOA2Qqmdvlceg2Mrom20tLBb9FMDRoA6eo=;
        b=NbwDLO9UHJs4IZO6RpU+vKn2/hOXCdHjkx13IbTQdkTO64CyrDcRo/NUCG7s8QhOmL
         /4F5X75/DE7P6LQM2BIFzHTfvakvQ2KkolUCHMYUVYgKyZjKXKOSQ+tq7mH9ZcZZpZaE
         Da4ynreOi7SsbL8KIov3VuXuwEx9i1mB941QiH5l/tM6EKD3jd2KDSVDUgNho5hneXxM
         +Sw6I+g8251x4kUytXpTZtnLv8XaF/tqJQ5u7UnfDlYHt1JMtc1+9EQ+xsSo16wUbADl
         f31ljCLhEDjY9jXJIQn+LIgnGrmu1aAQjDX6l2d0ZmB1TUMt89ypNBAcwDwoUgZWTfm9
         g1iA==
X-Gm-Message-State: AOAM531upiSMat6HDxUm3O9HA4x8i8EHEC6V9kP3d57cgTIkTVdxMN64
        A+1Jhwik6VEtBVOuo7x/O9LkHA==
X-Google-Smtp-Source: ABdhPJzVyANva+fJza2/Sfu3EJMVyNZvktU+OpnQzj6FWgSjEETySHwTT+qPdA8idoQZQ2NiKDwjVQ==
X-Received: by 2002:a50:f9cc:: with SMTP id a12mr2492130edq.227.1591795769805;
        Wed, 10 Jun 2020 06:29:29 -0700 (PDT)
Received: from [192.168.1.5] (212-5-158-114.ip.btc-net.bg. [212.5.158.114])
        by smtp.googlemail.com with ESMTPSA id b14sm15221126ejq.105.2020.06.10.06.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 06:29:29 -0700 (PDT)
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
Date:   Wed, 10 Jun 2020 16:29:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609111414.GC780233@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/20 2:14 PM, Greg Kroah-Hartman wrote:
> On Tue, Jun 09, 2020 at 01:46:03PM +0300, Stanimir Varbanov wrote:
>> Here we introduce few debug macros with levels (low, medium and
>> high) and debug macro for firmware. Enabling the particular level
>> will be done by dynamic debug with levels.
>>
>> For example to enable debug messages with low level:
>> echo 'module venus_dec level 0x01 +p' > debugfs/dynamic_debug/control
>>
>> If you want to enable all levels:
>> echo 'module venus_dec level 0x07 +p' > debugfs/dynamic_debug/control
>>
>> All the features which dynamic debugging provide are preserved.
>>
>> And finaly all dev_dbg are translated to VDBGX with appropriate
>> debug levels.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h      |  5 ++
>>  drivers/media/platform/qcom/venus/helpers.c   |  2 +-
>>  drivers/media/platform/qcom/venus/hfi_msgs.c  | 30 ++++-----
>>  drivers/media/platform/qcom/venus/hfi_venus.c | 20 ++++--
>>  .../media/platform/qcom/venus/pm_helpers.c    |  3 +-
>>  drivers/media/platform/qcom/venus/vdec.c      | 63 +++++++++++++++++--
>>  drivers/media/platform/qcom/venus/venc.c      |  4 ++
>>  7 files changed, 96 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> index b48782f9aa95..63eabf5ff96d 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -15,6 +15,11 @@
>>  #include "dbgfs.h"
>>  #include "hfi.h"
>>  
>> +#define VDBGL(fmt, args...)	pr_debug_level(0x01, fmt, ##args)
>> +#define VDBGM(fmt, args...)	pr_debug_level(0x02, fmt, ##args)
>> +#define VDBGH(fmt, args...)	pr_debug_level(0x04, fmt, ##args)
>> +#define VDBGFW(fmt, args...)	pr_debug_level(0x08, fmt, ##args)
>> +
>>  #define VIDC_CLKS_NUM_MAX		4
>>  #define VIDC_VCODEC_CLKS_NUM_MAX	2
>>  #define VIDC_PMDOMAINS_NUM_MAX		3
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 0143af7822b2..115a9a2af1d6 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -396,7 +396,7 @@ put_ts_metadata(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
>>  	}
>>  
>>  	if (slot == -1) {
>> -		dev_dbg(inst->core->dev, "%s: no free slot\n", __func__);
>> +		VDBGH("no free slot for timestamp\n");
> 
> So you just lost the information that dev_dbg() gave you with regards to
> the device/driver/instance creating that message?

No, I don't lose anything.  When I do debug I know that all debug
messages comes from my driver.  dev_dbg will give me few device
identifiers which I don't care so much. IMO, the device information
makes more sense to dev_err/warn/err variants.  On the other side we
will have dev_dbg_level(group) if still someone needs the device
information.

> 
> Ick, no, don't do that.
> 
> And why is this driver somehow "special" compared to all the rest of

Of course it is special ... to me ;-)

> the kernel?  Why is the current dev_dbg() control not sufficient that
> you need to change the core for just this tiny thing?
> 
> thanks,
> 
> greg k-h
> 

-- 
regards,
Stan
