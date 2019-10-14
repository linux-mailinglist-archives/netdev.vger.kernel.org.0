Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB4D6A70
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 21:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfJNT4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 15:56:51 -0400
Received: from mout.gmx.net ([212.227.15.15]:33385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730134AbfJNT4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 15:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571082692;
        bh=Y5igX5hM4djlJOytXHHgXEoCTCqTk5mnFb6UVSCd1h8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MlvJuysrZF8FTKWBUNzlIeCXDVbRZ3rotEK0L91nevZGT/ys7PN6/NwJseFEb8yOR
         2CTJmKA2jI9BLxpu1H4NZ29vjk8H02VO5bjPRAeK7xvMXYwaUqzBCjJ2LlEnYOyqao
         uhCT01n/rjTTiqmqOIxJIERb6du7rSXSWaJgMXnQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQe9s-1ifTFa2qyE-00NfK1; Mon, 14
 Oct 2019 21:51:32 +0200
Subject: Re: lan78xx and phy_state_machine
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
Date:   Mon, 14 Oct 2019 21:51:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:KhWpe5vytOT1yOYuJgf6j0RJfHwIaadx2ie96PDTExWMpgUyJyp
 Ysb5ZE9tonrP1/8sjsGnJJ0f9KSwEIq9YIIknrglbvR43hHcyaLy88Nn819Wje1ignXmbho
 5FdKt6ENUTXtBVdVMm3/oWPzmw4ugl7Ipn3QZ6QIfeJH4LluTAczTUuoU83jyNy/xlxwrXN
 +ccThxeBseApyZe4oLIZg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZJxRnKYKkL4=:TThLYJvjThvWnnIvBxGHTZ
 uRJOw6MilpZy1iPJFyFCmBN54Iv/1uydUEACb53douaeMgqeMvEO1yNuLOIuV4y7CQ2OF538J
 QBlBTnis6ULCe2O5671otVLQgLwlq3/0D2irv2dtZskESdQhEnsiQwJnVJNFG5HGqFJfUXyOm
 +6nI/ME1W43f1G46oBzV3VYvT1P89MUVGh3+uJ3K5cQ07qTfkgCPEC8Y2/oRrnipnIdLaCNlk
 +YkG2Ba+M3VHkjpcZcYkfOqR63XP35xFrK8JDGsQOmotOaejars2OaYZn5k6wflKxt/SfYwXs
 u5a2/m4bzmczN+9+dBOKH+5RSWuF9OQ1l78JR3JCIeJ0AKEZTNHHw5L9yh7FanYXljoV9nIsT
 QLfXxclfYRUdbvlJx/no323+xstInoHGl+IQYfLZFbOGXOLR0aWI08Rzs3KXZ/684ElZwGrxb
 sop2HCIvr5YEEUJaLgLlMS/xBonR4XDGMrGU7DJ/9mMtazx4huR0483oUavWDUHAhrw+nHNEi
 GcCbQskHXaVsrHmHcQw17or4+ynLQwZIaWyZnQDiELBQhpdjNNcEwAfvdC69pEyXQ3TMSe6gV
 RC7Lf5K5VNJAV/dyjwN8vnbpGFw6TVcp2EGVX6nZBaj37C+/TOdX1ZUhIQCAlwQQurHkuOX1n
 H2uiKPHX0/r9rsQJ8SdmavxX9bi8mfJBe5fz3VHNaO6nmpJaS2iRKcll2IMhrOxv6oX54UrGV
 1YBZoDSyTN1w0V4sSRP0G4afQ/p8NseuwgdywgYxW/sPgvDHGJy9dgQu6ykercXFg/F/R9rTl
 vSfWsGMx3BxHlGW7jEZe87qZndf26hdeo/q+4ZwBu+KOnYAObii27H157eRVKWCfAb/+Ojqrp
 MuVFUBfTVIIw4f75cVGPvdztfRjJ/krF36HmuumX+ipRPN8R1ekfsSWwpbv/8ygXc3E0p5I3P
 hjxraB0brq0/3gucAqvF0tT/e6gCp73zTjJSKpZOCOVWfbqBErYM4kE/b1f1ByqVD8hVgvuGr
 1tszEulUhpjsxQH7BNAD8sYBUav+qBAnt35awmrJ1cvbhatQMvzHligOFua0AhgP+X6Smlqy5
 njGGIN0W0JrqpriFrMHvdO7j0A/QwlM3gZin1tz0zuBUN8/rrIwrSY1Kw1RD30cjQ++7QZhrg
 6DZBAnuR6zafLlK6wywqarRs9gH6MvkkInzUQYCm5RBCepy9sxQUZff6cvDSa+tJCk1jcBjxR
 EKbIa4ODvha71IEQVhRccRdL1vRVCIsigVL4L/zTxkkCNy4slK7infl6IbUg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[add more recipients]

Am 14.10.19 um 21:25 schrieb Daniel Wagner:
> On Mon, Oct 14, 2019 at 05:30:04PM +0100, Russell King - ARM Linux admin=
 wrote:
>> On Mon, Oct 14, 2019 at 04:06:04PM +0200, Daniel Wagner wrote:
>>> Hi,
>>>
>>> I've trying to boot a RPi 3 Model B+ in 64 bit mode. While I can get
>>> my configuratin booting with v5.2.20, the current kernel v5.3.6 hangs
>>> when initializing the eth interface.
>>>
>>> Is this a know issue? Some configuration issues?
>> I don't see any successfully probed ethernet devices in the boot log, s=
o
>> I've no idea which of the multitude of ethernet drivers to look at.  I
>> thought maybe I could look at the DT, but I've no idea where
>> "arm/bcm2837-rpi-3-b-plus.dts" is located, included by
>> arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b-plus.dts.
> Sorry about being so terse. I thought, the RPi devices are well known. M=
y bad.
> Anyway, the kernel reports that is the lan78xx driver.
>
> ls -1 /sys/class/net/ | grep -v lo | xargs -n1 -I{} bash -c 'echo -n {} =
:" " ; basename `readlink -f /sys/class/net/{}/device/driver`'
> eth0 : lan78xx
>
>> The oops is because the PHY state machine has been started, but there
>> is no phydev->adjust_link set.  Can't say much more than that without
>> knowing what the driver is doing.
> This was a good tip! After a few printks I figured out what is happening=
.
>
> phy_connect_direct()
>    phy_attach_direct()
>      workqueue
>        phy_check_link_status()
>          phy_link_change
>
>
> Moving the phy_prepare_link() up in phy_connect_direct() ensures that
> phydev->adjust_link is set when the phy_check_link_status() is called.
>
> diff --git a/drivers/net/phy/phy_device.c
> b/drivers/net/phy/phy_device.c index 9d2bbb13293e..2a61812bcb0d 100644
> --- a/drivers/net/phy/phy_device.c +++ b/drivers/net/phy/phy_device.c
> @@ -951,11 +951,12 @@ int phy_connect_direct(struct net_device *dev,
> struct phy_device *phydev, if (!dev) return -EINVAL;
>
> +       phy_prepare_link(phydev, handler);
> +
>         rc =3D phy_attach_direct(dev, phydev, phydev->dev_flags, interfa=
ce);
>         if (rc)
>                 return rc;
>
> -       phy_prepare_link(phydev, handler);
>         if (phy_interrupt_is_valid(phydev))
>                 phy_request_interrupt(phydev);
>
> _______________________________________________
> linux-rpi-kernel mailing list
> linux-rpi-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
