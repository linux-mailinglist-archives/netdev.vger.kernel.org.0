Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA011B50B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbfLKPvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:51:12 -0500
Received: from mout.web.de ([212.227.15.4]:49279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732606AbfLKPvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 10:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576079456;
        bh=2vt6H9m6gvHEi1nJRDosEC6muzmSbOBdj9rDjM1l1RA=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=lMZl+kIoPaYLEgDwg7FkfY/A94edm93wzNwY31JVJL9mJ59RwugPR7R9LE4vc7Ur8
         iBiKKfHtfa01y0PnOzM6Adn98eyP45gTW9PCpXTAwThOKnWgfVyoaaaHTpk2MOpju4
         TwGciCpeCeN56jPE+/2waJvVQ5JFRtRghbCH5GY4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.138.97]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MHuv7-1ii6fC1BvR-003hlf; Wed, 11
 Dec 2019 16:50:56 +0100
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module
 at sdio0
From:   Soeren Moch <smoch@web.de>
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191209223822.27236-1-smoch@web.de> <6162240.GiEx4hqPFh@diego>
 <d0cece6c-9f90-c691-eb68-a25547532f68@web.de> <3170826.NpdqLUR24W@diego>
 <5d3bde69-9102-cc81-c1d2-d71b60258906@web.de>
Message-ID: <4b98437b-0d6f-6cc3-b601-f273441db93b@web.de>
Date:   Wed, 11 Dec 2019 16:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5d3bde69-9102-cc81-c1d2-d71b60258906@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:dFFyJ6iSHcoJx7Qh+68lCT8QQNP6FUWWUe9MP+9m/blQKF9T574
 tFfixMpTR2sAppfICTHWK6VA7KRK0dGSLSc1xifVMlUdZhJd5Qxw4mFwj/yXnEJO8avbllC
 jV85pQdoktREurcgt5K3JrlP9hif51zLdGDBxcGhc9jOoQjwcq7JpVCqvSh2kS3NKMtdmhQ
 f4684ea+mLx/qar9jeLgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lcTU9Hyg27Q=:kuXpUEu4NzA5u4RnHeC0ZO
 4j2m0tsrdcBVM9I1uILruzVFI+10E/Iu/jicWzIUOgyF+/U1t26o79R/8AzL5SAzX+5wdzFmw
 MzpcDbJfO245gdnM9yDtQ4M2LeCu2uUVhXF1FJtEMpxAc0FoWEel9IOagVQ4CeQISDt8U7VRM
 2yJ3oZ7+NeNak09PDzhTa0jckZqdRCvStr5gxU4La7hp6wGNcQPEl7MKQvCUYDadM8zX7Ogaa
 3DD+YU90cjyjGTtFwB2mVgLhUdrRuu/k2m5TWM6Zy9g0klHEQ4wLK1h8xMrjRL6E63WiDUBaj
 kTRzDeMM4hxKpaKF0ah3wmYM7IG+U/JlqU37TmaeGjQv+Y3hDtaEChVKtvXWdkjE8XIS48uCX
 HyURc3hSU9tSAgoN/oEbFBilnLnxsALgFwpwDRrTcHbkj/fMhDBLwo+6o9IZx8y6BNrDVfRGp
 NllLm5rcjY27dnntUt/K2GsyX3sdEbKkYQ457iKbsI2kj9Yyf1Rn8qLNFruVv7s0++b+gvwIk
 QHai3B+1xLf8Xx9ZFtfhWsOJM3X0/ZZ5Cop57bhKdn4AWW0CmSv+EXCFzMdoBymlygIHq+k6p
 K3Ooc8uB9XeRC0hnk5729MgEk5wXpkZf2JtZtyu9XUk9QSQ2Q9JAKXxtk6VXJshFT0+Df0Ij7
 FQKjomRAGIeOfd1zA8mLa5NU5Y7/ae8XISkDg4Qa1cVpGBBsUjTEe1iCORyqz8QIptfn503jS
 rCb1PyVsgJXeljdetFMOoYDBIvTX78nS6fuNqNSyCBdz7fQeoL7QL6Op6o8uTU23vD/ASRaIA
 2H6jUwxbjd/7kPlGBpq+PUCosK/4awixla60Ttm9RQi2wMvzrs0XSCs0e9st7xIo1a8PicQO1
 Vk96VloQylkSvdTKPkhWlVeGMus1bwDboKYvdoTTCBkgO6GEngCZ/t+SEBWleqo/o1RHqy5gH
 5+X2LyegYkRfbsvPxAHZC3DirVFcsQFHA2Y19iZBpQE2xcFRzU2qA9eoxfKZHcF7vJArNkkwZ
 2VIRyqsW5K8ubsPfdf6YeMD6WnwJQCYLIk9Dx/rzRxNh5wdJ2OT/t6n+CTzdwgNhFCOcEZbTN
 /w4Up/x6QDkCh8cGn0IVxj7uIV0VrJMQo58S7HEuRYi70Hk7gRMaZzvluCX+Eo4dTnACpgvCI
 NsbGEfvfNpEL8zu4tFi1SJBXE1Hy/zAF2707Dq0GHtGbm6h8R40J5mx9Ee77SM7fgVnr0MXg7
 RmBOykj9C4/SHUhg/egzPae+kDqGq7f7hSFiqhePbwcBq3G0zUMv1z5EABXo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

