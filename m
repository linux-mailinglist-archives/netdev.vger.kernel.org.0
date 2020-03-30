Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E425B19831E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgC3SOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:14:20 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50590 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3SOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:14:20 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02UIE7X5124911;
        Mon, 30 Mar 2020 13:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585592047;
        bh=Ysd2CfzoUryMv7olffzf/9E4mY3hhWXojGKfYzHOL6k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Rjwo3vpUSjlp3mC2/WZM64s6nB/dhQIu6GTBHE/cLhtJTNoeDbutDwTjPzepHr0LV
         3J/LRavtV0Ew/ZhxyM+qMfpIAVS+C14TCGYL/Y0LhYJ5ASohgsnmsj6Shmh8AUN6Hw
         twDGupg6w8UITkOoJAq8YNqKbBNPxxLNnNrFrDJ4=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02UIE71J099822
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Mar 2020 13:14:07 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 30
 Mar 2020 13:14:06 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 30 Mar 2020 13:14:06 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02UIE0Qg044169;
        Mon, 30 Mar 2020 13:14:02 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     Sekhar Nori <nsekhar@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     <peter.ujfalusi@ti.com>, Rob Herring <robh@kernel.org>,
        netdev <netdev@vger.kernel.org>, <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, <kishon@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
References: <20200323225254.12759-1-grygorii.strashko@ti.com>
 <20200326.200136.1601946994817303021.davem@davemloft.net>
 <CA+h21hr8G24ddEgAbU_TfoNAe0fqUJ0_Uyp54Gxn5cvPrM6u9g@mail.gmail.com>
 <8f5e981a-193c-0c1e-1e0a-b0380b2e6a9c@ti.com>
 <2d305c89-601c-5dee-06be-30257a26a392@ti.com>
 <cac3d501-cc36-73c5-eea8-aaa2d10105b0@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <590f9865-ace7-fc12-05e7-0c8579785f96@ti.com>
Date:   Mon, 30 Mar 2020 21:14:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cac3d501-cc36-73c5-eea8-aaa2d10105b0@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 30/03/2020 11:28, Sekhar Nori wrote:
> On 30/03/20 1:06 PM, Sekhar Nori wrote:
>> On 30/03/20 12:45 PM, Tero Kristo wrote:
>>> On 28/03/2020 03:53, Vladimir Oltean wrote:
>>>> Hi David,
>>>>
>>>> On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
>>>>>
>>>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>> Date: Tue, 24 Mar 2020 00:52:43 +0200
>>>>>
>>>>>> This v6 series adds basic networking support support TI K3
>>>>>> AM654x/J721E SoC which
>>>>>> have integrated Gigabit Ethernet MAC (Media Access Controller) into
>>>>>> device MCU
>>>>>> domain and named MCU_CPSW0 (CPSW2G NUSS).
>>>>>    ...
>>>>>
>>>>> Series applied, thank you.
>>>>
>>>> The build is now broken on net-next:
>>>>
>>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>>>> (phandle_references):
>>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>>>
>>>> Reference to non-existent node
>>>> or label "mcu_conf"
>>>>
>>>>     also defined at
>>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>>>> (phandle_references):
>>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>>>
>>>> Reference to non-existent node
>>>> or label "phy_gmii_sel"
>>>>
>>>>     also defined at
>>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>>>>
>>>> As Grygorii said:
>>>>
>>>> Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3
>>>> Platform
>>>> tree and provided here for testing purposes.
>>>
>>> Yeah, I think you are missing a dependency that was applied via the K3
>>> branch earlier. They are in linux-next now, but I am not so sure how
>>> much that is going to help you.
>>>
>>> You could just drop the DT patches from this merge and let me apply them
>>> via the platform branch.
>>
>> One other option would be that Dave merges your K3 tag which was sent to
>> ARM SoC to net-next. Its based on v5.6-rc1, has no other dependencies,
>> is already in linux-next, should be immutable and safe to merge. This
>> has the advantage that no rebase is necessary on net-next.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux
>> tags/ti-k3-soc-for-v5.7
> 
> FWIW, I was able to reproduce the build failure reported by Vladimir on
> net-next, merge Tero's tag (above) cleanly into it, and see that ARM64
> defconfig build on net-next succeeds after the merge.

Thank you Sekhar for checking this.

I'm very sorry for introducing this issue. I've tried hard to avoid such issue,
but still missed it (probably I have had to drop DT patches from last submission
and send them separately).

Sorry again.

-- 
Best regards,
grygorii
