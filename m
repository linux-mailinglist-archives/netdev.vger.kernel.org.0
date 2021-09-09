Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED2405B24
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239117AbhIIQpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbhIIQph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 12:45:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A82C061574;
        Thu,  9 Sep 2021 09:44:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j2so1447927pll.1;
        Thu, 09 Sep 2021 09:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b4uDLJPP+FU7QUvKzFswN3F23ammEK+c1YsboO8yo7Y=;
        b=oP2Y9akyRZyieSz6Vi8BvwKhZ75XuY4QdoNLEbSOR9dJgaCfTbbYsHykkWCDo04Yyt
         MEK46Z3PBgF40Guta6hyMnOr+svxIdDBxsLtJudVVhcAW1oG0arq3aDEjcJfArcX5kng
         vE9HY4Xh9Yb6ddoL/9YjKTMEqWs4atpvOnWcFlXU/XonaT46yul/EJ7s6eHjAn6+1+Bl
         ZpYYA2KdBeqDClultty999x8TQUXR5p/66IezsMdmxz36bUBAm/Zf+4qV5kSsDYbF3gr
         /W1lsXIOvQ9WfSYPkTwIKAMfiswKDCSSThxFsB0yNi6uDjoLrqgmH84YoJFSv7gtXkEt
         +Xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b4uDLJPP+FU7QUvKzFswN3F23ammEK+c1YsboO8yo7Y=;
        b=ddaT5r/yxs+wMONJ8EPmsY0u9+hmr6i9dScZ7dLVtPqcswMzwBEgi+1FlUh4NEpuNR
         5fnqlPW4iw7KOl9aCg1cQiH32o9tB8J5rb0tHbqXPFc2o9linoFoSCm0lcRt8osw8R0J
         5EZMbEXF0tzFpejnYa2IHVHi55GwrquedtTW7oSsPKx1MvXsJCpQAucrFzt7LohRzOJq
         hVIPFYJXe/PgrkpfLbwFQenK4yl8J9Ol63A8eNFMNxKlGjG6JqlSfT2zy8QsEKV9KObI
         1Ayb7COFsTNHnEHYBaPT0j1N7giStfLZlmV32L4ELw9H6OnP4fwvbcrCl+w+BJE22IdV
         scaQ==
X-Gm-Message-State: AOAM533lCoJG0rDiP5rRlzTKwk9x6mZzb2xZK+ECDj/Y1GLSD4UzkBKz
        E/k5h8DxS2f77TpHxJJiaWwI0PmiDis=
X-Google-Smtp-Source: ABdhPJxlF5YvZh35lFdwNXgmJt5w/7E3r9OPnqqK9IavRUuK8qj5MJIDxpghWQyc7qXBpIrRYNo3PA==
X-Received: by 2002:a17:90b:4c4d:: with SMTP id np13mr4681791pjb.166.1631205867034;
        Thu, 09 Sep 2021 09:44:27 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id cp17sm2769945pjb.3.2021.09.09.09.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 09:44:26 -0700 (PDT)
Message-ID: <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
Date:   Thu, 9 Sep 2021 09:44:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Content-Language: en-US
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2021 9:37 AM, Lino Sanfilippo wrote:
> On 09.09.21 at 17:47, Vladimir Oltean wrote:
>> On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
>>>> Do you see similar things on your 5.10 kernel?
>>>
>>> For the master device is see
>>>
>>> lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consumer:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:spi3.0
>>
>> So this is the worst of the worst, we have a device link but it doesn't help.
>>
>> Where the device link helps is here:
>>
>> __device_release_driver
>> 	while (device_links_busy(dev))
>> 		device_links_unbind_consumers(dev);
>>
>> but during dev_shutdown, device_links_unbind_consumers does not get called
>> (actually I am not even sure whether it should).
>>
>> I've reproduced your issue by making this very simple change:
>>
>> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> index 60d94e0a07d6..ec00f34cac47 100644
>> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> @@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver = {
>>   	.id_table = enetc_pf_id_table,
>>   	.probe = enetc_pf_probe,
>>   	.remove = enetc_pf_remove,
>> +	.shutdown = enetc_pf_remove,
>>   #ifdef CONFIG_PCI_IOV
>>   	.sriov_configure = enetc_sriov_configure,
>>   #endif
>>
>> on my DSA master driver. This is what the genet driver has "special".
>>
> 
> Ah, that is interesting.
> 
>> I was led into grave error by Documentation/driver-api/device_link.rst,
>> which I've based my patch on, where it clearly says that device links
>> are supposed to help with shutdown ordering (how?!).
>>
>> So the question is, why did my DSA trees get torn down on shutdown?
>> Basically the short answer is that my SPI controller driver does
>> implement .shutdown, and calls the same code path as the .remove code,
>> which calls spi_unregister_controller which removes all SPI children..
>>
>> When I added this device link, one of the main objectives was to not
>> modify all DSA drivers. I was certain based on the documentation that
>> device links would help, now I'm not so sure anymore.
>>
>> So what happens is that the DSA master attempts to unregister its net
>> device on .shutdown, but DSA does not implement .shutdown, so it just
>> sits there holding a reference (supposedly via dev_hold, but where from?!)
>> to the master, which makes netdev_wait_allrefs to wait and wait.
>>
> 
> Right, that was also my conclusion.
> 
>> I need more time for the denial phase to pass, and to understand what
>> can actually be done. I will also be away from the keyboard for the next
>> few days, so it might take a while. Your patches obviously offer a
>> solution only for KSZ switches, we need something more general. If I
>> understand your solution, it works not by virtue of there being any
>> shutdown ordering guarantee at all, but simply due to the fact that
>> DSA's .shutdown hook gets called eventually, and the reference to the
>> master gets freed eventually, which unblocks the unregister_netdevice
>> call from the master.
> 
> Well actually the SPI shutdown hook gets called which then calls ksz9477_shutdown
> (formerly ksz9477_reset_switch) which then shuts down the switch by
> stopping the worker thread and tearing down the DSA tree (via dsa_tree_shutdown()).
> 
> While it is right that the patch series only fixes the KSZ case for now, the idea was that
> other drivers could use a similar approach in by calling the new function dsa_tree_shutdown()
> in their shutdown handler to make sure that all refs to the master device are released.

It does not scale really well to have individual drivers call 
dsa_tree_shutdown() in their respective .shutdown callback, and in a 
multi-switch configuration, I am not sure what the results would look like.

In premise, each driver ought to be able to call 
dsa_unregister_switch(), along with all of the driver specific shutdown 
and eventually, given proper device ordering the DSA tree would get 
automatically torn down, and then the DSA master's .shutdown() callback 
would be called.

FWIW, the reason why we call .shutdown() in bcmgenet is to turn off DMA 
and clocks, which matters for kexec (DMA) as well as power savings (S5 
mode).
-- 
Florian
