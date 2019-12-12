Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81811CB3F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfLLKr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:47:29 -0500
Received: from mout.web.de ([212.227.17.12]:58431 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbfLLKr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576147629;
        bh=iU0ev7VoC1TijGDuRwLbBpmGPdY4l6wXakXHGIG0OlE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=XCLwiiEEagsVPHcOL/uDVAZyOVwelM3Mmf+s8rJu111S4kNmasEi4MnhCfyYOhU44
         r57699Z5UhuLNEwD9+MXtCTqyrrym0CJMQruVAKxT2cj+SoFGNviQG2EuoUbqJct1C
         oUEZqZCCIzcGVFA2/PJ9pc6sGMk/YlBmAK94bZfw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.139.166]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M6UxL-1hmGH82HNL-00yUj1; Thu, 12
 Dec 2019 11:47:09 +0100
Subject: Re: [PATCH v2 9/9] arm64: dts: rockchip: RockPro64: hook up bluetooth
 at uart0
To:     Robin Murphy <robin.murphy@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
References: <20191211235253.2539-1-smoch@web.de>
 <20191211235253.2539-10-smoch@web.de>
 <a0ad4723-db85-0eda-efb5-f0c9a2a6aec3@arm.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <b859b9f1-2d89-ddef-df26-724ac4ffb088@web.de>
Date:   Thu, 12 Dec 2019 11:47:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <a0ad4723-db85-0eda-efb5-f0c9a2a6aec3@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:GxvXISq/vQUw0CF4n7qCFX0ucOQQ/WrciDDXrMEuGYWZVSa/9hB
 QAPsZtpo3t9v0XTThIaCt5DvRpmp3fB8lWb//T5QodTKvZBcSVje+4mohTMLZVqN14UT3pS
 7KHQIMGBpf7mjeu1cNFW5zYEmU4IgvkoM+2RAsdoSGfHlZ5dlnc9cwEZ1igGGrszaSoUP4z
 Om2pt6sOQlrqUGzy7+qTA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tJ/tdq6fCbM=:+dw/5RxWG7gW0S7c717i5c
 qC/iLBFbuQhEZZoUY63jeayspCCRnlOuPytTsAlvpqNVatg++A2+MLAvjAG8zF3zBVe+Hhqcl
 YNsC5cTWfmNCsMOcMVdDVSGW46PPg3pW3AR7C850a2BlmmYj07PtIw84iCFGFyREwQ0bc9kFJ
 c3QPlG/1cbtv/7AXiRzHXEiqpMthD24Yst0DkfvB8JAWdEcAbVQnoeDHiuY8PxSyfB3hMCIMy
 otycqOrN5n4Av+3ebRscHZ4WOcPL0X9DZxmnW8B30wUv2ei1DQ7hLAesX8KklGAHtG/aMGyrG
 mDNNt8C2Fk2AI4OO7Yud4vFPf8QWWchLzeTzoIBEj/3Krm2p59MNAgr2RHbRVhJZqb+498iKr
 bZzTR4KbPUpmZ96FQ+zi+8h14ZFetc0ukHrepY3eAGXcYTGTMVVdqEp4clUe28GSuafEeeNW5
 I1HXygTosgqvCX64VTQzRxOXOPBFqtpEeYF9ViEwm7NXyQK5RxCpucdcd7Uq1aeosZG3i+F/9
 F/A+7CbF9I2VAZ2aXijdMuXVoKf8cNG2bfGhLkws086VBHDCBNz1GZfU9/p1tjC9XAt8vkRED
 zUuAVdNBpR9oHsfT4/99nHFTeaMK1rUwekofczJXDsCXpgOwQlJuTWEaoz0iU0iva6LL87G72
 vo9TLiBgRMpZRqtEWNKn90/Q5gXWrxMPDiUvFeNtnskT/tISY1yrCO4N2wuiM3cuddKZ74DGR
 TYfGnwGCx3ApOFNz2aqs6KchFirYOCV76JzQtPL7xKMWSbh0tJcZ9xOwgVna5Nt64d/DlyNfa
 0G3kb0+wCwqahGqe0OOVvSGbecFFZ9c3Bx4VnIdT/yVrxoLNe8jrSSsQpt6EVXlVJOr/TYhwz
 X3Mg4FjBYjBt0uBljQU+I1peJwQ9dv2YS0rc34Oj1VAYc72Pf2bjlWKJ/iWNY5POzGXgMfi03
 Sqp8etxIB5Ir0w3k8oeIfBT1nOMt04uqhRadIq8uHlWbCZxjHO5hGN30CaIr8LEft4ghCv/9H
 alWWN2FexeAEFSz/aqV4oAmraMzBWsN0M+QxgHVMZbOHgNCZL7iVMKFNgNlA/efAUjfVl++2X
 n85ZSqEvUFoJVJvJ1JXvONkqNFdCYgWBpci68KdZi3jiDAGndXMKHvTzcypFLMMfFoDkcD0Ab
 YQ/TQLlCGs50yQTK89k5h881RUrBCZVItewkt1NKp2QWPlxIbyK2iWIPjOci+RbyLOiSgtiA4
 3Yl5Q5K/y93xVK4y3b/JrFYO9mCnk3w3uPsN7Ow==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.12.19 11:22, Robin Murphy wrote:
