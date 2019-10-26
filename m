Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336A6E5940
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 10:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJZIYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 04:24:35 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:29148 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfJZIYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 04:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1572078269;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=i+MQHbSzYrAECD2i9GTqSSZFbktvxXHglJFMdbybaRE=;
        b=LNqqwElIvEiAjEsa2LSRu+A6IpBmygpF81iPakauQHuZVCUwGfzXQVv2gK5NtqJSDK
        E7RwKoB7utIOwMOedtguOI/atFZYOdxSxQFhc3pRVQOWgK7Hm1gLj7Op98hR9aWLfmOf
        atGTu8l6QR9ploMezQoPI9gSeIxahf0coppzuXAWygrSQwic0+IuaWvcSQp2l7hh2Sns
        8VI6IxVarZP3brRrUz6nrPl8Ow369ykyONCBib2O+sSz7wH1NTsu4VRkt4happKyNBpg
        SoYhipHE4YXckL2s8aGjmCh0RCtt65jH89uXnLxS79nkyR3lqKx3eD+XkRa1LO8Iv+rs
        B6iQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBp5hRw/qOxWRk4dCysP/lx4uw33QyGXuNISy7Vq++g6sYlqLxXuQw="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2001:16b8:2694:9c00:1e1:24c4:3f0e:1772]
        by smtp.strato.de (RZmta 44.28.1 AUTH)
        with ESMTPSA id R0b2a8v9Q8Nvkz4
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 26 Oct 2019 10:23:57 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 01/11] Documentation: dt: wireless: update wl1251 for sdio
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191025211338.GA20249@bogus>
Date:   Sat, 26 Oct 2019 10:24:05 +0200
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
        devicetree@vger.kernel.org, letux-kernel@openphoenux.org,
        linux-mmc@vger.kernel.org, kernel@pyra-handheld.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3A15C879-3A17-4FFC-B41E-0B98B63E8F7C@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com> <741828f69eca2a9c9a0a7e80973c91f50cc71f9b.1571510481.git.hns@goldelico.com> <20191025211338.GA20249@bogus>
To:     Rob Herring <robh@kernel.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 25.10.2019 um 23:13 schrieb Rob Herring <robh@kernel.org>:
>=20
> On Sat, Oct 19, 2019 at 08:41:16PM +0200, H. Nikolaus Schaller wrote:
>> The standard method for sdio devices connected to
>> an sdio interface is to define them as a child node
>> like we can see with wlcore.
>>=20
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>> ---
>> .../bindings/net/wireless/ti,wl1251.txt       | 26 =
+++++++++++++++++++
>> 1 file changed, 26 insertions(+)
>>=20
>> diff --git =
a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt =
b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
>> index bb2fcde6f7ff..88612ff29f2d 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
>> @@ -35,3 +35,29 @@ Examples:
>> 		ti,power-gpio =3D <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
>> 	};
>> };
>> +
>> +&mmc3 {
>> +	vmmc-supply =3D <&wlan_en>;
>> +
>> +	bus-width =3D <4>;
>> +	non-removable;
>> +	ti,non-removable;
>> +	cap-power-off-card;
>> +
>> +	pinctrl-names =3D "default";
>> +	pinctrl-0 =3D <&mmc3_pins>;
>=20
> None of the above are really relevant to this binding.

Ok, but how and where do we document that they are needed to make both =
ends of the interface work together?

>=20
>> +
>> +	#address-cells =3D <1>;
>> +	#size-cells =3D <0>;
>> +
>> +	wlan: wl1251@1 {
>=20
> wifi@1

Ok.

>=20
>> +		compatible =3D "ti,wl1251";
>> +
>> +		reg =3D <1>;
>> +
>> +		interrupt-parent =3D <&gpio1>;
>> +		interrupts =3D <21 IRQ_TYPE_LEVEL_HIGH>;	/* =
GPIO_21 */
>> +
>> +		ti,wl1251-has-eeprom;
>> +	};
>> +};
>> --=20
>> 2.19.1
>>=20

BR and thanks,
Nikolaus=
