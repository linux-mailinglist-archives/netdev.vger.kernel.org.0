Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE7F3EB1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfKHEGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:06:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39093 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfKHEGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:06:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id t26so4775468wmi.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 20:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6HI0cQLJ09P2w2nl42vy7SN3qXqwzINozbfNMS/s318=;
        b=Z/boHzJeZhBD3T7C+F7m8pYZGWOCik+aop6L8fltS/k5jts56ij5YnAeopsmzoGswR
         Idhz4NuE2IB4qzicXttULkuTl+W3UP2R4cjnmo4UWnht0atqKnakfZtUfu7U8wv67uO2
         pyvi8zpc5ixl8EQb+puPQ1CZ+CbzubN9HveXYso1qE/BInqAggD0uZvGj7JiHTNylCYl
         IBi2tej9clow+HU8vAu+MudnsTrZUQI5MKBWOeTq9f9fdDXKWrnbnHbJdgef97buhkId
         ewidwdXGDcQdkW22vIr7Yzc/rFesaFKuhPXhBP0w5CQWgYx/mzHejV3utFwDRTHXSngo
         BYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6HI0cQLJ09P2w2nl42vy7SN3qXqwzINozbfNMS/s318=;
        b=YKk7ETu0R638OinV4C8Ej8jVPfr0qLziv/5ntAWqOlE9bZBSli7j4yYuKXzs2UQmPX
         aJfU6ZVcRYxhgIeWT+aUlZ4HowvArRjbltyMDd1NcZu/FIb6mMpfH5TOhMLSSa18xMVR
         q/UPEiGNCdaoUjBWJe/0dtTLqlxldKOzcyx2McaiTlhTbNuyhFCrl6Sb+gtCcoxGFGXh
         dbBiE6GsLkzffrQP/5Zr8NxMwphw9MaX3HZMbqK6LvJT/A11HNH24RMEKCpVL2iirgbo
         iUY6VmSkg7s67TZuQ1ArfN7Ro/GGpjvLIDpvXAZKQZT7v0zRc/WkQVRSV8KARCqz7DMs
         OB+A==
X-Gm-Message-State: APjAAAXQ9SCEP+r0RF2vkJXcRQNNzOjzOugo/cy0CzLtekwfjWZ4K5Sw
        KYJACgLKmT7R5JHzQlHsU3iiemX+
X-Google-Smtp-Source: APXvYqzYBLchscr+zySI2W0F/dnbPTO/MthrfjgQ4U2RZRXL6WfSunKASZXaM6EEUC7t5iDzVyHh+w==
X-Received: by 2002:a1c:5415:: with SMTP id i21mr6429082wmb.120.1573185993509;
        Thu, 07 Nov 2019 20:06:33 -0800 (PST)
Received: from [10.230.29.119] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i18sm4460103wrx.14.2019.11.07.20.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 20:06:32 -0800 (PST)
Subject: Re: Possibility of me mainlining Tehuti Networks 10GbE driver
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
References: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <6fc9c7ef-0f6c-01e0-132b-74a80711788e@gmail.com>
Date:   Thu, 7 Nov 2019 20:06:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/7/2019 6:24 PM, Nicholas Johnson wrote:
> Hi all,
> 
> To start off, if I am emailing the wrong people, please blame the output 
> of: "scripts/get_maintainer.pl drivers/net/ethernet/tehuti/" and let me 
> know who I should be contacting. Should I add in 
> "linux-kernel@vger.kernel.org"?
> 
> I just discovered that the Tehuti 10GbE networking drivers (required for 
> things such as some AKiTiO Thunderbolt to 10GbE adapters) are not in 
> mainline. I am interested in mainlining it, but need to know how much 
> work it would take and if it will force me to be the maintainer for all 
> eternity.
> 
> The driver, in tn40xx-0.3.6.15-c.tar appears to be available here:
> Link: https://www.akitio.com/faq/341-thunder3-10gbe-adapter-can-i-use-this-network-adapter-on-linux
> Also here:
> Link: https://github.com/acooks/tn40xx-driver
> 
> I see some immediate style problems and indentation issues. I can fix 
> these.
> 
> The current driver only works with Linux v4.19, I believe. There are a 
> small handful of compile errors with v5.4. I can probably fix these.
> 
> However, could somebody please comment on any technical issues that you 
> can see here? How much work do you think I would have to do to mainline 
> this? Would I have to buy such a device for testing? Would I have to buy 
> *all* of the supported devices for testing? Or can other people do that 
> for me?

