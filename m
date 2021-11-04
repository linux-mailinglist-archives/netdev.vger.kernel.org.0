Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589C3445B7A
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 22:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhKDVGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 17:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhKDVGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 17:06:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1504FC061714;
        Thu,  4 Nov 2021 14:04:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o14so9365614plg.5;
        Thu, 04 Nov 2021 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=h6d4KYsPCgkIM6hYRgfbMryU9W2jxjbMCBBkti0NQMU=;
        b=Hi6BhicE6Z/jncVvvyENZV+cauK04GXs+PLfnr35IavphSKv3qLp+Zu/y06/TV5uhQ
         lq70z2a/RQwpM1UsCUINPENNzP0m1IcQGwdVKu86DKcYZVwbcTHJIWErTYmFuV3BGlgM
         PRsNh9L88j4vqMaVbzIpaTFoIQ4MUPYUyOtxmCEYS7vnYI2Wu7JgyXmpuCRCT4zudAoZ
         XarkZ/fIWzhQXqwqUXQdC2LMq6EDAt5G+n3Xx5VEQ2dQPUqCef4+/70csykGkgl/pHhb
         o8TCriZOcFv/jyeprszOh6n4NtCNmAOD9z+Fk3PoYryXI843vOW+OOg67U6nNqueyXGE
         tivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=h6d4KYsPCgkIM6hYRgfbMryU9W2jxjbMCBBkti0NQMU=;
        b=0jAlkEJZMTXop5FSamuJi9Asd7PP9Q6Rvm8RX0LFemxSxNi5EpIe3pBXiyCHKpU3dO
         8/b1ocoQW7Gf3nz2ztCYkx0TBOrwTEv/EXFMBgJ2LJtAnQSZl4UM+wF/tQRuc4e7JcK6
         AGwoQZtMr52E5eFbTFBSFu9xxWBByhPhG1dkMVhFjjxyFggtYgXqVkmmvoTahWfo2uR7
         U1xMNSOtVTHHJvPwkXIroAg+f57NFNWRCt/uSxS8RGVbfpis2B3YWHPHLbL4KoJ9UCAL
         t+ppOtstQzAoqiNli1JRkHhH9crPrSOJ6epvyDr2fVMscUvwbwH0yVkujcuz43J9VbJe
         9EDg==
X-Gm-Message-State: AOAM532NsQiykF/Z3hUhVNStJ9O/7dA+HuTI+wdMBAfcUkrkqUZVPLdu
        paw7IWLWCWbMz9DksDAsOu7Fk1WD5JM=
X-Google-Smtp-Source: ABdhPJy4VOP0ZhhpiVliYHss6TPQzcCZDhJY2NQqlZR5S6XdWeItB9SV8CR2DoLPgm76bxM5Cg+ELA==
X-Received: by 2002:a17:90a:1a4c:: with SMTP id 12mr25047488pjl.175.1636059848111;
        Thu, 04 Nov 2021 14:04:08 -0700 (PDT)
Received: from [10.1.1.26] (222-155-4-20-adsl.sparkbb.co.nz. [222.155.4.20])
        by smtp.gmail.com with ESMTPSA id om8sm25001pjb.12.2021.11.04.14.04.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Nov 2021 14:04:07 -0700 (PDT)
Subject: Re: [PATCH v8 3/3] net/8390: apne.c - add 100 Mbit support to apne.c
 driver
To:     Denis Kirjanov <dkirjanov@suse.de>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
References: <20211104061102.30899-1-schmitzmic@gmail.com>
 <20211104061102.30899-4-schmitzmic@gmail.com>
 <d1b941f8-de6a-4379-aa20-97274088e6df@suse.de>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <843806b9-7a1b-1389-c3f4-b0e01facd2cf@gmail.com>
Date:   Fri, 5 Nov 2021 10:04:02 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <d1b941f8-de6a-4379-aa20-97274088e6df@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis,

