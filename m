Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C955D3D355F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGWGxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 02:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhGWGxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 02:53:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34895C061575;
        Fri, 23 Jul 2021 00:33:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j2so1250234wrx.9;
        Fri, 23 Jul 2021 00:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VgC3vPpNT5La+R1XF1jyN9pqTr6GT5OZov/rHCOsaMQ=;
        b=LzzDWdADRUkSbBay5xrPP+bpll1wxkfmRtcG0CBrtdw+DL+zg1Yi46ZIFfgFWOJhe/
         j06xVhF+MfX+GHHIaR5KAf6EhfMnvXHvObTNiOUAVsPOAltQvzrdeHD9Ehua9DrkWcVP
         s/V/rDzauqd/j3+ZJC527TXO2Nhj7zYbVO9yzhFb0BjTms5yb1/6f4Yy3coD/V5wwxDE
         NNaEVQhH1MLGwzk+5qCLZo29ilPVGRabcp+FyyUuaK0RzwhKh3p8twblp3+XfFeTIu/U
         yJYHwboPdQkr1lcR/t2yyo7dHhm0J3qVK16emB1TdlS4OJeA3DBVYX3e78qKgcIA4IUi
         TM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VgC3vPpNT5La+R1XF1jyN9pqTr6GT5OZov/rHCOsaMQ=;
        b=XqLzdIMmTpFU7v8/CSpGUxtDXeFWLovJ450exd4LIgmVXJMsg9l9yLUNTv4C5pgSrt
         o4Y6A35G55oQpq0Qu5p+Un11/tfbljXzFWuE7+pZF73lMJzvi39EZQyG2qaVHw0DjO+G
         cWffoRB/syw3ICFWXkphINlmR1lCg6ITafFtxshNzT6EetZfRyqebzT9RtAxh2Tn/SCc
         ytHqy7T2rcxkh9Vg8bJDT01y3F47m7yLx3QNQST97wJ73Sj/krjC25RLas5d2c6jOSQf
         uOJk6zWQMUQPxbHrbLK2s7yURBqvEudB/rPwj+MJF5Xu0wHGCeOji11jzjGh3onBC4IO
         1o7Q==
X-Gm-Message-State: AOAM533Py5dB0HJebdhaKPe0oUElME2dN00Hpru3Oky1rgP8JlWKo9as
        V4a3CLbSFjn5oV6iNdVghR5A/L2nGWq9sA==
X-Google-Smtp-Source: ABdhPJykCwF5I969etjP8bi0AekEUMs/Y+Rps6uy3Npu3PwBQ8byqJ5w7l2ggmdg8oNLePEi1rvN9Q==
X-Received: by 2002:adf:ed08:: with SMTP id a8mr3612303wro.375.1627025624839;
        Fri, 23 Jul 2021 00:33:44 -0700 (PDT)
Received: from ?IPv6:2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5? ([2a02:810d:d40:2317:2ef0:5dff:fe0a:a2d5])
        by smtp.gmail.com with ESMTPSA id n23sm26882957wmc.38.2021.07.23.00.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 00:33:44 -0700 (PDT)
