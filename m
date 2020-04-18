Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164331AF1FE
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDRQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgDRQBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:01:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F69DC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:01:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a32so2525870pje.5
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z80UKq7Br8kyU2oOLI6L+aOEQTfcWn2zINsj6lOlGxc=;
        b=aGaR4n4PDj9hHA3IF0rk+P8Y5aFP05vAFzoMsFQIUgNcsQHuK0Al6O2Bf9DYQ+3fL2
         dIggxFYNR2aO07bFxhPyX152cC7eN3ZDH/hIYubkdImfwQhCbCfMBhU+va12NdbOCVtO
         9+ERwFfSn7nFnhweOrl4jIvKRj5DpJKz2VhNocCJXZYUU/ufB8MDBd2yV9HgbQRi0KHg
         ucGj3VPZjZMXjKvAHSIeVhu1lcshV9fNnXaRjsdon0WiECuLL9IG+fV4sRVGjR7hkwiT
         kJY84q/juNMHjutYtWCkN+a+1YUV0hOB1swzhaCIixXyS6dc9VG4mCmKGVSZLIlc06KY
         TABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z80UKq7Br8kyU2oOLI6L+aOEQTfcWn2zINsj6lOlGxc=;
        b=F5T16PH4Ma30MDzSjfKsz8OQDZ64JLoCdDO8uzwo009UUpjbKKOMDUpTOEPbGew4Rq
         VVYwSxqKMwXPB7dEMD16Z/ggqyQlNscYKNUoEYpVlWotSM7HWZKWk72glS7C1K4ROCag
         +t8A65Srl5HiZ6bGrCi//Isk9ndIn/82y2wzKoRPLxQgB0bNCpnVDrOH0x8ig0Pc4ORt
         dca5xYwv7HxDNiSk9aLNC2gjLUzqffDjKROOMKb2CWkPiUHiPQVST3a0FJgw106J1vxU
         LtAh/TFXHjM9yCtzFK0efqmzLbwUH9wy5PECQzZtiL5Lw+8pCjf/pa3BUvUbFSupgOk+
         BYPA==
X-Gm-Message-State: AGi0PuZeEKiaDvZh04YWC5BS3PPh9YGhBtUWI4ZV/cE/kOzWehN1plb9
        9RLl9LqJqoUXYWvocp5oZcU=
X-Google-Smtp-Source: APiQypJkSGnIQlexi6kAA22a0M3jL6bDdK1ScRGOn/cb//0pIHNvUrTSDo6IfrNoExdH/1crmS2mLg==
X-Received: by 2002:a17:902:7485:: with SMTP id h5mr8530674pll.226.1587225708186;
        Sat, 18 Apr 2020 09:01:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x10sm6373049pgq.79.2020.04.18.09.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 09:01:47 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
 <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
 <20200418142336.GB804711@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6b6c42b-aa2d-8036-958e-4f9929752536@gmail.com>
Date:   Sat, 18 Apr 2020 09:01:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418142336.GB804711@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 7:23 AM, Andrew Lunn wrote:
> On Fri, Apr 17, 2020 at 05:34:56PM -0700, Florian Fainelli wrote:
>> Hi Andrew,
>>
>> On 4/17/2020 5:03 PM, Andrew Lunn wrote:
>>> MDIO busses typically operate at 2.5MHz. However many devices can
>>> operate at faster speeds. This then allows more MDIO transactions per
>>> second, useful for Ethernet switch statistics, or Ethernet PHY TDR
>>> data. Allow the bus speed to be configured, using the standard
>>> "clock-frequency" property, which i2c busses use to indicate the bus
>>> speed.
>>>
>>> Suggested-by: Chris Healy <Chris.Healy@zii.aero>
>>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>>
>> This does look good to me, however if we go down that road, it looks like we
>> should also support a 'mdio-max-frequency' per MDIO child node in order to
>> scale up and down the frequency accordingly.
> 
> Hi Florian
> 
> I don't see how that would work. Each device on the bus needs to be
> able to receiver the transaction in order to decode the device
> address, and then either discard it, or act on it. So the same as I2C
> where the device address is part of the transaction. You need the bus
> to run as fast as the slowest device on the bus. So a bus property is
> the simplest. You could have per device properties, and during the bus
> scan, figure out what the slowest device is, but that seems to add
> complexity for no real gain. I2C does not have this either.
> 
> If MDIO was more like SPI, with per device chip select lines, then a
> per device frequency would make sense.

OK, that is a good point, but then again, just like patch #3 you need to 
ensure that you are setting a MDIO bus controller frequency that is the 
lowest common denominator of all MDIO slaves on the bus, which means 
that you need to know about what devices do support.

Your current patch makes it possible for someone to set a 
'clock-frequency' which is not going to guarantee that all MDIO devices 
will work, and the same is arguably true for every other MDIO controller 
that supports having its bus frequency defined/controlled. So maybe we 
can make this in a progressive manner: start with your patches, but add 
support for specifying the MDIO devices' maximum supported frequency and 
later add code in mdio_bus.c which is responsible for selecting the 
lowest frequency and telling the use that a frequency lower than that 
specified in 'clock-frequency' has been selected.
-- 
Florian
