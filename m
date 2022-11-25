Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49EB638669
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKYJmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKYJmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:42:13 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1324530F5F;
        Fri, 25 Nov 2022 01:42:12 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NJVDX0Q6QzJnrf;
        Fri, 25 Nov 2022 17:38:52 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 17:42:09 +0800
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>, Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <595e0f35-a6a0-eb6e-3a2b-d8bef120f037@huawei.com>
Date:   Fri, 25 Nov 2022 17:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/25 16:05, Naresh Kamboju wrote:
> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
>>> On Wed, 23 Nov 2022 at 19:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>>
>>>> On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>
>>>>> This is the start of the stable review cycle for the 5.10.156 release.
>>>>> There are 149 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>>
>>>> With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
>>>> following warnings / errors [1]. The NFS mount failed and failed to boot.
>>>>
>>>> I have to bisect this problem.
>>>
>>> Daniel bisected this reported problem and found the first bad commit,
>>>
>>> YueHaibing <yuehaibing@huawei.com>
>>>     net: broadcom: Fix BCMGENET Kconfig
>>
>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
>> this -rc release.
> 
> It started from 5.10.155 and this is only seen on 5.10 and other
> branches 5.15, 6.0 and mainline are looking good.
> 
>>
>> What config options are being set because of this that cause the
>> problem?
> 
> LKFT is built with arm64 defconfig + distro configs as described below.
> 
>>   Should it just be reverted for 5.10.y, and not the other
>> branches?  Or for everywhere including Linus's tree?
> 
> Reverting for 5.10 works for Rpi-4 to boot.
> 
> Due to the problematic commit
>       # CONFIG_BROADCOM_PHY is not set
> and Raspberry Pi 4 boot failed only on 5.10.155 and later.

BROADCOM_PHY is needed by ARCH_BCM2835,  but BROADCOM_PHY depends on PTP_1588_CLOCK_OPTIONAL now
see commit 39db6be781cd ("net: phy: broadcom: Add PTP support for some Broadcom PHYs.")

config BROADCOM_PHY
        tristate "Broadcom 54XX PHYs"
        select BCM_NET_PHYLIB
        select BCM_NET_PHYPTP if NETWORK_PHY_TIMESTAMPING
        depends on PTP_1588_CLOCK_OPTIONAL

Your config don't enable PTP_1588_CLOCK_OPTIONAL, maybe PTP_1588_CLOCK_OPTIONAL should be enabled
or BROADCOM_PHY does not depends on PTP_1588_CLOCK_OPTIONAL?

> 
> --
> 
> diff -Narub good-config bad-config
> --- good-config 2022-11-09 14:19:58.000000000 +0530
> +++ bad-config 2022-11-16 15:50:36.000000000 +0530
> @@ -1,6 +1,6 @@
>  #
>  # Automatically generated file; DO NOT EDIT.
> -# Linux/arm64 5.10.154-rc2 Kernel Configuration
> +# Linux/arm64 5.10.155 Kernel Configuration
>  #
>  CONFIG_CC_VERSION_TEXT="aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0"
>  CONFIG_CC_IS_GCC=y
> @@ -2611,7 +2611,7 @@
>  # CONFIG_ADIN_PHY is not set
>  CONFIG_AQUANTIA_PHY=y
>  # CONFIG_AX88796B_PHY is not set
> -CONFIG_BROADCOM_PHY=y
> +# CONFIG_BROADCOM_PHY is not set
>  # CONFIG_BCM54140_PHY is not set
>  CONFIG_BCM7XXX_PHY=y
>  # CONFIG_BCM84881_PHY is not set
> 
> ---
> 
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
> # Original tuxmake command with fragments listed below.
> # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig defconfig --kconfig-add
> https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft.config
> --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft-crypto.config
> --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/distro-overrides.config
> --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/systemd.config
> --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/virtio.config
> --kconfig-add CONFIG_ARM64_MODULE_PLTS=y --kconfig-add
> CONFIG_SYN_COOKIES=y --kconfig-add CONFIG_SCHEDSTATS=y
> CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-
> 
> Bad config link,
> https://builds.tuxbuild.com/2HcnnvEDD3gSr1zmS5DHzqPG2cJ/config
> 
>>
>> thanks,
>>
>> greg k-h
> 
> - Naresh
> .
> 
