Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E97340D0F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhCRSde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhCRSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:33:00 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54183C06174A;
        Thu, 18 Mar 2021 11:33:00 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id o19-20020a9d22130000b02901bfa5b79e18so6131327ota.0;
        Thu, 18 Mar 2021 11:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=68KRrEwMq9PQq849OciQP0m36IL1xJQ4EuOwvDR9Rgc=;
        b=WYVu9x/OkotfVM0WKRdcSlyCdBUnWKppvuOOERQhOGEW92033xbkw2ptj2vbhpgNj1
         nupX2UzgqldyUyMavtqzkBqWChGFP/L9O4sCUmuTOCNajHq2eMly2c10We+XuOGX0wOh
         qUUcdD+0YVX3TzKqfmzbzqrlOQ6coQDmGTmnH4sH/7IXo3DVRlsyi6xdh50UPDOfIa6R
         oqrAMPZgNcuCCVV948YNgg7/+bUUSLggRKGzk9ntOrcWRuWtzl+2BOI585vf18iKLla0
         0I6k95Dgt8+og7Sn8LoHYua5pLY0IZgPBFaVdKSaj3yojRU+VHxR7XE+0ifeyfmd4gw1
         kUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=68KRrEwMq9PQq849OciQP0m36IL1xJQ4EuOwvDR9Rgc=;
        b=aC75qnee4QLt8YAJud9W24dxyXrbE/mgIzYbhmIoG7DAw5X/X5zB0NtMxQTHq4NZjj
         GLJKB1RE4TVMnFcfmq9Xf5/CY5pMZQh5mXg+T6b3MnV074n3aDteaYEwghRbGPvRxfIw
         hp0dDzEyGf8Nip1/D1eHD4iW3GMRb7xAeXP/QLt6ltG+hguy/PKYhDBiqA8yXIsHh4YX
         q95/ylglsKGGQAS9TfLs8yfWwWlF5XKwRx3BFSSYLQMKaOpfa6sSmN3X28DBW4RSnsTz
         wTMA8uoTP19H68gIDSgRFe0IiZSHtf3TnYWBqyrqK67zsFKeLRJoOhVVm9IpqTahnHrS
         P52A==
X-Gm-Message-State: AOAM530uypr0Lur7wFLyj+VAxJ7c+tAqerEubpeTW80Im60gMJpcTS3D
        cOqP0FQvcSSRYVsa7r1O661Cqhv8Yu0=
X-Google-Smtp-Source: ABdhPJzJfqul9wonICMp/F/+b4/rfQsekD6SPyfti6z8pzkRkY+bfQfsEop/em5uGKeUPB/Nd9E5aQ==
X-Received: by 2002:a9d:bd6:: with SMTP id 80mr8886488oth.98.1616092379391;
        Thu, 18 Mar 2021 11:32:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h18sm704565oov.43.2021.03.18.11.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:32:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
