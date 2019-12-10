Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824BC11846B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLJKIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:08:43 -0500
Received: from mout.web.de ([212.227.15.14]:51487 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfLJKIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575972508;
        bh=IycienwQrmPkO1OUxpnyPUgsVdH+CUBjnZCexiMG1YQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CgMpGP3xMQ+A6rxCLaMPLGF9K1c2AecBz/+hplnfOVyRivesQURCDqvH9/kJoxFQ9
         yhy1q4RUmkRFDXVSUIANPfai+gXUjoa6JEHkUdNWb0umJquJHkHcgOvK+HKjb/hu90
         taFXnFzdSrzf/UVxJNA/TayF3SYmVOzgrGH4Uj6g=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.137.56]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lc8aj-1hvLXa3XXx-00jZIF; Tue, 10
 Dec 2019 11:08:28 +0100
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module
 at sdio0
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191209223822.27236-1-smoch@web.de> <2668270.pdtvSLGib8@diego>
 <2cf70216-8d98-4122-4f4e-b8254089a017@web.de> <6162240.GiEx4hqPFh@diego>
From:   Soeren Moch <smoch@web.de>
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d0cece6c-9f90-c691-eb68-a25547532f68@web.de>
Date:   Tue, 10 Dec 2019 11:08:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <6162240.GiEx4hqPFh@diego>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:Z14Ja1Y13gnxlqi++A4VBiki+KiverqxuAZzPiSZydJ2ywbLfKT
 koOklF7ILxLQf8X4Fk+GFmvOjlSO75eER9uV9wqiLcuyD36oHq2huSRA1FiTM/ed4pix1ab
 AQOPPHiUDus2JzW2BZf5ain4KKwa+V/03+Ye/wKnwUmQaRUVrA46IphBre6TFgbgPGNFbLb
 oZH3gD+Om7xJBMFtBYEEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CCHovLydRME=:ECR4u5HgnossIWY9Q1uC6A
 w5IrLst3RvrKNh/u++Z65H04h0uySCFB3D555kzygpm/0uOyoCvliD1lby+ZC3q2E+b56v+v3
 TqHX/ORfN2mXWhl9a+2+ntJ8pSQ5HRZn3LKw37aEAA72Kj01aqdUi2EcjmBXsCgiEtbubdgUR
 Ghgtdq9XCP9YJNWD0QWIX4e9QaRsSBVD71tzlolkOQ59KEt4omiquEN3JGULq+XwYzGodugqj
 nZ2AkfGRBH2HgSq+eoujWx389k+wflv5gkxf6mlS7hrcQ4XEpSkUVkUDbSI2NVkYYRXAh41M6
 4u05V2SLSX45eQyiIsOvYeikm0hNYNhgOTEkkTb4s7yVu4/5BCbzJPzZeTqRqrOH6vSGEu4CW
 kwhvNYKm6i9ykYN4QV342RKUFYwZbHfe8wujYKXzzs9ysMJdzmigLEITlwz7p+nEtsftYnvPt
 auc+AoHnU88UUKkPCYHaEsokIFXqhC7xG6uE6bWRGkZksI813+N5277tfDfchl8p9kWywBunO
 wrETqZJcZP2oKww2EM+V1uMjsNiEBLfd/ff+8Gt/m4xEdwDx1cYT7rppj5dyWvupyWAna4/dt
 HLY8IXabz8/2Ufaz4+OwYsfsKNHB1GQRjZ8Tl7FQHcLaHg7IbsclfrcvVkIURyY8qQxnngo8l
 wbm3Aaq5ym6jVxG/WpIyr+9iSQgulbRCoAujaNKEsgugQIJuJMdjtgLt/h9sYi6Pzv12qkjqY
 FKe+gKJ9S3fUMuYpIXYKQVCIdOJpfb0fbfB9tcCJsgogm5ZEqBXliC4zYdKPUX7uqotMe361n
 TyCk6/S4A+IXwWSm4Z1sdKSFQo5pLms14I18MT8gw3KWrlFHUYMC1jGaFp6hUQqpvQLvwBQk8
 CqKlGlPnrbDGifahPPYw5srVtyPWvAgeaxfdkwnnnY1JethE/io4mxN20hTkN/n53iifMMIHi
 vIzYD5PVolNKO6x/c4sXwB7EBriQ+1Stokza7JbjaqvhdasJW/zq52nDXb4FVDhAM06eJXqJm
 dI/gnYM/gT1jMtmFGBMcgZqJiYKsHZ0ScwFLXIEGQN/3twakwvW5f2zgEgfPeuRkS7R2OyMZb
 qOtSxNDw3eSUbTRUfH1hqP6X7mzCh9ul6gmfL6inJk2Z0x5885nYXu/LQfg3WlBvbI8/bz0Gx
 sz9khoHXv3R/9B9myISAwzouNbsMCmWh/CXb3IJxrQvzelIQfzHMbDAkjcMOO9n2rTXtNMLeW
 dYhT/9dP6+KPUw+lju/TLd1kbwW0NypUYXbC43A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

