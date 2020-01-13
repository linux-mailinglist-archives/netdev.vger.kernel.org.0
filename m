Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C91113983A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAMSA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:00:27 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:56234 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgAMSA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 13:00:26 -0500
Received: by mail-pj1-f67.google.com with SMTP id d5so4471785pjz.5;
        Mon, 13 Jan 2020 10:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yCp4vxbbK01gP2xT8FvEO0yKlVhO6YKgXdnC6X6xpIo=;
        b=Ze34RjtYhml3EApPG8NHt7yLS1Q7mFLYrJWTnUGdStT0U8LsKBnnM9JoPLrMZge/aX
         He3lZUWqYykNpTJpWcMaeEzHSM/BewEifnMHDUKxta5a1cTXP0rmwMzaIekRgFxdpBc+
         kTgNinfVyq3Uvb7gMfLDYrtJjIqF3s3dAnTC52trvT7Dder57EYX+TI/aYdraj2gu946
         HNALx0Ir4K6EOmDJLr2r8iQn3a79I3XuS/TdJ49NbCTNVp+GkqP0g21zEK9HrUucgL51
         BVGaN5Zv534n2NcfNalsKB3UsE9EWWXgCmEqLTHWlX22Nvm6vpR5Qtnp/n3yPuI7w5lk
         fLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yCp4vxbbK01gP2xT8FvEO0yKlVhO6YKgXdnC6X6xpIo=;
        b=V+TP0U+0p5mBDKXJ2V6nA6MhRnQW85oZkuVKN4ofBvj24+Ipgf446AsojU5PxUefNM
         xrDysD2gJsIADvAceDKMeqDWwG0TnQTeD4prwb56VJ3igvEjAHTnJ+dwf1PXNKn0vqbu
         w7WqkzbOWh4XSTbdW3EyHBZNKkDk03zvEyDNl/Gg0YMMu0lLamG+or+NwYpuAQdEhFA+
         BqV2U9Nm+fnG3xaCfEtp3OPe+e+5lyNYJhSzH7OEeRQSr7YecERomesppDTS6tumelCq
         SsjN45H29bBh5uyBvQ3hR9VcnvidqdTV1Y4ljAoX+DUpzT2YqrnmmAk3QtNdHQpViark
         eodw==
X-Gm-Message-State: APjAAAWJMH0vZwSqzUUWiJDaVukHYm6od02QgzHu0D0BjiLKllpzRpw8
        SzNRT+s/25O4AN++ng9uIpmQuWAb
X-Google-Smtp-Source: APXvYqx0ilb1HbdpABCCDkDFnhSvNm3O9GjCUKFojhjmHpkO7VZcMK0ZV0VREOiObyYR95cqHpth8g==
X-Received: by 2002:a17:902:740c:: with SMTP id g12mr15871413pll.166.1578938425545;
        Mon, 13 Jan 2020 10:00:25 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x7sm15359248pfp.93.2020.01.13.10.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 10:00:25 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: Maintain MDIO device and bus
 statistics
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20200113045325.13470-1-f.fainelli@gmail.com>
 <20200113132152.GB11788@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <ebeb2bb2-c816-6cb8-acaa-cfd86878678d@gmail.com>
Date:   Mon, 13 Jan 2020 10:00:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200113132152.GB11788@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 1/13/20 5:21 AM, Andrew Lunn wrote:
> On Sun, Jan 12, 2020 at 08:53:19PM -0800, Florian Fainelli wrote:
>> Maintain per MDIO device and MDIO bus statistics comprised of the number
>> of transfers/operations, reads and writes and errors. This is useful for
>> tracking the per-device and global MDIO bus bandwidth and doing
>> optimizations as necessary.
> 
> Hi Florian
> 
> One point for discussion is, is sysfs the right way to do this?
> Should we be using ethtool and exporting the statistics like other
> statistics?
> 
> The argument against it, is we have devices which are not related to a
> network interfaces on MDIO busses. For a PHY we could plumb the per
> PHY mdio device statistics into the exiting PHY statistics. But we
> also have Ethernet switches on MDIO devices, which don't have an
> association to a netdev interface. Broadcom also have some generic PHY
> device on MDIO busses, for USB, SATA, etc. And whole bus statistics
> don't fit the netdev model at all.

