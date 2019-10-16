Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4ED8FDA
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbfJPLpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:45:31 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:7113 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbfJPLpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:45:31 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Yuiko.Oshino@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="Yuiko.Oshino@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Yuiko.Oshino@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Yuiko.Oshino@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: yoZ5sfQnqvPL5Ccdi4QaCr8z5EYLTU/SOX4opgIG+d64XEtneCnOxhqXcwoX/BieORuPLZilQD
 wZoqgMsEKp5WiTV7TS+BE9ymLY+Ke5HPmUJ1GQ6Q2i6pnG8uYaNhHUNIk8SMHm5lJbLp0ZivD4
 0mPZVdURUOlXVJAilMNyHmX+peQaHStSVb78tiKzr5FTMA2cg0nAPtYsp7e7Lup2nkl+IMfrQZ
 zeV+PLB2xl4xF6oZHI1Bsr+teZHQ6ViDtgWwJczdenI9BD9XeV6gIL12m1cZRJNua4X3649lJh
 bBk=
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="54421467"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Oct 2019 04:45:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 04:45:28 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 16 Oct 2019 04:45:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+U7i2DNPBF4vVQJJ1oQWBtn3iw3ej/xaYsKHac/GTQcCuRimZVsgJzWC85PqcbIbf7+Vv4eTs61FIIphmVheCHgmMpvnddbZawQ6f2WtJs9ht8BejPAahPHTkfFqOPxm/HRF/zJWg4o0oM+IVmXXZYuULMWOfmqCGnbDWPi20ASK2GNlNy7YxwqMprsEkMAeSEW8W++CUoW8/FuWVgnEzHbn2Q8lTTJli1fU0bInoAkijrAGRZgrrhYyuhs1avVLtup2OcbJYqdYOUxQp/GzvR9NrwYBBu4ddBSNfg0YV+E6bPww26TW0/N0c3B5OHhadAAe6s9XhNVwSBnHw/E2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcxbM2FwSOxomGpukGyZ3hoOeE1IPz9Yzn2zsw4F7j4=;
 b=P0tGMw/0UegUHWYEmpvgTHU7F0kLShluIvwAoLMrNUdVmuwRCahjkH2aOn8s+e6gLY5YcKHVZx/RRZHcVuUjCO7mRCBnJ3LjB5l6umKJ8VERcsmDKs5OhKkt9yaKTTS7PWC9ZMkJEI8mLY4tz90l2uOx37PLp/PqjGy2+SDpFBYitBsBekWkS1QyhTYFPDRW0Kqs1j8HC6ImH7xclrE5rWjDvgK3Rt3WZWvNOqc6AdWuXLFqahKcsBuspNY+1vh6FSvpGgrS03gE6e6GhzuUiVS0sqnhNEWCyuHFZ+vhExvaxxMyLdE9a6n+j0DcWijQjTR+9H/HFGGasRBWNTWufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcxbM2FwSOxomGpukGyZ3hoOeE1IPz9Yzn2zsw4F7j4=;
 b=gBq8veDXyQay8wN8LdoNg6+1IRj1xVG8VsGLwZ+6q3/yEulWbFdFcw3CdxCCk1FG+gpaOXR+VK8jZs38t6bYnujcidocyvVYEFxmhIirq1b40g/qa9s/NHqUWFLrx4w5QjzARx67JQIEhGIOum/zOJXn+UtDc/1tKCO2yqur4hQ=
