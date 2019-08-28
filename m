Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3CA083C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfH1ROy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:14:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40174 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1ROy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 13:14:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so206684pfn.7;
        Wed, 28 Aug 2019 10:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nmX1iH5t+qGsoVau1cVSSS+oy8ShDNckWp+WcaFenT0=;
        b=Vnvh0Xj/ASJi51jsUph9xt++YDQHzJfdlYwWDRJO+zLKz2zIoxTHkyS2UQ57JpOrIV
         6Zbc2fx1HXukVUIVcS6rzxem/CoWtDoNgj8TfywJYln5ht/lFPcgU/wQ0r8izDgVMHek
         OCQmb6JvRkkOzq+kzaI1+E3u8nXHIiYkdWqgnocE8AncTaK6ATTZpaBb0oLSVjxqCPtc
         RNnyK66NbV4/Zdo3hDx5CIcP0SkM8Zti5lb6Bgshoi2cuVYSLvno/FdC1+jELybgJP7N
         c1BcbGIwNOYgty0YliB1dJYfb2cC43CUGwuLrzL+U5tYgrYEjdWZeqwyqD/kDoB/JOLq
         uPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nmX1iH5t+qGsoVau1cVSSS+oy8ShDNckWp+WcaFenT0=;
        b=AFAsHrFNLR3LuQR7EOBlMHOnqEwZJbn/0tFTNzkjp05bl4AGtBozaI1cFI4B6ttj/Y
         FKdq6ECPkfPxSAg5YznNcT0uZlpKuYDBuVZar2WdhXb45vtCIKSJmQ0nSK+RoU7QrQ+x
         QUOQPc3WhktMmNoIS1JGbvHAGDsFO0eZDyxG1AC15csdh++H8zQ58dVKb7K9RvArHd9d
         KhDMd3xWIhxA/VmknAhSpnZa4O06huFEJo9x03zabMEOoRwY59IEYZPaYuCkU4AF8jD9
         sOvEk60wQrscMMYc8Uw5lsEESFAi5gLzOLfs9OaOB82xI+q0Ih38q+e6SgiNRyGwCnnG
         0ybA==
X-Gm-Message-State: APjAAAWvFBPVYN3sYHbRVx5EPt5lgIdugzDZwNSCozoZErJ7vde15kY0
        HIc2/Hh7JMIkioTx5Y75w7g=
X-Google-Smtp-Source: APXvYqxY9SmeZYt0VS3ln3DwcM6OqEMQCVzdKMxwJOhUrn8iumNim1xjpg+hYQShXyUJp18QUomh1w==
X-Received: by 2002:aa7:9a12:: with SMTP id w18mr6211496pfj.110.1567012493608;
        Wed, 28 Aug 2019 10:14:53 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l123sm7132314pfl.9.2019.08.28.10.14.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 10:14:52 -0700 (PDT)
