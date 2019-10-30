Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D97EA278
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 18:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfJ3RZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 13:25:09 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:36708 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfJ3RZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 13:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1572456304;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=OsLmgSiDV+hk5s0I2fH4l/LO42oMc8+hGzlfb+0mtak=;
        b=FpH/F23pbV/WbTZSW3XOigRh0/E9t7gJlPbHiIUglPUO9b2kZQDtb8EJiDmcFT//+N
        uqhlfa2ZN1eQgmR8oDu6PGfsji35jOpbgRYDzLVjcLLBz+Owp+WgAAkMnwagAyoQA8Yi
        44mCxXxYj6LNxtXSGp7r/Eu/qAnNUnD0tg5q+hwVSZJI+4uSLapAUWKHvaZIceWtUOs0
        PfTtORel9GdKJwze1Ra4ESxc3AMkp1yCJYORKX9KB6hryAxZTLXAqn5dge1RZYUazzXE
        3Ahm/ya7FT/uhUpFwpXdHwQgQwljfUV2kiEllnTKf2Q4mMJOnptlNwsksFA8ZlF1ZBez
        nK/A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrpwDvG"
X-RZG-CLASS-ID: mo00
Received: from mbp-13-nikolaus.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3v9UHOp5p4
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 30 Oct 2019 18:24:51 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 03/11] DTS: ARM: pandora-common: define wl1251 as child node of mmc3
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAPDyKFrMQ3fBaeeAYVJfUdL8m=PDRU9Xt_9oGw6D1XOY68qDuQ@mail.gmail.com>
Date:   Wed, 30 Oct 2019 18:24:51 +0100
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        "# 4.0+" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9A82904-35BE-41F2-A308-9A49606428B1@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com> <bec9d76e6da03d734649b9bdf76e9d575c57631a.1571510481.git.hns@goldelico.com> <CAPDyKFrMQ3fBaeeAYVJfUdL8m=PDRU9Xt_9oGw6D1XOY68qDuQ@mail.gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 30.10.2019 um 17:44 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
>=20
> On Sat, 19 Oct 2019 at 20:42, H. Nikolaus Schaller <hns@goldelico.com> =
wrote:
>>=20
>> Since v4.7 the dma initialization requires that there is a
>> device tree property for "rx" and "tx" channels which is
>> not provided by the pdata-quirks initialization.
>>=20
>> By conversion of the mmc3 setup to device tree this will
>> finally allows to remove the OpenPandora wlan specific omap3
>> data-quirks.
>>=20
>> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
>>=20
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> Cc: <stable@vger.kernel.org> # 4.7.0
>> ---
>> arch/arm/boot/dts/omap3-pandora-common.dtsi | 37 =
+++++++++++++++++++--
>> 1 file changed, 35 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/arch/arm/boot/dts/omap3-pandora-common.dtsi =
b/arch/arm/boot/dts/omap3-pandora-common.dtsi
>> index ec5891718ae6..c595b3eb314d 100644
>> --- a/arch/arm/boot/dts/omap3-pandora-common.dtsi
>> +++ b/arch/arm/boot/dts/omap3-pandora-common.dtsi
>> @@ -226,6 +226,18 @@
>>                gpio =3D <&gpio6 4 GPIO_ACTIVE_HIGH>;     /* GPIO_164 =
*/
>>        };
>>=20
>> +       /* wl1251 wifi+bt module */
>> +       wlan_en: fixed-regulator-wg7210_en {
>> +               compatible =3D "regulator-fixed";
>> +               regulator-name =3D "vwlan";
>> +               regulator-min-microvolt =3D <1800000>;
>> +               regulator-max-microvolt =3D <1800000>;
>=20
> I doubt these are correct.
>=20
> I guess this should be in the range of 2.7V-3.6V.

Well, it is a gpio which enables some LDO inside the
wifi chip. We do not really know the voltage it produces
and it does not matter. The gpio voltage is 1.8V.

Basically we use a fixed-regulator to "translate" a
regulator into a control gpio because the mmc interface
wants to see a vmmc-supply.

>=20
>> +               startup-delay-us =3D <50000>;
>> +               regulator-always-on;
>=20
> Always on?

Oops. Yes, that is something to check!

>=20
>> +               enable-active-high;
>> +               gpio =3D <&gpio1 23 GPIO_ACTIVE_HIGH>;
>> +       };
>> +
>>        /* wg7210 (wifi+bt module) 32k clock buffer */
>>        wg7210_32k: fixed-regulator-wg7210_32k {
>>                compatible =3D "regulator-fixed";
>> @@ -522,9 +534,30 @@
>>        /*wp-gpios =3D <&gpio4 31 GPIO_ACTIVE_HIGH>;*/    /* GPIO_127 =
*/
>> };
>>=20
>> -/* mmc3 is probed using pdata-quirks to pass wl1251 card data */
>> &mmc3 {
>> -       status =3D "disabled";
>> +       vmmc-supply =3D <&wlan_en>;
>> +
>> +       bus-width =3D <4>;
>> +       non-removable;
>> +       ti,non-removable;
>> +       cap-power-off-card;
>> +
>> +       pinctrl-names =3D "default";
>> +       pinctrl-0 =3D <&mmc3_pins>;
>> +
>> +       #address-cells =3D <1>;
>> +       #size-cells =3D <0>;
>> +
>> +       wlan: wl1251@1 {
>> +               compatible =3D "ti,wl1251";
>> +
>> +               reg =3D <1>;
>> +
>> +               interrupt-parent =3D <&gpio1>;
>> +               interrupts =3D <21 IRQ_TYPE_LEVEL_HIGH>;  /* GPIO_21 =
*/
>> +
>> +               ti,wl1251-has-eeprom;
>> +       };
>> };
>>=20
>> /* bluetooth*/
>> --
>> 2.19.1
>>=20

BR and thanks,
Nikolaus

