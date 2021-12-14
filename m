Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73652473D60
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 08:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhLNHAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 02:00:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:50198 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhLNHAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 02:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639465241; x=1671001241;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Y/FMfiHJIrz7R0YNFd7EjbkndSGsqq+Ms9T4mV8fxiA=;
  b=afASr0dPXEBYVJgYsktdY0xJiQPA8RhKhFNRfXosOiU8a2w3B+eNMLpZ
   bFMknt7bOC1cR3bgQ/PW/G+4UDK0MaLFN/SlaTk7Nza5onjD0YOScIVM0
   gcttYA3p2xvrzy9BJOqiGc9jlUvjEXITE+B/qOnuuWhCsvV7f1ug0trm/
   tZL374fHxmYiYgU/IUN49mXGLocNHxJCf0ikHsGtafa79ZbJl0LtqfEat
   mwozrRkl/txndsuGSx6rx5GjbpPoiEO5wkx/Mdg6AlSoKFJmdQiy5PfT5
   H9L6p/RSIPn3xG5cvBIcMzlfX6qC3E3UvJi0rGb/JI6Xve1RGavEsUMLL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="219597764"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="219597764"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 23:00:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="752768111"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 13 Dec 2021 23:00:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:00:40 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:00:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 23:00:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 23:00:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNhVL2z7iagr+82NiL7ZXTo1al06yC7/pl+96Bdpkb84IiKYNCn7ZSoPs9KaKLLPtNT7aRmREWdd39DwpxQkbJbMxAy0Fp3YeOBecqIzV0vELy6T3X6mQEBhjkS8P3Sj8wM1Mcwm9wYxsO7l8OqyEFxgD2+M1GP+MWmNkl6Ifx0hEh4n6LC7sFZNDy8o3NdbBJEnTxjuUGkzyPrY2snWVGZ0z1ou+38+gsTantKSdWmHSoKtoVA3PteaJ3sI3fvpffVLS0DFuWUHF6YEvLOV3UiMCUeet34M5R7noeT95VtpFU03Yt5vHiCnrmR72RIBzFZj2QcgSHXCefQ8T8Xvlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/FMfiHJIrz7R0YNFd7EjbkndSGsqq+Ms9T4mV8fxiA=;
 b=KwGRPJ/3snDS0fqylV8jUCByYIwaoGhXY+t4NHtZTX2FQGBHv/m5qwqxtAdcHuiUi+v1DqJeWLZju4GSJnetNP0ZgvopJ0GFl+l8h0orXy4jzGGfz0TJAXLOgRUwbompjLJawsyzZX0/anLheK95PMYEQpDB8PbL4vcVAYGGn3NHkmp35cG21TcA/j/+qvVwE61WwvhpJ+G6wbw9UTiCc81fxeGzhBEw1do3+K+f+0eNAc6Md4bdRnDCzgd98hACXjgB5fFl7Yi4UNIHgvrbK4KKYx74+gd1hoE9FOJ7ICbiiYZjj71ul0EGdu7RJk0RexCwI+Z+qPMLVXPHYg6upQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/FMfiHJIrz7R0YNFd7EjbkndSGsqq+Ms9T4mV8fxiA=;
 b=nqiDZRyqyqiWzdXj3LP8dQgBwa57Io6d6ASiw9+cWiJ+SD4hHcSpPndF8u+QkSorbIe/2i7XLyS+QD+v8iQxhexzvSTl9+Z0jzkhu4AECwmo9hARaDYhAty21pFSnCVSl16FUrlCTthu8CwAVlDD8TIhHNFihKK/McJdQpaWT/4=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 07:00:37 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%8]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 07:00:37 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Topic: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Index: AdfwtmkvCyrAW5M4S3mERBKDxICdHA==
