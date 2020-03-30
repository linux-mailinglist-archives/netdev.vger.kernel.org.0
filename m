Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B119756C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgC3HQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:16:37 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41756 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgC3HQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:16:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02U7Femr070666;
        Mon, 30 Mar 2020 02:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585552540;
        bh=NXREPC6AjT+tb9XAu2s06xCTTiXQAq15gLRQdGHSrsc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=N7GDFfuNeAhgRmOm/cs0ZBnR0jXDoxuJ0gH6W2WZzvAz238bc/fq+eC9OmFUJUon7
         nDrqZPPaIW4lYuyAlII5IY2FBcU5KM9TBx6El5LhsmWELSjDHkstJME8SJ7ci6PCYG
         dNPTovCGAtmj6+aiYKzX6nqBD1YRrLwbGkZMwnEM=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02U7FeHx098221
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Mar 2020 02:15:40 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 30
 Mar 2020 02:15:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 30 Mar 2020 02:15:39 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02U7FZIN103554;
        Mon, 30 Mar 2020 02:15:36 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        <peter.ujfalusi@ti.com>, Rob Herring <robh@kernel.org>,
        netdev <netdev@vger.kernel.org>, <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, <nsekhar@ti.com>,
        <kishon@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20200323225254.12759-1-grygorii.strashko@ti.com>
 <20200326.200136.1601946994817303021.davem@davemloft.net>
 <CA+h21hr8G24ddEgAbU_TfoNAe0fqUJ0_Uyp54Gxn5cvPrM6u9g@mail.gmail.com>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <8f5e981a-193c-0c1e-1e0a-b0380b2e6a9c@ti.com>
Date:   Mon, 30 Mar 2020 10:15:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hr8G24ddEgAbU_TfoNAe0fqUJ0_Uyp54Gxn5cvPrM6u9g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2020 03:53, Vladimir Oltean wrote:
> Hi David,
> 
> On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
>>
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>> Date: Tue, 24 Mar 2020 00:52:43 +0200
>>
>>> This v6 series adds basic networking support support TI K3 AM654x/J721E SoC which
>>> have integrated Gigabit Ethernet MAC (Media Access Controller) into device MCU
>>> domain and named MCU_CPSW0 (CPSW2G NUSS).
>>   ...
>>
>> Series applied, thank you.
> 
> The build is now broken on net-next:
> 
> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
> (phandle_references):
> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
> Reference to non-existent node
> or label "mcu_conf"
> 
>    also defined at
> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
> arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
> (phandle_references):
> /interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
> Reference to non-existent node
> or label "phy_gmii_sel"
> 
>    also defined at
> arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
> 
> As Grygorii said:
> 
> Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3 Platform
> tree and provided here for testing purposes.

Yeah, I think you are missing a dependency that was applied via the K3 
branch earlier. They are in linux-next now, but I am not so sure how 
much that is going to help you.

You could just drop the DT patches from this merge and let me apply them 
via the platform branch.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
