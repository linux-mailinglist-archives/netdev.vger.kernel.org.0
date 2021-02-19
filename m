Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B374F31F49C
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 06:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBSFQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 00:16:02 -0500
Received: from mail-eopbgr110102.outbound.protection.outlook.com ([40.107.11.102]:39840
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhBSFP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 00:15:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhGJ+8uLZnIAwy+lc3QIa+w2LX5T4jGBQc9s7LYX/coN6DFHwElKf9bn6bVVe0BkpvZOEftFMcvF7LyqB90VfaTRGArnqzWcxb6B5rZhQDIN+fjer0znUgDNyCONVk52rKTAjSLhFeaoVvjAZQmZEVsw907X4USGkVYimB4UdalTZBY6kIy3N3Su+b2bqrugZPOv2p2HTs/DhAvBbNMIZ3IKo8sXiVYrOsKrriJZxuVNu1EuiFDfC184mQL3aCBUuGiXTtl1UAmeQhm/Ec/0JRKFRAizmRJZcFMdggH5XC1MtWqdy1tSiXTM15LPg2nEkaAxA4j2Z3MiGchiXptRxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xNJJZ9ET3zFxLXjqjtvuabaNasb3qUD4hZW4sbUS1s=;
 b=YXHKgJ+3+ggvj52L+ny1nheQ8MGzV9gFlBf6QCmzCqxmoHHRtZDffRtMee728JLioJ/pws+Q1EV7Ac18mbYlSLCJHA0iV3ksgbpCBaDjzQd/0TK9zw9COlcqnU5m4rxj8ZVfwfDDSRdoUece++/E6Kn+gAIbq0i6neG6mQdhLA5KDKQrihUGxuAWenx8kBl/hOSrasY+FGRiD+++sC60jBPlfxRUBmImbzeHvrYsJqpL0LpU3Za+3B3Kbag94vXBsspo0voRdk2hShF7LOQyZ4eyiIzLbHI8Kb5Jegp8YtuZUHj7oqBS8T6T41A609fsBLVa09jwPBZmbD9HJw60xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xNJJZ9ET3zFxLXjqjtvuabaNasb3qUD4hZW4sbUS1s=;
 b=vjHZVpzTsyf1bhDojYeCbifiKijT0LNbVMR9nbMhQIHI/hwYeSGbpbJeDvEDMVvNYl/xPT6up4LvStSIsJQcSMLuJ9ED1YqwgBKRNQ6+jmmzAsSNQ8G+4GGREzSAblwq7FbDz6/XFCzXVWLx44ROXsjLFSykqc1i/OrqIf4U2lQ=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWXP265MB3446.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Fri, 19 Feb
 2021 05:15:05 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167%9]) with mapi id 15.20.3846.043; Fri, 19 Feb 2021
 05:15:05 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXATVZ5f5l6UkeM0GGLk69Yeo12qpUh95mgApxXns=
Date:   Fri, 19 Feb 2021 05:15:05 +0000
Message-ID: <CWXP265MB17995C134CFC5BD3E39A7C08E0849@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20210212115030.124490-1-srini.raju@purelifi.com>
         (sfid-20210212_125300_396085_B8C8E2C0),<ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
