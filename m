Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E68629F6
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404715AbfGHT5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:57:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42717 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbfGHT5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:57:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so8098127pff.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7WB3DXRoKsKNZMegN6oHETRm0BCLyBvFymPNrQleu2U=;
        b=D4l1Enn/qpa2VPO1xlwWnRybqAtii/RXtH5dpMkDP7xlK8FQy3Z5tjL02a1ivN44Jo
         iz/cELb1/o/hG/7guEwNVDVUlMS7wSZKpI8v2SiHs7ORbo9BaErX1EKbuVzn+ZzgOP4Z
         idD/Evm3r3wv2jnmVjJIJOUIrwAwoMwrHcYxVyJrrRpkPM6VjrXCey4D3DbF+Yah9Ycb
         FxFq442cFb/SDsuim587vm2SLhjhQPbkD9ozATWvevrPBFtgaSofitwfAp78buPCa0YR
         ZFLW3L7rWNOOlKktY1PFFMQPw3EhfP80MjmJtIfUlydP/YRl6gSvCg9D2DBRmdobB49N
         OVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7WB3DXRoKsKNZMegN6oHETRm0BCLyBvFymPNrQleu2U=;
        b=OznABXeF6WkXRJL+DA0o8hSGjA9qQBiBD6rLTJZMpqk8EL7gBS/hV3OLO8r0GNP+6A
         Ox8PoKmMSKilFZfaYMnjpZct+bwF1Fed5kBib+khEA6tVaYDLBVkkH7ywNBuIPth5dpc
         npUXNpPv1q7HbirdW4OBriMh6ObI3rCWTYe0rCOlmcWchJrS41lEfWR48RqoVXiVY+sy
         KzuCe+AJsLXN5uOUq4t4WBfffAs/pXgK8+myXM8KvSqm7jNGraUD8B8PRTN7gTR2USry
         ZvuceccqrIWfh9B1U3qAf7WTxZ+dX3GJdJq/l5wGEQqUE9xBtafgE18HDZwM8k0gr5bp
         UqoA==
X-Gm-Message-State: APjAAAWcNyXVYxX2baoZ6hQuQAXGO40//Qmigc4/ua0rpwvh6gkRA98H
        D2kbfFW0XI1gb5nTjtTM9x8xXPS4NZg=
X-Google-Smtp-Source: APXvYqyxtQS1Rihmj44rzkdKMlydAE9XQWvhkSQ5woh0vAztU/jr+OumDXJUaO1jfuTNiDqmz1xPjQ==
X-Received: by 2002:a65:464d:: with SMTP id k13mr3577223pgr.99.1562615833635;
        Mon, 08 Jul 2019 12:57:13 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t2sm16034053pgo.61.2019.07.08.12.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:57:13 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <af206309-514d-9619-1455-efc93af8431e@pensando.io>
