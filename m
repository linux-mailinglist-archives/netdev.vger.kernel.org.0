Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683F216766F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbgBUIeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:34:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55425 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732195AbgBUIJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:09:44 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1j53NH-0003OX-CY; Fri, 21 Feb 2020 09:09:27 +0100
Received: from [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad] (unknown [IPv6:2a03:f580:87bc:d400:6ccf:3365:1a9c:55ad])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C89614BCCA9;
        Fri, 21 Feb 2020 08:09:24 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] can: m_can: m_can_platform: Add support for
 enabling transceiver
To:     Faiz Abbas <faiz_abbas@ti.com>, Dan Murphy <dmurphy@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Cc:     broonie@kernel.org, lgirdwood@gmail.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org, wg@grandegger.com,
        sriram.dash@samsung.com
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-3-faiz_abbas@ti.com>
 <250f905a-33c3-dd17-15c9-e282299dd742@ti.com>
 <8885c00b-7b73-0448-7e9d-ecb19fe84adf@ti.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXz
Message-ID: <8a001afe-dc97-fa1e-4e80-20da89eb2105@pengutronix.de>
Date:   Fri, 21 Feb 2020 09:09:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8885c00b-7b73-0448-7e9d-ecb19fe84adf@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 8:54 AM, Faiz Abbas wrote:
> Hi Dan,
> 
> On 17/02/20 8:40 pm, Dan Murphy wrote:
>> Faiz
>>
>> On 2/17/20 8:28 AM, Faiz Abbas wrote:
>>> CAN transceivers on some boards have a standby line which can be
>>> toggled to enable/disable the transceiver. Model this as an optional
>>> fixed xceiver regulator.
>>>
>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>>> Acked-by: Sriram Dash <sriram.dash@samsung.com>
>>> ---
>>>   drivers/net/can/m_can/m_can_platform.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/can/m_can/m_can_platform.c
>>> b/drivers/net/can/m_can/m_can_platform.c
>>> index 38ea5e600fb8..719468fab507 100644
>>> --- a/drivers/net/can/m_can/m_can_platform.c
>>> +++ b/drivers/net/can/m_can/m_can_platform.c
>>> @@ -6,6 +6,7 @@
>>>   // Copyright (C) 2018-19 Texas Instruments Incorporated -
>>> http://www.ti.com/
>>>     #include <linux/platform_device.h>
>>> +#include <linux/regulator/consumer.h>
>>>     #include "m_can.h"
>>>   @@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device
>>> *pdev)
>>>   {
>>>       struct m_can_classdev *mcan_class;
>>>       struct m_can_plat_priv *priv;
>>> +    struct regulator *reg_xceiver;
>>>       struct resource *res;
>>>       void __iomem *addr;
>>>       void __iomem *mram_addr;
>>> @@ -111,6 +113,10 @@ static int m_can_plat_probe(struct
>>> platform_device *pdev)
>>>         m_can_init_ram(mcan_class);
>>>   +    reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
>>> +    if (PTR_ERR(reg_xceiver) == -EPROBE_DEFER)
>>> +        return -EPROBE_DEFER;
>>> +
>>
>> Where is this regulator enabled?
> 
> I have set regulator-boot-on flag in the dt so this didn't require an
> enable.

Please don't do this, please handle it properly.

>> Shouldn't the regulator be managed by runtime PM as well?

If so, then make the runtime pm kconfig option mandatory.

Marc

-- 
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
