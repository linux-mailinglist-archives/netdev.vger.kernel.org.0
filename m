Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87F0485F6D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiAFD5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:57:12 -0500
Received: from mail.loongson.cn ([114.242.206.163]:35206 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbiAFD5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 22:57:12 -0500
Received: from [10.180.13.117] (unknown [10.180.13.117])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Cx6dGIaNZhEkoBAA--.2948S2;
        Thu, 06 Jan 2022 11:56:58 +0800 (CST)
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, zhuyinbo@loongson.cn,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk> <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
 <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
 <ba055ee6-9d81-3088-f395-8e4e1d9ba136@loongson.cn>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <5838a64c-5d0a-60a1-c699-727bff1cc715@loongson.cn>
Date:   Thu, 6 Jan 2022 11:56:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ba055ee6-9d81-3088-f395-8e4e1d9ba136@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Cx6dGIaNZhEkoBAA--.2948S2
X-Coremail-Antispam: 1UD129KBjvAXoW3uFW8KFyUKF47JF4xWw1UAwb_yoW8Cw45Go
        WxKw1fXa1Fgr4jgr1DGw1UJFW3Ja1rCryDXrWUWrn3WayUt3WYya48J348XayUJry8GFsr
        A34UJr1YkFW2yrn5n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYL7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxV
        W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/1/5 上午11:33, zhuyinbo 写道:
> 
> 
> 在 2022/1/4 下午9:11, zhuyinbo 写道:
>>
>>
>> 在 2021/12/7 下午5:41, zhuyinbo 写道:
>>>
>>>
>>> 在 2021/12/1 上午8:38, Andrew Lunn 写道:
>>>>> However, this won't work for PHY devices created _before_ the kernel
>>>>> has mounted the rootfs, whether or not they end up being used. So,
>>>>> every PHY mentioned in DT will be created before the rootfs is 
>>>>> mounted,
>>>>> and none of these PHYs will have their modules loaded.
>>>>
>>>> Hi Russell
>>>>
>>>> I think what you are saying here is, if the MAC or MDIO bus driver is
>>>> built in, the PHY driver also needs to be built in?
>>>>
>>>> If the MAC or MDIO bus driver is a module, it means the rootfs has
>>>> already been mounted in order to get these modules. And so the PHY
>>>> driver as a module will also work.
>>>>
>>>>> I believe this is the root cause of Yinbo Zhu's issue.
>>>
>>> I think you should be right and I had did lots of test but use 
>>> rquest_module it doesn't load marvell module, and dts does't include 
>>> any phy node. even though I was use "marvell" as input's args of 
>>> request_module.
>>>>
>>>> You are speculating that in Yinbo Zhu case, the MAC driver is built
>>>> in, the PHY is a module. The initial request for the firmware fails.
>>>> Yinbo Zhu would like udev to try again later when the modules are
>>>> available.
>>>>
>>>>> What we _could_ do is review all device trees and PHY drivers to see
>>>>> whether DT modaliases are ever used for module loading. If they 
>>>>> aren't,
>>>>> then we _could_ make the modalias published by the kernel conditional
>>>>> on the type of mdio device - continue with the DT approach for non-PHY
>>>>> devices, and switch to the mdio: scheme for PHY devices. I repeat, 
>>>>> this
>>>>> can only happen if no PHY drivers match using the DT scheme, otherwise
>>>>> making this change _will_ cause a regression.
>>>>
>>>
>>>> Take a look at
>>>> drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
>>>>
>>>> So there are some DT blobs out there with compatible strings for
>>>> PHYs. I've no idea if they actually load that way, or the standard PHY
>>>> mechanism is used.
>>>>
>>>>     Andrew
>>>>
>>>
>>>
>>>  > That is not true universally for all MDIO though - as
>>>  > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which 
>>> uses DT
>>>  > the compatible string to do the module load. So, we have proof there
>>>  > that Yinbo Zhu's change will definitely cause a regression which we
>>>  > can not allow.
>>>
>>> I don't understand that what you said about regression.  My patch 
>>> doesn't cause  xilinx_gmii2rgmii.c driver load fail, in this time 
>>> that do_of_table and platform_uevent will be responsible "of" type 
>>> driver auto load and my patch was responsible for "mdio" type driver 
>>> auto load,
>>> In default code. There are request_module to load phy driver, but as 
>>> Russell King said that request_module doesn't garantee auto load will 
>>> always work well, but udev mechanism can garantee it. and udev 
>>> mechaism is more mainstream, otherwise mdio_uevent is useless. if use 
>>> udev mechanism that my patch was needed. and if apply my patch it 
>>> doesn't cause request_module mechaism work bad because I will add 
>>> following change:
>>>
>>>
>>>
>>> -       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT,
>>> -                            MDIO_ID_ARGS(phy_id));
>>> +       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT, phy_id);
>>>          /* We only check for failures in executing the usermode binary,
>>>           * not whether a PHY driver module exists for the PHY ID.
>>>           * Accept -ENOENT because this may occur in case no 
>>> initramfs exists,
>>> diff --git a/include/linux/mod_devicetable.h 
>>> b/include/linux/mod_devicetable.h
>>> index 7bd23bf..bc6ea0d 100644
>>> --- a/include/linux/mod_devicetable.h
>>> +++ b/include/linux/mod_devicetable.h
>>> @@ -600,16 +600,7 @@ struct platform_device_id {
>>>   #define MDIO_NAME_SIZE         32
>>>   #define MDIO_MODULE_PREFIX     "mdio:"
>>>
>>> -#define MDIO_ID_FMT 
>>> "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
>>> -#define MDIO_ID_ARGS(_id) \
>>> -       ((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, 
>>> ((_id)>>28) & 1, \
>>> -       ((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, 
>>> ((_id)>>24) & 1, \
>>> -       ((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, 
>>> ((_id)>>20) & 1, \
>>> -       ((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, 
>>> ((_id)>>16) & 1, \
>>> -       ((_id)>>15) & 1, ((_id)>>14) & 1, ((_id)>>13) & 1, 
>>> ((_id)>>12) & 1, \
>>> -       ((_id)>>11) & 1, ((_id)>>10) & 1, ((_id)>>9) & 1, ((_id)>>8) 
>>> & 1, \
>>> -       ((_id)>>7) & 1, ((_id)>>6) & 1, ((_id)>>5) & 1, ((_id)>>4) & 
>>> 1, \
>>> -       ((_id)>>3) & 1, ((_id)>>2) & 1, ((_id)>>1) & 1, (_id) & 1
>>> +#define MDIO_ID_FMT "p%08x"
>>>
>>>
>>>
>>
>>  > > > > However, this won't work for PHY devices created _before_ the 
>> kernel
>>  > > > > has mounted the rootfs, whether or not they end up being 
>> used. So,
>>  > > > > every PHY mentioned in DT will be created before the rootfs 
>> is mounted,
>>  > > > > and none of these PHYs will have their modules loaded.
>>  > > >
>>  > > > Hi Russell
>>  > > >
>>  > > > I think what you are saying here is, if the MAC or MDIO bus 
>> driver is
>>  > > > built in, the PHY driver also needs to be built in?
>>  > > >
>>  > > > If the MAC or MDIO bus driver is a module, it means the rootfs has
>>  > > > already been mounted in order to get these modules. And so the PHY
>>  > > > driver as a module will also work.
>>  > > >
>>  > > > > I believe this is the root cause of Yinbo Zhu's issue.
>>  > >
>>  > > I think you should be right and I had did lots of test but use 
>> rquest_module
>>  > > it doesn't load marvell module, and dts does't include any phy 
>> node. even
>>  > > though I was use "marvell" as input's args of request_module.
>>
>>  > Please can you report the contents of /proc/sys/kernel/modprobe, and
>>  > the kernel configuration of CONFIG_MODPROBE_PATH. I wonder if your
>>  > userspace has that module loading mechanism disabled, or your kernel
>>  > has CONFIG_MODPROBE_PATH as an empty string.
>>
>>  > If the module is not present by the time this call is made, then
>>  > even if you load the appropriate driver module later, that module
>>  > will not be used - the PHY will end up being driven by the generic
>>  > clause 22 driver.
>>
>>  > > > That is not true universally for all MDIO though - as
>>  > > > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which 
>> uses DT
>>  > > > the compatible string to do the module load. So, we have proof 
>> there
>>  > > > that Yinbo Zhu's change will definitely cause a regression 
>> which we
>>  > > > can not allow.
>>  > >
>>  > > I don't understand that what you said about regression.  My patch 
>> doesn't
>>  > > cause  xilinx_gmii2rgmii.c driver load fail, in this time that 
>> do_of_table
>>  > >and platform_uevent will be responsible "of" type driver auto load 
>> and my
>>  > > patch was responsible for "mdio" type driver auto load,
>>
>>  > xilinx_gmii2rgmii is not a platform driver. It is a mdio driver:
>>
>>  > static struct mdio_driver xgmiitorgmii_driver = {
>>                ^^^^^^^^^^^
>>
>>  > Therefore, platform_uevent() is irrelevant since this will never match
>>  > a platform device. It will only match mdio devices, and the uevent
>>  > generation for that is via mdio_uevent() which is the function you
>>  > are changing.
>>
>>
>> static const struct of_device_id xgmiitorgmii_of_match[] = {
>>          { .compatible = "xlnx,gmii-to-rgmii-1.0" },
>>          {},
>> };
>> MODULE_DEVICE_TABLE(of, xgmiitorgmii_of_match);
>>
>> static struct mdio_driver xgmiitorgmii_driver = {
>>          .probe  = xgmiitorgmii_probe,
>>          .mdiodrv.driver = {
>>                  .name = "xgmiitorgmii",
>>                  .of_match_table = xgmiitorgmii_of_match,
>>          },
>> };
>>  From the present point of view, no matter what the situation, my 
>> supplement can cover udev or request_module for auto load module.
>>
>> if that phy driver isn't platform driver my patch cover it I think 
>> there is no doubt, if phy driver is platform driver and platform 
>> driver udev will cover it. My only requestion is the request_module 
>> not work well.
>>
>> about xgmiitorgmii_of_match that it belongs to platform driver load, 
>> please you note. and about your doubt usepace whether disable module 
>> load that module load function is okay becuase other device driver 
>> auto load is okay.
>>
>>  > > In default code. There are request_module to load phy driver, but 
>> as > Russell
>>  > > King said that request_module doesn't garantee auto load will 
>> always work
>>  > > well, but udev mechanism can garantee it. and udev mechaism is more
>>  > > mainstream, otherwise mdio_uevent is useless. if use udev 
>> mechanism that my
>>  > > patch was needed. and if apply my patch it doesn't cause 
>> request_module
>>  > > mechaism work bad because I will add following change:
>>
>>  > Please report back what the following command produces on your
>>  > problem system:
>>
>>  > /sbin/modprobe -vn mdio:00000001010000010000110111010001
>>
>>  > Thanks.
>>
>> [root@localhost ~]# lsmod | grep marvell
>> [root@localhost ~]# ls 
>> /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>> /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>> [root@localhost ~]# /sbin/modprobe -vn 
>> mdio:00000001010000010000110111010001
>> insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>> insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>> [root@localhost ~]#
>> [root@localhost ~]# cat /proc/sys/kernel/modprobe
>> /sbin/modprobe
>>
>> BRs,
>> Yinbo
> 
>  > On Tue, Jan 04, 2022 at 09:11:56PM +0800, zhuyinbo wrote:
>  > > From the present point of view, no matter what the situation, my 
> supplement
>  > > can cover udev or request_module for auto load module.
>  > >
>  > > if that phy driver isn't platform driver my patch cover it I think 
> there is
>  > > no doubt, if phy driver is platform driver and platform driver udev 
> will
>  > > cover it. My only requestion is the request_module not work well.
>  > >
>  > > about xgmiitorgmii_of_match that it belongs to platform driver 
> load, please
>  > > you note. and about your doubt usepace whether disable module load 
> that
>  > > module load function is okay becuase other device driver auto load 
> is okay.
> 
>  > xgmiitorgmii is *not* a platform driver.
> 
> For the module loading function, you need to focus on the first args 
> "of" in function MODULE_ DEVICE_TABLE, not the definition type of this 
> driver.  for "of" type that must platform covert it !
> 
>  > > > Please report back what the following command produces on your
>  > > > problem system:
>  > > >
>  > > > /sbin/modprobe -vn mdio:00000001010000010000110111010001
>  > > >
>  > > > Thanks.
>  > >
>  > > [root@localhost ~]# lsmod | grep marvell
>  > > [root@localhost ~]# ls
>  > > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>  > > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>  > > [root@localhost ~]# /sbin/modprobe -vn 
>  >mdio:00000001010000010000110111010001
>  > > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>  > > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
>  > > [root@localhost ~]#
>  > > [root@localhost ~]# cat /proc/sys/kernel/modprobe
>  > > /sbin/modprobe
> 
>  > Great, so the current scheme using "mdio:<binary digits>" works
>  > perfectly for you. What is missing is having that modalias in the
>  > uevent file.
> No, "lsmod | grep marvel" is NULL, so "mdio:<binary digits>" doesn't 
> work well. and that lost information is string that match do_mdio_entry 
> Hexadecimal string or binary digits and I add my patch use hexadecimal 
> and change do_mdio_entry to fix issue was to consider that different 
> "Revision Number" represent that phy hardware may be has some 
> difference, so I think we should not blindly load the corresponding PHY 
> driver. It is appropriate to match the PHY ID exactly. for 
> example,following code is marvell phy for 88e1510, which include it's 
> initial function for phy. and my platform hardware use 88e1512, if 
> doesn't change do_mdio_entry code, use "?" to match it, which represent
> 88e1512 hardware to match 881510 driver. of course if 88e1510 driver can 
> compatible with 88e1512 phy, it is okay, but for all kinds of ethernet 
> phy hc and hcd you can ensure it always has a good compatible for that?
> Like 88e1510 driver, it is compatible with 88e1512 and has no problem. 
> In fact, I'm not sure if there is a problem with the 88e1512 loaded 
> 88e1510 driver. So I modified do_mdio_entry is used for full matching, 
> and it can cover above all issue.
> 
>                  .phy_id = MARVELL_PHY_ID_88E1510,
>                  .phy_id_mask = MARVELL_PHY_ID_MASK,
>                  .name = "Marvell 88E1510",
>                  .features = PHY_GBIT_FEATURES | SUPPORTED_FIBRE,
>                  .flags = PHY_HAS_INTERRUPT,
>                  .probe = &m88e1510_probe,
>                  .config_init = &m88e1510_config_init,
>                  .config_aneg = &m88e1510_config_aneg,
>                  .read_status = &marvell_read_status,
> 
> 
>  > So, my patch on the 4th December should cause the marvell module to
>  > be loaded at boot time. Please test that patch ASAP, which I have
>  > already asked you to do. I'll include it again in this email so you
>  > don't have to hunt for it.
> 
>  > 8<===
>  > From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
>  > Subject: [PATCH] net: phy: generate PHY mdio modalias
> 
>  > The modalias string provided in the uevent sysfs file does not conform
>  > to the format used in PHY driver modules. One of the reasons is that
>  > udev loading of PHY driver modules has not been an expected use case.
> 
>  > This patch changes the MODALIAS entry for only PHY devices from:
>  >         MODALIAS=of:Nethernet-phyT(null)
>  > to:
>  >         MODALIAS=mdio:00000000001000100001010100010011
> 
>  > Other MDIO devices (such as DSA) remain as before.
> 
>  > However, having udev automatically load the module has the advantage
>  > of making use of existing functionality to have the module loaded
>  > before the device is bound to the driver, thus taking advantage of
>  > multithreaded boot systems, potentially decreasing the boot time.
> 
>  > However, this patch will not solve any issues with the driver module
>  > not being loaded prior to the network device needing to use the PHY.
>  > This is something that is completely out of control of any patch to
>  > change the uevent mechanism.
> 
>  > Reported-by: Yinbo Zhu <zhuyinbo@loongson.cn>
>  > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>  > ---
>  > drivers/net/phy/mdio_bus.c   |  8 ++++++++
>  > drivers/net/phy/phy_device.c | 14 ++++++++++++++
>  > include/linux/mdio.h         |  2 ++
>  > 3 files changed, 24 insertions(+)
> 
>  > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>  > index 4638d7375943..663bd98760fb 100644
>  > --- a/drivers/net/phy/mdio_bus.c
>  > +++ b/drivers/net/phy/mdio_bus.c
>  > @@ -1010,8 +1010,16 @@ static int mdio_bus_match(struct device *dev, 
>  > > struct device_driver *drv)
> 
>  >  static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>   > {
>  > +    struct mdio_device *mdio = to_mdio_device(dev);
>  >     int rc;
>  >
>  > +    /* Use the device-specific uevent if specified */
>  > +    if (mdio->bus_uevent) {
>  > +        rc = mdio->bus_uevent(mdio, env);
>  > +        if (rc != -ENODEV)
>  > +            return rc;
>  > +    }
>  > +
>  >     /* Some devices have extra OF data and an OF-style MODALIAS */
>  >      rc = of_device_uevent_modalias(dev, env);
>  >     if (rc != -ENODEV)
>  > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>  > index 23667658b9c6..f4c2057f0202 100644
>  > --- a/drivers/net/phy/phy_device.c
>  > +++ b/drivers/net/phy/phy_device.c
>  > @@ -563,6 +563,19 @@ static int phy_request_driver_module(struct 
> phy_device *dev, u32 phy_id)
>  >      return 0;
>  >  }
> 
>  > +static int phy_bus_uevent(struct mdio_device *mdiodev,
>  > +              struct kobj_uevent_env *env)
>  > +{
>  > +    struct phy_device *phydev;
>  > +
>  > +    phydev = container_of(mdiodev, struct phy_device, mdio);
>  > +
>  > +    add_uevent_var(env, "MODALIAS=" MDIO_MODULE_PREFIX MDIO_ID_FMT,
>  > +               MDIO_ID_ARGS(phydev->phy_id));
>  > +
>  > +    return 0;
>  > +}
>  > +
>  >  struct phy_device *phy_device_create(struct mii_bus *bus, int addr, 
> u32 phy_id,
>  >                       bool is_c45,
>  >                       struct phy_c45_device_ids *c45_ids)
>  > @@ -582,6 +595,7 @@ struct phy_device *phy_device_create(struct 
> mii_bus *bus, int addr, u32 phy_id,
>  >      mdiodev->dev.type = &mdio_bus_phy_type;
>  >      mdiodev->bus = bus;
>  >     mdiodev->bus_match = phy_bus_match;
>  > +    mdiodev->bus_uevent = phy_bus_uevent;
>  >     mdiodev->addr = addr;
>  >     mdiodev->flags = MDIO_DEVICE_FLAG_PHY;
>  >     mdiodev->device_free = phy_mdio_device_free;
>  > diff --git a/include/linux/mdio.h b/include/linux/mdio.h
>  > index df9c96e56907..5c6676d3de23 100644
>  > --- a/include/linux/mdio.h
>  > +++ b/include/linux/mdio.h
>  > @@ -38,6 +38,8 @@ struct mdio_device {
>  >      char modalias[MDIO_NAME_SIZE];
> 
>  >      int (*bus_match)(struct device *dev, struct device_driver *drv);
>  > +    int (*bus_uevent)(struct mdio_device *mdiodev,
>  > +              struct kobj_uevent_env *env);
>  >     void (*device_free)(struct mdio_device *mdiodev);
>  >     void (*device_remove)(struct mdio_device *mdiodev);
> your patch I have a try and it can make marvel driver auto-load. 
> However, you need to evaluate the above compatibility issues !
> in addition, if phy id register work bad or other case, you dont' read 
> phy id from phy.  your patch will not work well. so you shoud definition 
> a any_phy_id, of course, The most critical issue is the above driver 
> compatibility, please you note.
> 
> in additon, I have never received your email before. I have to check 
> patchwork every time, so if you have a advice that could you send a mail 
> to zhuyinbo@loongson.cn .
> 
> Thanks,
> 
> BRs,
> Yinbo Zhu.
Hi phy maintainer,

What's your viewpoint?

Thanks
BRs
Yinbo Zhu.


