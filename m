Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D150F8C2D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKLJsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:48:52 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:55500 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfKLJsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:48:52 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAC9mbsX012018;
        Tue, 12 Nov 2019 03:48:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573552117;
        bh=l9yUkZ7R54513+Ec0cFoJuRTwXy3GJPKi0IXvjNeP0U=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lX2ZH4Szb0vJwHUC1KaIfFxtKmZdWgX/MFjILfyJAzwKzIxntUSiwVZydwqubfTMq
         aKFKNtwrpsde8aVFSvC/4oekylGQemjfhdGuvPtTLr+ZjRXE93P6IZwLGh6bi47HmQ
         0jUpBC421zrVSgjlrK3uWsvRshKSZ29Gi6UKSrhk=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAC9mb8U113120
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Nov 2019 03:48:37 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 12
 Nov 2019 03:48:37 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 12 Nov 2019 03:48:19 -0600
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAC9mXT0016926;
        Tue, 12 Nov 2019 03:48:33 -0600
Subject: Re: [PATCH v5 net-next 00/12] net: ethernet: ti: introduce new cpsw
 switchdev based driver
To:     Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024160549.GY5610@atomide.com>
 <dc621a9d-eb92-5df9-81d7-ad2b037ac3c7@ti.com>
 <20191111170826.GT5610@atomide.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <3c24b4c0-7ef2-71d3-b537-90def7c15fec@ti.com>
Date:   Tue, 12 Nov 2019 11:48:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111170826.GT5610@atomide.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2019 19:08, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [191109 15:16]:
>> Hi Tony,
>>
>> On 24/10/2019 19:05, Tony Lindgren wrote:
>>> Hi,
>>>
>>> * Grygorii Strashko <grygorii.strashko@ti.com> [191024 10:10]:
>>>> This the RFC v5 which introduces new CPSW switchdev based driver which is
>>>> operating in dual-emac mode by default, thus working as 2 individual
>>>> network interfaces. The Switch mode can be enabled by configuring devlink driver
>>>> parameter "switch_mode" to 1/true:
>>>> 	devlink dev param set platform/48484000.ethernet_switch \
>>>> 	name switch_mode value 1 cmode runtime
>>>
>>> Just wondering about the migration plan.. Is this a replacement
>>> driver or used in addition to the old driver?
>>>
>>
>> Sry, I've missed you mail.
>>
>> As it's pretty big change the idea is to keep both drivers at least for sometime.
>> Step 1: add new driver and enable it on one platform. Do announcement.
>> Step 2: switch all one-port and dual mac drivers to the new driver
>> Step 3: switch all other platform to cpsw switchdev and deprecate old driver.
> 
> OK sounds good to me. So for the dts changes, we keep the old binding
> and just add a new module there?

yes, in general.
As you can see Patch 11 I've rearranged cpsw nodes between boards so cpsw_new is enabled
only on one board. But, Am5/dr7 board are good candidates to enable cpsw_new in batch as
the have only dual_mac default cfg.

> 
> Or do you also have to disable some parts of the old dts?

it will be the case for am3/am5 most probably.

-- 
Best regards,
grygorii
