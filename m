Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ACDD6AB3
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 22:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfJNUU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 16:20:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44019 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbfJNUU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 16:20:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so21123441wrq.10
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 13:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4pJ8h1KvG9GMPqRJCIBO4L84mDfYWc2RR4B52wfi9C0=;
        b=FpwwRgGjAc3xrZCrVPSRcgQlYoFdjvNTwhpUQlBalQ99gJJj4xzpTr6JxyglWveRx2
         a/vgpxi6EmvRuX8FYJRy9ICXJZbBO7+caNgbl8O7n5erU1jnIZM8ngttSsX6MV+WQP7R
         hiXH/Id8TdJsWgzsziV9jeSPB1020ICpXoLrPMohPH6T1nCUGLqhVYs9K7CcGNojMWb8
         t9oytQSRE3NUh5kooxGM+7nnb3itY7FkMv9hjXcGAwBo2kqrIR8ySIlAOkGoMMeY9jtN
         ry8PN1TVGWznE6pt7ALBdiWPXiyNlP9KMiMnmp7h21uKJSBrHv5GClsDmUYBdNMIe71a
         YdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4pJ8h1KvG9GMPqRJCIBO4L84mDfYWc2RR4B52wfi9C0=;
        b=OteIq1d545nn7ET9budwRhiMcbK/0qvPu7zIHtVshdcG1QIlLzSCeqqdy5UPPT0JWH
         MQDafMVQebcp79RKbkEk+28FAsDFBRyg2KCyzRCddDx0ocR+gq8mawMUbXDPBYqYz5oQ
         YWC7ydlWX2HGTmKG9hLygiR18HIDDbSS8iaUyEnbENuxck7b7G8b+r03R8/Y/JSgez3A
         wufJqhGkr+76UzlSfiSO1I+7lZdphrmqcxLtS9w9Oa8a6F0dXfRqwCoFDfwxY6Y2a4nN
         bCHnwM2f7W79COMf0Z/VwYMflEJbGAPF3jmGNEplyly/tKdwWZk5wiLFmC+KTiyQDHei
         JmVg==
X-Gm-Message-State: APjAAAXZsp5QtR2GjCEnpay7qFJhXOr+ladV/NXAE/tqwNWlIZxUsDAK
        6REfGQZWYX499gZFm+kTYxau2lVL
X-Google-Smtp-Source: APXvYqzSbq14INxUN4bj8YseI10o6NiB5w+YmbHKi06Q5p4i2P5FLL7Q6YMhWCWY6l9aZuAcACL+Vw==
X-Received: by 2002:adf:dc82:: with SMTP id r2mr5984223wrj.74.1571084424355;
        Mon, 14 Oct 2019 13:20:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ed5d:7e31:897c:be08? (p200300EA8F266400ED5D7E31897CBE08.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ed5d:7e31:897c:be08])
        by smtp.googlemail.com with ESMTPSA id r2sm42492616wma.1.2019.10.14.13.20.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 13:20:23 -0700 (PDT)
Subject: Re: lan78xx and phy_state_machine
To:     Stefan Wahren <wahrenst@gmx.net>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
 <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
Date:   Mon, 14 Oct 2019 22:20:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.10.2019 21:51, Stefan Wahren wrote:
> [add more recipients]
> 
> Am 14.10.19 um 21:25 schrieb Daniel Wagner:
>> On Mon, Oct 14, 2019 at 05:30:04PM +0100, Russell King - ARM Linux admin wrote:
>>> On Mon, Oct 14, 2019 at 04:06:04PM +0200, Daniel Wagner wrote:
>>>> Hi,
>>>>
>>>> I've trying to boot a RPi 3 Model B+ in 64 bit mode. While I can get
>>>> my configuratin booting with v5.2.20, the current kernel v5.3.6 hangs
>>>> when initializing the eth interface.
>>>>
>>>> Is this a know issue? Some configuration issues?
>>> I don't see any successfully probed ethernet devices in the boot log, so
>>> I've no idea which of the multitude of ethernet drivers to look at.  I
>>> thought maybe I could look at the DT, but I've no idea where
>>> "arm/bcm2837-rpi-3-b-plus.dts" is located, included by
>>> arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b-plus.dts.
>> Sorry about being so terse. I thought, the RPi devices are well known. My bad.
>> Anyway, the kernel reports that is the lan78xx driver.
>>
>> ls -1 /sys/class/net/ | grep -v lo | xargs -n1 -I{} bash -c 'echo -n {} :" " ; basename `readlink -f /sys/class/net/{}/device/driver`'
>> eth0 : lan78xx
>>
>>> The oops is because the PHY state machine has been started, but there
>>> is no phydev->adjust_link set.  Can't say much more than that without
>>> knowing what the driver is doing.
>> This was a good tip! After a few printks I figured out what is happening.
>>
>> phy_connect_direct()
>>    phy_attach_direct()
>>      workqueue
>>        phy_check_link_status()
>>          phy_link_change
>>

Interesting is just what is special with your config that this issue
didn't occur yet on other systems.

>>
>> Moving the phy_prepare_link() up in phy_connect_direct() ensures that
>> phydev->adjust_link is set when the phy_check_link_status() is called.
>>
>> diff --git a/drivers/net/phy/phy_device.c
>> b/drivers/net/phy/phy_device.c index 9d2bbb13293e..2a61812bcb0d 100644
>> --- a/drivers/net/phy/phy_device.c +++ b/drivers/net/phy/phy_device.c
>> @@ -951,11 +951,12 @@ int phy_connect_direct(struct net_device *dev,
>> struct phy_device *phydev, if (!dev) return -EINVAL;
>>
>> +       phy_prepare_link(phydev, handler);
>> +
>>         rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
>>         if (rc)

If phy_attach_direct() fails we may have to reset phydev->adjust_link to NULL,
as we do in phy_disconnect(). Apart from that change looks good to me.

>>                 return rc;
>>
>> -       phy_prepare_link(phydev, handler);
>>         if (phy_interrupt_is_valid(phydev))
>>                 phy_request_interrupt(phydev);
>>
>> _______________________________________________
>> linux-rpi-kernel mailing list
>> linux-rpi-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
> 

Heiner