Subject: Re: [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
To:     =?UTF-8?Q?St=c3=a9phane_Grosjean?= <s.grosjean@peak-system.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210721124048.590426-1-nautsch2@gmail.com>
 <20210721125926.593283-1-nautsch2@gmail.com>
 <PA4PR03MB67973D473C7CE600A6104EE8D6E39@PA4PR03MB6797.eurprd03.prod.outlook.com>
 <fe8998f2-7897-735c-926f-6b6b74018784@gmail.com>
 <DBBPR03MB67952FE719401869BC8F1A77D6E59@DBBPR03MB6795.eurprd03.prod.outlook.com>
From:   Andre Naujoks <nautsch2@gmail.com>
Message-ID: <e3c8a6c1-a108-0a11-aaf7-f17e1851f6d7@gmail.com>
Date:   Fri, 23 Jul 2021 09:33:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <DBBPR03MB67952FE719401869BC8F1A77D6E59@DBBPR03MB6795.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 23.07.21 um 09:24 schrieb Stéphane Grosjean:
> Hi,
> 
> We plan to send the patches during the next month.

Thank you for the info! Sounds great. I'm looking forward to it.

Best Regards
   Andre

> 
> Regards,
> 
> — Stéphane
> 
> 
> ------------------------------------------------------------------------
> *De :* Andre Naujoks <nautsch2@gmail.com>
> *Envoyé :* mercredi 21 juillet 2021 15:39
> *À :* Stéphane Grosjean <s.grosjean@peak-system.com>; Wolfgang 
> Grandegger <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengutronix.de>; 
> David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; 
> Vincent Mailhol <mailhol.vincent@wanadoo.fr>; Gustavo A. R. Silva 
> <gustavoars@kernel.org>; Pavel Skripkin <paskripkin@gmail.com>; Colin 
> Ian King <colin.king@canonical.com>; linux-can@vger.kernel.org 
> <linux-can@vger.kernel.org>; netdev@vger.kernel.org 
> <netdev@vger.kernel.org>; linux-kernel@vger.kernel.org 
> <linux-kernel@vger.kernel.org>
> *Objet :* Re: [PATCH v2] Expose Peak USB device id in sysfs via 
> phys_port_name.
> Am 21.07.21 um 15:29 schrieb Stéphane Grosjean:
>> Hi,
>> 
>> The display and the possibility to change this "device_number" is a current modification of the peak_usb driver. This modification will offer this possibility for all CAN - USB interfaces of PEAK-System.
> 
> Hi.
> 
> By "current modification" you mean something not yet public? Do you have
> a time frame for when you are planning to make it public? I'd really
> like to use this :-)
> 
>> 
>> However, it is planned to create new R/W entries for this (under /sys/class/net/canX/...) as is already the case in other USB - CAN interface drivers.
> 
> I'd be fine with that. I just chose something, that was already
> available and looked as if it made the most sense without breaking anything.
> 
> Thanks for the reply!
>     Andre
> 
>> 
>> — Stéphane
>> 
>> 
>> De : Andre Naujoks <nautsch2@gmail.com>
>> Envoyé : mercredi 21 juillet 2021 14:59
>> À : Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengutronix.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Stéphane Grosjean <s.grosjean@peak-system.com>; Vincent Mailhol <mailhol.vincent@wanadoo.fr>; Gustavo  A. R. Silva <gustavoars@kernel.org>; Pavel Skripkin 
> <paskripkin@gmail.com>; Colin Ian King <colin.king@canonical.com>; Andre 
> Naujoks <nautsch2@gmail.com>; linux-can@vger.kernel.org 
> <linux-can@vger.kernel.org>; netdev@vger.kernel.org 
> <netdev@vger.kernel.org>; linux-kernel@vger.kernel.org 
> <linux-kernel@vger.kernel.org>
>> Objet : [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
>> 
>> The Peak USB CAN adapters can be assigned a device id via the Peak
>> provided tools (pcan-settings). This id can currently not be set by the
>> upstream kernel drivers, but some devices expose this id already.
>> 
>> The id can be used for consistent naming of CAN interfaces regardless of
>> order of attachment or recognition on the system. The classical CAN Peak
>> USB adapters expose this id via bcdDevice (combined with another value)
>> on USB-level in the sysfs tree and this value is then available in
>> ID_REVISION from udev. This is not a feasible approach, when a single
>> USB device offers more than one CAN-interface, like e.g. the PCAN-USB
>> Pro FD devices.
>> 
>> This patch exposes those ids via the, up to now unused, netdevice sysfs
>> attribute phys_port_name as a simple decimal ASCII representation of the
>> id. phys_port_id was not used, since the default print functions from
>> net/core/net-sysfs.c output a hex-encoded binary value, which is
>> overkill for a one-byte device id, like this one.
>> 
>> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
>> ---
>>   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>> 
>> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
>> index e8f43ed90b72..f6cbb01a58cc 100644
>> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
>> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
>> @@ -408,6 +408,21 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
>>           return NETDEV_TX_OK;
>>   }
>> 
>> +static int peak_usb_ndo_get_phys_port_name(struct net_device *netdev,
>> +                                          char *name, size_t len)
>> +{
>> +       const struct peak_usb_device *dev = netdev_priv(netdev);
>> +       int err;
>> +
>> +       err = snprintf(name, len, "%u", dev->device_number);
>> +
>> +       if (err >= len || err <= 0) {
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>   /*
>>    * start the CAN interface.
>>    * Rx and Tx urbs are allocated here. Rx urbs are submitted here.
>> @@ -769,6 +784,7 @@ static const struct net_device_ops peak_usb_netdev_ops = {
>>           .ndo_stop = peak_usb_ndo_stop,
>>           .ndo_start_xmit = peak_usb_ndo_start_xmit,
>>           .ndo_change_mtu = can_change_mtu,
>> +       .ndo_get_phys_port_name = peak_usb_ndo_get_phys_port_name,
>>   };
>> 
>>   /*
>> --
>> 2.32.0
>> 
>> --
>> PEAK-System Technik GmbH
>> Sitz der Gesellschaft Darmstadt - HRB 9183
>> Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
>> Unsere Datenschutzerklaerung mit wichtigen Hinweisen
>> zur Behandlung personenbezogener Daten finden Sie unter
>> www.peak-system.com/Datenschutz.483.0.html 
> <http://www.peak-system.com/Datenschutz.483.0.html>
>> 
> 
> 
> --
> PEAK-System Technik GmbH
> Sitz der Gesellschaft Darmstadt - HRB 9183
> Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
> Unsere Datenschutzerklaerung mit wichtigen Hinweisen
> zur Behandlung personenbezogener Daten finden Sie unter
> www.peak-system.com/Datenschutz.483.0.html