re-send as plain text for mailing lists, sorry.

Soeren

On 11.12.19 16:43, Soeren Moch wrote:
>
>
> On 10.12.19 11:13, Heiko St=C3=BCbner wrote:
>> Am Dienstag, 10. Dezember 2019, 11:08:18 CET schrieb Soeren Moch:
>>> Hi Heiko,
>>>
>>> On 10.12.19 02:18, Heiko St=C3=BCbner wrote:
>>>> Hi Soeren,
>>>>
>>>> Am Dienstag, 10. Dezember 2019, 00:29:21 CET schrieb Soeren Moch:
>>>>> On 10.12.19 00:08, Heiko St=C3=BCbner wrote:
>>>>>> Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
>>>>>>> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
>>>>>>> The BCM4359/9 wifi controller in this module is connected to sdio0=
,
>>>>>>> enable this interface.
>>>>>>>
>>>>>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>>>>>> ---
>>>>>>> Not sure where to place exactly the sdio0 node in the dts because
>>>>>>> existing sd nodes are not sorted alphabetically.
>>>>>>>
>>>>>>> This last patch in this brcmfmac patch series probably should be p=
icked
>>>>>>> up by Heiko independently of the rest of this series. It was sent =
together
>>>>>>> to show how this brcmfmac extension for 4359-sdio support with RSD=
B is
>>>>>>> used and tested.
>>>>>> node placement looks good so I can apply it, just a general questio=
ns
>>>>>> I only got patch 8/8 are patches 1-7 relevant for this one and what=
 are they?
>>>>> Patches 1-7 are the patches to support the BCM4359 chipset with SDIO
>>>>> interface in the linux brcmfmac net-wireless driver, see [1].
>>>>>
>>>>> So this patch series has 2 parts:
>>>>> patches 1-7: add support for the wifi chipset in the wireless driver=
,
>>>>> this has to go through net-wireless
>>>>> patch 8: enable the wifi module with this chipset on RockPro64, this=
 patch