Received: from BYAPR11MB2791.namprd11.prod.outlook.com (52.135.228.21) by
 BYAPR11MB3846.namprd11.prod.outlook.com (20.178.236.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 11:45:28 +0000
Received: from BYAPR11MB2791.namprd11.prod.outlook.com
 ([fe80::e8ea:fa7e:747c:cba4]) by BYAPR11MB2791.namprd11.prod.outlook.com
 ([fe80::e8ea:fa7e:747c:cba4%4]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 11:45:28 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>, <Woojung.Huh@microchip.com>
CC:     <Allan.Nielsen@microchip.com>, <f.fainelli@gmail.com>,
        <Nicolas.Ferre@microchip.com>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>, <kernel@pengutronix.de>, <hkallweit1@gmail.com>,
        <Ravi.Hegde@microchip.com>, <Tristram.Ha@microchip.com>
Subject: RE: net: micrel: confusion about phyids used in driver
Thread-Topic: net: micrel: confusion about phyids used in driver
Thread-Index: AQHVBqYRcOEIH9dyL0OD1BCO0lH586ZjRcWAgAADbYCAAKvSgIBUKAwAgAAGD0CAOVhdgIAToemAgAFf6ACAABfQAIAAEcuAgFdOv4CAACrD8A==
Date:   Wed, 16 Oct 2019 11:45:27 +0000
Message-ID: <BYAPR11MB2791D145FD22C1FF0EBAE8108E920@BYAPR11MB2791.namprd11.prod.outlook.com>
References: <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
 <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
 <20190821184947.43iilefgrjn4zrtl@lx-anielsen.microsemi.net>
 <BL0PR11MB3012CC53F680EDF4C5146652E7AA0@BL0PR11MB3012.namprd11.prod.outlook.com>
 <20191016090955.np6m3heyv4qqdo4l@pengutronix.de>
In-Reply-To: <20191016090955.np6m3heyv4qqdo4l@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d7364c7-a66b-401c-f5e4-08d7522e5726
x-ms-traffictypediagnostic: BYAPR11MB3846:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3846A9AFF5CC731C22E252288E920@BYAPR11MB3846.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(136003)(376002)(346002)(13464003)(52284002)(53754006)(189003)(199004)(6246003)(5660300002)(55016002)(102836004)(52536014)(110136005)(7696005)(54906003)(6436002)(446003)(6116002)(305945005)(74316002)(3846002)(26005)(7736002)(6636002)(66066001)(107886003)(99286004)(476003)(11346002)(486006)(4326008)(6306002)(316002)(6506007)(76176011)(9686003)(229853002)(186003)(86362001)(66574012)(81156014)(8936002)(966005)(8676002)(81166006)(33656002)(14454004)(66946007)(66556008)(14444005)(256004)(478600001)(76116006)(71190400001)(66476007)(71200400001)(66446008)(64756008)(25786009)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3846;H:BYAPR11MB2791.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kubQR24qoRUuVdLG9pPNURid9ibE9D3q19i2CVhIaaVnJjXeZsD0E3QIMLDaAZhD+Oe1HVL8LhNT7ZiewtpJ0tq5c1ZIqoo11JBhpGDrJIRPvsnh3XigLmAgtZnpJT7WpEK66s0qAhk/LSaA/O4/Ul30jnhKCQNA57AHY1eIN8xQTG+P/9fp+3OS8AquSM//pM92uWXqUv9/uYDxdzh7Zyejq37AX7cFSDaGS3gZIkvKFcbGcjQzzTMu/Wvsf6cW3hL2tEM4ulgmwjzpdnhMZiJRMFW3VEBhWJrQmAEyAI1N0hhMADD+DcGHFvKCPT35aGGXfZUaFUU/o42Eu+JhCJiegTIq3Uc1kcuL/fI4Z+6GC9IBWL2ZAxUxL5/VNbM97WDqhsyyWawYtn0nIvwpkxKK832IygqhjcQhWQw9q3DZPaa04C8v15pLSFnYfPUe8Us9dAEL8/0MiC2CPImQuQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7364c7-a66b-401c-f5e4-08d7522e5726
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 11:45:27.8549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWiJhwNkj2Yd0ayg7bbe7qrjNifXOdmAvgvHNbOKW84rQzu1CwiBicXKKyHBbVlF4kTZvLKQPe8Eh4YTb7O1jdmZ4JpwR79xRt96ZCYaXew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

We are still working on this case.
I will feed your input.
Thank you for your patience...

Best regards,
Yuiko

>-----Original Message-----
>From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>Sent: Wednesday, October 16, 2019 5:10 AM
>To: Woojung Huh - C21699 <Woojung.Huh@microchip.com>; Yuiko Oshino -
>C18177 <Yuiko.Oshino@microchip.com>
>Cc: Allan Nielsen - M31684 <Allan.Nielsen@microchip.com>;
>f.fainelli@gmail.com; Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>=
;
>netdev@vger.kernel.org; andrew@lunn.ch; kernel@pengutronix.de;
>hkallweit1@gmail.com; Ravi Hegde - C21689 <Ravi.Hegde@microchip.com>;
>Tristram Ha - C24268 <Tristram.Ha@microchip.com>
>Subject: Re: net: micrel: confusion about phyids used in driver
>
>External E-Mail
>
>
>On Wed, Aug 21, 2019 at 07:53:29PM +0000, Woojung.Huh@microchip.com
>wrote:
>> Hi Allan & Florian,
>>
>> > > > So we're in need of someone who can get their hands on some more
>> > > > detailed documentation than publicly available to allow to make
>> > > > the driver handle the KSZ8051MLL correctly without breaking other =
stuff.
>> > > >
>> > > > I assume you are in a different department of Microchip than the
>> > > > people caring for PHYs, but maybe you can still help finding someo=
ne who
>cares?
>> > >
>> > > Allan, is this something you could help with? Thanks!
>> > Sorry, I'm new in Microchip (was aquired through Microsemi), and I
>> > know next to nothing about the Micrel stuff.
>> >
>> > Woojung: Can you comment on this, or try to direct this to someone
>> > who knows something...
>>
>> Forwarded to Yuiko. Will do follow-up.
>
>Nothing happend here, right? Would it be possible to get more detailed
>documentation about the affected chips than available on the website such =
that
>someone outside of microchip can address the problems?
>
>Best regards
>Uwe
>
>--
>Pengutronix e.K.                           | Uwe Kleine-K=F6nig           =
 |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |

