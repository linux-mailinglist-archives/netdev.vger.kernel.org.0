Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF1484226
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiADNMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:12:14 -0500
Received: from mail.loongson.cn ([114.242.206.163]:41932 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229568AbiADNMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 08:12:13 -0500
Received: from [10.180.13.117] (unknown [10.180.13.117])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9CxydGcR9Rhe7sAAA--.1828S2;
        Tue, 04 Jan 2022 21:11:57 +0800 (CST)
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        zhuyinbo@loongson.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk> <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
Date:   Tue, 4 Jan 2022 21:11:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9CxydGcR9Rhe7sAAA--.1828S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKFWxJFyUAry3tFyUCF1kGrg_yoWfCryxpF
        W8KFWYkrZ5AF1rA3W8tr1UZFyUC3yIqw43WF1rGayfuryDZr9Fvr42gr4a9ry7Xr48C3W0
        ga1qqFykur9rZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/12/7 下午5:41, zhuyinbo 写道:
> 
> 
> 在 2021/12/1 上午8:38, Andrew Lunn 写道:
>>> However, this won't work for PHY devices created _before_ the kernel
>>> has mounted the rootfs, whether or not they end up being used. So,
>>> every PHY mentioned in DT will be created before the rootfs is mounted,
>>> and none of these PHYs will have their modules loaded.
>>
>> Hi Russell
>>
>> I think what you are saying here is, if the MAC or MDIO bus driver is
>> built in, the PHY driver also needs to be built in?
>>
>> If the MAC or MDIO bus driver is a module, it means the rootfs has
>> already been mounted in order to get these modules. And so the PHY
>> driver as a module will also work.
>>
>>> I believe this is the root cause of Yinbo Zhu's issue.
> 
> I think you should be right and I had did lots of test but use 
> rquest_module it doesn't load marvell module, and dts does't include any 
> phy node. even though I was use "marvell" as input's args of 
> request_module.
>>
>> You are speculating that in Yinbo Zhu case, the MAC driver is built
>> in, the PHY is a module. The initial request for the firmware fails.
>> Yinbo Zhu would like udev to try again later when the modules are
>> available.
>>
>>> What we _could_ do is review all device trees and PHY drivers to see
>>> whether DT modaliases are ever used for module loading. If they aren't,
>>> then we _could_ make the modalias published by the kernel conditional
>>> on the type of mdio device - continue with the DT approach for non-PHY
>>> devices, and switch to the mdio: scheme for PHY devices. I repeat, this
>>> can only happen if no PHY drivers match using the DT scheme, otherwise
>>> making this change _will_ cause a regression.
>>
> 
>> Take a look at
>> drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
>>
>> So there are some DT blobs out there with compatible strings for
>> PHYs. I've no idea if they actually load that way, or the standard PHY
>> mechanism is used.
>>
>>     Andrew
>>
> 
> 
>  > That is not true universally for all MDIO though - as
>  > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which uses DT
>  > the compatible string to do the module load. So, we have proof there
>  > that Yinbo Zhu's change will definitely cause a regression which we
>  > can not allow.
> 
> I don't understand that what you said about regression.  My patch 
> doesn't cause  xilinx_gmii2rgmii.c driver load fail, in this time that 
> do_of_table and platform_uevent will be responsible "of" type driver 
> auto load and my patch was responsible for "mdio" type driver auto load,
> In default code. There are request_module to load phy driver, but as 
> Russell King said that request_module doesn't garantee auto load will 
> always work well, but udev mechanism can garantee it. and udev mechaism 
> is more mainstream, otherwise mdio_uevent is useless. if use udev 
> mechanism that my patch was needed. and if apply my patch it doesn't 
> cause request_module mechaism work bad because I will add following change:
> 
> 
> 
> -       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT,
> -                            MDIO_ID_ARGS(phy_id));
> +       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT, phy_id);
>          /* We only check for failures in executing the usermode binary,
>           * not whether a PHY driver module exists for the PHY ID.
>           * Accept -ENOENT because this may occur in case no initramfs 
> exists,
> diff --git a/include/linux/mod_devicetable.h 
> b/include/linux/mod_devicetable.h
> index 7bd23bf..bc6ea0d 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -600,16 +600,7 @@ struct platform_device_id {
>   #define MDIO_NAME_SIZE         32
>   #define MDIO_MODULE_PREFIX     "mdio:"
> 
> -#define MDIO_ID_FMT 
> "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
> -#define MDIO_ID_ARGS(_id) \
> -       ((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 
> 1, \
> -       ((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 
> 1, \
> -       ((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 
> 1, \
> -       ((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 
> 1, \
> -       ((_id)>>15) & 1, ((_id)>>14) & 1, ((_id)>>13) & 1, ((_id)>>12) & 
> 1, \
> -       ((_id)>>11) & 1, ((_id)>>10) & 1, ((_id)>>9) & 1, ((_id)>>8) & 1, \
> -       ((_id)>>7) & 1, ((_id)>>6) & 1, ((_id)>>5) & 1, ((_id)>>4) & 1, \
> -       ((_id)>>3) & 1, ((_id)>>2) & 1, ((_id)>>1) & 1, (_id) & 1
> +#define MDIO_ID_FMT "p%08x"
> 
> 
> 

 > > > > However, this won't work for PHY devices created _before_ the 
kernel
 > > > > has mounted the rootfs, whether or not they end up being used. So,
 > > > > every PHY mentioned in DT will be created before the rootfs is 
mounted,
 > > > > and none of these PHYs will have their modules loaded.
 > > >
 > > > Hi Russell
 > > >
 > > > I think what you are saying here is, if the MAC or MDIO bus driver is
 > > > built in, the PHY driver also needs to be built in?
 > > >
 > > > If the MAC or MDIO bus driver is a module, it means the rootfs has
 > > > already been mounted in order to get these modules. And so the PHY
 > > > driver as a module will also work.
 > > >
 > > > > I believe this is the root cause of Yinbo Zhu's issue.
 > >
 > > I think you should be right and I had did lots of test but use 
rquest_module
 > > it doesn't load marvell module, and dts does't include any phy 
node. even
 > > though I was use "marvell" as input's args of request_module.

 > Please can you report the contents of /proc/sys/kernel/modprobe, and
 > the kernel configuration of CONFIG_MODPROBE_PATH. I wonder if your
 > userspace has that module loading mechanism disabled, or your kernel
 > has CONFIG_MODPROBE_PATH as an empty string.

 > If the module is not present by the time this call is made, then
 > even if you load the appropriate driver module later, that module
 > will not be used - the PHY will end up being driven by the generic
 > clause 22 driver.

 > > > That is not true universally for all MDIO though - as
 > > > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which 
uses DT
 > > > the compatible string to do the module load. So, we have proof there
 > > > that Yinbo Zhu's change will definitely cause a regression which we
 > > > can not allow.
 > >
 > > I don't understand that what you said about regression.  My patch 
doesn't
 > > cause  xilinx_gmii2rgmii.c driver load fail, in this time that 
do_of_table
 > >and platform_uevent will be responsible "of" type driver auto load 
and my
 > > patch was responsible for "mdio" type driver auto load,

 > xilinx_gmii2rgmii is not a platform driver. It is a mdio driver:

 > static struct mdio_driver xgmiitorgmii_driver = {
               ^^^^^^^^^^^

 > Therefore, platform_uevent() is irrelevant since this will never match
 > a platform device. It will only match mdio devices, and the uevent
 > generation for that is via mdio_uevent() which is the function you
 > are changing.


static const struct of_device_id xgmiitorgmii_of_match[] = {
         { .compatible = "xlnx,gmii-to-rgmii-1.0" },
         {},
};
MODULE_DEVICE_TABLE(of, xgmiitorgmii_of_match);

static struct mdio_driver xgmiitorgmii_driver = {
         .probe  = xgmiitorgmii_probe,
         .mdiodrv.driver = {
                 .name = "xgmiitorgmii",
                 .of_match_table = xgmiitorgmii_of_match,
         },
};
 From the present point of view, no matter what the situation, my 
supplement can cover udev or request_module for auto load module.

if that phy driver isn't platform driver my patch cover it I think there 
is no doubt, if phy driver is platform driver and platform driver udev 
will cover it. My only requestion is the request_module not work well.

about xgmiitorgmii_of_match that it belongs to platform driver load, 
please you note. and about your doubt usepace whether disable module 
load that module load function is okay becuase other device driver auto 
load is okay.

 > > In default code. There are request_module to load phy driver, but 
as > Russell
 > > King said that request_module doesn't garantee auto load will 
always work
 > > well, but udev mechanism can garantee it. and udev mechaism is more
 > > mainstream, otherwise mdio_uevent is useless. if use udev mechanism 
that my
 > > patch was needed. and if apply my patch it doesn't cause request_module
 > > mechaism work bad because I will add following change:

 > Please report back what the following command produces on your
 > problem system:

 > /sbin/modprobe -vn mdio:00000001010000010000110111010001

 > Thanks.

[root@localhost ~]# lsmod | grep marvell
[root@localhost ~]# ls 
/lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
/lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
[root@localhost ~]# /sbin/modprobe -vn mdio:00000001010000010000110111010001
insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
[root@localhost ~]#
[root@localhost ~]# cat /proc/sys/kernel/modprobe
/sbin/modprobe

BRs,
Yinbo

