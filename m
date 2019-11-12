Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4013AF9B00
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKLUn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:43:59 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16680 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKLUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:43:59 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Bryan.Whitehead@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="Bryan.Whitehead@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Bryan.Whitehead@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 80qzxvo1Wuw12RtfyPFT20xGVZ4c5IZ9RX+Bnsv5/jKS82yji61IpqrHVjHNnD2LuO6uOY0ASX
 O1Ki4puYV7sJl6gtmBZ9PjvLE8UqkFfTkvQn+DrMrjKpdd6zGg/Xncw3zjQsx0W6G1SolJV3ka
 E8zPGXVWE9O84zGcY9Dcyy4SAOaxBa4KZkST+7/5F9A8Dj/F3ftbIPvCCWqS3m+hYfxwjXxejb
 x/wWUkxu4MIUHdG4lxj6rn8jdzwsWeoixQYEzY+M2lUYWM/vfLHw50yKHD6ZacheNVROtiXi/7
 7jU=
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="54004505"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 13:43:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 13:43:56 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 13:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lioVtLHkAM77kBYttxM+oMPHlCjcIp0L6k+rMjYRiie8s/Dt2apNIKc0JDvjzAazSsflfjSbOTVasQrdbkSAGVv+7H6akZ/KyCn8as0NGah7ASDOG4cWnemvjC99UuXDDv1htf0nTXbuWJCKjZjS/dp2mh5rtsLCI/WfGILfOZdH94onk0CVFg1qFky0U2JkoVmYD/jQV/EhzcViVcqTlAV8F1LvTFkCJcKddmjifXGo4tkl/wvKqBmklOfLXeo0fNNN1oBH4k8033L+uqd6onJroMe6hIbBpoafaw7x4y6UY8Yg6Skg7K7g1ZWE/7O0O9GZa/ieDMv8cuSSdbJeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gft74rA5/kVCB5Dv88xjXFd/YGgynHmFBVMm2gUKKK8=;
 b=PAO7JwBXjvn4bANdxP9euucTNL+G8rSVXp27ukZoIEP1eztM1ekZfvfLesHrRr6MJ1DtB9VC4LBrmGqHlRe2GUP4m9LhSr8ziN9sK8VfR/SWuV21VijaGKRDqchuciuSbnwPg7NwLB3V1wr+uV9Pic+UMx56iMLNwdFZ6A08zjfXl7nSxIx+SuBD86jD4rQWUB3ot4dZoQ0vDaPyLuLC9auet1K5M6icPOwmptI68I0ESZcdpHQ3JPpyODVliuRSx3HxMcjQXw3FTUl/6/ohjuKHswidHcqOOI9IwrZMcLUNx7muXa1WUWtaYdEK17Qd+oKcpWT5L9iaM9rcVQ6t5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gft74rA5/kVCB5Dv88xjXFd/YGgynHmFBVMm2gUKKK8=;
 b=TvOGTyodIqQXZP+XMKw7271XA+7uQD/T83gd4AkLJ8SCecg6sdoEPEGKpw6LaaTnAekIFM0sXPlid7RKZF7Mbl3jxHLglG+Vas/2wK5V1fvOx8r1b+jo+jfdGEWU1YloU9jR7scqu1cp3H5leoUnfMPvQkvjhbOhDDvISB6lokA=
Received: from MN2PR11MB4333.namprd11.prod.outlook.com (10.255.90.25) by
 MN2PR11MB4397.namprd11.prod.outlook.com (52.135.38.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 20:43:54 +0000
Received: from MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd]) by MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd%6]) with mapi id 15.20.2430.023; Tue, 12 Nov 2019
 20:43:54 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Topic: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Index: AQHVmXJIiwJOwhRbeU+HRtKC5Z72x6eH+9MAgAADSDA=
Date:   Tue, 12 Nov 2019 20:43:54 +0000
Message-ID: <MN2PR11MB433354EFACEDA615C14E4D16FA770@MN2PR11MB4333.namprd11.prod.outlook.com>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20191112.122544.356627523822808563.davem@davemloft.net>
In-Reply-To: <20191112.122544.356627523822808563.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52c5381b-cfc8-487a-bdda-08d767b10885
x-ms-traffictypediagnostic: MN2PR11MB4397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4397AB180CA88797601FABA2FA770@MN2PR11MB4397.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(136003)(39860400002)(199004)(189003)(5660300002)(4744005)(229853002)(25786009)(7696005)(71200400001)(102836004)(66476007)(66556008)(64756008)(76116006)(66446008)(66946007)(6506007)(6116002)(107886003)(2906002)(6916009)(4326008)(3846002)(71190400001)(33656002)(52536014)(86362001)(14454004)(76176011)(186003)(305945005)(66066001)(6436002)(7736002)(26005)(99286004)(55016002)(446003)(11346002)(476003)(74316002)(8936002)(316002)(81166006)(81156014)(8676002)(478600001)(6246003)(486006)(256004)(9686003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4397;H:MN2PR11MB4333.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xsmb9Ix2VlizlQyK0GFxs9xvoxLd9g0ttazPOeDL8yaq1QVMiMVAEOov2T8ymyAidrOTr/B8XugtuEdWYH1RX8h7kl2+CuEcL53lmQKFozWNCHxUiOfu4vb07OZvBfrXWOuDO29Jv2Us6VysCIqpJnegnqxZph1RXoQ4pmzLWTMX60fyFChKl5fToSwZv5DUGrnWjWN00TuLq8SltmWy27i1bJsLCUV1EdrV1EdCb1xf32e8oVac80ttBunAFckMzg7myqSDR+Uxwvz5bdDpVsjN5wC7GBvSuveDjS610P6XJJI4WA1sfmkiISbP9JCPqbml121RL+NWqDgREO8naFuJ9xxj9In5OKQnVi5vpzHTycvFa+n8+wCvHb0nLK4bDKvl6drK2GW8Pi5xTribs4kkencKI3P6qL9WwPgZlmtqhqnYXRvddulkPT0bEZ5J
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c5381b-cfc8-487a-bdda-08d767b10885
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 20:43:54.4080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGO8N5d+8PCfZd8vJp5WI9+5SlufpcNPmZMPToitlLpvXBBUFY/l4avWGPfefdT0MqcFLqq+G+uyAGH72iK9ZLk5IhH9q8oH9zeOobLLf40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Bryan Whitehead <Bryan.Whitehead@microchip.com>
> Date: Tue, 12 Nov 2019 10:54:08 -0500
>=20
> >  		phy =3D container_of(map[addr], struct phy_device, mdio);
>=20
> Unnecessary space added between this assignment and the test.
>=20
> > +		if (!phy)
> > +			continue;
>=20
> And this test makes no sense, the result of container_of() is never NULL
> unless it is for the first member of a structure of a NULL pointer.

Hi David,

I do have a NULL case, so I can check map[addr] for NULL instead.

Thanks,
Bryan




