Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB28C14671A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAWLpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 06:45:07 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51394 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgAWLpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 06:45:06 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00NBijAB129984;
        Thu, 23 Jan 2020 05:44:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579779885;
        bh=QnJ9VUHPpMMd8YUAGeL/71FiTwnavEbizZbc/dCqjBQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xA6ob+SJdg7zfXn7hlg2ASxYri8hGEOhWPfgeB83gcf3pZOhdMBigo2kRnsAhiTIn
         VfSfH3quOr7/RiJPl70v28p2MY0hvYXEfwVQLJ79oo54UxHGb6Andxc3oUcdUX67V5
         SGrYv56ow2oBNw/v7YNv+bv/yF6EDuQExoEVS+xs=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00NBiiMB060474;
        Thu, 23 Jan 2020 05:44:44 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 23
 Jan 2020 05:44:44 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 23 Jan 2020 05:44:44 -0600
Received: from [172.24.190.4] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00NBienv047691;
        Thu, 23 Jan 2020 05:44:40 -0600
Subject: Re: [PATCH 0/3] Add Support for MCAN in AM654x-idk
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>, <dmurphy@ti.com>, <nm@ti.com>,
        <t-kristo@ti.com>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
 <e3025ab6-04b5-3eba-5e0d-70caabee26fb@pengutronix.de>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <f6bf75f0-68ea-0b61-ed43-9ad894016cfd@ti.com>
Date:   Thu, 23 Jan 2020 17:16:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e3025ab6-04b5-3eba-5e0d-70caabee26fb@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc,

On 23/01/20 4:47 pm, Marc Kleine-Budde wrote:
> On 1/22/20 9:03 AM, Faiz Abbas wrote:
>> This series adds driver patches to support MCAN in TI's AM654x-idk.
>>
>> Faiz Abbas (3):
>>   dt-bindings: net: can: m_can: Add Documentation for stb-gpios
>>   can: m_can: m_can_platform: Add support for enabling transceiver
>>     through the STB line
>>   arm64: defconfig: Add Support for Bosch M_CAN controllers
>>
>>  Documentation/devicetree/bindings/net/can/m_can.txt |  2 ++
>>  arch/arm64/configs/defconfig                        |  3 +++
>>  drivers/net/can/m_can/m_can_platform.c              | 12 ++++++++++++
>>  3 files changed, 17 insertions(+)
> 
> What about adding support for xceiver-supply as done in several other
> drivers (ti_hecc.c, flexcan.c, mcp251x.c)? And using this for the stb line?

Looks like you had given this feedback a long time ago and I forgot
about it. Sorry about that :-)

https://lore.kernel.org/patchwork/patch/1006238/

But now that I think about it, its kinda weird that we are modelling
part of the transceiver as a separate child node
(Documentation/devicetree/bindings/net/can/can-transceiver.txt) and the
other parts as a regulator.

Anyone looking at the transceiver node would figure thats where the
enable gpio/regulator node needs to go instead of the parent node.
Shouldn't we have all transceiver properties under the same node?

Thanks,
Faiz