Date:   Tue, 14 Dec 2021 07:00:37 +0000
Message-ID: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c2f8307-752b-4cbd-14ad-08d9becf6ecc
x-ms-traffictypediagnostic: MW5PR11MB5881:EE_
x-microsoft-antispam-prvs: <MW5PR11MB5881120A8FE540F11F6F037BD5759@MW5PR11MB5881.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIrxnHymSFky/6i2BHHaTgCtz2ZfPLBBFhOF5TTt3EqtbQFvZdqrdTmC6CvZnP0Doo8KoRW88T23j+fBn52C6WvvI+rVL8zblEKnpKNz8OpibFFJwSzOslgAiUR7OCeEOg1tv5jI4OxWKOd7FWI4jz6+mKvhHNKlwo9YejB+jAN4PMUWzrJvKVUQgvivTutGjKz2gLvYn9R/KmGhs3nhRQS+1XIkd9B3Jtd5hGIpO8qB2MtkEn4eEAguEPbQPDMJ4Or8L6VXtb+Hiun5ROB8SKvlB7Wjk2n60IADkHUetYc/T5jpFpCThOfTR1PVgmzUlPA0I/Hde51+rMmXDde3K6WqEuUpPuH5whEvhKgMDvnnhee6eDTt/1J5scLv29n91gCkWfh+yDi3xOHyTBjBJ69mBRj+kftvFgbgyIka0ZFhIa8e30EH87D42LMb6xM1juINRnb/jfPzqrMyv7lW7TvuLBWb7B1rPJJj6f6Bfhfei3wWlv7kwhyCG521hiMBViLGwennREK4ofWkJ09pNdxcjM2qgB2Dmr1Wz9snspwnyA8/BS83n7ZZT/fLM/KPm0dUmP+OqaiXfh4pl7K5DfHiQJ8Iw4pya0L2309urZ4ZPvPHMJ22/hV5FFDRUhlVSjDixex7LtuSiVmubktzAkKigu0qx0pPENDRlcvavdYsDJKzAP4fe4G2LXqsim8DoeMAQeTqT+vnrL9TU8Aa4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(508600001)(86362001)(9686003)(7696005)(76116006)(26005)(122000001)(2906002)(38070700005)(52536014)(66476007)(64756008)(4744005)(66446008)(33656002)(66946007)(4326008)(66556008)(6916009)(8936002)(71200400001)(6506007)(107886003)(82960400001)(316002)(8676002)(83380400001)(55016003)(38100700002)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l3zjKJTlnq+YJ3WWNNeeJPFEwKQgsMx3UvLs5pnMDykOSE/5VPV+lLc9rVOz?=
 =?us-ascii?Q?zlVJSjrXfLkBZ+Xz2qtDP/iOuHITaMo2gphDsRMsDuSc6I59YSRjZV7aLFfx?=
 =?us-ascii?Q?W3cJsE1M0bmzmzejy6/GurkMke/0SChviaDpAb50cOSEjzQBl0DvGmOhiBu9?=
 =?us-ascii?Q?5+kvGPWoHM6YpOJIVAugbw6+535ysF9u3VuJiG+wj+3YPXVacEOBjO5t/neZ?=
 =?us-ascii?Q?du+FQC55aoNouzmb3TcgPOxgaTiAr7B8ffV459E5pCmtRVs/Bvq2VGxsRxZd?=
 =?us-ascii?Q?34Z2uJIKa95ShoVApXHTP8I3jJsFsT+QUkOH+AAWCgkF7DPzTk+zNyUh2WMu?=
 =?us-ascii?Q?PeCA3CDWJWuOBpNADnT25uxpyC3kOiRf9XnYhCthF+w8lDRHHPCWekFCdC+/?=
 =?us-ascii?Q?PYOwyFTBco4CX9Dt2bBXSvLZM5Ig/UVVAgk11YE/YohA7+PXIBX54dneSBxL?=
 =?us-ascii?Q?BXgB+nR0eCtzQ00BMUO1wmf+6GC5U/hikgk6KRvPbu/x+fZ1ByGeUSQCWqTp?=
 =?us-ascii?Q?aOspsrVYCoJ0YpSR5IcollCKVDi1MGO6n3s0S0CDw3VnJ61BXeZWGAl3WKHW?=
 =?us-ascii?Q?Jzn5hpenTgWhxqaR8OIC5RC1HwpojpiiQW2ielwcZ72YjYp14INZghb8u2yf?=
 =?us-ascii?Q?PnfJp6eWm3ZKkq5M3V+Ns20qY8XGtUCDHtQy/NiA7y9tUKi82ebLERyt6tzs?=
 =?us-ascii?Q?nEAU3H8T7+/7BzBjKSwYmKKzt1rLKktBtH3akzRBmlkYnVKlUTGdyVWWIkvZ?=
 =?us-ascii?Q?ClgGbuZkhiDPY9SHYhW2EGYTJ/yuz4Kzp4IA+eR9B6aCRSn3rlDI/rPi3ptN?=
 =?us-ascii?Q?2WOmWh9m6yRZm6wlQwC+hfOcnJhsr+XZ9jSYCk0pXO2Jw4Kr9AQGy0D1mfP2?=
 =?us-ascii?Q?f7nmtcffyu9ybMA+5ff9FeEB1HDXwOZTLLMM0vHQQdiBPRYhrVCgdSJhwxvY?=
 =?us-ascii?Q?FRawSi2qgmn9ftjKsPadQIJu3XumXongJOlZW51rIyHsLwqoF2DkciKSBkRb?=
 =?us-ascii?Q?QB59MWXaTDqxu6TwbZeEBczZcbk9JpAtkPZzG1vtsm5Rw4vhAlnN7sSDk5r6?=
 =?us-ascii?Q?gQ47GHPEc2IwpN1VDu1Y7Zy/y1i1fjIPS+HWFW7GD26hNDEhXOF+bymGi5rv?=
 =?us-ascii?Q?+x1TDw2syv/Q3DWXMnellgdGhWxCt5RpMJEn1wSb+ipdw2wQOxQshRwXuaD7?=
 =?us-ascii?Q?kDZ4wxhAOFXA3vfJPzd7J64k49NOe4kDRGDP3R42on7zK1xK723kmkqmKGAS?=
 =?us-ascii?Q?/1d/8Qeu8DLTVV83xKp+5iWF9T7JiSmks/4ngZaG0VGGb80ZfqZcYudPuGn9?=
 =?us-ascii?Q?Y1KKQVKoF4o22YtkFS9R1xTvTdjtvEv6LIdq/yhA79HHb3rc+DfTyo3rKhhV?=
 =?us-ascii?Q?+CBVYuf2GWtYDdChS1KlrnZtGrN6RrMyRdxNV9JNfOyy1S9KyujEv34xqoZ3?=
 =?us-ascii?Q?BnCz17eV6aSSbUILol/GGal5JvSFU7P9/heK6GtD0ZjciiTJICCZxBDWZLvg?=
 =?us-ascii?Q?sKZSDkhFdMqcEZJ4m78FUSrPnYXBey+FU1zTzMfmev8NM3Urs1Ppyg1MmRow?=
 =?us-ascii?Q?HlKTGCRLVBt86lCbo3AHbQDGJ02Wn1vrSJLeBaRfgJfCL18DhJ7BcPKCn5VC?=
 =?us-ascii?Q?uAAR2iZw8SotHTjffYRqxRI9g8gO8nyndc4rrKDa8Ek5UApdaZd0LBbHBjUp?=
 =?us-ascii?Q?+rPIt7Xwf9q1aSfNXfc6irYLIvmjeoz+3+66AFlS4cgR0Djv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2f8307-752b-4cbd-14ad-08d9becf6ecc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 07:00:37.5016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kER846U2wjpLmWafy/cDdFfCIbnFkWmQxhUGn9bOBt4ScgRoP2v5BdiVDScPBcSRJfuwj+1dA34saO/qLO1IzrgBSywpiFu8fxl4Uzzcdl+O8jsQjCuU/QfXz9hBG+5t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5881
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

"net: phy: genphy_loopback: add link speed configuration" patch causes Marv=
ell 88E1510 PHY not able to perform PHY loopback using ethtool command (eth=
tool -t eth0 offline). Below is the error message:=20

"Marvell 88E1510 stmmac-3:01: genphy_loopback failed: -110"=20

Tested on Intel Elkhart Lake platform (Synopsys Designware QoS MAC and Marv=
ell88E1510 PHY). Kernel version is 5.15.x.

Reverting the patch able to fix the issue.

Thank you.

Regards,
Athari

