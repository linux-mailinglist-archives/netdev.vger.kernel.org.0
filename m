Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CDE46B7B2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhLGJpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:45:42 -0500
Received: from mail.loongson.cn ([114.242.206.163]:54216 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229799AbhLGJpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 04:45:41 -0500
Received: from [10.180.13.84] (unknown [10.180.13.84])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv8pfLK9hyDoEAA--.9364S2;
        Tue, 07 Dec 2021 17:41:52 +0800 (CST)
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        zhuyinbo@loongson.cn, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk> <YabEHd+Z5SPAhAT5@lunn.ch>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
Date:   Tue, 7 Dec 2021 17:41:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YabEHd+Z5SPAhAT5@lunn.ch>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxv8pfLK9hyDoEAA--.9364S2
X-Coremail-Antispam: 1UD129KBjvJXoWxArWrAF1UCF1UJr1fJr17GFg_yoWrAw45pF
        WqkFWa9rs5AFs5CF18Jr1UXFWUC3yDX3y3GF1rK3yxua4DJr9Fyr47Gr43JrW7Xw48AF10
        g3ZrXFykCrWxZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2021/12/1 ÉÏÎç8:38, Andrew Lunn Ð´µÀ:
>> However, this won't work for PHY devices created _before_ the kernel
>> has mounted the rootfs, whether or not they end up being used. So,
>> every PHY mentioned in DT will be created before the rootfs is mounted,
>> and none of these PHYs will have their modules loaded.
> 
> Hi Russell
> 
> I think what you are saying here is, if the MAC or MDIO bus driver is
> built in, the PHY driver also needs to be built in?
> 
> If the MAC or MDIO bus driver is a module, it means the rootfs has
> already been mounted in order to get these modules. And so the PHY
> driver as a module will also work.
> 
>> I believe this is the root cause of Yinbo Zhu's issue.

I think you should be right and I had did lots of test but use 
rquest_module it doesn't load marvell module, and dts does't include any 
phy node. even though I was use "marvell" as input's args of request_module.
> 
> You are speculating that in Yinbo Zhu case, the MAC driver is built
> in, the PHY is a module. The initial request for the firmware fails.
> Yinbo Zhu would like udev to try again later when the modules are
> available.
> 
>> What we _could_ do is review all device trees and PHY drivers to see
>> whether DT modaliases are ever used for module loading. If they aren't,
>> then we _could_ make the modalias published by the kernel conditional
>> on the type of mdio device - continue with the DT approach for non-PHY
>> devices, and switch to the mdio: scheme for PHY devices. I repeat, this
>> can only happen if no PHY drivers match using the DT scheme, otherwise
>> making this change _will_ cause a regression.
> 

> Take a look at
> drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
> 
> So there are some DT blobs out there with compatible strings for
> PHYs. I've no idea if they actually load that way, or the standard PHY
> mechanism is used.
> 
> 	Andrew
> 


 > That is not true universally for all MDIO though - as
 > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which uses DT
 > the compatible string to do the module load. So, we have proof there
 > that Yinbo Zhu's change will definitely cause a regression which we
 > can not allow.

I don't understand that what you said about regression.  My patch 
doesn't cause  xilinx_gmii2rgmii.c driver load fail, in this time that 
do_of_table and platform_uevent will be responsible "of" type driver 
auto load and my patch was responsible for "mdio" type driver auto load,
In default code. There are request_module to load phy driver, but as 
Russell King said that request_module doesn't garantee auto load will 
always work well, but udev mechanism can garantee it. and udev mechaism 
is more mainstream, otherwise mdio_uevent is useless. if use udev 
mechanism that my patch was needed. and if apply my patch it doesn't 
cause request_module mechaism work bad because I will add following change:



-       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT,
-                            MDIO_ID_ARGS(phy_id));
+       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT, phy_id);
         /* We only check for failures in executing the usermode binary,
          * not whether a PHY driver module exists for the PHY ID.
          * Accept -ENOENT because this may occur in case no initramfs 
exists,
diff --git a/include/linux/mod_devicetable.h 
b/include/linux/mod_devicetable.h
index 7bd23bf..bc6ea0d 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -600,16 +600,7 @@ struct platform_device_id {
  #define MDIO_NAME_SIZE         32
  #define MDIO_MODULE_PREFIX     "mdio:"

-#define MDIO_ID_FMT 
"%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
-#define MDIO_ID_ARGS(_id) \
-       ((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 
1, \
-       ((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 
1, \
-       ((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 
1, \
-       ((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 
1, \
-       ((_id)>>15) & 1, ((_id)>>14) & 1, ((_id)>>13) & 1, ((_id)>>12) & 
1, \
-       ((_id)>>11) & 1, ((_id)>>10) & 1, ((_id)>>9) & 1, ((_id)>>8) & 1, \
-       ((_id)>>7) & 1, ((_id)>>6) & 1, ((_id)>>5) & 1, ((_id)>>4) & 1, \
-       ((_id)>>3) & 1, ((_id)>>2) & 1, ((_id)>>1) & 1, (_id) & 1
+#define MDIO_ID_FMT "p%08x"