Correct, that was the reasoning, which I should probably put in the
commit message.

> 
> So sysfs does make sense. But i would also suggest we do plumb per PHY
> MDIO device statistics into the exiting ethtool call.

It looks like replicating statistics that are already available via
another mechanism is kind of frowned upon, see this for an example:



> 
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-mdio |  34 +++++++
>>  drivers/net/phy/mdio_bus.c               | 116 +++++++++++++++++++++++
>>  drivers/net/phy/mdio_device.c            |   1 +
>>  include/linux/mdio.h                     |  10 ++
>>  include/linux/phy.h                      |   2 +
>>  5 files changed, 163 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/sysfs-bus-mdio
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-mdio b/Documentation/ABI/testing/sysfs-bus-mdio
>> new file mode 100644
>> index 000000000000..a552d92890f1
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-mdio
>> @@ -0,0 +1,34 @@
>> +What:          /sys/bus/mdio_bus/devices/.../statistics/
>> +Date:          January 2020
>> +KernelVersion: 5.6
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +		This folder contains statistics about MDIO bus transactions.
>> +
>> +What:          /sys/bus/mdio_bus/devices/.../statistics/transfers
>> +Date:          January 2020
>> +KernelVersion: 5.6
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +		Total number of transfers for this MDIO bus.
>> +
>> +What:          /sys/bus/mdio_bus/devices/.../statistics/errors
>> +Date:          January 2020
>> +KernelVersion: 5.6
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +		Total number of transfer errors for this MDIO bus.
>> +
>> +What:          /sys/bus/mdio_bus/devices/.../statistics/writes
>> +Date:          January 2020
>> +KernelVersion: 5.6
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +		Total number of write transactions for this MDIO bus.
>> +
>> +What:          /sys/bus/mdio_bus/devices/.../statistics/reads
>> +Date:          January 2020
>> +KernelVersion: 5.6
>> +Contact:       netdev@vger.kernel.org
>> +Description:
>> +		Total number of read transactions for this MDIO bus.
> 
> Looking at this description, it is not clear we have whole bus and per
> device statistics. 
> 
>>  int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>>  {
>> +	struct mdio_device *mdiodev = bus->mdio_map[addr];
>>  	int retval;
>>  
>>  	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
>> @@ -555,6 +645,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>>  	retval = bus->read(bus, addr, regnum);
>>  
>>  	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
>> +	mdiobus_stats_acct(&bus->stats, true, retval);
>> +	if (mdiodev)
>> +		mdiobus_stats_acct(&mdiodev->stats, true, retval);
>>  
>>  	return retval;
> 
> I think for most Ethernet switches, these per device counters are
> going to be misleading. The switch often takes up multiple addresses
> on the bus, but the switch is represented as a single mdiodev with one
> address.

For MDIO switches you would usually have the mdio_device claim the
pseudo PHY address and all other MDIO addresses should correspond to
built-in PHYs, for which we also have mdio_device instances, is there a
case that I am missing?

> So the counters will reflect the transfers on that one
> address, not the whole switch. The device tree binding does not have
> enough information for us to associated one mdiodev to multiple
> addresses. And for some of the Marvell switches, it is a sparse address
> map, and i have seen PHY devices in the holes. So in the sysfs
> documentation, we should probably add a warning that when used with an
> Ethernet switch, the counters are unlikely to be accurate, and should
> be interpreted with care.

If the answer to my question above is that we still have reads to
addresses for which we do not have mdio_device (which we might very well
have), then we could either:

- create <mdio_bus>:<address>/statistics/ folders even for non-existent
devices, but just to track the per-address statistics
- create <mdio_bus>/<address>/statistics and when a mdio_device instance
exists we symbolic link <mdio_bus>:<address>/statistics ->
../<mdio_bus>/<addr>/statistics

Would that work?
-- 
Florian