In-Reply-To: <ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.213.193.240]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd113ac3-7a82-4833-c07b-08d8d495515a
x-ms-traffictypediagnostic: CWXP265MB3446:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB3446AEB00E7A89FE1AA82E57E0849@CWXP265MB3446.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BEB9jxifnuMCamPGdc+RJRcMZQaDXT5icAU9ZtV31AiR2JSMWQtoWu9VNv9M9Og60QMRCBwhZDOTuwJSWDk2iQvqBHsCv3d5JNiqrjRm+gOkseLKYooHc5Pycjvsc9G2744XvoYCAvB2+lHaA+yXbgXDG2oQEkVxINDVBlD422Rb4tYoVXtVX+bM2RQ4vzDiM2p8JOEeTO6LDz8f/LJtPdIBHtptqLICRr4Iu01ABt9dzEUyfHWoF2MXsrjmEojqrB9bNju/lOs+IeTujKLNCsJOKjnCCL+pp4EMYeZtgyXpaM+n7r0MOC2r374tSTw4W5kFw88cqQbi0r4efilNf0GXS/6+MVEYgw6m6Wxbj2sjXxQ+26iLg5p5NvL5mTTyofPUHU2EOah9bB6jTiaNzGs2KK48FTaC/JaOHE2QI74Y/72E3fkvgE9PhBhmG9PjzuvkpNk93ghuNOPubul4n1t/iJ9+OWrazFyw/eLokiWQTXvJvqV0SpeCs4Yc8g5QuXo5QHVbGlmbmC4D9IfzSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(376002)(136003)(346002)(366004)(39830400003)(396003)(53546011)(6506007)(186003)(86362001)(26005)(66946007)(8676002)(8936002)(83380400001)(91956017)(33656002)(478600001)(9686003)(4326008)(55016002)(71200400001)(6916009)(52536014)(5660300002)(64756008)(66446008)(316002)(30864003)(7696005)(54906003)(76116006)(2906002)(66476007)(66556008)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?VxiLDqNbfyCnGqE+8UlmKzjOINjFS8gKskdjHGzN6VH61xfK4wfFx5J4xu?=
 =?iso-8859-1?Q?7q0PpsoxwiMtHstOuMfawARb1Lxm/3Xw0P3e6BzpDux6d2J7qbE4zKIF4i?=
 =?iso-8859-1?Q?1IlZqftEbUSgBP9Wn3qu9horMv2P9SDwvurCfSotRb+4s4yK2LIqR0ErvQ?=
 =?iso-8859-1?Q?KUfANXucp1LPiP8y6fK10LznZJZCShAzPZkAdLejfDzwu310vKVMYT8JTs?=
 =?iso-8859-1?Q?WIJgENSD1P/HAWPpjLdKs5Kc1zlIJxagVzNtbJm2OpHFo/l3gj8F3gatF6?=
 =?iso-8859-1?Q?6IjsNPkbUkSNUvuueNcmQleoeTQ0iNkTwaUzrYMeHyHRQf+jnYiEgCnRCW?=
 =?iso-8859-1?Q?VYfZU7ysYiCsEwksm+7cboolFKduZ4X9F2LcQ5URM35iqfrJVMEcrUf0Hd?=
 =?iso-8859-1?Q?eQ4TiwDkZaXpLtP+RrNT3/nrc5zN0G3yW7ctdZwnsg2MqVUKCbAGZgX2ab?=
 =?iso-8859-1?Q?pvDVugjjYUAGQTv+QajxSM7eKvVZjuAPxBo3W99x/k57aDVxCmrAL0QABH?=
 =?iso-8859-1?Q?DwnLTTcrImdrhjNUVRseryw/VqyKsLB2Re7Qzawl/ND8uPTuWxiPbwS2ID?=
 =?iso-8859-1?Q?NlWhl1gh1ztbZqZW7cCJHrLDzfxPklFJSkTq/LCGPjtbBZz/eIk8gtpyUE?=
 =?iso-8859-1?Q?eP9ipvNnLcQ8AscJlCXoG8fOOvqJi0Ki9UaSwdubE78k7tunnFvlphfvLO?=
 =?iso-8859-1?Q?ZIg16C/xayTPr6xLlE5Ls0ugKyQtQkRROQ1UJORQ70H+oHjEIIDtmpL4uj?=
 =?iso-8859-1?Q?dpn1toFa8SXcKVDaf3YQSBnTbPwe2yqDfuXiM89KKiWSIs5YsIx/ud8G18?=
 =?iso-8859-1?Q?Ox+dBNAO3rHFp/kAdvqgk0bFC8+ZcwGgCM3i6tj8fyWnpICTVSTCf0Ppbk?=
 =?iso-8859-1?Q?UwNAGWyjBEIVqlPwH+0IsMKw7z4eGD/Qgf/HLYVQgCIEfgH7HReMyL93F2?=
 =?iso-8859-1?Q?DJhss1OExc5oRHuRJm0Xyu0hxGJTrXMmSQjB5uaXIpDMz2LInUuxD5bptf?=
 =?iso-8859-1?Q?9EbNgoVOzjatIFqsDvzIeRW1yZlW9CYOlRpdJC6N//ZkUtPJ6P1wva5rMg?=
 =?iso-8859-1?Q?YlCmgv56JVviP7Le64rTxf+GCrcMcSUyZ7TNxwVJHCZhHoQhiQFbyOELoI?=
 =?iso-8859-1?Q?ae1/zsQHViXRn2ta2tBBGYoUTaqmaq7yTFwoYjyyzEJ361mCa6YuS5pULD?=
 =?iso-8859-1?Q?jD5XGd3c+yX0beJSHg8JZN98XmjPy25SiGsgJiDQxmHrj1Zlf0cqa1q45k?=
 =?iso-8859-1?Q?/cyKGE2azGs1ZzRMOrnTdAfcT6znICm+debxTStL9sLSGdWJcY8oJO3gBw?=
 =?iso-8859-1?Q?BreL2l25Rr5gTl0mSDfEkRJUzuNG+YaRcH0yXY5sIPu6vmM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fd113ac3-7a82-4833-c07b-08d8d495515a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 05:15:05.1758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpPw1ogaETyaRCt7r5EAIR+5kybQ+FWvnq24DYcw40tRSmv/wtADexKHDQSUZ3prs2gKEWo2jZWcw7I5iaS26g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3446
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
Please find a few responses to the comments , We will fix rest of the comme=
nts and submit v14 of the patch.=0A=
=0A=
> Also, you *really* need some validation here, rather than blindly=0A=
> trusting that the file is well-formed, otherwise you immediately have a=
=0A=
> security issue here.=0A=
=0A=
The firmware is signed and the harware validates the signature , so we are =
not validating in the software.=0A=
=0A=
>> +static const struct plf_reg_alpha2_map reg_alpha2_map[] =3D {=0A=
>> +     { PLF_REGDOMAIN_FCC, "US" },=0A=
>> +     { PLF_REGDOMAIN_IC, "CA" },=0A=
>> +     { PLF_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictiv=
e */=0A=
>> +     { PLF_REGDOMAIN_JAPAN, "JP" },=0A=
>> +     { PLF_REGDOMAIN_SPAIN, "ES" },=0A=
>> +     { PLF_REGDOMAIN_FRANCE, "FR" },=0A=
>> +};=0A=
=0A=
> You actually have regulatory restrictions on this stuff?=0A=
=0A=
Currently, There are no regulatory restrictions applicable for LiFi , regul=
atory_hint setting is only for wifi core =0A=
=0A=
>> +static const struct ieee80211_rate purelifi_rates[] =3D {=0A=
>> +     { .bitrate =3D 10,=0A=
>> +             .hw_value =3D PURELIFI_CCK_RATE_1M,=0A=
>> +             .flags =3D 0 },=0A=
>> +     { .bitrate =3D 20,=0A=
>> +             .hw_value =3D PURELIFI_CCK_RATE_2M,=0A=
>> +             .hw_value_short =3D PURELIFI_CCK_RATE_2M=0A=
>> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
>> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
>> +     { .bitrate =3D 55,=0A=
>> +             .hw_value =3D PURELIFI_CCK_RATE_5_5M,=0A=
>> +             .hw_value_short =3D PURELIFI_CCK_RATE_5_5M=0A=
>> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
>> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
>> +     { .bitrate =3D 110,=0A=
>> +             .hw_value =3D PURELIFI_CCK_RATE_11M,=0A=
>> +             .hw_value_short =3D PURELIFI_CCK_RATE_11M=0A=
>> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
>> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
=0A=
=0A=
> So ... how much of that is completely fake? Are you _actually_ doing 1,=
=0A=
> 2, 5.5 etc. Mbps over the air, and you even have short and long=0A=
> preamble? Why do all of that legacy mess, when you're essentially=0A=
> greenfield??=0A=
=0A=
Yes, this not used. We will test and remove the unused legacy settings=0A=
=0A=
> OTOH, I can sort of see why/how you're reusing wifi functionality here,=
=0A=
> very old versions of wifi even had an infrared PHY I think.=0A=
>=0A=
> Conceptually, it seems odd. Perhaps we should add a new band definition?=
=0A=
>=0A=
> And what I also asked above - how much of the rate stuff is completely=0A=
> fake? Are you really doing CCK/OFDM in some (strange?) way?=0A=
=0A=
Yes, your understanding is correct, and we use OFDM.=0A=
For now we will use the existing band definition.=0A=
=0A=
Thanks=0A=
Srini=0A=
________________________________________=0A=
From: Johannes Berg <johannes@sipsolutions.net>=0A=
Sent: Friday, February 12, 2021 7:14 PM=0A=
To: Srinivasan Raju=0A=
Cc: Mostafa Afgani; Kalle Valo; David S. Miller; Jakub Kicinski; open list;=
 open list:NETWORKING DRIVERS (WIRELESS); open list:NETWORKING DRIVERS=0A=
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi=
 STA devices=0A=
=0A=
Hi,=0A=
=0A=
Thanks for your patience, and thanks for sticking around!=0A=
=0A=
I'm sorry I haven't reviewed this again in a long time, but I was able=0A=
to today.=0A=
=0A=
=0A=
> +PUREILIFI USB DRIVER=0A=
=0A=
Did you mistype "PURELIFI" here, or was that intentional?=0A=
=0A=
> +PUREILIFI USB DRIVER=0A=
> +M:   Srinivasan Raju <srini.raju@purelifi.com>=0A=
=0A=
Probably would be good to have an "L" entry with the linux-wireless list=0A=
here.=0A=
=0A=
> +if WLAN_VENDOR_PURELIFI=0A=
> +=0A=
> +source "drivers/net/wireless/purelifi/plfxlc/Kconfig"=0A=
=0A=
Seems odd to have the Makefile under purelifi/ but the Kconfig is yet=0A=
another directory deeper?=0A=
=0A=
> +++ b/drivers/net/wireless/purelifi/Makefile=0A=
> @@ -0,0 +1,2 @@=0A=
> +# SPDX-License-Identifier: GPL-2.0-only=0A=
> +obj-$(CONFIG_WLAN_VENDOR_PURELIFI)           :=3D plfxlc/=0A=
=0A=
Although this one doesn't do anything, so all you did was save a level=0A=
of Kconfig inclusion I guess ... no real objection to that.=0A=
=0A=
> diff --git a/drivers/net/wireless/purelifi/plfxlc/Kconfig b/drivers/net/w=
ireless/purelifi/plfxlc/Kconfig=0A=
> new file mode 100644=0A=
> index 000000000000..07a65c0fce68=0A=
> --- /dev/null=0A=
> +++ b/drivers/net/wireless/purelifi/plfxlc/Kconfig=0A=
> @@ -0,0 +1,13 @@=0A=
> +# SPDX-License-Identifier: GPL-2.0-only=0A=
> +config PLFXLC=0A=
> +=0A=
> +     tristate "pureLiFi X, XL, XC device support"=0A=
=0A=
extra blank line.=0A=
=0A=
Also, maybe that should be a bit more verbose? PURELIFI_XLC or so? I=0A=
don't think it shows up in many places, but if you see "PLFXLC"=0A=
somewhere that's not very helpful.=0A=
=0A=
> +     depends on CFG80211 && MAC80211 && USB=0A=
> +     help=0A=
> +        This driver makes the adapter appear as a normal WLAN interface.=
=0A=
> +=0A=
> +        The pureLiFi device requires external STA firmware to be loaded.=
=0A=
> +=0A=
> +        To compile this driver as a module, choose M here: the module wi=
ll=0A=
> +        be called purelifi.=0A=
=0A=
But will it? Seems like it would be called "plfxlc"?=0A=
=0A=
See here:=0A=
=0A=
> +++ b/drivers/net/wireless/purelifi/plfxlc/Makefile=0A=
> @@ -0,0 +1,3 @@=0A=
> +# SPDX-License-Identifier: GPL-2.0-only=0A=
> +obj-$(CONFIG_PLFXLC)         :=3D plfxlc.o=0A=
> +plfxlc-objs          +=3D chip.o firmware.o usb.o mac.o=0A=
=0A=
=0A=
> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interva=
l,=0A=
> +                              u8 dtim_period, int type)=0A=
> +{=0A=
> +     if (!interval ||=0A=
> +         (chip->beacon_set && chip->beacon_interval =3D=3D interval)) {=
=0A=
> +             return 0;=0A=
> +     }=0A=
=0A=
Don't need braces here=0A=
=0A=
> +     chip->beacon_interval =3D interval;=0A=
> +     chip->beacon_set =3D true;=0A=
> +     return usb_write_req((const u8 *)&chip->beacon_interval,=0A=
> +                          sizeof(chip->beacon_interval),=0A=
> +                          USB_REQ_BEACON_INTERVAL_WR);=0A=
=0A=
There's clearly an endian problem hiding here somewhere. You should have=0A=
"chip->beacon_interval" be (probably) __le16 since you send it to the=0A=
device as a buffer, yet the parameter to this function is just "u16".=0A=
Therefore, a conversion is missing somewhere - likely you need it to be=0A=
__le16 in the chip struct since you can't send USB requests from stack.=0A=
=0A=
=0A=
You should add some annotations for things getting sent to the device=0A=
like this, and then you can run sparse to validate them all over the=0A=
code.=0A=
=0A=
=0A=
> +}=0A=
> +=0A=
> +int purelifi_chip_init_hw(struct purelifi_chip *chip)=0A=
> +{=0A=
> +     u8 *addr =3D purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip))=
;=0A=
> +     struct usb_device *udev =3D interface_to_usbdev(chip->usb.intf);=0A=
> +=0A=
> +     pr_info("purelifi chip %02x:%02x v%02x  %02x-%02x-%02x %s\n",=0A=
=0A=
"%04x:%04x" for the USB ID?=0A=
=0A=
And you should probably use %pM for the MAC address - the format you=0A=
have there looks ... strange? Why only print the vendor OUI?=0A=
=0A=
> +int purelifi_chip_switch_radio(struct purelifi_chip *chip, u32 value)=0A=
> +{=0A=
> +     int r;=0A=
> +=0A=
> +     r =3D usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_POWE=
R_WR);=0A=
> +     if (r)=0A=
> +             dev_err(purelifi_chip_dev(chip), "POWER_WR failed (%d)\n", =
r);=0A=
=0A=
Same endian problem here.=0A=
=0A=
>=0A=
> +static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,=
=0A=
> +                                     u8 *addr)=0A=
> +{=0A=
> +     unsigned int i =3D addr[5] >> 2;=0A=
> +=0A=
> +     if (i < 32)=0A=
> +             hash->low |=3D 1 << i;=0A=
> +     else=0A=
> +             hash->high |=3D 1 << (i - 32);=0A=
=0A=
That's UB if i =3D=3D 31, you need 1U << i, or just use the BIT() macro.=0A=
=0A=
> +     r =3D request_firmware((const struct firmware **)&fw, fw_name,=0A=
=0A=
Not sure why that cast should be required?=0A=
=0A=
> +     fpga_dmabuff =3D NULL;=0A=
> +     fpga_dmabuff =3D kmalloc(PLF_FPGA_SLEN, GFP_KERNEL);=0A=
=0A=
that NULL assignment is pointless :)=0A=
=0A=
> +=0A=
> +     if (!fpga_dmabuff) {=0A=
> +             r =3D -ENOMEM;=0A=
> +             goto error_free_fw;=0A=
> +     }=0A=
> +     send_vendor_request(udev, PLF_VNDR_FPGA_SET_REQ, fpga_dmabuff, size=
of(fpga_setting));=0A=
> +     memcpy(fpga_setting, fpga_dmabuff, PLF_FPGA_SLEN);=0A=
> +     kfree(fpga_dmabuff);=0A=
=0A=
I'd say you should remove fpga_setting from the stack since you anyway=0A=
allocated it, save the memcpy() to the stack, and just use fpga_dmabuff=0A=
below - and then free it later?=0A=
=0A=
> +             for (tbuf_idx =3D 0; tbuf_idx < blk_tran_len; tbuf_idx++) {=
=0A=
> +                     /* u8 bit reverse */=0A=
> +                     fw_data[tbuf_idx] =3D=0A=
> +                             ((fw_data[tbuf_idx] & 128) >> 7) |=0A=
> +                             ((fw_data[tbuf_idx] &  64) >> 5) |=0A=
> +                             ((fw_data[tbuf_idx] &  32) >> 3) |=0A=
> +                             ((fw_data[tbuf_idx] &  16) >> 1) |=0A=
> +                             ((fw_data[tbuf_idx] &   8) << 1) |=0A=
> +                             ((fw_data[tbuf_idx] &   4) << 3) |=0A=
> +                             ((fw_data[tbuf_idx] &   2) << 5) |=0A=
> +                             ((fw_data[tbuf_idx] &   1) << 7);=0A=
> +             }=0A=
=0A=
check out include/linux/bitrev.h and bitrev8().=0A=
=0A=
> +     fpga_dmabuff =3D NULL;=0A=
> +     fpga_dmabuff =3D kmalloc(PLF_FPGA_ST_LEN, GFP_KERNEL);=0A=
=0A=
again useless NULL assignment=0A=
=0A=
> +     if (!fpga_dmabuff) {=0A=
> +             r =3D -ENOMEM;=0A=
> +             goto error_free_fw;=0A=
> +     }=0A=
> +     memset(fpga_dmabuff, 0xFF, PLF_FPGA_ST_LEN);=0A=
=0A=
does it have to be 0xff? Maybe kzalloc() would be shorter?=0A=
=0A=
> +     send_vendor_request(udev, PLF_VNDR_FPGA_STATE_REQ, fpga_dmabuff,=0A=
> +                         sizeof(fpga_state));=0A=
> +=0A=
> +     dev_dbg(&intf->dev, "fpga status: %x %x %x %x %x %x %x %x\n",=0A=
> +             fpga_dmabuff[0], fpga_dmabuff[1],=0A=
> +             fpga_dmabuff[2], fpga_dmabuff[3],=0A=
> +             fpga_dmabuff[4], fpga_dmabuff[5],=0A=
> +             fpga_dmabuff[6], fpga_dmabuff[7]);=0A=
=0A=
consider something like=0A=
        dev_dbg(..., "%*ph\n", 8, fpga_dmabuff);=0A=
=0A=
to simplify this.=0A=
=0A=
> +     if (fpga_dmabuff[0] !=3D 0) {=0A=
> +             r =3D -EINVAL;=0A=
> +             kfree(fpga_dmabuff);=0A=
> +             goto error_free_fw;=0A=
=0A=
you have an out label anyway, make it free fpga_dmabuff too? kfree(NULL)=0A=
is OK, so you can just always do that there.=0A=
=0A=
> +     no_of_files =3D *(u32 *)&fw_packed->data[0];=0A=
=0A=
All of this is completely endianness broken, and quite possibly also has=0A=
alignment problems. Need get_unaligned_le32() I guess.=0A=
=0A=
> +     for (step =3D 0; step < no_of_files; step++) {=0A=
> +             buf[0] =3D step;=0A=
> +             r =3D send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,=
=0A=
> +                                     PLF_XL_BUF_LEN);=0A=
> +=0A=
> +             if (step < no_of_files - 1)=0A=
> +                     size =3D *(u32 *)&fw_packed->data[4 + ((step + 1) *=
 4)]=0A=
> +                             - *(u32 *)&fw_packed->data[4 + (step) * 4];=
=0A=
> +             else=0A=
> +                     size =3D tot_size -=0A=
> +                             *(u32 *)&fw_packed->data[4 + (step) * 4];=
=0A=
> +=0A=
> +             start_addr =3D *(u32 *)&fw_packed->data[4 + (step * 4)];=0A=
=0A=
Lots of those here too - you might want to define a struct with __le32=0A=
entries for some of this stuff so sparse can validate your assumptions=0A=
("make C=3D1").=0A=
=0A=
Also, you *really* need some validation here, rather than blindly=0A=
trusting that the file is well-formed, otherwise you immediately have a=0A=
security issue here.=0A=
=0A=
> +#define PLF_MAC_VENDOR_REQUEST 0x36=0A=
> +#define PLF_SERIAL_NUMBER_VENDOR_REQUEST 0x37=0A=
> +#define PLF_FIRMWARE_VERSION_VENDOR_REQUEST 0x39=0A=
> +#define PLF_SERIAL_LEN 14=0A=
> +#define PLF_FW_VER_LEN 8=0A=
> +     struct usb_device *udev =3D interface_to_usbdev(intf);=0A=
> +     int r =3D 0;=0A=
> +     unsigned char *dma_buffer =3D NULL;=0A=
> +     unsigned long long firmware_version;=0A=
> +=0A=
> +     dma_buffer =3D kmalloc(PLF_SERIAL_LEN, GFP_KERNEL);=0A=
=0A=
I'd probably throw in a few build assertions such as=0A=
=0A=
        BUILD_BUG_ON(ETH_ALEN > PLF_SERIAL_LEN);=0A=
        BUILD_BUG_ON(PLF_FW_VER_LEN > PLF_SERIAL_LEN);=0A=
=0A=
> +     if (!dma_buffer) {=0A=
> +             r =3D -ENOMEM;=0A=
> +             goto error;=0A=
=0A=
you do nothing at the error label, might as well remove it=0A=
=0A=
and then you can remove the 'r' variable=0A=
=0A=
> +struct rx_status {=0A=
> +     u16 rssi;=0A=
> +     u8  rate_idx;=0A=
> +     u8  pad;=0A=
> +     u64 crc_error_count;=0A=
> +} __packed;=0A=
=0A=
endian issues, I assume=0A=
=0A=
> +struct usb_req_t {=0A=
> +     enum usb_req_enum_t id;=0A=
> +     u32            len;=0A=
> +     u8             buf[512];=0A=
> +};=0A=
=0A=
quite possibly here too, but dunno. Not sure I'd rely on 'enum' to have=0A=
a specific size here, and anyway the enum here will basically make the=0A=
sparse endian annotations impossible - better use __le32 with a comment=0A=
pointing to the enum.=0A=
=0A=
> +static const struct plf_reg_alpha2_map reg_alpha2_map[] =3D {=0A=
> +     { PLF_REGDOMAIN_FCC, "US" },=0A=
> +     { PLF_REGDOMAIN_IC, "CA" },=0A=
> +     { PLF_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive=
 */=0A=
> +     { PLF_REGDOMAIN_JAPAN, "JP" },=0A=
> +     { PLF_REGDOMAIN_SPAIN, "ES" },=0A=
> +     { PLF_REGDOMAIN_FRANCE, "FR" },=0A=
> +};=0A=
=0A=
You actually have regulatory restrictions on this stuff?=0A=
=0A=
> +static const struct ieee80211_rate purelifi_rates[] =3D {=0A=
> +     { .bitrate =3D 10,=0A=
> +             .hw_value =3D PURELIFI_CCK_RATE_1M,=0A=
> +             .flags =3D 0 },=0A=
> +     { .bitrate =3D 20,=0A=
> +             .hw_value =3D PURELIFI_CCK_RATE_2M,=0A=
> +             .hw_value_short =3D PURELIFI_CCK_RATE_2M=0A=
> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
> +     { .bitrate =3D 55,=0A=
> +             .hw_value =3D PURELIFI_CCK_RATE_5_5M,=0A=
> +             .hw_value_short =3D PURELIFI_CCK_RATE_5_5M=0A=
> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
> +     { .bitrate =3D 110,=0A=
> +             .hw_value =3D PURELIFI_CCK_RATE_11M,=0A=
> +             .hw_value_short =3D PURELIFI_CCK_RATE_11M=0A=
> +                     | PURELIFI_CCK_PREA_SHORT,=0A=
> +             .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },=0A=
=0A=
So ... how much of that is completely fake? Are you _actually_ doing 1,=0A=
2, 5.5 etc. Mbps over the air, and you even have short and long=0A=
preamble? Why do all of that legacy mess, when you're essentially=0A=
greenfield??=0A=
=0A=
> +=0A=
> +static const struct ieee80211_channel purelifi_channels[] =3D {=0A=
> +     { .center_freq =3D 2412, .hw_value =3D 1 },=0A=
> +     { .center_freq =3D 2417, .hw_value =3D 2 },=0A=
> +     { .center_freq =3D 2422, .hw_value =3D 3 },=0A=
> +     { .center_freq =3D 2427, .hw_value =3D 4 },=0A=
> +     { .center_freq =3D 2432, .hw_value =3D 5 },=0A=
> +     { .center_freq =3D 2437, .hw_value =3D 6 },=0A=
> +     { .center_freq =3D 2442, .hw_value =3D 7 },=0A=
> +     { .center_freq =3D 2447, .hw_value =3D 8 },=0A=
> +     { .center_freq =3D 2452, .hw_value =3D 9 },=0A=
> +     { .center_freq =3D 2457, .hw_value =3D 10 },=0A=
> +     { .center_freq =3D 2462, .hw_value =3D 11 },=0A=
> +     { .center_freq =3D 2467, .hw_value =3D 12 },=0A=
> +     { .center_freq =3D 2472, .hw_value =3D 13 },=0A=
> +     { .center_freq =3D 2484, .hw_value =3D 14 },=0A=
> +};=0A=
> +=0A=
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,=0A=
> +                                   struct sk_buff *beacon, bool in_intr)=
;=0A=
> +=0A=
> +static int plf_reg2alpha2(u8 regdomain, char *alpha2)=0A=
> +{=0A=
> +     unsigned int i;=0A=
> +     const struct plf_reg_alpha2_map *reg_map;=0A=
> +             for (i =3D 0; i < ARRAY_SIZE(reg_alpha2_map); i++) {=0A=
=0A=
indentation is off here, and a blank line after the variables would be=0A=
nice=0A=
=0A=
> +int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, unsigned char *hw_a=
ddress)=0A=
=0A=
const u8 *?=0A=
=0A=
> +void block_queue(struct purelifi_usb *usb, const u8 *mac, bool block)=0A=
=0A=
Why is there a mac argument to this?=0A=
=0A=
> +     dev_dbg(purelifi_mac_dev(mac), "irq_disabled (%d)\n", irqs_disabled=
());=0A=
> +     r =3D plf_reg2alpha2(mac->regdomain, alpha2);=0A=
> +     r =3D regulatory_hint(hw->wiphy, alpha2);=0A=
=0A=
that first assignment to r is unused?=0A=
=0A=
> +/**=0A=
> + * purelifi_mac_tx_status - reports tx status of a packet if required=0A=
> + * @hw - a &struct ieee80211_hw pointer=0A=
> + * @skb - a sk-buffer=0A=
=0A=
bad kernel doc format I believe, and you do use : below:=0A=
=0A=
> + * @flags: extra flags to set in the TX status info=0A=
> + * @ackssi: ACK signal strength=0A=
> + * @success - True for successful transmission of the frame=0A=
=0A=
just not always :)=0A=
=0A=
> + * This information calls ieee80211_tx_status_irqsafe() if required by t=
he=0A=
> + * control information. It copies the control information into the statu=
s=0A=
> + * information.=0A=
> + *=0A=
> + * If no status information has been requested, the skb is freed.=0A=
=0A=
That last line doesn't seem true?=0A=
=0A=
> +     } else {=0A=
> +             /* ieee80211_tx_status_irqsafe(hw, skb); */=0A=
=0A=
?=0A=
=0A=
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,=0A=
> +                                   struct sk_buff *beacon, bool in_intr)=
=0A=
=0A=
unused in_intr arg?=0A=
=0A=
> +     if (skb_headroom(skb) < sizeof(struct purelifi_ctrlset)) {=0A=
> +             dev_dbg(purelifi_mac_dev(mac), "Not enough hroom(1)\n");=0A=
> +             return 1;=0A=
> +     }=0A=
> +=0A=
> +     cs =3D (struct purelifi_ctrlset *)skb_push(skb,=0A=
> +                     sizeof(struct purelifi_ctrlset));=0A=
=0A=
FWIW, (void *) cast is sufficient=0A=
=0A=
> +     cs->id =3D USB_REQ_DATA_TX;=0A=
> +     cs->payload_len_nw =3D frag_len;=0A=
> +     cs->len =3D cs->payload_len_nw + sizeof(struct purelifi_ctrlset)=0A=
> +             - sizeof(cs->id) - sizeof(cs->len);=0A=
=0A=
the - at the end of line is generally preferred, but not really that=0A=
important I guess=0A=
=0A=
> +     /*check if 32 bit aligned and align data*/=0A=
> +     tmp =3D skb->len & 3;=0A=
> +     if (tmp) {=0A=
> +             if (skb_tailroom(skb) < (3 - tmp)) {=0A=
> +                     if (skb_headroom(skb) >=3D 4 - tmp) {=0A=
> +                             u8 len;=0A=
> +                             u8 *src_pt;=0A=
> +                             u8 *dest_pt;=0A=
> +=0A=
> +                             len =3D skb->len;=0A=
> +                             src_pt =3D skb->data;=0A=
> +                             dest_pt =3D skb_push(skb, 4 - tmp);=0A=
> +                             memcpy(dest_pt, src_pt, len);=0A=
=0A=
that can overlap, so you really need memmove(), not memcpy().=0A=
=0A=
> +                     } else {=0A=
> +                             return 1;=0A=
=0A=
return 1 is "unidiomatic" in the kernel, maybe just return -ENOBUFS?=0A=
=0A=
> +                             /* should never happen b/c=0A=
=0A=
wouldn't hurt to spell that out ;)=0A=
=0A=
> +                              * sufficient headroom was reserved=0A=
> +                              */=0A=
> +                             return 1;=0A=
=0A=
same here=0A=
=0A=
> +static void purelifi_op_tx(struct ieee80211_hw *hw,=0A=
> +                        struct ieee80211_tx_control *control,=0A=
> +                        struct sk_buff *skb)=0A=
> +{=0A=
> +     struct purelifi_mac *mac =3D purelifi_hw_mac(hw);=0A=
> +     struct purelifi_usb *usb =3D &mac->chip.usb;=0A=
> +     struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);=0A=
> +     unsigned long flags;=0A=
> +     int r;=0A=
> +=0A=
> +     r =3D fill_ctrlset(mac, skb);=0A=
> +     if (r)=0A=
> +             goto fail;=0A=
> +     info->rate_driver_data[0] =3D hw;=0A=
> +=0A=
> +     if (skb->data[24] =3D=3D IEEE80211_FTYPE_DATA) {=0A=
=0A=
it would be much clearer if you had a struct that you overlay on top of=0A=
the struct and then you have something like=0A=
=0A=
        struct purelifi_header *plhdr =3D (void *)skb->data;=0A=
=0A=
        if (plhdr->frametype =3D=3D IEEE80211_FTYPE_DATA)=0A=
=0A=
here.=0A=
=0A=
Assuming that's what it does? Otherwise it doesn't make much sense?=0A=
=0A=
It's not obvious what the SKB contains at this point, having a struct=0A=
there would make it obvious.=0A=
=0A=
> +             u8 dst_mac[ETH_ALEN];=0A=
> +             u8 sidx;=0A=
> +             bool found =3D false;=0A=
> +             struct purelifi_usb_tx *tx =3D &usb->tx;=0A=
> +=0A=
> +             memcpy(dst_mac, &skb->data[28], ETH_ALEN);=0A=
=0A=
Why copy it to the stack first?=0A=
=0A=
> +             for (sidx =3D 0; sidx < MAX_STA_NUM; sidx++) {=0A=
> +                     if (!(tx->station[sidx].flag & STATION_CONNECTED_FL=
AG))=0A=
> +                             continue;=0A=
> +                     if (!memcmp(tx->station[sidx].mac, dst_mac, ETH_ALE=
N)) {=0A=
=0A=
you haven't changed the skb?=0A=
=0A=
And if you wanted it for line length or something, then just use a=0A=
pointer? Again though, the data[28] probably should be some struct=0A=
dereference.=0A=
=0A=
> +                             found =3D true;=0A=
> +                             break;=0A=
> +                     }=0A=
> +             }=0A=
> +=0A=
> +             /* Default to broadcast address for unknown MACs */=0A=
> +             if (!found)=0A=
> +                     sidx =3D STA_BROADCAST_INDEX;=0A=
> +=0A=
> +             /* Stop OS from sending packets, if the queue is half full =
*/=0A=
> +             if (skb_queue_len(&tx->station[sidx].data_list) > 60)=0A=
> +                     block_queue(usb, tx->station[sidx].mac, true);=0A=
> +=0A=
> +             /* Schedule packet for transmission if queue is not full */=
=0A=
> +             if (skb_queue_len(&tx->station[sidx].data_list) < 256) {=0A=
=0A=
60/256 isn't really half, but hey :)=0A=
=0A=
> +                     skb_queue_tail(&tx->station[sidx].data_list, skb);=
=0A=
> +                     purelifi_send_packet_from_data_queue(usb);=0A=
> +             } else {=0A=
> +                     dev_kfree_skb(skb);=0A=
=0A=
It's kind of strangely inconsistent that you have here a free and then=0A=
fall through to the return, but other times you a 'goto fail':=0A=
=0A=
> +             }=0A=
> +     } else {=0A=
> +             spin_lock_irqsave(&usb->tx.lock, flags);=0A=
> +             r =3D usb_write_req_async(&mac->chip.usb, skb->data, skb->l=
en,=0A=
> +                                     USB_REQ_DATA_TX, tx_urb_complete, s=
kb);=0A=
> +             spin_unlock_irqrestore(&usb->tx.lock, flags);=0A=
> +             if (r)=0A=
> +                     goto fail;=0A=
> +     }=0A=
> +     return;=0A=
> +=0A=
> +fail:=0A=
> +     dev_kfree_skb(skb);=0A=
=0A=
where you free it=0A=
=0A=
> +static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_=
hdr,=0A=
> +                   struct ieee80211_rx_status *stats)=0A=
=0A=
Generally, it'd be nice if more of your functions came with some prefix,=0A=
like say plf_filter_ack() in this case.=0A=
=0A=
> +int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,=0A=
> +                 unsigned int length)=0A=
=0A=
or, well, purelifi_ :)=0A=
=0A=
> +     crc_error_cnt_low =3D status->crc_error_count;=0A=
> +     crc_error_cnt_high =3D status->crc_error_count >> 32;=0A=
> +     mac->crc_errors =3D ((u64)ntohl(crc_error_cnt_low) << 32) |=0A=
> +             ntohl(crc_error_cnt_high);=0A=
=0A=
Oh hey, I found one place where you do endian conversion ;-)=0A=
=0A=
but ... what's wrong with be64_to_cpu()?=0A=
=0A=
> +     if (buffer[0] =3D=3D IEEE80211_STYPE_PROBE_REQ)=0A=
> +             dev_dbg(purelifi_mac_dev(mac), "Probe request\n");=0A=
> +     else if (buffer[0] =3D=3D IEEE80211_STYPE_ASSOC_REQ)=0A=
> +             dev_dbg(purelifi_mac_dev(mac), "Association request\n");=0A=
> +=0A=
> +     if (buffer[0] =3D=3D IEEE80211_STYPE_AUTH) {=0A=
> +             dev_dbg(purelifi_mac_dev(mac), "Authentication req\n");=0A=
> +             min_exp_seq_nmb =3D 0;=0A=
> +     } else if (buffer[0] =3D=3D IEEE80211_FTYPE_DATA) {=0A=
=0A=
maybe a switch statement would be better anyway, but this "interrupted=0A=
else-if chain" looks really weird.=0A=
=0A=
Not sure I'd add any of this in the first place=0A=
=0A=
> +             unsigned short int seq_nmb =3D (buffer[23] << 4) |=0A=
> +                     ((buffer[22] & 0xF0) >> 4);=0A=
> +=0A=
> +             if (seq_nmb < min_exp_seq_nmb &&=0A=
> +                 ((min_exp_seq_nmb - seq_nmb) < 3000)) {=0A=
> +                     dev_dbg(purelifi_mac_dev(mac), "seq_nmb < min_exp\n=
");=0A=
> +             } else {=0A=
> +                     min_exp_seq_nmb =3D (seq_nmb + 1) % 4096;=0A=
> +             }=0A=
=0A=
don't need braces=0A=
=0A=
> +     memcpy(skb_put(skb, payload_length), buffer, payload_length);=0A=
=0A=
skb_put_data()=0A=
=0A=
> +     hw =3D ieee80211_alloc_hw(sizeof(struct purelifi_mac), &purelifi_op=
s);=0A=
> +     if (!hw) {=0A=
> +             dev_dbg(&intf->dev, "out of memory\n");=0A=
> +             return NULL;=0A=
> +     }=0A=
> +     set_wiphy_dev(hw->wiphy, &intf->dev);=0A=
> +=0A=
> +     mac =3D purelifi_hw_mac(hw);=0A=
> +=0A=
> +     memset(mac, 0, sizeof(*mac));=0A=
=0A=
no need, we use kzalloc() internally.=0A=
=0A=
> +     hw->wiphy->bands[NL80211_BAND_2GHZ] =3D &mac->band;=0A=
=0A=
This is kind of the only fundamental problem I have with this ... are we=0A=
really sure we want this to pretend to be 2.4 GHz? You only have a=0A=
single channel anyway, and you pretend that's a fixed one (somewhere=0A=
above, I skipped it)...=0A=
=0A=
But it really has absolutely no relation to 2.4 GHz!=0A=
=0A=
OTOH, I can sort of see why/how you're reusing wifi functionality here,=0A=
very old versions of wifi even had an infrared PHY I think.=0A=
=0A=
Conceptually, it seems odd. Perhaps we should add a new band definition?=0A=
=0A=
And what I also asked above - how much of the rate stuff is completely=0A=
fake? Are you really doing CCK/OFDM in some (strange?) way?=0A=
=0A=
> +     _ieee80211_hw_set(hw, IEEE80211_HW_RX_INCLUDES_FCS);=0A=
> +     _ieee80211_hw_set(hw, IEEE80211_HW_SIGNAL_DBM);=0A=
> +     _ieee80211_hw_set(hw, IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING);=0A=
> +     _ieee80211_hw_set(hw, IEEE80211_HW_MFP_CAPABLE);=0A=
=0A=
Why not use the macro?=0A=
=0A=
> +     hw->extra_tx_headroom =3D sizeof(struct purelifi_ctrlset) + 4;=0A=
=0A=
Ah, so you _do_ have a struct for all this header stuff! Please use it=0A=
where I pointed it out above.=0A=
=0A=
> +struct purelifi_ctrlset {=0A=
> +     enum usb_req_enum_t id;=0A=
> +     u32            len;=0A=
> +     u8             modulation;=0A=
> +     u8             control;=0A=
> +     u8             service;=0A=
> +     u8             pad;=0A=
> +     __le16         packet_length;=0A=
> +     __le16         current_length;=0A=
> +     __le16          next_frame_length;=0A=
> +     __le16         tx_length;=0A=
> +     u32            payload_len_nw;=0A=
=0A=
having a mix of __le32 and u32 seems weird :)=0A=
=0A=
but not sure you ever even converted things, did you run sparse with=0A=
"make C=3D1"?=0A=
=0A=
> +struct purelifi_mac {=0A=
> +     struct purelifi_chip chip;=0A=
> +     spinlock_t lock; /* lock for mac data */=0A=
> +     spinlock_t intr_lock; /* not used : interrupt lock for mac */=0A=
=0A=
well, remove it if it's not used?=0A=
=0A=
> +     /* whether to pass frames with CRC errors to stack */=0A=
> +     unsigned int pass_failed_fcs:1;=0A=
> +=0A=
> +     /* whether to pass control frames to stack */=0A=
> +     unsigned int pass_ctrl:1;=0A=
> +=0A=
> +     /* whether we have received a 802.11 ACK that is pending */=0A=
> +     bool ack_pending:1;=0A=
=0A=
bool bitfield looks really odd ... what does that even do? I think=0A=
better use unsigned int like above.=0A=
=0A=
> +static inline struct purelifi_mac *purelifi_chip_to_mac(struct purelifi_=
chip=0A=
> +             *chip)=0A=
=0A=
I'd recommend writing that as=0A=
=0A=
static inline struct ... *=0A=
purelifi_chip_to_mac(...)=0A=
=0A=
=0A=
> +#ifdef DEBUG=0A=
> +void purelifi_dump_rx_status(const struct rx_status *status);=0A=
> +#else=0A=
> +#define purelifi_dump_rx_status(status)=0A=
=0A=
do {} while (0)=0A=
=0A=
> +#define FCS_LEN 4=0A=
=0A=
might want to reuse FCS_LEN from ieee80211.h, i.e. just remove this?=0A=
=0A=
> +struct proc_dir_entry *proc_folder;=0A=
> +struct proc_dir_entry *modulation_proc_entry;=0A=
=0A=
You really need to remove procfs stuff, even these traces ;-)=0A=
=0A=
> +     switch (urb->status) {=0A=
> +     case 0:=0A=
> +             break;=0A=
> +     case -ESHUTDOWN:=0A=
> +     case -EINVAL:=0A=
> +     case -ENODEV:=0A=
> +     case -ENOENT:=0A=
> +     case -ECONNRESET:=0A=
> +     case -EPIPE:=0A=
> +             dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status=
);=0A=
> +             return;=0A=
> +     default:=0A=
> +             dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status=
);=0A=
> +             goto resubmit;=0A=
=0A=
you might want to limit that resubmit loop here to a few attempts=0A=
=0A=
> +     buffer =3D urb->transfer_buffer;=0A=
> +     length =3D (*(u32 *)(buffer + sizeof(struct rx_status))) + sizeof(u=
32);=0A=
=0A=
endian issues=0A=
=0A=
> +     kfree(urbs);=0A=
> +=0A=
> +     spin_lock_irqsave(&rx->lock, flags);=0A=
> +     rx->urbs =3D NULL;=0A=
> +     rx->urbs_count =3D 0;=0A=
> +     spin_unlock_irqrestore(&rx->lock, flags);=0A=
=0A=
That looks ... really weird, first you free and then you assign the=0A=
pointer to NULL, but under the lock?=0A=
=0A=
I guess the lock is completely pointless here.=0A=
=0A=
> +void purelifi_usb_release(struct purelifi_usb *usb)=0A=
> +{=0A=
> +     usb_set_intfdata(usb->intf, NULL);=0A=
> +     usb_put_intf(usb->intf);=0A=
> +     /* FIXME: usb_interrupt, usb_tx, usb_rx? */=0A=
=0A=
what about them?=0A=
=0A=
> +     dma_buffer =3D kzalloc(usb_bulk_msg_len, GFP_KERNEL);=0A=
> +=0A=
> +     if (!dma_buffer) {=0A=
> +             r =3D -ENOMEM;=0A=
> +             goto error;=0A=
> +     }=0A=
> +     memcpy(dma_buffer, &usb_req, usb_bulk_msg_len);=0A=
=0A=
kmemdup()=0A=
=0A=
=0A=
> +static int pre_reset(struct usb_interface *intf)=0A=
> +{=0A=
> +     struct ieee80211_hw *hw =3D usb_get_intfdata(intf);=0A=
> +     struct purelifi_mac *mac;=0A=
> +     struct purelifi_usb *usb;=0A=
> +=0A=
> +     if (!hw || intf->condition !=3D USB_INTERFACE_BOUND)=0A=
> +             return 0;=0A=
> +=0A=
> +     mac =3D purelifi_hw_mac(hw);=0A=
> +     usb =3D &mac->chip.usb;=0A=
> +=0A=
> +     usb->was_running =3D test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags)=
;=0A=
> +=0A=
> +     purelifi_usb_stop(usb);=0A=
> +=0A=
> +     mutex_lock(&mac->chip.mutex);=0A=
=0A=
this looks kind of problematic locking-wise=0A=
=0A=
> +static int post_reset(struct usb_interface *intf)=0A=
> +{=0A=
> +     struct ieee80211_hw *hw =3D usb_get_intfdata(intf);=0A=
> +     struct purelifi_mac *mac;=0A=
> +     struct purelifi_usb *usb;=0A=
> +=0A=
> +     if (!hw || intf->condition !=3D USB_INTERFACE_BOUND)=0A=
> +             return 0;=0A=
=0A=
especially since this doesn't always unlock?=0A=
=0A=
Not sure intf->condition can change inbetween, but it looks very=0A=
fragile.=0A=
=0A=
> +#define TO_NETWORK(X) ((((X) & 0xFF000000) >> 24) | (((X) & 0xFF0000) >>=
 8) |\=0A=
> +                   (((X) & 0xFF00) << 8) | (((X) & 0xFF) << 24))=0A=
> +=0A=
> +#define TO_NETWORK_16(X) ((((X) & 0xFF00) >> 8) | (((X) & 0x00FF) << 8))=
=0A=
> +=0A=
> +#define TO_NETWORK_32(X) TO_NETWORK(X)=0A=
> +=0A=
> +#define TO_HOST(X)    TO_NETWORK(X)=0A=
> +#define TO_HOST_16(X) TO_NETWORK_16(X)=0A=
> +#define TO_HOST_32(X) TO_NETWORK_32(X)=0A=
=0A=
Remove all of that.=0A=
=0A=
> +static inline struct usb_device *purelifi_usb_to_usbdev(struct purelifi_=
usb=0A=
> +             *usb)=0A=
=0A=
indentation per above comment=0A=
=0A=
johannes=0A=
=0A=
