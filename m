Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27FD17831E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgCCT1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:27:00 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38412 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCCT1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:27:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so2002829pgh.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 11:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eGH+109FYpmHuD7i436cf/usQy8WJaO5yGmod8cgNAA=;
        b=gbIkxHd/yd9cSgEhHqGhsFhHvhHQbwqaJb/mJe7xxb7rjMUMEXeFV+nPhOgOwP5ZdD
         9nGLwXDgkJYgGiOZJ/K3K29CKVcafQaVoWG4tUYO9pGDOd03zs+Z3XzIP9Rvxxn4q6Ed
         T8qvCEebHWeW569SQBIJ9QapHv2YTiLWQvtEgRIkm8dKfttjrqXZFo0rs94zEOnnTooB
         NJ6CF2DazS5V1cwa2k6oCJNUQro78LQmhCOOgzvTXCwNvLBAcr0XwBPxdqchOn/h4uKY
         nWvlET0e56oW4rgbnxX/c/ZgGkQyxhVoXosu6LNitdmVACVktavzAugK/L24pa4GTqUU
         DJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eGH+109FYpmHuD7i436cf/usQy8WJaO5yGmod8cgNAA=;
        b=AE1ccOrwNE9Da4eKOIYuhJGaQ3oBeY6ingKy0bFlqRJMp8a/EcE/YFHEudoBtay0AY
         KE9FRB+JWG9hrwnAthppiNUU0Wbf2GFVHJVCeLWBf51QQorNyVNzbcXFAmPXJ3GzCGJ/
         4158g0TOAhS96u/um8lpN5CQuQ4hDnsw19MPwzdgxROrqLB6KMGm0CxE5Do+DTczzldV
         JDgmMpTSlvnN/HfQG4399c0gsnwShN9neY7STasbiY2Y/AEh9YuIg71Pz8xKBpTl/zFX
         M5Xo6OD4wr1lebmCHqW0KyrGTzv7tQh/jdlkaGQokBMEwvot11G9Tr9Y6pIIKvA8lsn/
         8gYQ==
X-Gm-Message-State: ANhLgQ3g6L8ILmrLhbVP2k9Plo+/DPwT3roB0UVPYl+bzIHURoTCvDZw
        UK6OTgf2+nHMiwzCUn1FpfJ2wHykOEU=
X-Google-Smtp-Source: ADFU+vunaHvetU/22aEJYD5plpMrWHAK5OOJpZfvPuMiFeJRSdcLy585jT7RB2Zs7PXmyzY9FqD/TQ==
X-Received: by 2002:a63:6cc6:: with SMTP id h189mr5365440pgc.201.1583263618421;
        Tue, 03 Mar 2020 11:26:58 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 4sm27054406pfn.90.2020.03.03.11.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 11:26:57 -0800 (PST)
Subject: Re: [PATCH net-next 8/8] ionic: drop ethtool driver version
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20200303041545.1611-1-snelson@pensando.io>
 <20200303041545.1611-9-snelson@pensando.io> <20200303063509.GD121803@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e0cbc84c-7860-abf2-a622-4035be1479dc@pensando.io>
Date:   Tue, 3 Mar 2020 11:26:57 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303063509.GD121803@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 10:35 PM, Leon Romanovsky wrote:
> On Mon, Mar 02, 2020 at 08:15:45PM -0800, Shannon Nelson wrote:
>> Use the default kernel version in ethtool drv_info output
>> and drop the module version.
>>
>> Cc: Leon Romanovsky <leonro@mellanox.com>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
>>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
>>   drivers/net/ethernet/pensando/ionic/ionic_main.c    | 7 +++----
>>   3 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index c8ff33da243a..1c720759fd80 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -12,7 +12,6 @@ struct ionic_lif;
>>
>>   #define IONIC_DRV_NAME		"ionic"
>>   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
>> -#define IONIC_DRV_VERSION	"0.20.0-k"
>>
>>   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> index acd53e27d1ec..bea9b78e0189 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> @@ -86,7 +86,6 @@ static void ionic_get_drvinfo(struct net_device *netdev,
>>   	struct ionic *ionic = lif->ionic;
>>
>>   	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
>> -	strlcpy(drvinfo->version, IONIC_DRV_VERSION, sizeof(drvinfo->version));
>>   	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
>>   		sizeof(drvinfo->fw_version));
>>   	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> index a8e3fb73b465..5428af885fa7 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/module.h>
>>   #include <linux/netdevice.h>
>>   #include <linux/utsname.h>
>> +#include <linux/vermagic.h>
>>
>>   #include "ionic.h"
>>   #include "ionic_bus.h"
>> @@ -15,7 +16,6 @@
>>   MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
>>   MODULE_AUTHOR("Pensando Systems, Inc");
>>   MODULE_LICENSE("GPL");
>> -MODULE_VERSION(IONIC_DRV_VERSION);
>>
>>   static const char *ionic_error_to_str(enum ionic_status_code code)
>>   {
>> @@ -414,7 +414,7 @@ int ionic_identify(struct ionic *ionic)
>>   	memset(ident, 0, sizeof(*ident));
>>
>>   	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
>> -	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
>> +	strncpy(ident->drv.driver_ver_str, UTS_RELEASE,
>>   		sizeof(ident->drv.driver_ver_str) - 1);
> Strange, I see that you are issuing command IONIC_CMD_IDENTIFY with this
> data, doesn't the other side expect specific format? Can I send any
> string here? and what will be result?

There is no expected format - this is a simple string.

Nothing happens with the string other than to end up in a logfile on the 
device as context for a potential support debugging session.

>
>>   	mutex_lock(&ionic->dev_cmd_lock);
>> @@ -558,8 +558,7 @@ int ionic_port_reset(struct ionic *ionic)
>>
>>   static int __init ionic_init_module(void)
>>   {
>> -	pr_info("%s %s, ver %s\n",
>> -		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
>> +	pr_info("%s %s\n", IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION);
> While cleaning from driver versions, we are removing such code too.
> It is done for three reasons:
> 1. In case of success, there is no need in dmesg to know about the fact
> that driver is going to be up.
> 2. In case of failure, there will/should be error prints.
> 3. There are so many options to know about execution of every function
> and module init/exit that extra print is definitely useless.

Sure, I'll remove this in the next patchset, or in v2 of this if there 
are other changes needed.

sln

>
> Thanks
>
>>   	ionic_debugfs_create();
>>   	return ionic_bus_register_driver();
>>   }
>> --
>> 2.17.1
>>