>>>> Thanks for the clarification :-) .
>>>>
>>>> As patch 8 "only" does the core sdio node, it doesn't really depend o=
n the
>>>> earlier ones and you can submit any uart-hooks for bluetooth once the
>>>> other patches land I guess.
>>> The uart part for bluetooth already is in: uart0.
>>> However, I haven't tested if it really works.
>> In the new world there is now also a way to actually hook the bt-uart t=
o
>> the wifi driver without userspace intervention, and you might want to h=
ook
>> up the interrupt as well for sdio?
>>  For example look at the rock960:
> Thanks for the examples.
>> sdio-interrupt: https://git.kernel.org/pub/scm/linux/kernel/git/torvald=
s/linux.git/tree/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi#n510
> The signal name wifi_host_wake_l suggests that this is an active-low
> wake-up signal, probably used for wake-on-wifi. But in fact this is
> the active-high out-of-band sdio interrupt and can also be used as
> such on RockPro64 when following your example.
> However, with this external interrupt enabled=C2=A0 wifi runs unstable,
> maybe because board designers (probably confused by their own naming
> style) mixed in the PCI-Express-WAKE# signal to route this to the same
> GPIO.
>
> So I want to use the in-band sdio interrupt instead on RockPro64,
> which works perfectly fine.
> ||||
>> uart-magic: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/li=
nux.git/tree/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi#n557
> OK, people probably like to see Bluetooth support. I will add it.
>
> Soeren
>> Heiko
>>
>>>>> If this was confusing, what would be the ideal way to post such seri=
es?
>>>> I think every maintainer has some slightly different perspective on t=
his,
>>>> but personally I like getting the whole series to follow the discussi=
on but
>>>> also to just see when the driver-side changes get merged, as the dts-=
parts
>>>> need to wait for that in a lot of cases.
>>> OK, thanks.
>>> I will add you for the whole series when sending a v2.
>>>
>>> Soeren
>>>> Heiko
>>>>
>>>>
>>>>> [1] https://patchwork.kernel.org/project/linux-wireless/list/?series=
=3D213951
>>>>>> Thanks
>>>>>> Heiko
>>>>>>
>>>>>>
>>>>>>> Cc: Heiko Stuebner <heiko@sntech.de>
>>>>>>> Cc: Kalle Valo <kvalo@codeaurora.org>
>>>>>>> Cc: linux-wireless@vger.kernel.org
>>>>>>> Cc: brcm80211-dev-list.pdl@broadcom.com
>>>>>>> Cc: brcm80211-dev-list@cypress.com
>>>>>>> Cc: netdev@vger.kernel.org
>>>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>>>> Cc: linux-rockchip@lists.infradead.org
>>>>>>> Cc: linux-kernel@vger.kernel.org
>>>>>>> ---
>>>>>>>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 21 ++++++++++++--=
-----
>>>>>>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/a=
rch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>>>>> index 7f4b2eba31d4..9fa92790d6e0 100644
>>>>>>> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>>>>> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>>>>> @@ -71,13 +71,6 @@
>>>>>>>  		clock-names =3D "ext_clock";
>>>>>>>  		pinctrl-names =3D "default";
>>>>>>>  		pinctrl-0 =3D <&wifi_enable_h>;
>>>>>>> -
>>>>>>> -		/*
>>>>>>> -		 * On the module itself this is one of these (depending
>>>>>>> -		 * on the actual card populated):
>>>>>>> -		 * - SDIO_RESET_L_WL_REG_ON
>>>>>>> -		 * - PDN (power down when low)
>>>>>>> -		 */
>>>>>>>  		reset-gpios =3D <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
>>>>>>>  	};
>>>>>>>
>>>>>>> @@ -650,6 +643,20 @@
>>>>>>>  	status =3D "okay";
>>>>>>>  };
>>>>>>>
>>>>>>> +&sdio0 {
>>>>>>> +	bus-width =3D <4>;
>>>>>>> +	cap-sd-highspeed;
>>>>>>> +	cap-sdio-irq;
>>>>>>> +	disable-wp;
>>>>>>> +	keep-power-in-suspend;
>>>>>>> +	mmc-pwrseq =3D <&sdio_pwrseq>;
>>>>>>> +	non-removable;
>>>>>>> +	pinctrl-names =3D "default";
>>>>>>> +	pinctrl-0 =3D <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
>>>>>>> +	sd-uhs-sdr104;
>>>>>>> +	status =3D "okay";
>>>>>>> +};
>>>>>>> +
>>>>>>>  &sdmmc {
>>>>>>>  	bus-width =3D <4>;
>>>>>>>  	cap-sd-highspeed;
>>>>>>> --
>>>>>>> 2.17.1
>>>>>>>
>>
>

