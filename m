Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D3A31B649
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBOJRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:17:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:56411 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhBOJQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613380619; x=1644916619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HmWPijra70N984gfeHw2SKXy8MScufhnAwNfGkvEIOg=;
  b=lQo+/cPglst0AYwfjlwLO8+p5PiPs1FR35Fvj0VajXiLmq1X/k2epyuU
   ZIc7YsXPGR8rgpXCXVBT+T42Qwn1YXcpmnA1UY3qmtY9uAbfto/hJxS6J
   U7mxuRcDBC0Y6TA3LyTD7ooOfmY0UU+fQH28mvxVKNL+vEfp7EgnYd2W2
   h137m/OVBNjgkYBDcG9WRMZebrsjvb3AHaM65JzrIZFm3BONOqv5O+oeQ
   UaeRzNaTDmLwv2XjPiOZNhpMJfCpaJ2WBVMFi+0JwiD7kqFP1DUxFtEwh
   Rkwv4y8Efr1aa2+ENuk6frhX7haVeqCjXo+DPvBsDRHGtUIe3+KjnkJcc
   A==;
IronPort-SDR: Ux/UUfEYmdgENMbc4+UVd6nOnE4KawFq1hOzf51u6vUJ4rprdSwekHXTUL6ochISdTw1LCPUNc
 1Dle8KKhj8saBA9fuha9eoNFzm6BkEvZS3MpPPKhxIbCDAXmxrIIle3XmjYo71JSRqHtuUZJdl
 e5S64ibbVHXMSvbXZ0yOsdtKXmPbTm8bfugeyTh1s7g6nrTZqAEETK+JWCsCj9ey7CEOTCd729
 POgY5caGLeyYnw5bjGAZehRYOyY9A9PtqW90R9s08mmFHnoC5kg6q9yeY+L8fM5uXz+ZPiS2WX
 CZU=
X-IronPort-AV: E=Sophos;i="5.81,180,1610434800"; 
   d="scan'208";a="103760687"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 02:15:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 02:15:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 15 Feb 2021 02:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsT3LLbJupVKRpGVWhjKrnLmLKBg0DYBzRNtNSKco7MxQO+c4ahfRdxCcMV/+nDuuxThlw1KMlYKDBpf0hguZAjLHslVTsaCaBpVrNZthQWGPrRYRFlQQgL7R2X7MJKVpR81oxWVz/shF0YUPTFKCAZP5AiKjEpLriFOVvClcmdTBszbspGYJCc1bAEE+F5iRLaxlr6qYg+XV1FA59DODC7nA1Wf6YMlHG/btBZ91NJENvLXeCngZLlRIjzE0gsZngc0sHYurerDCH+gmdRGy6NluLs+52Q9fjC1Q7ofi0xvO5SJgnIrem4PAXvFx+wOa46kP03q9pKkt1K1hOcxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmWPijra70N984gfeHw2SKXy8MScufhnAwNfGkvEIOg=;
 b=lMou3mOcWsbBmN3VYz5nCW6R00uIYCw0jtWeKDzHdhz3AV5Hm9KzWCZ+lXnudYdWtHfjYeHnp6BpMHX0p1ajnjjvcdNDJH3Xbb6G1ut9hFDS1CehuU97BPLK+lVNTCASpAZNCeninSTKZxo+t2MxkfvHdN1f8lvjENSHcW1JESDkLTMbCXzSJfugnvEjHMeehAnZE5PFzv3/sVRGJEvDaEstfE4fd1/K8m1+qiqbNFZNq4obgJNSfOlaFFeec6EnEey0+xLW8Q33lSTG/lDc+VB7eC5fTkj+mjrjZKPXA0ea7x8AvwellZWTQyjNOmyxUSTVZIcFw3sQ86sjr+JEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmWPijra70N984gfeHw2SKXy8MScufhnAwNfGkvEIOg=;
 b=ApmMZw7ZpjimChH3i7cdnuNWV7AOLLwXzkq9lLbUXKjmaXSLojCm1WCn8nyWCNbzO2xZlm+XJM6UDNQoSChEVONa0WpKzBQ3E6D1ifbJwq7sled8IUDcJ3UNHUZEBGgJBvXGe61CnX3Zsf3xVlX3Nkx+FKBM/EGt+3P8aUhRznI=
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com (2603:10b6:3:9e::23)
 by DM5PR11MB1529.namprd11.prod.outlook.com (2603:10b6:4:b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.26; Mon, 15 Feb 2021 09:15:41 +0000
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9]) by DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9%11]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 09:15:41 +0000
From:   <Bjarni.Jonasson@microchip.com>
To:     <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Steen.Hegelund@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <vladimir.oltean@nxp.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <atenart@kernel.org>, <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Topic: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to VSC8514
Thread-Index: AQHXAUhdJHjYZpRQGkCBgBTJu+lKnapUop6AgARREwA=
Date:   Mon, 15 Feb 2021 09:15:41 +0000
Message-ID: <0ca9c6ce3ec7d49b03367413103a3c1f152ab546.camel@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
         <YCacux8K+ocWbRQ2@lunn.ch>
