Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B20E1DBBFD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgETRxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:53:04 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38238 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgETRxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:53:04 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KHqxnO082673;
        Wed, 20 May 2020 12:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589997179;
        bh=SMQCS5BSmnxFa3H5C1NH1s5D+HnAPmg4JMl1668xgyk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dyYg60zw1ySiaIyZRM5p11q9kuuiMv8NHWPI4TdTk63YMLiREgGYPxMEXmyRXoPfO
         PFrRJCD23iboJFkIrXzbziBc6O59UMetynvTUjUBXqVytAdEwRoUjKEJXp6xkvmg/G
         xMWR0ZllagvfR9c9ul+z5B9SCkUzKRoYi3PEerTU=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KHqwVi036168
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 12:52:59 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 12:52:58 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 12:52:58 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KHqw5O074199;
        Wed, 20 May 2020 12:52:58 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
 <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
Date:   Wed, 20 May 2020 12:52:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 5/20/20 12:45 PM, Florian Fainelli wrote:
>
> On 5/20/2020 10:20 AM, Dan Murphy wrote:
>> Andrew/Florian
>>
>> On 5/20/20 11:43 AM, Andrew Lunn wrote:
>>>> I am interested in knowing where that is documented.  I want to RTM I
>>>> grepped for a few different words but came up empty
>>> Hi Dan
>>>
>>> It probably is not well documented, but one example would be
>>>
>>> Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>>
>>> says:
>>>
>>>         # RX and TX delays are added by the MAC when required
>>>         - rgmii
>>>
>>>         # RGMII with internal RX and TX delays provided by the PHY,
>>>         # the MAC should not add the RX or TX delays in this case
>>>         - rgmii-id
>>>
>>>         # RGMII with internal RX delay provided by the PHY, the MAC
>>>         # should not add an RX delay in this case
>>>         - rgmii-rxid
>>>
>>>         # RGMII with internal TX delay provided by the PHY, the MAC
>>>         # should not add an TX delay in this case
>>>
>>>         Andrew
>> OKI I read that.  I also looked at a couple other drivers too.
>>
>> I am wondering if rx-internal-delay and tx-internal-delay should become
>> a common property like tx/rx fifo-depth
>>> And properly document how to use it or at least the expectation on use.
> Yes they should, and they should have an unit associated with the name.


UGH I think I just got volunteered to do make them common.

Dan

