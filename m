Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F7FD882C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387440AbfJPFsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:48:20 -0400
Received: from mout.gmx.net ([212.227.15.19]:40497 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfJPFsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 01:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571204883;
        bh=65lW9dAdvijQMWhG3ua+QYp0BwCCA6cteHad21u0XDo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=HnwlK6zYSSYMRVKucvOP3Nf5CFzE3SYqAz3abmT3rtcB/6Die/o1elFy85+M3q/1m
         d7flwGoo/dyeqbJMrOsdSXhO6uGiNALs5cFVhibZdFK3uNK0tQTabY7pLBoEKHotwj
         XkR+s/27Q0t0Lu9BWSPZjCokOX2u5G6LblMvml9c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0X8o-1i6GCk3v4G-00wUZQ; Wed, 16
 Oct 2019 07:48:03 +0200
Subject: Re: lan78xx and phy_state_machine
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Wagner <dwagner@suse.de>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
 <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
 <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
 <20191014221211.GR25745@shell.armlinux.org.uk>
 <524267e6-df8e-d884-aeef-1ed8700e4e58@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <4b160706-97a4-1fd8-9ddb-00a81d0cd6bb@gmx.net>
Date:   Wed, 16 Oct 2019 07:48:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <524267e6-df8e-d884-aeef-1ed8700e4e58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:Ew7FNDku7ITKf0fnF4Nvts7IZlNkydC8o0+5l8Ur87v+IVxOCRW
 M+zVQx/mCY6gFDDx04bBSPjOEHDK3L+pYbwv2db9HxHPksvZ6kWy8qDyy9+NmOhmapqMLAF
 exISiaWXKX285EiRT7KLlGkwfILDSWbL57N1/hGngKU4jbUtCRM/RChB7Mq3O1Zgv4tY4/i
 qPJbdhByOWjpgrjehF8Ow==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m03NsduD8hg=:QTnRELOPLA8iyWNrENMKQl
 KLsEU7kRUXo5eWaGOGCGLHAOQiCLOPPAuyFgB5yfN3DA5MQpjYKqDc9aSWl1dEtGdQYHrgSh1
 +BeyIWC2QppDBJPVXjW14RcD0lz+krIUEr1DVqP2qFGMYfg+ukwtsO3zp77IzULkPxM4LHEo8
 OjJOirz/WYKAwGVKGEtaI74P8pWu87hcGjLRsgsFiy8/aI3ZMQRmaKQZs1uUPx/KXo2hZUDT2
 8UbAWY63nqOH7sseO3mRMcYaAXR469pAOmGz1sjxAEoeBLCXcujdgfR8g8I0Ojf5VjmaBAoHa
 9jcahKCKuAjNTJmDK18WDe56MdNlvq/mxM0yDgLxmCWHvKWzu1FQU5DOV3rrv2N6JSAwe8PuU
 UPdUfRyw5iLzKhCehxW3KPvoTzNblpjUJhW8ao1a2vmYtatCwbDyclF8iM3VvDg+o/oMGsRGz
 BnedLgs66Is26ZYFHXQB+0Nh9ckmgRLHzJPBbpjtsynSbiKayKGMKplBg+jTJ/TIb78YXuKPK
 eWrsX3ppW+MPXo09mHnbeDnsJw0HikzCu8w2FgtF1hrah9svVO6hZD/QfD7rZPnskDfrWQntl
 UY9aT3yUN592nq3DYe0imF6YdCj4wF99ti3Seo7MTEA8tNCJlJYlxzTC5gZ2kRYzTJnOs5jlD
 U5CRDH430kXlWnp3C2lrTHaMe2EDcAxxNHYvIr+PfLwPFDxOZBiHPnJVawkiiLbs+bSvo2I5W
 cxJUt3zcfBw+/WnqvQ6lkAfdF4D2SAayQmVz9EK9T974ksf59v2n5UGo7lzAB43vwB8+o5G4G
 oorUx/I7/TgtkaJCiZlGUa9uFdQ0KTj0JuRx4r0mcH15FS0yPs5OPPj8l1JbGuyDjtDn9h/tz
 a+aMDXzVYzlEWSXOWs4qd87cSpxE+eBQx/L+rbdcLtg9InD1yb76RfFiuN9DDcoILPmcyOLSV
 PVM2G6On1gmL8VQVo7ukBN1vBB9uyl5/yNYBWeeb10lTZDvzLjO03rHCkIrLNPpmm+QAZnOL5
 0YnyKWklDhLLuKtphQiR4foucNKdI7iGEulzOB/3YImC0Y0FOLAUnU/DXODlNsecogl2DXn1c
 EAxvxjh1T8oJyCEo0hmH78d32aIQXTdpJnRnpQwR8Kofgn71trI6sZx9flJO/vUUTHq+AzukV
 0dIMVRZDZ+Fnn5xExVwaRqb7w9iatO8ppgDmVf3T+1EttKRoxdadjMyyxxq7QqXwWS6Sgrxqe
 7AktKoxj47X6d5bEq8Tqe1wm/Snd7PzA9n+qoesHfnVWEL1j67E+8uU8iVEo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 15.10.19 um 21:38 schrieb Heiner Kallweit:
> On 15.10.2019 00:12, Russell King - ARM Linux admin wrote:
>> On Mon, Oct 14, 2019 at 10:20:15PM +0200, Heiner Kallweit wrote:
>>> On 14.10.2019 21:51, Stefan Wahren wrote:
>>>> [add more recipients]
>>>>
>>>> Am 14.10.19 um 21:25 schrieb Daniel Wagner:
>>>>> Moving the phy_prepare_link() up in phy_connect_direct() ensures that
>>>>> phydev->adjust_link is set when the phy_check_link_status() is called.
>>>>>
>>>>> diff --git a/drivers/net/phy/phy_device.c
>>>>> b/drivers/net/phy/phy_device.c index 9d2bbb13293e..2a61812bcb0d 100644
>>>>> --- a/drivers/net/phy/phy_device.c +++ b/drivers/net/phy/phy_device.c
>>>>> @@ -951,11 +951,12 @@ int phy_connect_direct(struct net_device *dev,
>>>>> struct phy_device *phydev, if (!dev) return -EINVAL;
>>>>>
>>>>> +       phy_prepare_link(phydev, handler);
>>>>> +
>>>>>         rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
>>>>>         if (rc)
>>> If phy_attach_direct() fails we may have to reset phydev->adjust_link to NULL,
>>> as we do in phy_disconnect(). Apart from that change looks good to me.
>> Sorry, but it doesn't look good to me.
>>
>> I think there's a deeper question here - why is the phy state machine
>> trying to call the link change function during attach?
> After your comment I had a closer look at the lm78xx driver and few things
> look suspicious:
>
> - lan78xx_phy_init() (incl. the call to phy_connect_direct()) is called
>   after register_netdev(). This may cause races.
>
> - The following is wrong, irq = 0 doesn't mean polling.
>   PHY_POLL is defined as -1. Also in case of irq = 0 phy_interrupt_is_valid()
>   returns true.
>
> 	/* if phyirq is not set, use polling mode in phylib */
> 	if (dev->domain_data.phyirq > 0)
> 		phydev->irq = dev->domain_data.phyirq;
> 	else
> 		phydev->irq = 0;
>
> - Manually calling genphy_config_aneg() in lan78xx_phy_init() isn't
>   needed, however this should not cause our problem.
Thanks for this review. This may help to fix at least a one of all the
other issues with lan78xx.
