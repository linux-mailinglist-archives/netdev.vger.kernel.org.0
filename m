Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3321675AE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbgBUIad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:30:33 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57696 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgBUIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:30:32 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01L8UBTi015091;
        Fri, 21 Feb 2020 02:30:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582273811;
        bh=+GwlT/Yat0yhSuALWos65geLATvxwiVl9nMI6ZThU74=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DghcjZaQsPfTbKfnW/1UJ7PRfuWJ+c78eU1tqmFIwTARL8D3YzAwWvMkKNdkYCFIi
         1CX8KZmbKFisJ4b4RetAzP2XHCypsnQVCIkHkvtXm3S7sFP9Rn0hqyLvfnk7VDW9Ia
         Xe6Cl4sojFoR1i3HHMeA6X9uI3Tn53vK3Rulj7Ik=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01L8UBXA075825
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Feb 2020 02:30:11 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 21
 Feb 2020 02:30:11 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 21 Feb 2020 02:30:11 -0600
Received: from [172.24.190.4] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01L8U6eo107119;
        Fri, 21 Feb 2020 02:30:07 -0600
Subject: Re: [PATCH v2 1/3] dt-bindings: m_can: Add Documentation for
 transceiver regulator
To:     Rob Herring <robh@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>, <dmurphy@ti.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-2-faiz_abbas@ti.com> <20200219203529.GA21085@bogus>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <a987bcd7-ca1c-dfda-72f3-cd2004a87ea5@ti.com>
Date:   Fri, 21 Feb 2020 14:01:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219203529.GA21085@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 20/02/20 2:05 am, Rob Herring wrote:
> On Mon, Feb 17, 2020 at 07:58:34PM +0530, Faiz Abbas wrote:
>> Some CAN transceivers have a standby line that needs to be asserted
>> before they can be used. Model this GPIO lines as an optional
>> fixed-regulator node. Document bindings for the same.
>>
>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>> ---
>>  Documentation/devicetree/bindings/net/can/m_can.txt | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> This has moved to DT schema in my tree, so please adjust it and resend.

Ok.
> 
>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
>> index ed614383af9c..f17e2a5207dc 100644
>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>> @@ -48,6 +48,9 @@ Optional Subnode:
>>  			  that can be used for CAN/CAN-FD modes. See
>>  			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>  			  for details.
>> +
>> +- xceiver-supply: Regulator that powers the CAN transceiver.
> 
> The supply for a transceiver should go in the transceiver node.
> 

Marc, while I have you here, do you agree with this?

Thanks,
Faiz
