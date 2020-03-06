Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17917B30B
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCFAlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:41:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46345 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgCFAlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 19:41:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id w12so107407pll.13
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 16:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1A3UDi16ob5YL0UvnLWM1oybojtgaRw4KVbxq4RKci0=;
        b=aNv3WZgd95g5MPhMlW4nv7k72d9cTnKe3Kow1AG4u0x8EB/F1beuPhoRAnNA/NUx67
         YhZpfhiz3xYUSIAJKCYyYOxkBtMWIrCh+8w1fROnzZrtJRJFWrXJ0Qo8YYiTA7aelexO
         zWaCiPCvkvBh5MXc+NmxYwi8c0ZkEZuwL6J2fo+onPxOK94FYthvv0aqRn+AkRTHioMu
         Phl03SG/jgFjKMnFsMmbjsjJ2Mrp6948W32D2RNgM/RmEfV9GCV658eA5jQqNKq8luYD
         djwjjt6FKNRNtQQiVZRG/m2VuUrKoXSf0hl/ImSQnmDgkzSbgVHBqKur/woBP5H5n1MT
         kgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1A3UDi16ob5YL0UvnLWM1oybojtgaRw4KVbxq4RKci0=;
        b=RR/UzzcI8Zr53PpK47/vILBuWSPyAft3EwhBH/eZu4ib9SCfA7RF4uHTj7C2tcqf1+
         /sK+rJCGnwDNuX/jZ3RCmjw6CPReuze6AbpR7xCpN5tHNvWtKUkup+UWOpkMNkjuiBPH
         Ec+BRapPpQqho7lgiAEoVtVubQXzvyVs0oroXeJskR8ytIQXVCDcx3DItepcmvVhqnQB
         snNSkcMbHk5miuOIoNU7pqayIDbj7tgBidyRtga40P7krTJoxoAI/+Ne0LtYk8iQfBJJ
         pFPAg7m3+mHTIY2DjBjUtYhgUhz+buzT1vMUMEpvrkyzYuRRpPUQfT/GnF0LMdVpD2dc
         mNsQ==
X-Gm-Message-State: ANhLgQ2H4RGqWQXcQnhe0u/gqCwsp5tG/6/eSw0eAlfaL311KUCPZKTV
        Qyj2N0mRr3WJsl87kPF3UyPnqvPmNPE=
X-Google-Smtp-Source: ADFU+vtL3O8zQPlxB2jG3hAy9Ar1+rgyZvMEm33wrNF8/3kI+yA4bR4tH/Qdodrm/UH2v5PI9Zao8A==
X-Received: by 2002:a17:90a:2308:: with SMTP id f8mr848328pje.108.1583455310209;
        Thu, 05 Mar 2020 16:41:50 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id a10sm32105764pgk.71.2020.03.05.16.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 16:41:49 -0800 (PST)
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-8-snelson@pensando.io>
 <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
Date:   Thu, 5 Mar 2020 16:41:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 2:03 PM, Jakub Kicinski wrote:
> On Wed,  4 Mar 2020 21:23:18 -0800 Shannon Nelson wrote:
>> Add support for an additional device id.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> I have thought about this for a while and I wanted to ask you to say
> a bit more about the use of the management device.
>
> Obviously this is not just "additional device id" in the traditional
> sense where device IDs differentiate HW SKUs or revisions. This is the
> same exact hardware, just a different local feature (as proven by the
> fact that you make 0 functional changes).
>
> In the past we (I?) rejected such extensions upstream from Netronome and
> Cavium, because there were no clear use cases which can't be solved by
> extending standard kernel APIs. Do you have any?

Do you by chance have any references handy to such past discussions?  
I'd be interested in reading them to see what similarities and 
differences we have.

The network device we present is only a portion of the DSC's functions.  
The device configuration and management for the various services is 
handled in userspace programs on the OS running inside the device.  
These are accessed through a secured REST API, typically through the 
external management ethernet port.  In addition to our centralized 
management user interface, we have a command line tool for managing the 
device configuration using that same REST interface.

In some configurations we make it possible to open a network connection 
into the device through the host PCI, just as if you were to connect 
through the external mgmt port.  This is the PCI deviceid that 
corresponds to that port, and allows use of the command line tool on the 
host.

The host network driver doesn't have access to the device management 
commands, it only can configure the NIC portion for what it needs for 
passing network packets.

sln



>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index bb106a32f416..c8ff33da243a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -18,6 +18,7 @@ struct ionic_lif;
>>   
>>   #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
>>   #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
>> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
>>   
>>   #define DEVCMD_TIMEOUT  10
>>   
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 59b0091146e6..3dc985cae391 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -15,6 +15,7 @@
>>   static const struct pci_device_id ionic_id_table[] = {
>>   	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
>>   	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
>> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
>>   	{ 0, }	/* end of table */
>>   };
>>   MODULE_DEVICE_TABLE(pci, ionic_id_table);

