Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB894175A7
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345212AbhIXN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:29:05 -0400
Received: from mail-eopbgr100138.outbound.protection.outlook.com ([40.107.10.138]:6417
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345878AbhIXN2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:28:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsofP+kX1LoKCAfOb72J2pHDHFGxhId4y+H21nPuXzcVRqQKz+masvMgXPNkcX3Phzmhhtstz+PPQhUNqy8XLiDxbV+aH8dL7YXDgFWAQIYC2Oh2Q/m332BJPFB21RwqX1oQyxJwJjCjNOUwlFwtTR07OaflW4IYyfTt6eFPStIVKop9jF6j6kj8E0IC29eBXpXdc3yiuadm3DkBWF4ZIwk1UYRBfCUGd246KIoaE25eA/AHwNK1aO3hpXqrrMigD55XwRdU7uRIGeenKXV2V06ltIpeCgpmYEZgNDGu/HUwijAWYwtuqKX7TS6vC3WVIwafND5TZ03cVJPYsT16bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=77p0ikCdmzuRz3qbBEfKfTNm2e54iN+dBkfc5XWLdVE=;
 b=WY/d7RbCtrpw4hqNWabv/1ijc4lXVYWsg4YvyjvOJ41MMEkRqPOdiAUn3r3o5zajd9RBaur2Vg5DMqHvC7f3QRI2/k3hq75qakDsGKa3yPzcJYzBm9YY/Ftq9twkiDTV/bUbHEacb7xZPaxXaqOtzuB3byA5XYQBCWaxLxpK9DS+pRSeSK2rkHafh580hfVF4h3nDH2Hw0HoMGCPaGAKHkl5CI85q/xSRVB0S5rk8mbGE3sd5i7Snk3kf91JkZCW1OyYExnUBT2CKjgLkeu7HXEnlwv4THHsU9DBkvyNC/+u+dK/VFJ47g6gPuV+bhIXmp/anz6VIqCGeWjyEoVhbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77p0ikCdmzuRz3qbBEfKfTNm2e54iN+dBkfc5XWLdVE=;
 b=u4Bb4tJwvOZSpCs9lmBLqLFRiyulvHoEmU6bACmocSJ3ZIbYVoHqkf+GmXXftFAoOg2ZWzT702+gvCCmed12t6FL08ssnp5F7iWHPBqBYDYF7q6QsIwvAP2/dTYKH14GnbjMwgsQjUeO02rblOGQ/JqiLNtZUjPUbvrGXH2+IYc=
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWXP265MB2117.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:7d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Fri, 24 Sep 2021 13:27:15 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::7c2a:fab0:33ec:20b6]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::7c2a:fab0:33ec:20b6%6]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 13:27:15 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] [v15] wireless: Initial
 driver submission for pureLiFi STA devices
Thread-Topic: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] [v15] wireless: Initial
 driver submission for pureLiFi STA devices
Thread-Index: AQHXlDtMPQ6mbpowvECz4xZspmG0nautGLMEgAFQdYWAADiTt4ABPjQAgAOEzcc=
Date:   Fri, 24 Sep 2021 13:27:15 +0000
Message-ID: <CWLP265MB32175E7DE6201F5958510A17E0A49@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
References: <20210226130810.119216-1-srini.raju@purelifi.com>
         <20210818141343.7833-1-srini.raju@purelifi.com>
         <87o88nwg74.fsf@codeaurora.org>
         <CWLP265MB3217BB5AA5F102629A3AD204E0A19@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
         <87ee9iun4o.fsf@codeaurora.org>
 <e0522c7845390a71203744d209a9516cb8a562e6.camel@sipsolutions.net>
In-Reply-To: <e0522c7845390a71203744d209a9516cb8a562e6.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 1a08920e-7142-5f43-2e9d-e773062a2c15
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none
 header.from=purelifi.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 157af14e-d0f2-4d8b-2193-08d97f5f0635