> Hi Soeren,
>
> On 11/12/2019 11:52 pm, Soeren Moch wrote:
>> With enabled wifi support (required for firmware loading) for the
>> Ampak AP6359SA based wifi/bt combo module we now also can enable
>> the bluetooth part.
>>
>> Suggested-by: Heiko Stuebner <heiko@sntech.de>
>> Signed-off-by: Soeren Moch <smoch@web.de>
>> ---
>> changes in v2:
>> - new patch
>>
>> Cc: Heiko Stuebner <heiko@sntech.de>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: brcm80211-dev-list.pdl@broadcom.com
>> Cc: brcm80211-dev-list@cypress.com
>> Cc: netdev@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-rockchip@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> =C2=A0 .../boot/dts/rockchip/rk3399-rockpro64.dts=C2=A0=C2=A0=C2=A0 | 2=
9 ++++++++++++++++++-
>> =C2=A0 1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>> b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>> index 9fa92790d6e0..94cc462e234d 100644
>> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
>> @@ -561,6 +561,20 @@
>> =C2=A0 };
>>
>> =C2=A0 &pinctrl {
>> +=C2=A0=C2=A0=C2=A0 bt {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt_enable_h: bt-enable-h {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 roc=
kchip,pins =3D <0 RK_PB1 RK_FUNC_GPIO &pcfg_pull_none>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt_host_wake_l: bt-host-wak=
e-l {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 roc=
kchip,pins =3D <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_down>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt_wake_l: bt-wake-l {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 roc=
kchip,pins =3D <2 RK_PD3 RK_FUNC_GPIO &pcfg_pull_none>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>> +=C2=A0=C2=A0=C2=A0 };
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 buttons {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pwrbtn: pwrbtn {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 rockchip,pins =3D <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_up>;
>> @@ -729,8 +743,21 @@
>>
>> =C2=A0 &uart0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default";
>> -=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&uart0_xfer &uart0_cts>;
>> +=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&uart0_xfer &uart0_cts &uart0_rts>;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D "okay";
>> +
>> +=C2=A0=C2=A0=C2=A0 bluetooth {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 compatible =3D "brcm,bcm434=
38-bt";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clocks =3D <&rk808 1>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clock-names =3D "extclk";
>
> Is this right? Comparing the binding and the naming on the schematics,
> it seems more likely that this might be the LPO clock rather than the
> TXCO clock.
>
> Robin.
On second thought I have to agree. So we need another round on this.

Thanks for your review and bug report,
Soeren
>
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device-wakeup-gpios =3D <&g=
pio2 RK_PD3 GPIO_ACTIVE_HIGH>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 host-wakeup-gpios =3D <&gpi=
o0 RK_PA4 GPIO_ACTIVE_HIGH>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shutdown-gpios =3D <&gpio0 =
RK_PB1 GPIO_ACTIVE_HIGH>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default"=
;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&bt_host_wak=
e_l &bt_wake_l &bt_enable_h>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vbat-supply =3D <&vcc3v3_sy=
s>;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vddio-supply =3D <&vcc_1v8>=
;
>> +=C2=A0=C2=A0=C2=A0 };
>> =C2=A0 };
>>
>> =C2=A0 &uart2 {
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> Linux-rockchip mailing list
>> Linux-rockchip@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>>

