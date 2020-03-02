Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4B7175549
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgCBIPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:15:20 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47434 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgCBIPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:15:20 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0228Esbw067966;
        Mon, 2 Mar 2020 02:14:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583136894;
        bh=TdhMpVGavBMp+rXwCQqseldtj1O3C6Ev8oQyZs2QgMQ=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=DRENygLrbKRMRypHzLIXHGsOsqoyTlJ5Vkm+EKAVOcFMmK11FULvxBUIHsDLXKN+K
         aNo3jq8jEpTzrBm/UgzqoEZeGBAui6BEtEkGbb++n3N/HIJ+K6sBoq0MpMThKZ84My
         V/LeFhUvoK7C5lFZaA2WubDIoF2vtwevBqu9Gh70=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0228EsA4016695;
        Mon, 2 Mar 2020 02:14:54 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 2 Mar
 2020 02:14:54 -0600
Received: from localhost.localdomain (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 2 Mar 2020 02:14:54 -0600
Received: from [10.24.69.157] (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 0228EnLq073051;
        Mon, 2 Mar 2020 02:14:50 -0600
Subject: Re: [PATCH v2 1/3] dt-bindings: m_can: Add Documentation for
 transceiver regulator
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-2-faiz_abbas@ti.com> <20200219203529.GA21085@bogus>
 <a987bcd7-ca1c-dfda-72f3-cd2004a87ea5@ti.com>
 <20b86553-9b98-1a9d-3757-54174aa67c62@pengutronix.de>
 <72e4b1f4-e7f1-cccd-6327-0c8ab6f9f9a7@ti.com>
Message-ID: <679bdfd3-5325-b903-de5f-1beb5b577d73@ti.com>
Date:   Mon, 2 Mar 2020 13:46:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <72e4b1f4-e7f1-cccd-6327-0c8ab6f9f9a7@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc,

On 26/02/20 2:40 pm, Faiz Abbas wrote:
> Hi Marc,
> 
> On 21/02/20 2:01 pm, Marc Kleine-Budde wrote:
>> On 2/21/20 9:31 AM, Faiz Abbas wrote:
>>> Hi Rob,
>>>
>>> On 20/02/20 2:05 am, Rob Herring wrote:
>>>> On Mon, Feb 17, 2020 at 07:58:34PM +0530, Faiz Abbas wrote:
>>>>> Some CAN transceivers have a standby line that needs to be asserted
>>>>> before they can be used. Model this GPIO lines as an optional
>>>>> fixed-regulator node. Document bindings for the same.
>>>>>
>>>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/net/can/m_can.txt | 3 +++
>>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> This has moved to DT schema in my tree, so please adjust it and resend.
>>>
>>> Ok.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>> index ed614383af9c..f17e2a5207dc 100644
>>>>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>> @@ -48,6 +48,9 @@ Optional Subnode:
>>>>>  			  that can be used for CAN/CAN-FD modes. See
>>>>>  			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>>>>  			  for details.
>>>>> +
>>>>> +- xceiver-supply: Regulator that powers the CAN transceiver.
>>>>
>>>> The supply for a transceiver should go in the transceiver node.
>>>>
>>>
>>> Marc, while I have you here, do you agree with this?
>>
>> I'll look into the details later today.
>>
> 
> Sure. Be sure to take another look at my attempt to use the transceiver
> with a phy driver some time ago.
> 
> https://lore.kernel.org/patchwork/patch/1006238/
> 

Do you have any comments?

Thanks,
Faiz
