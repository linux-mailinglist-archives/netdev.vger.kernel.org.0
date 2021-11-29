Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1217461790
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377952AbhK2OLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbhK2OJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:09:12 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E235FC061D5F;
        Mon, 29 Nov 2021 04:45:58 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a18so36541012wrn.6;
        Mon, 29 Nov 2021 04:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=+C3RPddZ2B1ATgdb4ybhIFXmpY9oyj6DqIhiFIK5oZA=;
        b=nWbc5kHtVKHHHo1Oz3Auy3J9e2qdlYA16UEmKL/64otnA6KTmemSyis41eMBRIPiWq
         xuN36JEUbkpF5hIutSz3JsGzgU6utuQO5sgIsTgE+5Qh6OPFbeCEcg6ho7843VT0w8XB
         Q3yd0wr/mvhqhNaWIdHZrdCVGSpmh2pX7V1zdHErB6N+Mkg2VFNMF1ZEg9n5TYc/vwOw
         OiGdCojtmnLQNRSy+DIAPpcKoaW6oXTniWaRVWpt1qq95F4JFRIGrd9J4SUekFAEM6As
         pVH7AW4LJY+Zzu7V1ZYiq6YkzSs0N4ilFDsVEaDuzoBK9+7fmmgRHU9UqTOAcYKb2QVy
         r6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=+C3RPddZ2B1ATgdb4ybhIFXmpY9oyj6DqIhiFIK5oZA=;
        b=NoqlDLUwNjVs2YErVJut6C0zC/QDdjsrt7/OPRqDz5oBCEYrI4JVrTVWrI5mUQkzII
         N2jGj1VkkDZIYk4sktVb/hLSooaDownj3yvlHuyKcydK2natIzyk8hsOm1IM3xAEQSNv
         sxrpudJInZKztILNnArI+jW/o6aSaeEXAByrrM423c3C6EgpD8S94eiw8oJ745PShDWo
         mQkn438VZ344dWHSLK8WiazPx8H3zZRVJOPk4b6IndyVZGjE/RyIfJCg6S4LVQD5NzBh
         9yFCYwWtz9SIm8bgZBo+oaGyKlPbI8uuJ4pJrza9Wh3kVBfAQmROY+U77lgCllS5vuCj
         Qx+w==
X-Gm-Message-State: AOAM533DXkTIeuF1SYd8SFjAqDMQLNnWKwqPvLW0pv5EWE/fHuEbzSkX
        Yiw7f7q4b6ABPg==
X-Google-Smtp-Source: ABdhPJwHIKl2aRomDCrxJNvXolhvEuiAAAm49ca3Odw2+GCvVrvhZA/UiZtLrNC0W14JNHad9lLMFQ==
X-Received: by 2002:adf:fa4b:: with SMTP id y11mr34381460wrr.460.1638189957575;
        Mon, 29 Nov 2021 04:45:57 -0800 (PST)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id l4sm13461483wrv.94.2021.11.29.04.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 04:45:57 -0800 (PST)
From:   "Colin King (gmail)" <colin.i.king@googlemail.com>
X-Google-Original-From: "Colin King (gmail)" <colin.i.king@gmail.com>
Message-ID: <39358e61-c2fb-356a-2ddd-4e87232bfe57@gmail.com>
Date:   Mon, 29 Nov 2021 12:45:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH][next] iwlwifi: mei: Fix spelling mistakes in a devfs file
 and error message
Content-Language: en-US
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Colin Ian King <colin.i.king@googlemail.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211129122517.10424-1-colin.i.king@gmail.com>
 <SA1PR11MB58258E8E9DA01215009B2273F2669@SA1PR11MB5825.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB58258E8E9DA01215009B2273F2669@SA1PR11MB5825.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2021 12:34, Grumbach, Emmanuel wrote:
> Hi Colin,
> 
>> Subject: [PATCH][next] iwlwifi: mei: Fix spelling mistakes in a devfs file and
>> error message
>>
>> There is a spelling mistake in a dev_err message and also in a devfs
>> filename. Fix these.
>>
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>> ---
>>   drivers/net/wireless/intel/iwlwifi/mei/main.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c
>> b/drivers/net/wireless/intel/iwlwifi/mei/main.c
>> index 112cc362e8e7..ed208f273289 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
>> @@ -209,7 +209,7 @@ static void iwl_mei_free_shared_mem(struct
>> mei_cl_device *cldev)
>>   	struct iwl_mei *mei = mei_cldev_get_drvdata(cldev);
>>
>>   	if (mei_cldev_dma_unmap(cldev))
>> -		dev_err(&cldev->dev, "Coudln't unmap the shared mem
>> properly\n");
>> +		dev_err(&cldev->dev, "Couldn't unmap the shared mem
>> properly\n");
>>   	memset(&mei->shared_mem, 0, sizeof(mei->shared_mem));
>>   }
> 
> I fixed this one already in a separate patch that hasn't been applied yet.
> 
>>
>> @@ -1754,7 +1754,7 @@ static void iwl_mei_dbgfs_register(struct iwl_mei
>> *mei)
>>   			     mei->dbgfs_dir, &iwl_mei_status);
>>   	debugfs_create_file("send_start_message", S_IWUSR, mei-
>>> dbgfs_dir,
>>   			    mei, &iwl_mei_dbgfs_send_start_message_ops);
>> -	debugfs_create_file("req_ownserhip", S_IWUSR, mei->dbgfs_dir,
>> +	debugfs_create_file("req_ownership", S_IWUSR, mei->dbgfs_dir,
>>   			    mei, &iwl_mei_dbgfs_req_ownership_ops);
>>   }
>>
>> --
> 
> I hadn't stop this one.

I'll send a V2 with the debugfs fix

> 
>> 2.33.1
> 

