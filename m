Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621057118C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 08:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfGWGBD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 02:01:03 -0400
Received: from mx01.hilscher.com ([46.189.19.166]:38030 "EHLO
        mx01.hilscher.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfGWGBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 02:01:02 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 02:01:00 EDT
Received: from maiser03.hilscher.local (192.168.100.44) by
 maiser03.hilscher.local (192.168.100.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 23 Jul 2019 07:45:57 +0200
Received: from maiser03.hilscher.local ([::1]) by maiser03.hilscher.local
 ([::1]) with mapi id 15.01.1713.004; Tue, 23 Jul 2019 07:45:57 +0200
From:   Michael Trensch <MTrensch@hilscher.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH 3/3] uio: remove netx driver
Thread-Topic: [PATCH 3/3] uio: remove netx driver
Thread-Index: AQHVQMII3XQs32YH5Uu6SMzNN3HhjKbXsQJQ
Date:   Tue, 23 Jul 2019 05:45:57 +0000
Message-ID: <415f511480774ca58e068d6c005c917b@hilscher.com>
References: <20190722191552.252805-1-arnd@arndb.de>
 <20190722191552.252805-3-arnd@arndb.de>
In-Reply-To: <20190722191552.252805-3-arnd@arndb.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.5.83]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "uio_netx" driver is not used in conjunction with the removed netX SoC support.
It is used to handle netX-Based PCI(e) cards (https://www.hilscher.com/products/product-groups/pc-cards/) plugged into a PC or any kind of embedded hardware.

So a removal of this driver would render those extension cards unusable in future.

--
Michael Trensch | netX System
Phone: +49 (0) 6190 9907-0 | Fax: +49 (0) 6190 9907-50 | mtrensch@hilscher.com
> -----Ursprüngliche Nachricht-----
> Von: Arnd Bergmann <arnd@arndb.de>
> Gesendet: Montag, 22. Juli 2019 21:15
> An: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: netdev@vger.kernel.org; linux-serial@vger.kernel.org; tglx@linutronix.de;
> davem@davemloft.net; Sascha Hauer <s.hauer@pengutronix.de>; Michael
> Trensch <MTrensch@hilscher.com>; Linus Walleij <linus.walleij@linaro.org>;
> Robert Schwebel <r.schwebel@pengutronix.de>; Arnd Bergmann
> <arnd@arndb.de>; linux-kernel@vger.kernel.org
> Betreff: [PATCH 3/3] uio: remove netx driver
>
> The netx platform got removed, so this driver is now useless.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/uio/Kconfig    |  11 ---
>  drivers/uio/Makefile   |   1 -
>  drivers/uio/uio_netx.c | 178 -----------------------------------------
>  3 files changed, 190 deletions(-)
>  delete mode 100644 drivers/uio/uio_netx.c
>
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig index
> 202ee81cfc2b..abc8dd97b474 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -94,17 +94,6 @@ config UIO_PCI_GENERIC
>    primarily, for virtualization scenarios.
>    If you compile this as a module, it will be called uio_pci_generic.
>
> -config UIO_NETX
> -tristate "Hilscher NetX Card driver"
> -depends on PCI
> -help
> -  Driver for Hilscher NetX based fieldbus cards (cifX, comX).
> -  This driver requires a userspace component that comes with the card
> -  or is available from Hilscher (http://www.hilscher.com).
> -
> -  To compile this driver as a module, choose M here; the module
> -  will be called uio_netx.
> -
>  config UIO_FSL_ELBC_GPCM
>  tristate "eLBC/GPCM driver"
>  depends on FSL_LBC
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile index
> c285dd2a4539..d94012263a42 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -6,7 +6,6 @@ obj-$(CONFIG_UIO_DMEM_GENIRQ)+=
> uio_dmem_genirq.o
>  obj-$(CONFIG_UIO_AEC)+= uio_aec.o
>  obj-$(CONFIG_UIO_SERCOS3)+= uio_sercos3.o
>  obj-$(CONFIG_UIO_PCI_GENERIC)+= uio_pci_generic.o
> -obj-$(CONFIG_UIO_NETX)+= uio_netx.o
>  obj-$(CONFIG_UIO_PRUSS)         += uio_pruss.o
>  obj-$(CONFIG_UIO_MF624)         += uio_mf624.o
>  obj-$(CONFIG_UIO_FSL_ELBC_GPCM)+= uio_fsl_elbc_gpcm.o
> diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c deleted file mode
> 100644 index 9ae29ffde410..000000000000
> --- a/drivers/uio/uio_netx.c
> +++ /dev/null
> @@ -1,178 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * UIO driver for Hilscher NetX based fieldbus cards (cifX, comX).
> - * See http://www.hilscher.com for details.
> - *
> - * (C) 2007 Hans J. Koch <hjk@hansjkoch.de>
> - * (C) 2008 Manuel Traut <manut@linutronix.de>
> - *
> - */
> -
> -#include <linux/device.h>
> -#include <linux/io.h>
> -#include <linux/module.h>
> -#include <linux/pci.h>
> -#include <linux/slab.h>
> -#include <linux/uio_driver.h>
> -
> -#define PCI_VENDOR_ID_HILSCHER0x15CF
> -#define PCI_DEVICE_ID_HILSCHER_NETX0x0000
> -#define PCI_DEVICE_ID_HILSCHER_NETPLC0x0010
> -#define PCI_SUBDEVICE_ID_NETPLC_RAM0x0000
> -#define PCI_SUBDEVICE_ID_NETPLC_FLASH0x0001
> -#define PCI_SUBDEVICE_ID_NXSB_PCA0x3235
> -#define PCI_SUBDEVICE_ID_NXPCA0x3335
> -
> -#define DPM_HOST_INT_EN00xfff0
> -#define DPM_HOST_INT_STAT00xffe0
> -
> -#define DPM_HOST_INT_MASK0xe600ffff
> -#define DPM_HOST_INT_GLOBAL_EN0x80000000
> -
> -static irqreturn_t netx_handler(int irq, struct uio_info *dev_info) -{
> -void __iomem *int_enable_reg = dev_info->mem[0].internal_addr
> -+ DPM_HOST_INT_EN0;
> -void __iomem *int_status_reg = dev_info->mem[0].internal_addr
> -+ DPM_HOST_INT_STAT0;
> -
> -/* Is one of our interrupts enabled and active ? */
> -if (!(ioread32(int_enable_reg) & ioread32(int_status_reg)
> -& DPM_HOST_INT_MASK))
> -return IRQ_NONE;
> -
> -/* Disable interrupt */
> -iowrite32(ioread32(int_enable_reg) & ~DPM_HOST_INT_GLOBAL_EN,
> -int_enable_reg);
> -return IRQ_HANDLED;
> -}
> -
> -static int netx_pci_probe(struct pci_dev *dev,
> -const struct pci_device_id *id)
> -{
> -struct uio_info *info;
> -int bar;
> -
> -info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> -if (!info)
> -return -ENOMEM;
> -
> -if (pci_enable_device(dev))
> -goto out_free;
> -
> -if (pci_request_regions(dev, "netx"))
> -goto out_disable;
> -
> -switch (id->device) {
> -case PCI_DEVICE_ID_HILSCHER_NETX:
> -bar = 0;
> -info->name = "netx";
> -break;
> -case PCI_DEVICE_ID_HILSCHER_NETPLC:
> -bar = 0;
> -info->name = "netplc";
> -break;
> -default:
> -bar = 2;
> -info->name = "netx_plx";
> -}
> -
> -/* BAR0 or 2 points to the card's dual port memory */
> -info->mem[0].addr = pci_resource_start(dev, bar);
> -if (!info->mem[0].addr)
> -goto out_release;
> -info->mem[0].internal_addr = ioremap(pci_resource_start(dev, bar),
> -pci_resource_len(dev, bar));
> -
> -if (!info->mem[0].internal_addr)
> -goto out_release;
> -
> -info->mem[0].size = pci_resource_len(dev, bar);
> -info->mem[0].memtype = UIO_MEM_PHYS;
> -info->irq = dev->irq;
> -info->irq_flags = IRQF_SHARED;
> -info->handler = netx_handler;
> -info->version = "0.0.1";
> -
> -/* Make sure all interrupts are disabled */
> -iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
> -
> -if (uio_register_device(&dev->dev, info))
> -goto out_unmap;
> -
> -pci_set_drvdata(dev, info);
> -dev_info(&dev->dev, "Found %s card, registered UIO device.\n",
> -info->name);
> -
> -return 0;
> -
> -out_unmap:
> -iounmap(info->mem[0].internal_addr);
> -out_release:
> -pci_release_regions(dev);
> -out_disable:
> -pci_disable_device(dev);
> -out_free:
> -kfree(info);
> -return -ENODEV;
> -}
> -
> -static void netx_pci_remove(struct pci_dev *dev) -{
> -struct uio_info *info = pci_get_drvdata(dev);
> -
> -/* Disable all interrupts */
> -iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
> -uio_unregister_device(info);
> -pci_release_regions(dev);
> -pci_disable_device(dev);
> -iounmap(info->mem[0].internal_addr);
> -
> -kfree(info);
> -}
> -
> -static struct pci_device_id netx_pci_ids[] = {
> -{
> -.vendor =PCI_VENDOR_ID_HILSCHER,
> -.device =PCI_DEVICE_ID_HILSCHER_NETX,
> -.subvendor =0,
> -.subdevice =0,
> -},
> -{
> -.vendor =       PCI_VENDOR_ID_HILSCHER,
> -.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
> -.subvendor =    PCI_VENDOR_ID_HILSCHER,
> -.subdevice =    PCI_SUBDEVICE_ID_NETPLC_RAM,
> -},
> -{
> -.vendor =       PCI_VENDOR_ID_HILSCHER,
> -.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
> -.subvendor =    PCI_VENDOR_ID_HILSCHER,
> -.subdevice =    PCI_SUBDEVICE_ID_NETPLC_FLASH,
> -},
> -{
> -.vendor =PCI_VENDOR_ID_PLX,
> -.device =PCI_DEVICE_ID_PLX_9030,
> -.subvendor =PCI_VENDOR_ID_PLX,
> -.subdevice =PCI_SUBDEVICE_ID_NXSB_PCA,
> -},
> -{
> -.vendor =PCI_VENDOR_ID_PLX,
> -.device =PCI_DEVICE_ID_PLX_9030,
> -.subvendor =PCI_VENDOR_ID_PLX,
> -.subdevice =PCI_SUBDEVICE_ID_NXPCA,
> -},
> -{ 0, }
> -};
> -
> -static struct pci_driver netx_pci_driver = {
> -.name = "netx",
> -.id_table = netx_pci_ids,
> -.probe = netx_pci_probe,
> -.remove = netx_pci_remove,
> -};
> -
> -module_pci_driver(netx_pci_driver);
> -MODULE_DEVICE_TABLE(pci, netx_pci_ids); -MODULE_LICENSE("GPL v2"); -
> MODULE_AUTHOR("Hans J. Koch, Manuel Traut");
> --
> 2.20.0


Hilscher Gesellschaft für Systemautomation mbH   |  Rheinstrasse 15  |  65795 Hattersheim  |  Germany  |  www.hilscher.com<http://www.hilscher.com>
Sitz der Gesellschaft / place of business: Hattersheim  |  Geschäftsführer / managing director: Dipl.-Ing. Hans-Jürgen Hilscher
Handelsregister / commercial register: Frankfurt B 26873  |  Ust. Idnr. / VAT No.: DE113852715
Registergericht / register court: Amtsgericht Frankfurt/Main

Important Information:
This e-mail message including its attachments contains confidential and legally protected information solely intended for the addressee. If you are not the intended addressee of this message, please contact the addresser immediately and delete this message including its attachments. The unauthorized dissemination, copying and change of this e-mail are strictly forbidden. The addresser shall not be liable for the content of such changed e-mails.

Wichtiger Hinweis:
Diese E-Mail einschließlich ihrer Anhänge enthält vertrauliche und rechtlich geschützte Informationen, die nur für den Adressaten bestimmt sind. Sollten Sie nicht der bezeichnete Adressat sein, so teilen Sie dies bitte dem Absender umgehend mit und löschen Sie diese Nachricht und ihre Anhänge. Die unbefugte Weitergabe, das Anfertigen von Kopien und jede Veränderung der E-Mail ist untersagt. Der Absender haftet nicht für Inhalte von veränderten E-Mails.
