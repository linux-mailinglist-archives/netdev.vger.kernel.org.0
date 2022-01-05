Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E575485783
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242459AbiAERmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:42:43 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4352 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242412AbiAERmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:42:38 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JTcDP1FRwz67w73;
        Thu,  6 Jan 2022 01:39:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 18:42:31 +0100
Received: from [10.47.27.56] (10.47.27.56) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 5 Jan
 2022 17:42:28 +0000
From:   John Garry <john.garry@huawei.com>
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
CC:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Karsten Keil" <isdn@linux-pingi.de>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
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
References: <20211229160317.GA1681139@bhelgaas>
 <e0877e91d7d50299ea5a3ffcee2cf1016458ce10.camel@linux.ibm.com>
Message-ID: <3f39d8a2-2e57-a671-2926-eb4f2bf20c76@huawei.com>
Date:   Wed, 5 Jan 2022 17:42:16 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e0877e91d7d50299ea5a3ffcee2cf1016458ce10.camel@linux.ibm.com>
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

On 29/12/2021 16:55, Niklas Schnelle wrote:
> On Wed, 2021-12-29 at 10:03 -0600, Bjorn Helgaas wrote:
>> On Wed, Dec 29, 2021 at 01:12:07PM +0100, Mauro Carvalho Chehab wrote:
>>> Em Wed, 29 Dec 2021 12:45:38 +0100
>>> Niklas Schnelle<schnelle@linux.ibm.com>  escreveu:
>>>> ...
>>>> I do think we agree that once done correctly there is value in
>>>> such an option independent of HAS_IOPORT only gating inb() etc uses.
>> I'm not sure I'm convinced about this.  For s390, you could do this
>> patch series, where you don't define inb() at all, and you add new
>> dependencies to prevent compile errors.  Or you could define inb() to
>> return ~0, which is what happens on other platforms when the device is
>> not present.
>>
>>> Personally, I don't see much value on a Kconfig var for legacy PCI I/O
>>> space. From maintenance PoV, bots won't be triggered if someone use
>>> HAS_IOPORT instead of the PCI specific one - or vice-versa. So, we
>>> could end having a mix of both at the wrong places, in long term.
>>>
>>> Also, assuming that PCIe hardware will some day abandon support for
>>> "legacy" PCI I/O space, I guess some runtime logic would be needed,
>>> in order to work with both kinds of PCIe controllers. So, having a
>>> Kconfig option won't help much, IMO.
>>>
>>> So, my personal preference would be to have just one Kconfig var, but
>>> I'm ok if the PCI maintainers decide otherwise.
>> I don't really like the "LEGACY_PCI" Kconfig option.  "Legacy" just
>> means something old and out of favor; it doesn't say*what*  that
>> something is.
>>
>> I think you're specifically interested in I/O port space usage, and it
>> seems that you want all PCI drivers that*only*  use I/O port space to
>> depend on LEGACY_PCI?  Drivers that can use either I/O or memory
>> space or both would not depend on LEGACY_PCI?  This seems a little
>> murky and error-prone.
> I'd like to hear Arnd's opinion on this but you're the PCI maintainer
> so of course your buy-in would be quite important for such an option.
> 

Hi Niklas,

I can't see the value in the LEGACY_PCI config - however I don't really 
understand Arnd's original intention.

It was written that it would allow us to control "whether we have any 
pre-PCIe devices or those PCIe drivers that need PIO accessors other 
than ioport_map()/pci_iomap()".

However I just don't see why CONFIG_PCI=y and CONFIG_HAS_IOPORT=y aren't 
always the gating factor here. Arnd?

Thanks,
John
