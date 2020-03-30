Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52E719766E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgC3I2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:28:35 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45284 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgC3I2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 04:28:35 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02U8SERF110283;
        Mon, 30 Mar 2020 03:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585556894;
        bh=1YfcS38BPhZe/p5W8i5G+38GAG3OkNcS1KKAWP4M02Q=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=Dx268NtKt8MNlm4k8PX37tpHEKSLzyMAmWYnugW6ihPQBOfctEiBLCWkYklM6/8/h
         DWwzVspu4bdTCGIzHkXMNM5E2n3h3k/azSnILrmah1lW3fxAB8dqNUonZm4d1k5FmW
         JyGPMDgUB8xzEQNPvm3067KxHIEVykRbugwFnZT4=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02U8SE8F019493
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Mar 2020 03:28:14 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 30
 Mar 2020 03:28:14 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 30 Mar 2020 03:28:14 -0500
Received: from [10.24.69.198] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02U8S902055047;
        Mon, 30 Mar 2020 03:28:10 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
From:   Sekhar Nori <nsekhar@ti.com>
To:     Tero Kristo <t-kristo@ti.com>, Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        <peter.ujfalusi@ti.com>, Rob Herring <robh@kernel.org>,
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
Message-ID: <cac3d501-cc36-73c5-eea8-aaa2d10105b0@ti.com>
Date:   Mon, 30 Mar 2020 13:58:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2d305c89-601c-5dee-06be-30257a26a392@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/20 1:06 PM, Sekhar Nori wrote:
> On 30/03/20 12:45 PM, Tero Kristo wrote:
>> On 28/03/2020 03:53, Vladimir Oltean wrote:
>>> Hi David,
>>>
>>> On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
>>>>
>>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> Date: Tue, 24 Mar 2020 00:52:43 +0200
>>>>
>>>>> This v6 series adds basic networking support support TI K3
>>>>> AM654x/J721E SoC which
>>>>> have integrated Gigabit Ethernet MAC (Media Access Controller) into
>>>>> device MCU
>>>>> domain and named MCU_CPSW0 (CPSW2G NUSS).
>>>>   ...
>>>>
>>>> Series applied, thank you.
>>>
>>> The build is now broken on net-next:
>>>
>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>>> (phandle_references):
>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>>
>>> Reference to non-existent node
>>> or label "mcu_conf"
>>>
>>>    also defined at
>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>>> (phandle_references):
>>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>>
>>> Reference to non-existent node
>>> or label "phy_gmii_sel"
>>>
>>>    also defined at
>>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>>>
>>> As Grygorii said:
>>>
>>> Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3
>>> Platform
>>> tree and provided here for testing purposes.
>>
>> Yeah, I think you are missing a dependency that was applied via the K3
>> branch earlier. They are in linux-next now, but I am not so sure how
>> much that is going to help you.
>>
>> You could just drop the DT patches from this merge and let me apply them
>> via the platform branch.
> 
> One other option would be that Dave merges your K3 tag which was sent to
> ARM SoC to net-next. Its based on v5.6-rc1, has no other dependencies,
> is already in linux-next, should be immutable and safe to merge. This
> has the advantage that no rebase is necessary on net-next.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux
> tags/ti-k3-soc-for-v5.7

FWIW, I was able to reproduce the build failure reported by Vladimir on
net-next, merge Tero's tag (above) cleanly into it, and see that ARM64
defconfig build on net-next succeeds after the merge.

Thanks,
Sekhar
