Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC7F18C991
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgCTJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:08:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40752 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgCTJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:08:47 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02K98jPA059657;
        Fri, 20 Mar 2020 04:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584695325;
        bh=iIVhyBp9gLMYDLuXFGRZPRptJw/NYgWDMuFepFE+92o=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uO54Iy8H4yh7Jo14cgDxb5ffUAn6A68+cu62YzeV+xWp9R1aKyYS/Gnu0VNWjiHJ0
         XhWg0Ble3ZcH8CmLH8r3UwF3FXDFC1dODLqLv4JmKUGi2znaeRkSLtKBbFCCy5pkOa
         D6eYkQIpe/01BpDxpfgg1pm7nR9v8W88DqqfajGc=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02K98jUH095614
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Mar 2020 04:08:45 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 04:08:44 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 04:08:44 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02K98fUm108760;
        Fri, 20 Mar 2020 04:08:42 -0500
Subject: Re: [for-next PATCH v2 0/5] phy: ti: gmii-sel: add support for
 am654x/j721e soc
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        David Miller <davem@davemloft.net>
CC:     <m-karicheri2@ti.com>, <nsekhar@ti.com>, <robh+dt@kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
 <20200304.143951.1102411401290807167.davem@davemloft.net>
 <71a6fea9-65c1-3a3c-a35b-9432208b3ee5@ti.com>
 <7c5395a6-56cb-1d2a-0243-99a6b0fed2a7@ti.com>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <a6fad5b9-fb90-2db7-9876-d875a91b0633@ti.com>
Date:   Fri, 20 Mar 2020 11:08:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7c5395a6-56cb-1d2a-0243-99a6b0fed2a7@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2020 12:55, Grygorii Strashko wrote:
> 
> 
> On 05/03/2020 07:17, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On 05/03/20 4:09 am, David Miller wrote:
>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Date: Tue, 3 Mar 2020 18:00:24 +0200
>>>
>>>> Hi Kishon,
>>>>
>>>> This series adds support for TI K3 AM654x/J721E SoCs in TI 
>>>> phy-gmii-sel PHY
>>>> driver, which is required for future adding networking support.
>>>>
>>>> depends on:
>>>>   [PATCH 0/2] phy: ti: gmii-sel: two fixes
>>>>   https://lkml.org/lkml/2020/2/14/2510
>>>>
>>>> Changes in v2:
>>>>   - fixed comments
>>>>
>>>> v1: https://lkml.org/lkml/2020/2/22/100
>>>
>>> This is mostly DT updates and not much networking code changes, will 
>>> some other
>>> tree take this?
>>
>> I can take the phy related changes. Grygorii, can you split the dt
>> patches into a separate series?
> 
> sure. Could pls, pick up 1-3 and I'll resend 4-5.
> Or you want me re-send once again?
> 

Queued up patches #4 and #5 towards 5.7, thanks.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
