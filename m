Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98535998A6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389643AbfHVP7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:59:01 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37878 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfHVP7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 11:59:00 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7MFwpZh108990;
        Thu, 22 Aug 2019 10:58:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566489531;
        bh=Y7rcW8KTzIBeyaMcZQrWDg6Mb7RkDjT9VkgH5yO6LtE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=tRPPHwh2K/1hNAnzSvAsqOT1KyFi38/QI/Kx+7Q25T4Lo/lasRz9X9jdAK3YtsJOg
         Clb47pdd6UDrGbmzNYUmZr+MFeDijUNCq6SVUQORmkPlUjBDjUAPqTGAEXnTTjk+44
         MCgdHMIsqRvpHPQvgh1s9pYOh1TC0vZURWt72yPc=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7MFwpFR059196
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Aug 2019 10:58:51 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 22
 Aug 2019 10:58:51 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 22 Aug 2019 10:58:51 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7MFwp3Z094706;
        Thu, 22 Aug 2019 10:58:51 -0500
Subject: Re: [PATCH v12 3/5] dt-bindings: can: tcan4x5x: Add DT bindings for
 TCAN4x5X driver
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <wg@grandegger.com>,
        <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-3-dmurphy@ti.com>
 <bdf06ead-a2e8-09a9-8cdd-49b54ec9da72@pengutronix.de>
 <ff9e007b-6e39-3d64-b62b-93c281d69113@ti.com>
 <6c2bf55f-e360-c51a-e7bb-effc86aa5b6c@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d7c7dba5-9d7a-07c8-a0b9-fe3ca1ddd4c3@ti.com>
Date:   Thu, 22 Aug 2019 10:58:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6c2bf55f-e360-c51a-e7bb-effc86aa5b6c@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 8/22/19 10:46 AM, Marc Kleine-Budde wrote:
> On 8/22/19 4:20 PM, Dan Murphy wrote:
>>>> +tcan4x5x: tcan4x5x@0 {
>>>> +		compatible = "ti,tcan4x5x";
>>>> +		reg = <0>;
>>>> +		#address-cells = <1>;
>>>> +		#size-cells = <1>;
>>>> +		spi-max-frequency = <10000000>;
>>>> +		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
>>>> +		data-ready-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
>>> Can you convert this into a proper interrupt property? E.g.:
>> OK.  Do you want v13 or do you want patches on top for net-next?
> Please use net-next/master as the base.


Thanks for the reply.  I see that that there are patches on top of the 
driver so I will send patches on top of that.

Dan

<snip>