x-ms-traffictypediagnostic: CWXP265MB2117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB21172318B09F4CA33893C27EE0A49@CWXP265MB2117.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +mK3sKgWt4BmWblFs/3Qu7AytkBSszj4VjUO5BMLd7sIbxl8jh/x0Wib79ozFefTQAObG5D1iBs9R1VYb7lzPfso/442Z7J7X2yWKPuWqrJ6lvfycqCd9hH7dZL0iEbZs6pAXbd9UdxK/Bx2j9ISdCprWv39+99i0w7EVg73dPaLWmLW06lWqPZ6UavEM9YXgeiTQbGRi6nbebK83AxZ/KM/at7oBNsmp7oSPID75Ew+Zx8Y4u9T7Ew221NroCVWOnFvHAFNuLVbmCl865mPuSgoQl5NJDPt6iUYmlWBFFkv8LJptXxkT+D6p0XKTEen2m3Ab4E47WL57eSJvjE0tCE2tPao9kYaMmQUmugH4NRNWKJmzqgFVbOrpmIu4ULzdVKJb3Xs1PpULw79GYjJoKef+BcmA6IiqQdX4tp8eD9i+/BgLqGLuoI+B+j0FMZ+fdhsuG/WdxeFHXBQ9ptfL9qtPhUX9pT3gCGqLaonZfMcc+hpYrexTLSAcESyUc5pBZuqY8MtlnAmeuhsDnaFC72Sg04TLgk2Te23CphCIsgR0g8X6C9YV3+UwHRYAlabruFUYz9Bp+hFbAFfl2496x36vLs7il+hZCyu6a69Pe3nQhhTthLxrWMdl1FR3ppaTbzUc1t2wnyohbmd7Qo/1fZv/84lqklhjwcNBfmItUuTPCt5FCdVGBp6W2jlPn/CuBFRjjgEMV/bXb8qK0jDew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(366004)(39840400004)(376002)(346002)(396003)(110136005)(508600001)(54906003)(6506007)(8936002)(5660300002)(66476007)(38070700005)(86362001)(7696005)(55016002)(71200400001)(186003)(83380400001)(316002)(91956017)(2906002)(66946007)(38100700002)(76116006)(122000001)(66556008)(64756008)(9686003)(66446008)(4326008)(33656002)(8676002)(26005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gZkXfe6MwSbjqPYIs81LfNw2BaxPs3XfLyJcCCkQ8oDI5r9lJeZzEFNi+k?=
 =?iso-8859-1?Q?+kKeqaYmmxCKkvCaOAJz2bciAEn8SWI7/Jh3JxCeUHxAE+zDv85kRxN/yr?=
 =?iso-8859-1?Q?WVf/z8mwPfJNkJ6O5yulwf40xKJSwgyGkEFdGAK50D7UVCYuetu9gwFYoo?=
 =?iso-8859-1?Q?GLlyjGNTUccT53uHpMnDaMCk3vDo+TKh6aWL1IOpCti32EFb+RwjRLNr6o?=
 =?iso-8859-1?Q?ia8bcz7Cs7YfyQmRU1wb6KCUJR+1BnVDINSZPkdnY/sA6hLMf/O/s7+FD3?=
 =?iso-8859-1?Q?dY3pcfwMMmP7C+AWH0GyZ7rSIDR4IspJGZZWROSnUZGKnVbZQwCfzW75cT?=
 =?iso-8859-1?Q?CFQ15HeZ8rLhKJYmHSgBpW4NiLJAvs0xZnW+0ESUrb8ZRdjS3vySO3zVqZ?=
 =?iso-8859-1?Q?tueQJK2MBfgFilw5UrSK67Oj6MtbcZd7izoPRT9zVK0EeooBqaBEayyO07?=
 =?iso-8859-1?Q?5KDUSyWNy7W0faXFtFjkBy2Pz5kBWMN3dfGA9Bf8AOreWVYJWA/6BOxW4s?=
 =?iso-8859-1?Q?D9lL1I0LbY2NuDfnYywYvRyDRJ3ERdkB7Sq1SXaok4FNOZl54IyRbxWiri?=
 =?iso-8859-1?Q?yYcaxm2FJBMntbo2nbL9iKgWcz6WT8yyoPOJ8ExKum1C/CHtVZ+8Bdns6n?=
 =?iso-8859-1?Q?neGLiJlp2AafrcGqH5dijdGkAwJa8v8iaJgZ8pJY5TLoPqVsT+8/QDEvEX?=
 =?iso-8859-1?Q?d1TyNjOomLOALusH7/ZVmz52sfbPDXL8hgFlB6Q6oEn4HROMaODmc5/+xl?=
 =?iso-8859-1?Q?OCn/kVyETf+adJlyGjbLNbu0iAahGhSqH5WHgv86c239xh9FsqJtRairU0?=
 =?iso-8859-1?Q?OkI6B3aEq8y78hz1tULUyrax/ybR/aB0/COjFxS1VctEIhFGHmuLRmQXkA?=
 =?iso-8859-1?Q?TzGn8cNztbhzM++/wlokSyaCZ6IlAfOypTIz1R33wYJHufFX57OUfjwzYN?=
 =?iso-8859-1?Q?aUNbjQ1/1oUcLOkO1hacTrMcI+v3dV54JjIxH0KA6OPaEN3o9cMCHEe0SO?=
 =?iso-8859-1?Q?oj9HNjkLGW3JG2quLh4rbFhZfcwYMED4EXZQtK2aAyO1JuxHRx9K6/lW1c?=
 =?iso-8859-1?Q?GE3R6oPI5OoTWlG0hGTH3LLJK48Hl+UsiPRxKqZCo85yKL9Bf8TVvs+oJt?=
 =?iso-8859-1?Q?NbGl9jaMxNACkIuqBAodJSnFMuQFq2Ac0n+Kpx8hS1wv1YAxtelGds9qlQ?=
 =?iso-8859-1?Q?iPUNoKxxInIesN1YZkeNgVH4idVWPy+AxPKuZIK9T8cZ1uND5z+JOYOePb?=
 =?iso-8859-1?Q?hZlr1l20zlTlyDmcyFewTvYzrEqh5vVvqOAS8INkENgujsrQTT0BrSUHpW?=
 =?iso-8859-1?Q?JWaIYwf/VTLhaEsdfIxlRf4RVO+a5BFdSmCPZoeo8+wN91U=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 157af14e-d0f2-4d8b-2193-08d97f5f0635
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 13:27:15.1874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VHkwoYnL6r92e9Fm1ul3Hru3P0faTuNz8rj9iwnrjUnHVb5EfkOVR37f57hvdcOWN0Ei9kxEWlpjgO7u3h4cyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >=0A=
> > Yes, I agree, As LiFi is not standardized yet we are using the=0A=
> > existing wireless frameworks. For now, piggy backing with 2.4GHz is=0A=
> > seamless for users. We will undertake band and other wider change once=
=0A=
> > IEEE 802.11bb is standardized.=0A=
>=0A=
> I don't see why the IEEE standard needs to be final before adding the=0A=
> band. Much better to add a band which is in draft stage compared to=0A=
> giving false information to the user space.=0A=
=0A=
> I tend to agree, but looking at the current draft (D0.6), that's ...=0A=
> vague? Maybe it's obvious to somebody familiar with the technology, but=
=0A=
> I really don't understand how 800-1000nm infrared band maps to 21 MHz +=
=0A=
> channel offset? Isn't the frequency there a couple hundred THz?=0A=
=0A=
> Regardless, if the channelisation plan says 21 MHz + n_ch * 5 MHz, then=
=0A=
> I think we can just define NL80211_BAND_LC and the driver advertises=0A=
> those channels - that even gets you easy access to all the defined=0A=
> channels (apparently today all the odd channels from 1-61, split into=0A=
> 20/40/80/160 MHz bandwidth).=0A=
=0A=
> I guess I'm really not sure how that maps to the actual infrared, but=0A=
> reusing all the 20/40/80/160 machinery from VHT means we can actually do=
=0A=
> a lot of things in mac80211/etc. without much changes, which isn't bad.=
=0A=
=0A=
> Anyway, I'd feel more comfortable defining an LC band here, even if it=0A=
> potentially changes later. Or maybe especially if the actual channels=0A=
> there change later.=0A=
=0A=
Thanks, I have submitted next version of the patch. I will study how to def=
ine NL80211_BAND_LC and other changes/tests required.=0A=
I will also consider other points mentioned and will reply / update the pat=
ch (or send addional pathces).=0A=
=0A=
--Srini=
