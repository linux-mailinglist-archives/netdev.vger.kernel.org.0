Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569224868DA
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbiAFRl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:41:28 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4360 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241966AbiAFRlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:41:24 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JVD6c3dG6z67wb3;
        Fri,  7 Jan 2022 01:36:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 18:41:19 +0100
Received: from [10.47.27.56] (10.47.27.56) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 6 Jan
 2022 17:41:15 +0000
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        "Damien Le Moal" <damien.lemoal@opensource.wdc.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        "H Hartley Sweeten" <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Sathya Prakash" <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Jouni Malinen <j@w1.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Teddy Wang" <teddy.wang@siliconmotion.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Wim Van Sebroeck" <wim@linux-watchdog.org>,
        Jaroslav Kysela <perex@perex.cz>,
        "Takashi Iwai" <tiwai@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-csky@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-hwmon@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <MPT-FusionLinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-wireless@vger.kernel.org>, <megaraidlinux.pdl@broadcom.com>,
        <linux-spi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-watchdog@vger.kernel.org>
References: <20220105194748.GA215560@bhelgaas>
From:   John Garry <john.garry@huawei.com>
Message-ID: <74bf4fde-3972-1c36-ca04-58089da0d82b@huawei.com>
Date:   Thu, 6 Jan 2022 17:41:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220105194748.GA215560@bhelgaas>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.27.56]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 19:47, Bjorn Helgaas wrote:
>>>>>   ok if the PCI maintainers decide otherwise.
>>>> I don't really like the "LEGACY_PCI" Kconfig option.  "Legacy" just
>>>> means something old and out of favor; it doesn't say*what*  that
>>>> something is.
>>>>
>>>> I think you're specifically interested in I/O port space usage, and it
>>>> seems that you want all PCI drivers that*only*  use I/O port space to
>>>> depend on LEGACY_PCI?  Drivers that can use either I/O or memory
>>>> space or both would not depend on LEGACY_PCI?  This seems a little
>>>> murky and error-prone.
>>> I'd like to hear Arnd's opinion on this but you're the PCI maintainer
>>> so of course your buy-in would be quite important for such an option.
> I'd like to hear Arnd's opinion, too.  If we do add LEGACY_PCI, I
> think we need a clear guide for when to use it, e.g., "a PCI driver
> that uses inb() must depend on LEGACY_PCI" or whatever it is.
> 
> I must be missing something because I don't see what we gain from
> this.  We have PCI drivers, e.g., megaraid [1], for devices that have
> either MEM or I/O BARs.  I think we want to build drivers like that on
> any arch that supports PCI.
> 
> If the arch doesn't support I/O port space, devices that only have I/O
> BARs won't work, of course, and hopefully the PCI core and driver can
> figure that out and gracefully fail the probe.
> 
> But that same driver should still work with devices that have MEM
> BARs.  If inb() isn't always present, I guess we could litter these
> drivers with #ifdefs, but that would be pretty ugly. 

There were some ifdefs added to the 8250 drivers in Arnd's original 
patch [0], but it does not seem included here.

Niklas, what happened to the 8250 and the other driver changes?

[0] 
https://lore.kernel.org/lkml/CAK8P3a0MNbx-iuzW_-=0ab6-TTZzwV-PT_6gAC1Gp5PgYyHcrA@mail.gmail.com/

> IMO inb() should
> be present but do something innocuous like return ~0, as it would if
> I/O port space is supported but there's no device at that address.
> 
> [1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/megaraid.c?id=v5.15#n4210
> 

That driver would prob not be used on systems which does not support 
PIO, and so could have a HAS_IOPORT dependency. But it is not strictly 
necessary.

Anyway, it would be good to have an idea of how much ifdeffery is 
required in drivers.

Thanks,
John