On 05/11/21 00:19, Denis Kirjanov wrote:
>
>
> 11/4/21 9:10 AM, Michael Schmitz пишет:
>> Add module parameter, IO mode autoprobe and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>>
>> Select core PCMCIA support modules for use by APNE driver.
>>
>> 10 Mbit and 100 Mbit mode are supported by the same module.
>> Use the core PCMCIA cftable parser to detect 16 bit cards,
>> and automatically enable 16 bit ISA IO access for those cards
>> by changing isa_type at runtime. Code to reset the PCMCIA
>> hardware required for 16 bit cards is also added to the driver
>> probe.
>>
>> An optional module parameter switches Amiga ISA IO accessors
>> to 8 or 16 bit access in case autoprobe fails.
>>
>> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
>> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
>> Kazik <alex@kazik.de>.
>>
>> CC: netdev@vger.kernel.org
>> Link:
>> https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
>>
>> Tested-by: Alex Kazik <alex@kazik.de>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>>
>> --
>>
>> Changes from v7:
>>
>> - move 'select' for PCCARD and PCMCIA to 8390 Kconfig, so
>>    Amiga pcmcia.c may remain built-in while core PCMCIA
>>    code can be built as modules if APNE driver is a module.
>> - move 16 bit mode autoprobe code from amiga/pcmcia.c to this
>>    driver, to allow the core PCMCIA code we depend on to be
>>    built as modules.
>> - change module parameter type from bool to int to allow for
>>    tri-state semantics (autoprobe, 8 bit, 16 bit).
>>
>> Changes from v6:
>>
>> - use 16 bit mode autoprobe based on PCMCIA config table data
>>
>> Changes from v5:
>>
>> - move autoprobe code to new patch in this series
>>
>> Geert Uytterhoeven:
>> - reword Kconfig help text
>>
>> Finn Thain:
>> - style fixes, use msec_to_jiffies in timeout calc
>>
>> Alex Kazik:
>> - revert module parameter permission change
>>
>> Changes from v4:
>>
>> Geert Uytterhoeven:
>> - remove APNE100MBIT config option, always include 16 bit support
>> - change module parameter permissions
>> - try autoprobing for 16 bit mode early on in device probe
>>
>> Changes from v3:
>>
>> - change module parameter name to match Kconfig help
>>
>> Finn Thain:
>> - fix coding style in new card reset code block
>> - allow reset of isa_type by module parameter
>>
>> Changes from v1:
>>
>> - fix module parameter name in Kconfig help text
>>
>> Alex Kazik:
>> - change module parameter type to bool, fix module parameter
>>    permission
>>
>> Changes from RFC:
>>
>> Geert Uytterhoeven:
>> - change APNE_100MBIT to depend on APNE
>> - change '---help---' to 'help' (former no longer supported)
>> - fix whitespace errors
>> - fix module_param_named() arg count
>> - protect all added code by #ifdef CONFIG_APNE_100MBIT
>>
>> change module parameter - 0 for 8 bit, 1 for 16 bit, else autoprobe
>> ---
>>   drivers/net/ethernet/8390/Kconfig |  9 ++++
>>   drivers/net/ethernet/8390/apne.c  | 69 +++++++++++++++++++++++++++++++
>>   2 files changed, 78 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/8390/Kconfig
>> b/drivers/net/ethernet/8390/Kconfig
>> index a4130e643342..b22c3cf96560 100644
>> --- a/drivers/net/ethernet/8390/Kconfig
>> +++ b/drivers/net/ethernet/8390/Kconfig
>> @@ -136,6 +136,8 @@ config NE2K_PCI
>>   config APNE
>>       tristate "PCMCIA NE2000 support"
>>       depends on AMIGA_PCMCIA
>> +    select PCCARD
>> +    select PCMCIA
>>       select CRC32
>>       help
>>         If you have a PCMCIA NE2000 compatible adapter, say Y.
>> Otherwise,
>> @@ -144,6 +146,13 @@ config APNE
>>         To compile this driver as a module, choose M here: the module
>>         will be called apne.
>>   +      The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
>> +      CNet Singlepoint). To activate 100 Mbit support, use the kernel
>> +      option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
>> +      module parameter. The driver will attempt to autoprobe 100 Mbit
>> +      mode, so this option may not be necessary. Use apne.100mbit=0
>> +      should autoprobe mis-detect a 100 Mbit card.
>> +
>>   config PCMCIA_PCNET
>>       tristate "NE2000 compatible PCMCIA support"
>>       depends on PCMCIA
>> diff --git a/drivers/net/ethernet/8390/apne.c
>> b/drivers/net/ethernet/8390/apne.c
>> index da1ae37a9d73..115c008a129c 100644
>> --- a/drivers/net/ethernet/8390/apne.c
>> +++ b/drivers/net/ethernet/8390/apne.c
>> @@ -38,6 +38,7 @@
>>   #include <linux/etherdevice.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/jiffies.h>
>> +#include <pcmcia/cistpl.h>
>>     #include <asm/io.h>
>>   #include <asm/setup.h>
>> @@ -87,6 +88,7 @@ static void apne_block_output(struct net_device
>> *dev, const int count,
>>   static irqreturn_t apne_interrupt(int irq, void *dev_id);
>>     static int init_pcmcia(void);
>> +static int pcmcia_is_16bit(void);
>>     /* IO base address used for nic */
>>   @@ -119,6 +121,10 @@ static u32 apne_msg_enable;
>>   module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>   MODULE_PARM_DESC(msg_enable, "Debug message level (see
>> linux/netdevice.h for bitmap)");
>>   +static u32 apne_100_mbit = -1;
>> +module_param_named(100_mbit, apne_100_mbit, uint, 0444);
>> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
>
> Can we try to detect 100mbit support by default on load and make a
> configuration option in sysfs?

100mbit support _is_ detected by default on load (see code below). The 
module option is only there as an override.

PCMCIA 100mbit support is equivalent to 16 bit IO supported by the card. 
You might argue a sysfs option belongs in the built-in Amiga PCMCIA 
support code, instead of the card driver even though this is about a 
card feature. We had discussed this earlier and gone for the module 
parameter. I'll discuss this with Geert again.

Cheers,

	Michael

>
>> +
>>   static struct net_device * __init apne_probe(void)
>>   {
>>       struct net_device *dev;
>> @@ -140,6 +146,13 @@ static struct net_device * __init apne_probe(void)
>>         pr_info("Looking for PCMCIA ethernet card : ");
>>   +    if (apne_100_mbit == 1)
>> +        isa_type = ISA_TYPE_AG16;
>> +    else if (apne_100_mbit == 0)
>> +        isa_type = ISA_TYPE_AG;
>> +    else
>> +        pr_cont(" (autoprobing 16 bit mode) ");
>> +
>>       /* check if a card is inserted */
>>       if (!(PCMCIA_INSERTED)) {
>>           pr_cont("NO PCMCIA card inserted\n");
>> @@ -167,6 +180,14 @@ static struct net_device * __init apne_probe(void)
>>         pr_cont("ethernet PCMCIA card inserted\n");
>>   +#if IS_ENABLED(CONFIG_PCMCIA)
>> +    if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
>> +        pr_info("16-bit PCMCIA card detected!\n");
>> +        isa_type = ISA_TYPE_AG16;
>> +        apne_100_mbit = 1;
>> +    }
>> +#endif
>> +
>>       if (!init_pcmcia()) {
>>           /* XXX: shouldn't we re-enable irq here? */
>>           free_netdev(dev);
>> @@ -583,6 +604,16 @@ static int init_pcmcia(void)
>>   #endif
>>       u_long offset;
>>   +    /* reset card (idea taken from CardReset by Artur Pogoda) */
>> +    if (isa_type == ISA_TYPE_AG16) {
>> +        u_char tmp = gayle.intreq;
>> +
>> +        gayle.intreq = 0xff;
>> +        mdelay(1);
>> +        gayle.intreq = tmp;
>> +        mdelay(300);
>> +    }
>> +
>>       pcmcia_reset();
>>       pcmcia_program_voltage(PCMCIA_0V);
>>       pcmcia_access_speed(PCMCIA_SPEED_250NS);
>> @@ -616,4 +647,42 @@ static int init_pcmcia(void)
>>       return 1;
>>   }
>>   +#if IS_ENABLED(CONFIG_PCMCIA)
>> +static int pcmcia_is_16bit(void)
>> +{
>> +    u_char cftuple[258];
>> +    int cftuple_len;
>> +    tuple_t cftable_tuple;
>> +    cistpl_cftable_entry_t cftable_entry;
>> +
>> +    cftuple_len = pcmcia_copy_tuple(CISTPL_CFTABLE_ENTRY, cftuple, 256);
>> +    if (cftuple_len < 3)
>> +        return 0;
>> +#ifdef DEBUG
>> +    else
>> +        print_hex_dump(KERN_WARNING, "cftable: ", DUMP_PREFIX_NONE, 8,
>> +                   sizeof(char), cftuple, cftuple_len, false);
>> +#endif
>> +
>> +    /* build tuple_t struct and call pcmcia_parse_tuple */
>> +    cftable_tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
>> +    cftable_tuple.TupleCode = CISTPL_CFTABLE_ENTRY;
>> +    cftable_tuple.TupleData = &cftuple[2];
>> +    cftable_tuple.TupleDataLen = cftuple_len - 2;
>> +    cftable_tuple.TupleDataMax = cftuple_len - 2;
>> +
>> +    if (pcmcia_parse_tuple(&cftable_tuple, (cisparse_t
>> *)&cftable_entry))
>> +        return 0;
>> +
>> +#ifdef DEBUG
>> +    pr_info("IO flags: %x\n", cftable_entry.io.flags);
>> +#endif
>> +
>> +    if (cftable_entry.io.flags & CISTPL_IO_16BIT)
>> +        return 1;
>> +
>> +    return 0;
>> +}
>> +#endif
>> +
>>   MODULE_LICENSE("GPL");
>>