Date:   Mon, 8 Jul 2019 12:58:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190708193454.GF2282@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 12:34 PM, Jiri Pirko wrote:
> Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>> Add a devlink interface for access to information that isn't
>> normally available through ethtool or the iplink interface.
>>
>> Example:
>> 	$ ./devlink -j -p dev info pci/0000:b6:00.0
>> 	{
>> 	    "info": {
>> 		"pci/0000:b6:00.0": {
>> 		    "driver": "ionic",
>> 		    "serial_number": "FLM18420073",
>> 		    "versions": {
>> 			"fixed": {
>> 			    "fw_version": "0.11.0-50",
>> 			    "fw_status": "0x1",
>> 			    "fw_heartbeat": "0x716ce",
>> 			    "asic_type": "0x0",
>> 			    "asic_rev": "0x0"
>> 			}
>> 		    }
>> 		}
>> 	    }
>> 	}
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>> drivers/net/ethernet/pensando/ionic/Makefile  |  2 +-
>> drivers/net/ethernet/pensando/ionic/ionic.h   |  1 +
>> .../ethernet/pensando/ionic/ionic_bus_pci.c   |  7 ++
>> .../ethernet/pensando/ionic/ionic_devlink.c   | 89 +++++++++++++++++++
>> .../ethernet/pensando/ionic/ionic_devlink.h   | 12 +++
>> 5 files changed, 110 insertions(+), 1 deletion(-)
>> create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
>> index 4f3cfbf36c23..ce187c7b33a8 100644
>> --- a/drivers/net/ethernet/pensando/ionic/Makefile
>> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
>> @@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
>>
>> ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
>> 	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
>> -	   ionic_stats.o
>> +	   ionic_stats.o ionic_devlink.o
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index cd08166f73a9..a0034bc5b4a1 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -44,6 +44,7 @@ struct ionic {
>> 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
>> 	struct work_struct nb_work;
>> 	struct notifier_block nb;
>> +	struct devlink *dl;
>> };
>>
>> struct ionic_admin_ctx {
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 98c12b770c7f..a8c99254489f 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -10,6 +10,7 @@
>> #include "ionic_bus.h"
>> #include "ionic_lif.h"
>> #include "ionic_debugfs.h"
>> +#include "ionic_devlink.h"
>>
>> /* Supported devices */
>> static const struct pci_device_id ionic_id_table[] = {
>> @@ -212,9 +213,14 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>> 		goto err_out_deinit_lifs;
>> 	}
>>
>> +	err = ionic_devlink_register(ionic);
>> +	if (err)
>> +		dev_err(dev, "Cannot register devlink (ignored): %d\n", err);
>> +
>> 	return 0;
>>
>> err_out_deinit_lifs:
>> +	ionic_devlink_unregister(ionic);
>> 	ionic_lifs_deinit(ionic);
>> err_out_free_lifs:
>> 	ionic_lifs_free(ionic);
>> @@ -247,6 +253,7 @@ static void ionic_remove(struct pci_dev *pdev)
>> 	struct ionic *ionic = pci_get_drvdata(pdev);
>>
>> 	if (ionic) {
>> +		ionic_devlink_unregister(ionic);
>> 		ionic_lifs_unregister(ionic);
>> 		ionic_lifs_deinit(ionic);
>> 		ionic_lifs_free(ionic);
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> new file mode 100644
>> index 000000000000..fbbfcdde292f
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> @@ -0,0 +1,89 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +
>> +#include "ionic.h"
>> +#include "ionic_bus.h"
>> +#include "ionic_lif.h"
>> +#include "ionic_devlink.h"
>> +
>> +struct ionic_devlink {
>> +	struct ionic *ionic;
>> +};
>> +
>> +static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>> +			     struct netlink_ext_ack *extack)
>> +{
>> +	struct ionic *ionic = *(struct ionic **)devlink_priv(dl);
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	char buf[16];
>> +	u32 val;
>> +
>> +	devlink_info_driver_name_put(req, DRV_NAME);
>> +
>> +	devlink_info_version_fixed_put(req, "fw_version",
>> +				       idev->dev_info.fw_version);
>> +
>> +	val = ioread8(&idev->dev_info_regs->fw_status);
>> +	snprintf(buf, sizeof(buf), "0x%x", val);
>> +	devlink_info_version_fixed_put(req, "fw_status", buf);
>> +
>> +	val = ioread32(&idev->dev_info_regs->fw_heartbeat);
>> +	snprintf(buf, sizeof(buf), "0x%x", val);
>> +	devlink_info_version_fixed_put(req, "fw_heartbeat", buf);
>> +
>> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
>> +	devlink_info_version_fixed_put(req, "asic_type", buf);
>> +
>> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
>> +	devlink_info_version_fixed_put(req, "asic_rev", buf);
>> +
>> +	devlink_info_serial_number_put(req, idev->dev_info.serial_num);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct devlink_ops ionic_dl_ops = {
>> +	.info_get	= ionic_dl_info_get,
>> +};
>> +
>> +int ionic_devlink_register(struct ionic *ionic)
>> +{
>> +	struct devlink *dl;
>> +	struct ionic **ip;
>> +	int err;
>> +
>> +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
> Oups. Something is wrong with your flow. The devlink alloc is allocating
> the structure that holds private data (per-device data) for you. This is
> misuse :/
>
> You are missing one parent device struct apparently.
>
> Oh, I think I see something like it. The unused "struct ionic_devlink".

If I'm not mistaken, the alloc is only allocating enough for a pointer, 
not the whole per device struct, and a few lines down from here the 
pointer to the new devlink struct is assigned to ionic->dl.  This was 
based on what I found in the qed driver's qed_devlink_register(), and it 
all seems to work.

That unused struct ionic_devlink does need to go away, it was 
superfluous after working out a better typecast off of devlink_priv().

I'll remove the unused struct ionic_devlink, but I think the rest is okay.

sln

>
>
>> +	if (!dl) {
>> +		dev_warn(ionic->dev, "devlink_alloc failed");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	ip = (struct ionic **)devlink_priv(dl);
>> +	*ip = ionic;
>> +	ionic->dl = dl;
>> +
>> +	err = devlink_register(dl, ionic->dev);
>> +	if (err) {
>> +		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
>> +		goto err_dl_free;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_dl_free:
>> +	ionic->dl = NULL;
>> +	devlink_free(dl);
>> +	return err;
>> +}
>> +
>> +void ionic_devlink_unregister(struct ionic *ionic)
>> +{
>> +	if (!ionic->dl)
>> +		return;
>> +
>> +	devlink_unregister(ionic->dl);
>> +	devlink_free(ionic->dl);
>> +}
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>> new file mode 100644
>> index 000000000000..35528884e29f
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>> @@ -0,0 +1,12 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#ifndef _IONIC_DEVLINK_H_
>> +#define _IONIC_DEVLINK_H_
>> +
>> +#include <net/devlink.h>
>> +
>> +int ionic_devlink_register(struct ionic *ionic);
>> +void ionic_devlink_unregister(struct ionic *ionic);
>> +
>> +#endif /* _IONIC_DEVLINK_H_ */
>> -- 
>> 2.17.1
>>

