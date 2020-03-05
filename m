Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8DD17A076
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgCEHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:20:16 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41368 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCEHUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:20:16 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so2235842plr.8
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 23:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rKuIrZZDnjnUkGiYaaBfXr29ckvwXKiAAxlWpKQznm0=;
        b=uPvS7C/NyjoTMY7wd2dAoQ7yVlHfnTs4JQO0yuENz5DSQtepvz4RliZbeYRGHrwasV
         nUlzPuCcYyfxm06d1qjKmRe+uHCLZKwqYbX89KZo9R0FCyWsx+FAalBCAQjf45nboXUA
         Ojr/QrSULbLBCjM4pyNjKovfGTds+ZMiuMkgTagP2N/8fRKZOpHxBw4Ewj2Ralakx1gx
         H5A1g0PM2h69ocEl6Jt3dRw8rUo7KFOe/D57R/L8b/T8hZcklvRFk4VHKwMiHSnm1i3w
         awafVRHZkvEy0DPWMpFfHAWryThQRElwe+9ZDiMXIB6EGA6yD6FvDPPMA6VQcuRRUJ5/
         I74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rKuIrZZDnjnUkGiYaaBfXr29ckvwXKiAAxlWpKQznm0=;
        b=HgjXp5a7SfOVLvLgW5o+5ES0JimWKHCiUTnHd/AWih8UHifXJLB2cai7yuKtPpITSh
         D1Rq6BbkbKKPh61R1xY5MmfUC/LJ9mohfMveZIizjQ/aUc90p/YKgRHiq7mYtlZSHGs8
         KJ6Dpchwf8cB7uexCho7bbpQLQbGLKL1bJUnzTxeZOLb099oTaq3eqqo8Qh1kmln9T2h
         l03umM8hBlWZBCVKiz5XLnHlybUa7SztSDpSKqUCPTR/tZmrkDAOi3up6oKO1sVghPsl
         LT4TnPR6zi2JcBuiIZqHhXNxnRBwzouSxLtZtNyEqQeziKj3eh7GzMtojDfOXVciJ54C
         +/Cg==
X-Gm-Message-State: ANhLgQ2z+imFaQUa8CftZFTo8AJwnQ4jPwV9Ajl2A9tsBOStOMLcOCTy
        eSIOJjPC15medsZmJXiCnX6M5Wf4jCI=
X-Google-Smtp-Source: ADFU+vvCnW2Ixs86qRkP3kKFlf5RtqLuPspaajF3ofyA1Z1embKPegjLEe3xGUuFZ8lZWcUha0sgJQ==
X-Received: by 2002:a17:90a:bf83:: with SMTP id d3mr7246378pjs.77.1583392813721;
        Wed, 04 Mar 2020 23:20:13 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d1sm22941906pfc.3.2020.03.04.23.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 23:20:13 -0800 (PST)
Subject: Re: [PATCH v3 net-next 8/8] ionic: drop ethtool driver version
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-9-snelson@pensando.io> <20200305061039.GP121803@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <32978b18-d607-9655-bbfa-7d1ec5c4d054@pensando.io>
Date:   Wed, 4 Mar 2020 23:20:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305061039.GP121803@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 10:10 PM, Leon Romanovsky wrote:
> On Wed, Mar 04, 2020 at 09:23:19PM -0800, Shannon Nelson wrote:
>> Use the default kernel version in ethtool drv_info output
>> and drop the module version.
>>
>> Cc: Leon Romanovsky <leonro@mellanox.com>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
>>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
>>   drivers/net/ethernet/pensando/ionic/ionic_main.c    | 6 ++----
>>   3 files changed, 2 insertions(+), 6 deletions(-)
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
>> index a8e3fb73b465..e4a76e66f542 100644
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
> i see that you responded to my question about usage of this string [1]
> and I can't say anything about netdev policy on that, but in other
> subsystems, the idea that driver has duplicated debug functionalities
> to the general kernel code is not welcomed.
>
> [1] https://lore.kernel.org/netdev/e0cbc84c-7860-abf2-a622-4035be1479dc@pensando.io

This DSC (Distributed Services Card) is more than a simple NIC, and in 
several use cases is intended to be managed centrally and installed in 
hosts that can be handed out to customers as bare-metal machines to 
which the datacenter personnel cannot access.  The device can be 
accessed through a separate management network port, similar to an ilom 
or cimc other similar host management gizmo. Getting a little 
information about the driver into the card's logfiles allows for a 
little better debugging context from the management side without having 
access to the host.

Yes, we want to keep functionality duplication to a minimum, but I think 
this is a different case.  We also want to keep customer information 
leakage to a minimum, which is why we were using only the individual 
driver version info before it was replaced with the kernel version.  I'd 
like to keep at least some bit of driver context information available 
to those on the management side of this PCI device.

sln

>>   	mutex_lock(&ionic->dev_cmd_lock);
>> @@ -558,8 +558,6 @@ int ionic_port_reset(struct ionic *ionic)
>>
>>   static int __init ionic_init_module(void)
>>   {
>> -	pr_info("%s %s, ver %s\n",
>> -		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
>>   	ionic_debugfs_create();
>>   	return ionic_bus_register_driver();
>>   }
>> --
>> 2.17.1
>>

