Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBACB6D3E62
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 09:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjDCHs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDCHsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 03:48:55 -0400
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0411644AE;
        Mon,  3 Apr 2023 00:48:53 -0700 (PDT)
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3336VYA2031952;
        Mon, 3 Apr 2023 09:48:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=lbrDY8Ppljv7KIzDAhEp83EYJqZkiErv5p1W4oG7g5k=;
 b=PM/TjdUTTRv7HcYJYnvyYOweQIo3jLh3k9NJFkAB/TU53eldc3KtqlJn2GA/vcU9x4Hr
 lFX2bQ64LeKl8TT0frZPCFoMUgYmp3uaEDwqkL6JDbP9IGaMONiQbZe5kmvZ9/KdXzNG
 oZfzCJ69+8DyX5+wrFBNb+/ehOkzUqrf2DidTOTGFW4qsk4ZBp8WcMTYBUFwE2eHam3/
 DAen+x9N5TUv2ncdxTG+aCjfzpFRwtvV5fkiabI9EpKDCRizZv9rwfDkIsgfLDpERtgz
 d7oplG72nWe8hzUy12lFw7Ctz1PKmj8ZrNqVnz7nWgHi30CVRLAryy63/4E9aQjkPMhG jw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3ppbgm11ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 09:48:29 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 3109010002A;
        Mon,  3 Apr 2023 09:48:28 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2AD5B2122F3;
        Mon,  3 Apr 2023 09:48:28 +0200 (CEST)
Received: from [10.201.21.93] (10.201.21.93) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Mon, 3 Apr
 2023 09:48:27 +0200
Message-ID: <509b45f9-b6f1-d6a1-c76f-1047efc2334c@foss.st.com>
Date:   Mon, 3 Apr 2023 09:48:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1] ARM: dts: stm32: prtt1c: Add PoDL PSE regulator nodes
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230323123242.3763673-1-o.rempel@pengutronix.de>
 <1a2d16c8-8c16-5fcc-7906-7b454a81922f@foss.st.com>
 <20230328110247.GE15196@pengutronix.de>
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
In-Reply-To: <20230328110247.GE15196@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.21.93]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_04,2023-03-31_01,2023-02-09_01
X-Spam-Status: No, score=-3.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

On 3/28/23 13:02, Oleksij Rempel wrote:
> On Tue, Mar 28, 2023 at 11:58:34AM +0200, Alexandre TORGUE wrote:
>> Hi Oleksij
>>
>> On 3/23/23 13:32, Oleksij Rempel wrote:
>>> This commit introduces Power over Data Line (PoDL) Power Source
>>> Equipment (PSE) regulator nodes to the PRTT1C devicetree. The addition
>>> of these nodes enables support for PoDL in PRTT1C devices, allowing
>>> power delivery and data transmission over a single twisted pair.
>>>
>>> The new PoDL PSE regulator nodes provide voltage capability information
>>> of the current board design, which can be used as a hint for system
>>> administrators when configuring and managing power settings. This
>>> update enhances the versatility and simplifies the power management of
>>> PRTT1C devices while ensuring compatibility with connected Powered
>>> Devices (PDs).
>>>
>>> After applying this patch, the power delivery can be controlled from
>>> user space with a patched [1] ethtool version using the following commands:
>>>     ethtool --set-pse t1l2 podl-pse-admin-control enable
>>> to enable power delivery, and
>>>     ethtool --show-pse t1l2
>>> to display the PoDL PSE settings.
>>>
>>> By integrating PoDL PSE support into the PRTT1C devicetree, users can
>>> benefit from streamlined power and data connections in their
>>> deployments, improving overall system efficiency and reducing cabling
>>> complexity.
>>>
>>> [1] https://lore.kernel.org/all/20230317093024.1051999-1-o.rempel@pengutronix.de/
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>
>> Please, fix the introduction of those new yaml validation errors:
>>
>> arch/arm/boot/dts/stm32mp151a-prtt1c.dtb: ethernet-pse-1: $nodename:0:
>> 'ethernet-pse-1' does not match '^ethernet-pse(@.*)?$'
>>          From schema:
>> /Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
>> arch/arm/boot/dts/stm32mp151a-prtt1c.dtb: ethernet-pse-2: $nodename:0:
>> 'ethernet-pse-2' does not match '^ethernet-pse(@.*)?$'
>>          From schema: /local/home/frq08678/STLINUX/kernel/my-kernel/stm32/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
> 
> Using ethernet-pse@1 will require to use "reg" or "ranges" properties.
> Which makes no sense in this use case. I need to fix the schema instead by
> allowing this patter with following regex: "^ethernet-pse(@.*|-[0-9a-f])*$"
> 
> Should I send schema fix together with this patch?

Yes you can. As soon as Rob or Krzysztof review it I'll apply both on 
stm32-next.

Thanks
Alex




> Regards,
> Oleksij