Subject: Re: [PATCH v1 net-next] net: stmmac: Add support for MDIO interrupts
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
References: <1566870320-9825-1-git-send-email-weifeng.voon@intel.com>
 <20190826184719.GF2168@lunn.ch>
 <cac5aba0-b47b-00c6-f99b-64c6b385308a@gmail.com>
 <D6759987A7968C4889FDA6FA91D5CBC814759747@PGSMSX103.gar.corp.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 mQGiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz7QnRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+iGYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSC5BA0ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU4hPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJ7kCDQRXG8fwARAA6q/pqBi5PjHcOAUgk2/2LR5LjjesK50bCaD4JuNc
 YDhFR7Vs108diBtsho3w8WRd9viOqDrhLJTroVckkk74OY8r+3t1E0Dd4wHWHQZsAeUvOwDM
 PQMqTUBFuMi6ydzTZpFA2wBR9x6ofl8Ax+zaGBcFrRlQnhsuXLnM1uuvS39+pmzIjasZBP2H
 UPk5ifigXcpelKmj6iskP3c8QN6x6GjUSmYx+xUfs/GNVSU1XOZn61wgPDbgINJd/THGdqiO
 iJxCLuTMqlSsmh1+E1dSdfYkCb93R/0ZHvMKWlAx7MnaFgBfsG8FqNtZu3PCLfizyVYYjXbV
 WO1A23riZKqwrSJAATo5iTS65BuYxrFsFNPrf7TitM8E76BEBZk0OZBvZxMuOs6Z1qI8YKVK
 UrHVGFq3NbuPWCdRul9SX3VfOunr9Gv0GABnJ0ET+K7nspax0xqq7zgnM71QEaiaH17IFYGS
 sG34V7Wo3vyQzsk7qLf9Ajno0DhJ+VX43g8+AjxOMNVrGCt9RNXSBVpyv2AMTlWCdJ5KI6V4
 KEzWM4HJm7QlNKE6RPoBxJVbSQLPd9St3h7mxLcne4l7NK9eNgNnneT7QZL8fL//s9K8Ns1W
 t60uQNYvbhKDG7+/yLcmJgjF74XkGvxCmTA1rW2bsUriM533nG9gAOUFQjURkwI8jvMAEQEA
 AYkCaAQYEQIACQUCVxvH8AIbAgIpCRBhV5kVtWN2DsFdIAQZAQIABgUCVxvH8AAKCRCH0Jac
 RAcHBIkHD/9nmfog7X2ZXMzL9ktT++7x+W/QBrSTCTmq8PK+69+INN1ZDOrY8uz6htfTLV9+
 e2W6G8/7zIvODuHk7r+yQ585XbplgP0V5Xc8iBHdBgXbqnY5zBrcH+Q/oQ2STalEvaGHqNoD
 UGyLQ/fiKoLZTPMur57Fy1c9rTuKiSdMgnT0FPfWVDfpR2Ds0gpqWePlRuRGOoCln5GnREA/
 2MW2rWf+CO9kbIR+66j8b4RUJqIK3dWn9xbENh/aqxfonGTCZQ2zC4sLd25DQA4w1itPo+f5
 V/SQxuhnlQkTOCdJ7b/mby/pNRz1lsLkjnXueLILj7gNjwTabZXYtL16z24qkDTI1x3g98R/
 xunb3/fQwR8FY5/zRvXJq5us/nLvIvOmVwZFkwXc+AF+LSIajqQz9XbXeIP/BDjlBNXRZNdo
 dVuSU51ENcMcilPr2EUnqEAqeczsCGpnvRCLfVQeSZr2L9N4svNhhfPOEscYhhpHTh0VPyxI
 pPBNKq+byuYPMyk3nj814NKhImK0O4gTyCK9b+gZAVvQcYAXvSouCnTZeJRrNHJFTgTgu6E0
 caxTGgc5zzQHeX67eMzrGomG3ZnIxmd1sAbgvJUDaD2GrYlulfwGWwWyTNbWRvMighVdPkSF
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9Za0Dx0yyp44iD1OvHtkEI
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <a5ca1ddf-76ff-a9d9-681c-dea56a318e70@gmail.com>
Date:   Wed, 28 Aug 2019 10:14:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC814759747@PGSMSX103.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/19 10:07 AM, Voon, Weifeng wrote:
>>>> DW EQoS v5.xx controllers added capability for interrupt generation
>>>> when MDIO interface is done (GMII Busy bit is cleared).
>>>> This patch adds support for this interrupt on supported HW to avoid
>>>> polling on GMII Busy bit.
>>>>
>>>> stmmac_mdio_read() & stmmac_mdio_write() will sleep until wake_up()
>>>> is called by the interrupt handler.
>>>
>>> Hi Voon
>>>
>>> I _think_ there are some order of operation issues here. The mdiobus
>>> is registered in the probe function. As soon as of_mdiobus_register()
>>> is called, the MDIO bus must work. At that point MDIO read/writes can
>>> start to happen.
>>>
>>> As far as i can see, the interrupt handler is only requested in
>>> stmmac_open(). So it seems like any MDIO operations after probe, but
>>> before open are going to fail?
>>
>> AFAIR, wait_event_timeout() will continue to busy loop and wait until
>> the timeout, but not return an error because the polled condition was
>> true, at least that is my recollection from having the same issue with
>> the bcmgenet driver before it was moved to connecting to the PHY in the
>> ndo_open() function.
>> --
>> Florian
> 
> Florian is right as the poll condition is still true after the timeout. 
> Hence, any mdio operation after probe and before ndo_open will still work.
> The only cons here is that attaching the PHY will takes a full length of 
> timeout time for each mdio_read and mdio_write. 
> So we should attach the phy only after the interrupt handler is requested?

From a power management/resource utilization perspective, it is better
to initialize as close as possible from the time where you are actually
going to use the hardware, therefore ndo_open().

This may not be convenient or possible given how widely use stmmac is,
and I do not know if parts of the Ethernet MAC require the PHY to supply
the clock, in which case, you may have some chicke and egg conditions if
the design does not allow for MDIO to work independently from the data
plane. Also, I would be worried about introducing bugs.

You could do a couple of things:

- continue to probe the device with interrupts disabled and add a
condition around the call to wait_event_timeout() to do a busy-loop
without going to the maximum defined timeout, if the interrupt line is
requested, use wait_event_timeout()

- request the interrupt during the probe function, but only
unmask/enable the MDIO interrupts for the probe to succeed and leave the
data path interrupts for a later enabling during ndo_open()
-- 
Florian