In-Reply-To: <YCacux8K+ocWbRQ2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7471e596-f411-40c4-e1e1-08d8d192442b
x-ms-traffictypediagnostic: DM5PR11MB1529:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1529EEA0DEAF9F6E6327C619E4889@DM5PR11MB1529.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AXVHG9EMEetcw/zBDXeSuL59zPtRq30sJmTFoBTQ/nfe7qlsFtS3pqpiRVQHTaDVqs/YTxVhwgBi3SYTdtx+uxkgmmkMNEszBKhAX2kfhYZybcgXeEwSaQAbTxAldieyBmcKa9+TH96xl8BFYKdmWHbSwAwtwwLnEh93XJbFw4MjdHfZWQVtSxzWdeAbH1uzwAEfgLuH1Oe2v+pDAXvw9F6NPkiFHK7i5ORk0Pi0kl/ykiSrsVgvUKWgu2MsWKK/5mGv8i8J2WSg4CjZZmtTa07dOcIIdO5jXprvvO8H8F7DMEtD9YarIogrAYkSvDYl4g9UJRI/wUyhELLQ3QqXVLqL3FLQuzyrV2muL0+m+7MSRE7WfQWKeGQduVUL2DJjQC1idtOKBEN1Z6lpwJlgY3V/w9+VmkpNfBd7vWAfZpAbBoQPZqXC9AkOmJ6Y/73Ob31Vr9nW/+qrfUd3mMH7YJDQk99ocXoErgfqyYZECxxJY9+Nw1wIj94SKcpjcdQbZ4jUtb6aLRfVET56uaWqSZ6aCHzrHzqa+dwUvZp90N5Va0onK7UJuGPUczBgJFKy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2329.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(136003)(39860400002)(6512007)(36756003)(8936002)(6486002)(2906002)(478600001)(8676002)(83380400001)(7416002)(66446008)(54906003)(86362001)(4326008)(316002)(6916009)(6506007)(2616005)(66556008)(26005)(186003)(5660300002)(71200400001)(66476007)(66946007)(76116006)(64756008)(91956017)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c3l0QURTY0tkSUJCVmQvRnYrMkVnSzAzQkk4Y0ZodTl6YVZXUzR6VjZNNlJP?=
 =?utf-8?B?dVplK2FkaGRyTDBVQXl2WmEzNmpWRm9LbFU3akZNNnRGcjl3ZGNTM3dMUDdW?=
 =?utf-8?B?Ky9BY21PSURMMEpBakpvNFdubkp0S29iUUdCa0xOdmQ0amRtVGJzZzlKeExN?=
 =?utf-8?B?a2VZdUc3dWpOaEZyYkdjbHRLd3BqR3V5c0p6NEJENlBJSGZ2amRZY1lCellI?=
 =?utf-8?B?cEZxR1F2T2NXWWdBY3RHQ1BQb2dXa245QTM3WC92RnUydjRNU2tzU045SmI0?=
 =?utf-8?B?TnhEckh5U1R0ZG53SXdDL1V3QW5CZklMUjZmNmJrU0hlQmlRUit6SWVmSWlz?=
 =?utf-8?B?R0UrTlA1ekxXT0J4SUp0eGZqb21GWDBsNUh6SHFyTW44MFRJTTN1Snh1MzVk?=
 =?utf-8?B?cTRGNWdXL0l6QisxbzV3RW4rK0p3aDUydzAvbkFRWXVId2hFaGtrME0xUE0y?=
 =?utf-8?B?YjFlNThCTi9zemoyaUtQMm1qRHYxRFZUV3pPRzFvUFhrQmZGR01ZSXYrMnFY?=
 =?utf-8?B?aVR0QUZrVmFsWG1XVkd5Q011dE1aSCtpWktEa0lKTG52MmN0MjFqYjluNEZN?=
 =?utf-8?B?TUxzK2pjZ3dJUW1qYmk1Y1VYM0pFYlNXb3lIa0xIbjBiMk5tb0lPaVUrMTMv?=
 =?utf-8?B?Q1ZEbXpNNjl6MWZjdXFmaERqVUxxSkRIQVpzWVFYRVNvRHVoUDVZRlo3WmxD?=
 =?utf-8?B?VnhpUE9QaWlyRENlZzNrb09keFpYSUMxRjkrSWdBSDNuNGRhQ1dsOXY4OTNX?=
 =?utf-8?B?TjN6TVVoQkhBUmM1RHVWd1QrWDVIYlN6TEhBUVcweXF4bVp1SEJWYS9MZ202?=
 =?utf-8?B?eWVZY2x2VlNRbDZIYTdzdXpITEJQTXJFaFIrUytBKzNMdVdlMDVqVElHYUZm?=
 =?utf-8?B?bE1wOWpVWklnZHBjVVhGV05EOTRTUHNkcWx1V2ZSZ1dWNkFyUHZ0WG80dEMv?=
 =?utf-8?B?UE1qRitFeE1YNUdKU1lXaGw3cVFMT2JLUTJDdUtvZHhaajZ6VFhpeU93WlNF?=
 =?utf-8?B?R1RWdVloZ01HY1k5b0dZU0h2NGowVXhxb3VZNUJlSFhnL1NUN0U4LzBhb1BI?=
 =?utf-8?B?dEJlcUFjRklWYSttVll1bmlWMFhtbmJGZ2w0NXpjdUwwdllQMExXMHAvL0lS?=
 =?utf-8?B?enhUMlBhcXJROE9lN3dzWVNtbmFtTUtHM0RoWDhiM3drNU9PY3hGSCtoTXRU?=
 =?utf-8?B?SzVpODRuT2FhYWNndlVHR1JWcDQxcW1pc1RpOE9QQWdiTVRPeFQ1SUxCZnNv?=
 =?utf-8?B?NmZQQlpQZkpCS0xuc0hxdGRKNVlMY0NRZ2lWdDhTNGIybTRoelpkWHVHUmp6?=
 =?utf-8?B?eldMWWg3cGIvSkNxUXUzMVFOV0tsUk1PamIvNXB6QmJ4ajFDd1gycmE3akly?=
 =?utf-8?B?a0N5NTV4OG1pdlBOTnAwVjhxYzRKTS8wY283b3ViMndmdFJSN3M5TTNIU2ZG?=
 =?utf-8?B?UThCbkFLR0o5bDkyd3ZWOEkvY0NpVUZEem9zWmI4V2FHMm1wTWsvL2pJSHNq?=
 =?utf-8?B?QXBSWmRtMVQwcFZVcVRvelJMVVlBRGpsNnhSZzMzbDN5a25VSzAzWnN5Vkxi?=
 =?utf-8?B?K0Zhby9WMzNXYnpMS3FWRFRCbXF3MEVZYlVsVVhJYlhwUjlRZ1VzYzVucHZa?=
 =?utf-8?B?Y3dVREdPNmRYNXVvOWlmcWlMalJjY1ByYVlUTWhCMlJIVlRYTjdzV2ViQ3B0?=
 =?utf-8?B?Y2RLeDh4cXEraUlrdkdER3M1WWtDdnVCbVQ1M1kzLzJtazlwVXZTNk40cENk?=
 =?utf-8?Q?1FS8ksN3db63TCJys2/zkxFqi4mTF/XtI0Gl6fs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FE884D08113494990ADCF5D59EFEB0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2329.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7471e596-f411-40c4-e1e1-08d8d192442b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 09:15:41.0952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVIxEYdri6nmnsjTOZlen7lF43xpDgdxNk4ZJcekJ3/vFNtmQf7iTD4WhSPr3A/6kpux0bRspW1B0VI2xnDPA+/lBZmnxZmd1L+MSvRLq4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1529
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTEyIGF0IDE2OjIwICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIEZlYiAx
MiwgMjAyMSBhdCAwMzowNjo0MVBNICswMTAwLCBCamFybmkgSm9uYXNzb24gd3JvdGU6DQo+ID4g
K3N0YXRpYyB1MzIgdnNjODV4eF9jc3JfcmVhZChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBjc3JfdGFyZ2V0IHRhcmdldCwgdTMy
IHJlZyk7DQo+ID4gK3N0YXRpYyBpbnQgdnNjODV4eF9jc3Jfd3JpdGUoc3RydWN0IHBoeV9kZXZp
Y2UgKnBoeWRldiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtIGNzcl90YXJn
ZXQgdGFyZ2V0LCB1MzIgcmVnLCB1MzINCj4gPiB2YWwpOw0KPiA+ICsNCj4gDQo+IEhpIEJqYXJu
aQ0KPiANCj4gTm8gZm9yd2FyZCBkZWZpbml0aW9ucyBwbGVhc2UuIE1vdmUgdGhlIGNvZGUgYXJv
dW5kIHNvIHRoZXkgYXJlIG5vdA0KPiByZXF1aXJlZC4gU29tZXRpbWVzIGl0IGlzIGJlc3QgdG8g
ZG8gc3VjaCBhIG1vdmUgYXMgYSBwcmVwYXJhdGlvbg0KPiBwYXRjaC4NCg0KU3VyZSwgSSB3aWxs
IHJlbW92ZSB0aGVtLg0KDQo+IA0KPiA+IEBAIC0xNTY5LDggKzE2NjQsMTYgQEAgc3RhdGljIGlu
dCB2c2M4NTE0X2NvbmZpZ19wcmVfaW5pdChzdHJ1Y3QNCj4gPiBwaHlfZGV2aWNlICpwaHlkZXYp
DQo+ID4gICAgICAgICAgICAgICB7MHgxNmIyLCAweDAwMDA3MDAwfSwNCj4gPiAgICAgICAgICAg
ICAgIHsweDE2YjQsIDB4MDAwMDA4MTR9LA0KPiA+ICAgICAgIH07DQo+ID4gKyAgICAgc3RydWN0
IGRldmljZSAqZGV2ID0gJnBoeWRldi0+bWRpby5kZXY7DQo+ID4gICAgICAgdW5zaWduZWQgaW50
IGk7DQo+ID4gICAgICAgdTE2IHJlZzsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiANCj4gSGFyZCB0
byBzYXkgZnJvbSB0aGUgbGltaXRlZCBjb250ZXh0LCBidXQgaXMgcmV2ZXJzZSBjaHJpc3RtYXNz
IHRyZWUNCj4gYmVpbmcgcHJlc2VydmVkIGhlcmU/DQoNCkkgd2lsbCBkb2JiZWxjaGVjay4NCg0K
PiANCj4gICAgICAgQW5kcmV3DQo=
