Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E2FEAE07
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfJaK6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:58:21 -0400
Received: from forward101o.mail.yandex.net ([37.140.190.181]:51347 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfJaK6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:58:21 -0400
Received: from mxback27j.mail.yandex.net (mxback27j.mail.yandex.net [IPv6:2a02:6b8:0:1619::227])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id CEB973C01509;
        Thu, 31 Oct 2019 13:58:15 +0300 (MSK)
Received: from iva6-6f4302ae52e5.qloud-c.yandex.net (iva6-6f4302ae52e5.qloud-c.yandex.net [2a02:6b8:c0c:9a82:0:640:6f43:2ae])
        by mxback27j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id MqTxeuNTtt-wEaiEtox;
        Thu, 31 Oct 2019 13:58:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572519495;
        bh=CnUEsomcZToujM6zlvvqh/M/VDXtZjPQrvhlDicaFhA=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=I6y0jQZyDWddPsb6XQzTUD9AGwNj+wzirysDdK6n3vAKco0tvXiWJXopQFW6Hul2i
         mW3dDcFOxIOpv3/qQonhhobhPY9809zVHbCFJkYa8zuWuLcRz+phBikZ6JcovA3iv4
         p92mVe+TLRskv3vPizha5J+XQWdjNhWgSw2CViMo=
Authentication-Results: mxback27j.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by iva6-6f4302ae52e5.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id apLSeE0B5F-vTVigpuo;
        Thu, 31 Oct 2019 13:58:13 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 4/5] dt-bindings: net: document loongson.pci-gmac
To:     Simon Horman <simon.horman@netronome.com>
Cc:     linux-mips@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, axboe@kernel.dk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
 <20191030135347.3636-5-jiaxun.yang@flygoat.com>
 <20191031083509.GA30739@netronome.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <a93eedb9-8863-3802-a563-fe4955d846c3@flygoat.com>
Date:   Thu, 31 Oct 2019 18:57:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031083509.GA30739@netronome.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2019/10/31 ÏÂÎç4:35, Simon Horman Ð´µÀ:
> Hi Jiaxun,
>
> thanks for your patch.
>
> On Wed, Oct 30, 2019 at 09:53:46PM +0800, Jiaxun Yang wrote:
>> This binding will provide extra information for PCI enabled
>> device.
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Please verify the bindings using dtbs_check as described in
> Documentation/devicetree/writing-schema.rst
>
>> ---
>>   .../net/wireless/loongson,pci-gmac.yaml       | 71 +++++++++++++++++++
>>   1 file changed, 71 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
>> new file mode 100644
>> index 000000000000..5f764bd46735
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
>> @@ -0,0 +1,71 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/allwinner,sun7i-a20-gmac.yaml#
> The id does not match the filename of the schema.
>
> i.e. the above should be:
>
> 	$id: http://devicetree.org/schemas/net/wireless/loongson,pci-gmac.yaml#
>
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Loongson PCI GMAC Device Tree Bindings
>> +
>> +allOf:
>> +  - $ref: "snps,dwmac.yaml#"
> snps,dwmac.yaml# is in the parent directory relative to loongson,pci-gmac.yaml.
> So I think the above needs to be:
>
> 	$ref: "../snps,dwmac.yaml#"
>
>> +
>> +maintainers:
>> +  - Jiaxun Yang <jiaxun.yang@flygoat.com>
>> +
>> +properties:
>> +  compatible:
>> +    const: loongson,pci-gmac
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  interrupts:
>> +    minItems: 1
>> +    maxItems: 3
>> +    items:
>> +      - description: Combined signal for various interrupt events
>> +      - description: The interrupt to manage the remote wake-up packet detection
>> +      - description: The interrupt that occurs when Rx exits the LPI state
>> +
>> +  interrupt-names:
>> +    minItems: 1
>> +    maxItems: 3
>> +    items:
>> +      - const: macirq
>> +      - const: eth_wake_irq
>> +      - const: eth_lpi
>> +
>> +  clocks:
>> +    items:
>> +      - description: GMAC main clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: stmmaceth
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - interrupts
>> +  - interrupt-names
>> +  - clocks
>> +  - clock-names
>> +  - phy-mode
>> +
>> +examples:
>> +  - |
>> +    gmac: ethernet@ {
> I would have expected a bus address here, f.e.:
>
> 	gmac: ethernet@0x00001800
>
>> +        compatible = "loongson,pci-irq";
>> +        reg = <0x00001800 0 0 0 0>;
> I think there is one to many cell in the above, perhaps it should be.
>
> 	reg = <0x00001800 0 0 0>;
>
> Also, I would expect the registers to be wider than 0, i.e. no registers.

Hi Simon,

Thanks for your suggestions above, will fix in v1.

Here, the reg domain is a standard 5-cell representing a PCI device,

See: Documentation/devicetree/bindings/pci/pci.txt and IEEE Std 
1275-1994,<https://github.com/torvalds/linux/blob/master/Documentation/devicetree/bindings/pci/pci.txt>

Should I add some description?

Jiaxun