On 10.12.19 02:18, Heiko St=C3=BCbner wrote:
> Hi Soeren,
>
> Am Dienstag, 10. Dezember 2019, 00:29:21 CET schrieb Soeren Moch:
>> On 10.12.19 00:08, Heiko St=C3=BCbner wrote:
>>> Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
>>>> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
>>>> The BCM4359/9 wifi controller in this module is connected to sdio0,
>>>> enable this interface.
>>>>
>>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>>> ---
>>>> Not sure where to place exactly the sdio0 node in the dts because
>>>> existing sd nodes are not sorted alphabetically.
>>>>
>>>> This last patch in this brcmfmac patch series probably should be pic=
ked
>>>> up by Heiko independently of the rest of this series. It was sent to=
gether
>>>> to show how this brcmfmac extension for 4359-sdio support with RSDB =
is
>>>> used and tested.
>>> node placement looks good so I can apply it, just a general questions=

>>> I only got patch 8/8 are patches 1-7 relevant for this one and what a=
re they?
>> Patches 1-7 are the patches to support the BCM4359 chipset with SDIO
>> interface in the linux brcmfmac net-wireless driver, see [1].
>>
>> So this patch series has 2 parts:
>> patches 1-7: add support for the wifi chipset in the wireless driver,
>> this has to go through net-wireless
>> patch 8: enable the wifi module with this chipset on RockPro64, this p=
atch
> Thanks for the clarification :-) .
>
> As patch 8 "only" does the core sdio node, it doesn't really depend on =
the
> earlier ones and you can submit any uart-hooks for bluetooth once the
> other patches land I guess.
The uart part for bluetooth already is in: uart0.
However, I haven't tested if it really works.
>> If this was confusing, what would be the ideal way to post such series=
?
> I think every maintainer has some slightly different perspective on thi=
s,
> but personally I like getting the whole series to follow the discussion=
 but
> also to just see when the driver-side changes get merged, as the dts-pa=
rts
> need to wait for that in a lot of cases.
OK, thanks.
I will add you for the whole series when sending a v2.

Soeren
>
> Heiko
>
>
>> [1] https://patchwork.kernel.org/project/linux-wireless/list/?series=3D=
213951
>>> Thanks
>>> Heiko
>>>
>>>
>>>> Cc: Heiko Stuebner <heiko@sntech.de>
>>>> Cc: Kalle Valo <kvalo@codeaurora.org>
>>>> Cc: linux-wireless@vger.kernel.org
>>>> Cc: brcm80211-dev-list.pdl@broadcom.com
>>>> Cc: brcm80211-dev-list@cypress.com
>>>> Cc: netdev@vger.kernel.org
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-rockchip@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 21 ++++++++++++----=
---
>>>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arc=
h/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>> index 7f4b2eba31d4..9fa92790d6e0 100644
>>>> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>>>> @@ -71,13 +71,6 @@
>>>>  		clock-names =3D "ext_clock";
>>>>  		pinctrl-names =3D "default";
>>>>  		pinctrl-0 =3D <&wifi_enable_h>;
>>>> -
>>>> -		/*
>>>> -		 * On the module itself this is one of these (depending
>>>> -		 * on the actual card populated):
>>>> -		 * - SDIO_RESET_L_WL_REG_ON
>>>> -		 * - PDN (power down when low)
>>>> -		 */
>>>>  		reset-gpios =3D <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
>>>>  	};
>>>>
>>>> @@ -650,6 +643,20 @@
>>>>  	status =3D "okay";
>>>>  };
>>>>
>>>> +&sdio0 {
>>>> +	bus-width =3D <4>;
>>>> +	cap-sd-highspeed;
>>>> +	cap-sdio-irq;
>>>> +	disable-wp;
>>>> +	keep-power-in-suspend;
>>>> +	mmc-pwrseq =3D <&sdio_pwrseq>;
>>>> +	non-removable;
>>>> +	pinctrl-names =3D "default";
>>>> +	pinctrl-0 =3D <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
>>>> +	sd-uhs-sdr104;
>>>> +	status =3D "okay";
>>>> +};
>>>> +
>>>>  &sdmmc {
>>>>  	bus-width =3D <4>;
>>>>  	cap-sd-highspeed;
>>>> --
>>>> 2.17.1
>>>>
>>>
>>>
>>
>
>
>


