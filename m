Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2611975D4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgC3HhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:37:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44562 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbgC3HhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:37:07 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02U7avtO076750;
        Mon, 30 Mar 2020 02:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585553818;
        bh=voYQW80EDvQkOlSfgnq9c/dTJexZ26VOrA18YkmsPTw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=EoXO05vQBMtq0tom/g/Fbz6SZPBShTbVdsPJ4+iOQlEjDowyGWB1hDXOUzYbr4BE/
         ua9Cn8M1pnrkq97+Jp0+ERZ16Lej0LWhkw80kgiPcM8lWJhrHTN+0Lgb2sCW9L5E2o
         J5cfY5e4wbDZ1Fy2BTB7wPn+rs7beppbGEgVK+Ts=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02U7avrb068349
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Mar 2020 02:36:57 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 30
 Mar 2020 02:36:57 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 30 Mar 2020 02:36:57 -0500
Received: from [10.24.69.198] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02U7aq7w094270;
        Mon, 30 Mar 2020 02:36:53 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
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
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <2d305c89-601c-5dee-06be-30257a26a392@ti.com>
Date:   Mon, 30 Mar 2020 13:06:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8f5e981a-193c-0c1e-1e0a-b0380b2e6a9c@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/20 12:45 PM, Tero Kristo wrote:
> On 28/03/2020 03:53, Vladimir Oltean wrote:
>> Hi David,
>>
>> On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
>>>
>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Date: Tue, 24 Mar 2020 00:52:43 +0200
>>>
>>>> This v6 series adds basic networking support support TI K3
>>>> AM654x/J721E SoC which
>>>> have integrated Gigabit Ethernet MAC (Media Access Controller) into
>>>> device MCU
>>>> domain and named MCU_CPSW0 (CPSW2G NUSS).
>>>   ...
>>>
>>> Series applied, thank you.
>>
>> The build is now broken on net-next:
>>
>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>> (phandle_references):
>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>
>> Reference to non-existent node
>> or label "mcu_conf"
>>
>>    also defined at
>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
>> (phandle_references):
>> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
>>
>> Reference to non-existent node
>> or label "phy_gmii_sel"
>>
>>    also defined at
>> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
>>
>> As Grygorii said:
>>
>> Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3
>> Platform
>> tree and provided here for testing purposes.
> 
> Yeah, I think you are missing a dependency that was applied via the K3
> branch earlier. They are in linux-next now, but I am not so sure how
> much that is going to help you.
> 
> You could just drop the DT patches from this merge and let me apply them
> via the platform branch.

One other option would be that Dave merges your K3 tag which was sent to
ARM SoC to net-next. Its based on v5.6-rc1, has no other dependencies,
is already in linux-next, should be immutable and safe to merge. This
has the advantage that no rebase is necessary on net-next.

git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux
tags/ti-k3-soc-for-v5.7

+ ARM SoC maintainers for their information and any advise.

Thanks,
Sekhar

