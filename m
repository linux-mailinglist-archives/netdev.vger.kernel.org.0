Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B53484B24
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 00:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiADXXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 18:23:10 -0500
Received: from 6.mo560.mail-out.ovh.net ([87.98.165.38]:41957 "EHLO
        6.mo560.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiADXXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 18:23:07 -0500
X-Greylist: delayed 8817 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2022 18:23:07 EST
Received: from player728.ha.ovh.net (unknown [10.109.143.208])
        by mo560.mail-out.ovh.net (Postfix) with ESMTP id 38A992436B
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 20:56:09 +0000 (UTC)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id D340D25E4B2BB;
        Tue,  4 Jan 2022 20:56:02 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-98R0026380bf79-739d-4914-9f9d-9982a54db208,
                    711BEDA5BDA1217D757D3668A2C77AE5119AF47D) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Message-ID: <0463d60e-b58e-84cc-df5e-d5030e8fdc1d@milecki.pl>
Date:   Tue, 4 Jan 2022 21:56:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rob Herring <robh@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20211223110755.22722-1-zajec5@gmail.com>
 <20211223110755.22722-4-zajec5@gmail.com>
 <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
 <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
 <YdSrG3EGDHMmhm1Y@robh.at.kernel.org>
 <49a2b78e-67a8-2e5c-f0c4-542851eabbf2@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
In-Reply-To: <49a2b78e-67a8-2e5c-f0c4-542851eabbf2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12999921799475342199
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudeffedgudegfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeftrghfrghlucfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeejteeludegjedtveehteeiudehgfetvdegffdtvdefvdeiveejgeelffelgedtueenucfkpheptddrtddrtddrtddpudelgedrudekjedrjeegrddvfeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrhejvdekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprhgrfhgrlhesmhhilhgvtghkihdrphhlpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4.01.2022 21:50, Rafał Miłecki wrote:
> On 4.01.2022 21:16, Rob Herring wrote:
>> On Thu, Dec 23, 2021 at 10:58:56PM +0100, Rafał Miłecki wrote:
>>> On 23.12.2021 22:18, Rob Herring wrote:
>>>> On Thu, Dec 23, 2021 at 7:08 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>>>>
>>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>>
>>>>> Not every NVMEM has predefined cells at hardcoded addresses. Some
>>>>> devices store cells in internal structs and custom formats. Referencing
>>>>> such cells is still required to let other bindings use them.
>>>>>
>>>>> Modify binding to require "reg" xor "label". The later one can be used
>>>>> to match "dynamic" NVMEM cells by their names.
>>>>
>>>> 'label' is supposed to correspond to a sticker on a port or something
>>>> human identifiable. It generally should be something optional to
>>>> making the OS functional. Yes, there are already some abuses of that,
>>>> but this case is too far for me.
>>>
>>> Good to learn that!
>>>
>>> "name" is special & not allowed I think.
>>
>> It's the node name essentially. Why is using node names not sufficient?
>> Do you have some specific examples?
> 
> I tried to explain in
> [PATCH 1/5] dt-bindings: nvmem: add "label" property to allow more flexible cells names
> that some vendors come with fancy names that can't fit node names.
> 
> Broadcom's NVRAM examples:
> 0:macaddr
> 1:macaddr
> 2:macaddr
> 0:ccode
> 1:ccode
> 2:ccode
> 0:regrev

In other words I'd like to have something like:

nvram@1eff0000 {
	compatible = "brcm,nvram";
	reg = <0x1eff0000 0x10000>;

	mac: cell-0 {
		label = "1:macaddr";
	};
};

ethernet@1000 {
	compatible = "brcm,ethernet";
	reg = <0x1000 0x1000>;
	nvmem-cells = <&mac>;
	nvmem-cell-names = "mac-address";
};