Date:   Thu, 18 Mar 2021 11:32:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 10:25 AM, Christophe Leroy wrote:
> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
> removed the last selector of CONFIG_MV64X60.
> 
> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
> can be removed.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/Kconfig       |   4 -
>  drivers/watchdog/Makefile      |   1 -
>  drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
>  include/linux/mv643xx.h        |   8 -
>  4 files changed, 337 deletions(-)
>  delete mode 100644 drivers/watchdog/mv64x60_wdt.c
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 1fe0042a48d2..178296bda151 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1831,10 +1831,6 @@ config 8xxx_WDT
>  
>  	  For BookE processors (MPC85xx) use the BOOKE_WDT driver instead.
>  
> -config MV64X60_WDT
> -	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
> -	depends on MV64X60 || COMPILE_TEST
> -
>  config PIKA_WDT
>  	tristate "PIKA FPGA Watchdog"
>  	depends on WARP || (PPC64 && COMPILE_TEST)
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index f3a6540e725e..752c6513f731 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -175,7 +175,6 @@ obj-$(CONFIG_PIC32_DMT) += pic32-dmt.o
>  # POWERPC Architecture
>  obj-$(CONFIG_GEF_WDT) += gef_wdt.o
>  obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
> -obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
>  obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
>  obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
>  obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
> diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
> deleted file mode 100644
> index 894aa63488d3..000000000000
> --- a/drivers/watchdog/mv64x60_wdt.c
> +++ /dev/null
> @@ -1,324 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * mv64x60_wdt.c - MV64X60 (Marvell Discovery) watchdog userspace interface
> - *
> - * Author: James Chapman <jchapman@katalix.com>
> - *
> - * Platform-specific setup code should configure the dog to generate
> - * interrupt or reset as required.  This code only enables/disables
> - * and services the watchdog.
> - *
> - * Derived from mpc8xx_wdt.c, with the following copyright.
> - *
> - * 2002 (c) Florian Schirmer <jolt@tuxbox.org>
> - */
> -
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
> -#include <linux/fs.h>
> -#include <linux/init.h>
> -#include <linux/kernel.h>
> -#include <linux/miscdevice.h>
> -#include <linux/module.h>
> -#include <linux/watchdog.h>
> -#include <linux/platform_device.h>
> -#include <linux/mv643xx.h>
> -#include <linux/uaccess.h>
> -#include <linux/io.h>
> -
> -#define MV64x60_WDT_WDC_OFFSET	0
> -
> -/*
> - * The watchdog configuration register contains a pair of 2-bit fields,
> - *   1.  a reload field, bits 27-26, which triggers a reload of
> - *       the countdown register, and
> - *   2.  an enable field, bits 25-24, which toggles between
> - *       enabling and disabling the watchdog timer.
> - * Bit 31 is a read-only field which indicates whether the
> - * watchdog timer is currently enabled.
> - *
> - * The low 24 bits contain the timer reload value.
> - */
> -#define MV64x60_WDC_ENABLE_SHIFT	24
> -#define MV64x60_WDC_SERVICE_SHIFT	26
> -#define MV64x60_WDC_ENABLED_SHIFT	31
> -
> -#define MV64x60_WDC_ENABLED_TRUE	1
> -#define MV64x60_WDC_ENABLED_FALSE	0
> -
> -/* Flags bits */
> -#define MV64x60_WDOG_FLAG_OPENED	0
> -
> -static unsigned long wdt_flags;
> -static int wdt_status;
> -static void __iomem *mv64x60_wdt_regs;
> -static int mv64x60_wdt_timeout;
> -static int mv64x60_wdt_count;
> -static unsigned int bus_clk;
> -static char expect_close;
> -static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
> -
> -static bool nowayout = WATCHDOG_NOWAYOUT;
> -module_param(nowayout, bool, 0);
> -MODULE_PARM_DESC(nowayout,
> -		"Watchdog cannot be stopped once started (default="
> -				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> -
> -static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
> -{
> -	u32 data;
> -	u32 enabled;
> -	int ret = 0;
> -
> -	spin_lock(&mv64x60_wdt_spinlock);
> -	data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
> -	enabled = (data >> MV64x60_WDC_ENABLED_SHIFT) & 1;
> -
> -	/* only toggle the requested field if enabled state matches predicate */
> -	if ((enabled ^ enabled_predicate) == 0) {
> -		/* We write a 1, then a 2 -- to the appropriate field */
> -		data = (1 << field_shift) | mv64x60_wdt_count;
> -		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
> -
> -		data = (2 << field_shift) | mv64x60_wdt_count;
> -		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
> -		ret = 1;
> -	}
> -	spin_unlock(&mv64x60_wdt_spinlock);
> -
> -	return ret;
> -}
> -
> -static void mv64x60_wdt_service(void)
> -{
> -	mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
> -			       MV64x60_WDC_SERVICE_SHIFT);
> -}
> -
> -static void mv64x60_wdt_handler_enable(void)
> -{
> -	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
> -				   MV64x60_WDC_ENABLE_SHIFT)) {
> -		mv64x60_wdt_service();
> -		pr_notice("watchdog activated\n");
> -	}
> -}
> -
> -static void mv64x60_wdt_handler_disable(void)
> -{
> -	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
> -				   MV64x60_WDC_ENABLE_SHIFT))
> -		pr_notice("watchdog deactivated\n");
> -}
> -
> -static void mv64x60_wdt_set_timeout(unsigned int timeout)
> -{
> -	/* maximum bus cycle count is 0xFFFFFFFF */
> -	if (timeout > 0xFFFFFFFF / bus_clk)
> -		timeout = 0xFFFFFFFF / bus_clk;
> -
> -	mv64x60_wdt_count = timeout * bus_clk >> 8;
> -	mv64x60_wdt_timeout = timeout;
> -}
> -
> -static int mv64x60_wdt_open(struct inode *inode, struct file *file)
> -{
> -	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
> -		return -EBUSY;
> -
> -	if (nowayout)
> -		__module_get(THIS_MODULE);
> -
> -	mv64x60_wdt_handler_enable();
> -
> -	return stream_open(inode, file);
> -}
> -
> -static int mv64x60_wdt_release(struct inode *inode, struct file *file)
> -{
> -	if (expect_close == 42)
> -		mv64x60_wdt_handler_disable();
> -	else {
> -		pr_crit("unexpected close, not stopping timer!\n");
> -		mv64x60_wdt_service();
> -	}
> -	expect_close = 0;
> -
> -	clear_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags);
> -
> -	return 0;
> -}
> -
> -static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
> -				 size_t len, loff_t *ppos)
> -{
> -	if (len) {
> -		if (!nowayout) {
> -			size_t i;
> -
> -			expect_close = 0;
> -
> -			for (i = 0; i != len; i++) {
> -				char c;
> -				if (get_user(c, data + i))
> -					return -EFAULT;
> -				if (c == 'V')
> -					expect_close = 42;
> -			}
> -		}
> -		mv64x60_wdt_service();
> -	}
> -
> -	return len;
> -}
> -
> -static long mv64x60_wdt_ioctl(struct file *file,
> -					unsigned int cmd, unsigned long arg)
> -{
> -	int timeout;
> -	int options;
> -	void __user *argp = (void __user *)arg;
> -	static const struct watchdog_info info = {
> -		.options =	WDIOF_SETTIMEOUT	|
> -				WDIOF_MAGICCLOSE	|
> -				WDIOF_KEEPALIVEPING,
> -		.firmware_version = 0,
> -		.identity = "MV64x60 watchdog",
> -	};
> -
> -	switch (cmd) {
> -	case WDIOC_GETSUPPORT:
> -		if (copy_to_user(argp, &info, sizeof(info)))
> -			return -EFAULT;
> -		break;
> -
> -	case WDIOC_GETSTATUS:
> -	case WDIOC_GETBOOTSTATUS:
> -		if (put_user(wdt_status, (int __user *)argp))
> -			return -EFAULT;
> -		wdt_status &= ~WDIOF_KEEPALIVEPING;
> -		break;
> -
> -	case WDIOC_GETTEMP:
> -		return -EOPNOTSUPP;
> -
> -	case WDIOC_SETOPTIONS:
> -		if (get_user(options, (int __user *)argp))
> -			return -EFAULT;
> -
> -		if (options & WDIOS_DISABLECARD)
> -			mv64x60_wdt_handler_disable();
> -
> -		if (options & WDIOS_ENABLECARD)
> -			mv64x60_wdt_handler_enable();
> -		break;
> -
> -	case WDIOC_KEEPALIVE:
> -		mv64x60_wdt_service();
> -		wdt_status |= WDIOF_KEEPALIVEPING;
> -		break;
> -
> -	case WDIOC_SETTIMEOUT:
> -		if (get_user(timeout, (int __user *)argp))
> -			return -EFAULT;
> -		mv64x60_wdt_set_timeout(timeout);
> -		fallthrough;
> -
> -	case WDIOC_GETTIMEOUT:
> -		if (put_user(mv64x60_wdt_timeout, (int __user *)argp))
> -			return -EFAULT;
> -		break;
> -
> -	default:
> -		return -ENOTTY;
> -	}
> -
> -	return 0;
> -}
> -
> -static const struct file_operations mv64x60_wdt_fops = {
> -	.owner = THIS_MODULE,
> -	.llseek = no_llseek,
> -	.write = mv64x60_wdt_write,
> -	.unlocked_ioctl = mv64x60_wdt_ioctl,
> -	.compat_ioctl = compat_ptr_ioctl,
> -	.open = mv64x60_wdt_open,
> -	.release = mv64x60_wdt_release,
> -};
> -
> -static struct miscdevice mv64x60_wdt_miscdev = {
> -	.minor = WATCHDOG_MINOR,
> -	.name = "watchdog",
> -	.fops = &mv64x60_wdt_fops,
> -};
> -
> -static int mv64x60_wdt_probe(struct platform_device *dev)
> -{
> -	struct mv64x60_wdt_pdata *pdata = dev_get_platdata(&dev->dev);
> -	struct resource *r;
> -	int timeout = 10;
> -
> -	bus_clk = 133;			/* in MHz */
> -	if (pdata) {
> -		timeout = pdata->timeout;
> -		bus_clk = pdata->bus_clk;
> -	}
> -
> -	/* Since bus_clk is truncated MHz, actual frequency could be
> -	 * up to 1MHz higher.  Round up, since it's better to time out
> -	 * too late than too soon.
> -	 */
> -	bus_clk++;
> -	bus_clk *= 1000000;		/* convert to Hz */
> -
> -	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
> -	if (!r)
> -		return -ENODEV;
> -
> -	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
> -	if (mv64x60_wdt_regs == NULL)
> -		return -ENOMEM;
> -
> -	mv64x60_wdt_set_timeout(timeout);
> -
> -	mv64x60_wdt_handler_disable();	/* in case timer was already running */
> -
> -	return misc_register(&mv64x60_wdt_miscdev);
> -}
> -
> -static int mv64x60_wdt_remove(struct platform_device *dev)
> -{
> -	misc_deregister(&mv64x60_wdt_miscdev);
> -
> -	mv64x60_wdt_handler_disable();
> -
> -	return 0;
> -}
> -
> -static struct platform_driver mv64x60_wdt_driver = {
> -	.probe = mv64x60_wdt_probe,
> -	.remove = mv64x60_wdt_remove,
> -	.driver = {
> -		.name = MV64x60_WDT_NAME,
> -	},
> -};
> -
> -static int __init mv64x60_wdt_init(void)
> -{
> -	pr_info("MV64x60 watchdog driver\n");
> -
> -	return platform_driver_register(&mv64x60_wdt_driver);
> -}
> -
> -static void __exit mv64x60_wdt_exit(void)
> -{
> -	platform_driver_unregister(&mv64x60_wdt_driver);
> -}
> -
> -module_init(mv64x60_wdt_init);
> -module_exit(mv64x60_wdt_exit);
> -
> -MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
> -MODULE_DESCRIPTION("MV64x60 watchdog driver");
> -MODULE_LICENSE("GPL");
> -MODULE_ALIAS("platform:" MV64x60_WDT_NAME);
> diff --git a/include/linux/mv643xx.h b/include/linux/mv643xx.h
> index 47e5679b48e1..000b126acfb6 100644
> --- a/include/linux/mv643xx.h
> +++ b/include/linux/mv643xx.h
> @@ -918,12 +918,4 @@
>  
>  extern void mv64340_irq_init(unsigned int base);
>  
> -/* Watchdog Platform Device, Driver Data */
> -#define	MV64x60_WDT_NAME			"mv64x60_wdt"
> -
> -struct mv64x60_wdt_pdata {
> -	int	timeout;	/* watchdog expiry in seconds, default 10 */
> -	int	bus_clk;	/* bus clock in MHz, default 133 */
> -};
> -
>  #endif /* __ASM_MV643XX_H */
> 