This is based on roughly 5 minutes of browsing source files, but what I
see, which is typical from out of tree vendor drivers is a complete lack
of use of existing kernel APIs beyond registering a net_device which you
would have to use to seek upstream inclusion, that includes for the most
part:

- make use of the PHYLINK subsystem for supporting 10GBaseT and SFP
modules instead of doing your own, there might be existing PHY drivers
that you can use for the Aquantia and Marvell parts, see
drivers/net/phy/ to check whether the PHY models are indeed supported

- implement a proper mii_bus interface for "talking" to the PHYs,
implement a proper gpio_chip instance to register with Linux as a GPIO
controller, such that then you can use i2c-gpio to become an i2c bus
master driver, and then talk to the SFPs properly

- lots and lots of stylistic issues that must be fixed

- getting rid of private driver ioctl implementation

There are certainly many more details once we start digging of course.

> 
> I am not keen on having to buy anything without mainline support - it is 
> an instant disqualification of a hardware vendor. It results in a 
> terrible user experience for experienced people (might not be able to 
> use latest kernel which is needed for supporting other things) and is 
> debilitating for people new to Linux who do not how to use the terminal, 
> possibly enough so that they will go back to Windows.

Seems like a reasonable position to me, the grey area is when there is a
Linux driver, but its quality is not making it upstream available, then
you find yourself emailing netdev about that very situation :)

> 
> Andy, what is your relationship to Tehuti Networks? Would you be happy 
> to maintain this if I mainlined it? It says you are maintainer of 
> drivers/net/ethernet/tehuti/ directory. I will not do this if I am 
> expected to maintain it - in no small part because I do not know a lot 
> about it. I will only be modifying what is currently available to make 
> it acceptable for mainline, if possible.

Given how the driver is broken up, you can do a couple of strategies:

- try to submit it all as-is (almost) under drivers/staging/ where it
may get contributions from people to clean it up to the kernel coding
style, using coccinelle semantic patch and pretty much anything that can
be done by inspecting code visually while not really testing it. This
might make the driver stay in staging for a long time, but if there are
in-kernel API changes, they will be done and so it will continue to
build and maybe even work, for any version of Linux in which it got
included and onward. The problem with that approach is that it will
likely stay in limbo unless a dedicated set of people start working
towards moving it out of staging.

- rewrite it in smaller parts and submit it in small chunks, with basic
functionality one step at a time, e.g.: driver skeleton/entry point as a
pci_device/driver, then net_device registration without anything, then
RX path, then TX path, then control path, then ethtool interface, etc.
etc. Given the shape of the driver, but not knowing how familiar you are
with the driver or the kernel, a 3 man/month work for someone motivated
is probably an optimistic estimate of the work you have ahead of you,
6m/m sounds more realistic. There is also an expectation that you will
be maintaining this driver for a few months (maybe years) to come, and
network drivers tend to always have something that needs to be fixed, so
it is a nice side gig, but it could be time consuming.

> 
> Also, license issues - does GPLv2 permit mainlining to happen? I believe 
> the Tehuti driver is available under GPLv2 (correct me if I am wrong).

The source code on the github tree suggests this is the case, therefore
it is entirely appropriate to seek upstream inclusion given the license
allows it.

What needs to be figured out is the PHY firmware situation which appears
to be completed punted onto the user to figure out which files (and
where to download), how to extract the relevant firmware blobs (there
are scripts, okay). If you have a contact with one of the vendors
supported by the driver, or better yet, with Tehuti, that may be
something they could help with. A mainline driver with proprietary
firmware blobs is not uncommon, but having to get the blobs outside of
linux-firmware is a real pain for distributions and some might even
refuse to build your driver because of that.

> 
> Would I need to send patches for this, or for something this size, is it 
> better to send a pull request? If I am going to do patches, I will need 
> to make a gmail account or something, as Outlook messes with the 
> encoding of the things which I send.

For sending patches, you would want to use git send-email to make sure
you avoid MUA issues.

> 
> Thanks for any comments on this.

Hope all of this helps. Cheers
-- 
Florian
