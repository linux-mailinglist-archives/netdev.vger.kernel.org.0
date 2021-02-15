Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9DA31B66C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhBOJ2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:28:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38836 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhBOJ2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613381314; x=1644917314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BLFgZI2SkiVnRoJC8SvSMsy1cpIH414B9xJNEOC3FaY=;
  b=hkGJazRi4qQmft5SRHOu0VbUuOFb6MoCckWRUR/1e4TbVXuwOlD4hJ2f
   dQ4/she3VZVv6BFGv1wPJ9ymHc1CYbvmsecU1rqaG2V/ihTHHbN0k+NBd
   ArCBxj74Ukz6mFSYsLrGLOokGFU/8JwsPkrwx+slYYVcqdgMO86TFGLZB
   240h5//ay8jnms5cy6lT+rnxdJszaTD0tPnUhEcURvSIbfWqTzsUsPU2S
   XLnLbcx8wWoB6/sHtEsk3ZraAY7cD0LnhnAeBB7zMxWL4MHIseLvORNyl
   H2SQj3UgT04mWRbUY9A+8MIiN0Pl663F8SOdcKcgG9VySqa5GAhtNr+fW
   Q==;
IronPort-SDR: brnBAYWnmiHB0PiTgVmzLxIRVSaIqp5Oez6+U5J6EJkoY45mRyq81ZcqbuZ65abuJDn+xjbMMB
 OMCIq4QC8sPU1SsAdpibqLvVLv+W05qw7+sDsaJ7JSQ7xDpKBCLOwAiOA6J/4/SxVgQduZ/pK5
 UT//FUQBZdfMAarpWywkWfyhuVFF9T0RDwjxZ/bC506Toj9QIm4cKVguK48Z96n+KNzTEN528P
 uyvHEYzPUfZm8J/LW0srmWHnU/XzGsOymxJ63RcXIxBzQdI2Nc5lfB7uQ+u/d0Yo6hE+8e1Hp2
 esc=
X-IronPort-AV: E=Sophos;i="5.81,180,1610434800"; 
   d="scan'208";a="44097691"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 02:27:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 02:27:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 15 Feb 2021 02:27:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6fnL3N9m0+m0Lb9w+lIf8kw9fHxWMrKhSX338dejSCYmZi8WAjk9DzXaS9M7kOhjAJVLUfJVfqrOUzMFrkV2GfZNF4wMHuK0dfBxGfoJ990hE9i6uArEzzf/g52vcoVSgZLHNPNdAhI0KSl5F9TYK5Kn+rCx5UgO3NVV6+9tO/5TJBIkeARrfr/9/kl111YNYNksKQdH8CInfN6iutBSjiCOCIgveKun11qgubWA/i+dIU3bIAhdX6vUaoDglZjIyzisBoBq4e1/lT1VGA2z6oNwmSdjU3MUGPpysxuIo4eKTW3wSY7nNb+rGqedegkeSNUhlP85B3VKamnmVFzMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLFgZI2SkiVnRoJC8SvSMsy1cpIH414B9xJNEOC3FaY=;
 b=RDF4c4pKYftYhpouhmoFyZJR9oyyD4xfHr5qf10gc5fVHOi7RbyAKMt99XjZiBGxu6apGZYmRWPggR1v9jr1sFtqC0xNL7HY9CmmCSXCyDr690HCxDNveMpVX4r6Y3hb1ISB/VBn5lptRVkoh9rqbP/xAwhnV1qQ0Lrb4ZMZW9XorhsKdjb0NkLcX3yIHnygQULbH0r4TRQt86KBdpEBJ6TUNkr3lBlPA/yYeJDJx2TgKXkvsTX66+G9slxlEjp7bW4AgyKQ53p3QCaGWS0+8HpcYlGgEeQYJUoRIFNhf7d3WFCwMWDVMmd6rYVsrGapccCjScnhwcFt/DqCsQftXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLFgZI2SkiVnRoJC8SvSMsy1cpIH414B9xJNEOC3FaY=;
 b=Yt51UKSreQdNLWyCUq9Cxc2NNsbIHkdWE/kWIHS3Q8Cltkqx0H6TXB+5gnGBBnH0ZKwlOx6X1MUiBKA6wbwPa1EF7Xk3IaLZ8Rae+pR6SGiIOAJa2+eScmfy9NVXU9Ok9RNk24bG1q+Sg8yAWFzWudg3VYUdhNLO1/dtbna7PwI=
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com (2603:10b6:3:9e::23)
 by DM5PR1101MB2251.namprd11.prod.outlook.com (2603:10b6:4:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Mon, 15 Feb
 2021 09:27:12 +0000
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9]) by DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9%11]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 09:27:11 +0000
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
Thread-Index: AQHXAUhdJHjYZpRQGkCBgBTJu+lKnapUrDIAgARKtQA=
Date:   Mon, 15 Feb 2021 09:27:11 +0000
Message-ID: <f25d05b2470f66ddf174e4b64545ecc486a98d81.camel@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
         <YCakxN3iYvsW8afy@lunn.ch>
In-Reply-To: <YCakxN3iYvsW8afy@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b591041-0b09-4082-bfbb-08d8d193dfd3
x-ms-traffictypediagnostic: DM5PR1101MB2251:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB22516249E6EE1C24CA5DEE1FE4889@DM5PR1101MB2251.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pyqk8xh95n6OB/GCfZm5qHcJ3kmQaeTGk8rRDtqLRKKu2BdrHlxIdg4ryidbvibW6+CHwB3pW1CxvfDPPOj+LxIYZRkHRy+FIsXrvrJIqWO4QwFm4uqw6QHB7aRG3E7HZ7L6CEwOqCHpF0WAHPyK8Wmi3NprEI1bzUSbX5/7DqKJ4JAelxrwA8DOLUHBzdmY+t52DApgz1/6PFkLiYp5+M9aJk8VdWrJL3UgV6qk75oSNoq/rTibRdDFoQsQjflwH7bAfUilVIbkXBCvx1ctJc/0FtZ62bO5+aWyL347uREgSR0BygEKXXHbgZN4RgcrahSXZESzLY1xy0in5T+0W97bezTpm4lQ4X+kxOTDkwXfnNGkEPKUtGdbBWGgeVjH60NXbAXtDMUhYRUAtkTCcf5kFq/PUEp//SXa9qrDFB7kF9+8GdMn7UPCVPJnCeSRuOA0zYKfnSwEjney1OfA5F5Ns3AQRtTTG+Qbrz4nTuMFYbtG/Wxtmohly/kCB44bpGy5d4lG6iMmNrzxkLzIaET41kAcElGZaxaI5j4Z6BSX/lvVRVP4k7HgIEifwouOco+SsADlLjf5p5Rgetx6EGgHtd1o8b63d75v8fuUnJq0CBGwLwVAzRQ6swh2QuBT5Xf4lZ819TjQOHEpGz6Aeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2329.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(346002)(376002)(66446008)(64756008)(66476007)(76116006)(2906002)(8936002)(66556008)(66946007)(83380400001)(4326008)(91956017)(8676002)(36756003)(186003)(316002)(6486002)(2616005)(54906003)(6916009)(6506007)(86362001)(966005)(26005)(478600001)(6512007)(7416002)(5660300002)(71200400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UlRCbExWZndmSlk5SVZwSXFUYVh0d1JKMW9icXk1WnVZN2RxLzBkdThycnNl?=
 =?utf-8?B?R0dxcDJ6dUhCREhpb285RFZvcXN2dmdXRUUzNHorL24wVUFZR0pVSEovdzBC?=
 =?utf-8?B?SDY5MUwrVmdHbXI4ZnFKS1RRaWJIUUhQQnJoYmFqNUczcENSSkNwa2VsdzUr?=
 =?utf-8?B?UTZTR04xNHRlQVBjOU8zUHNFWm10d3NDY3lvQ3czU1dCeUxSTDBLNGhtQ3Va?=
 =?utf-8?B?N282RlNSRGtDRlBSRTRheHFMdmdIdFFHK3l6NEEvZnJoZFhvc3AyNnpUUEhs?=
 =?utf-8?B?TVAwSWlHcG5kR2JicXVOQzJQTUdDVVZTWGJDeGlMTlgxdUo0b1Q2eHBSTTRU?=
 =?utf-8?B?UUNlRDgwUCt2bWZDYVZ1aGV0VjczZWE2OThxczM2YW1rRUhUbkFadW92WGdO?=
 =?utf-8?B?RDI3eXFCN1ZoR2JsUXRkRlhaSGtPL2YyZmRCVFJReTBBdXgzOUIxQnFCUHps?=
 =?utf-8?B?QzZiUHdLYmlMTm5IUXBsaWZtSWJuUnhMN1RHUWVxbUYvUmErN2F2RWpHYVVB?=
 =?utf-8?B?V3FXYmVud1QxUnVFWk0ySDZtV2F3eTJlV2dJdndsVkt4RVZuQ3htWXRpK0Zl?=
 =?utf-8?B?SUo2aEJ0RmpPMHlmbEgrYlNOWVlOZWlYUXk4ajBLdWtLcng4c0xlRnVSRmxz?=
 =?utf-8?B?OW9FdUgvUmJkV290bFBydXZQSWtaRDc3ZE9KWGkxYVQwVDM3Nm1YaWY1Nitj?=
 =?utf-8?B?VHhrcWo0bTl1SHZHRkYya2tBbXF6UDEyMGE2QzNBeTZrR2xUS1lpN2hmTWNk?=
 =?utf-8?B?ZmFUaHMwWFk1WHNJUE5vWS8wU3pMZVpiRTNUOWpXd1ZqUzJJQ3NMTDdpMEZu?=
 =?utf-8?B?cVRzYmdoWlpqcW5sTjlWRnJROWJlL1R4UmhrcG9kME5mdm1mWVJCU1E0Yllz?=
 =?utf-8?B?Nzg2RHdZVm0vTnZ2RlNsN3dseXFqY1FMVXI4TXYydVFsTmxncWxKaldNOFda?=
 =?utf-8?B?Q2xTQTV2b3E3eWRla25zM2dmY25hS1JHK0pDWmJzV2FTdjRFdnhRUXBveVJT?=
 =?utf-8?B?Z0dDNFEvL01FV1ZRK1Y0Q3Z3VDI1L2lWcXhoOHBEeERvZ1VRQ0ZDci93SlRa?=
 =?utf-8?B?WVZKdjFwUzQwaVNDQlFHQ2VhbkxvM0tNZWxLcVQ2cGVLcE9UUWhGMko0THhE?=
 =?utf-8?B?TGJqZGtwRDZkaDJ2a1p4ZHU4eXpKeVFPVnJ2SHdUdlA1dklSaDlFUlZ5N0o0?=
 =?utf-8?B?RGdwaWI3bzVzMnZZOHM2U1lSRVVycXYreUtzcW4rMEtVOWthenp0b3VvUldh?=
 =?utf-8?B?dUZFdjkwakJ5OHY3NGgyVlZpenNPYzd6ZWliQlNkZHpJM0RoU0VGRWxFMkZo?=
 =?utf-8?B?Zzl2RmJ6LzIyUHdrUE1UT09OYkEzRXYwR3hwR0VKUzVxT3MxNzNGLzlacjBr?=
 =?utf-8?B?cUhuVWMwYzRLNlR0UTB2QTBhSWJvSXdhcGFwZ3JRTVYwOWVYNzBxOVgrcG5O?=
 =?utf-8?B?MXZSRG95MFZ6Z01GTDZ2QzBwQ0RUNW1mT04vRDJOdXVhMk1UNEhlNjdaOFFj?=
 =?utf-8?B?amZTLzVOeC8ydCtPUHJOQk5TZSswWEkrWlYyVHZlalVHb0wyQ1lSNG9QNHdX?=
 =?utf-8?B?OS9IWFRuZ252SUxiY3cyWGFJcVIrTjdMUCt1Zkxwd3dOY3M0TG5EeDROOHNx?=
 =?utf-8?B?U1U3eUptUE5lUnpqU1dBaHRwclFlUGlOUldTK3lDSHo1dGM1VThQNStRemg5?=
 =?utf-8?B?dEtVTHFqVUZUVUV0Y2ZjdjhoRVV3NTRnRHdjUnY1azBUOXRKMGpWdnBISTBu?=
 =?utf-8?Q?5FRIqI8LD2lo13DA6FYMjBRqblrzLsb5gC2+Ufh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5930AE349D43F42BFD436F08438D238@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2329.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b591041-0b09-4082-bfbb-08d8d193dfd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 09:27:11.7829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nendtrMb6gI/6cAA0xNnu4SStwSZKshzOacESA2Y7gQOGdh/DtMk+ymv89HT6bgcA2rpiwSRBQt2F0pzyQT663clxi4PJrfO8RyicGoys5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2251
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTEyIGF0IDE2OjU0ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIEZlYiAx
MiwgMjAyMSBhdCAwMzowNjo0MVBNICswMTAwLCBCamFybmkgSm9uYXNzb24gd3JvdGU6DQo+ID4g
QXQgUG93ZXItT24gUmVzZXQsIHRyYW5zaWVudHMgbWF5IGNhdXNlIHRoZSBMQ1BMTCB0byBsb2Nr
IG9udG8gYQ0KPiA+IGNsb2NrIHRoYXQgaXMgbW9tZW50YXJpbHkgdW5zdGFibGUuIFRoaXMgaXMg
bm9ybWFsbHkgc2VlbiBpbiBRU0dNSUkNCj4gPiBzZXR1cHMgd2hlcmUgdGhlIGhpZ2hlciBzcGVl
ZCA2RyBTZXJEZXMgaXMgYmVpbmcgdXNlZC4NCj4gPiBUaGlzIHBhdGNoIGFkZHMgYW4gaW5pdGlh
bCBMQ1BMTCBSZXNldCB0byB0aGUgUEhZIChmaXJzdCBpbnN0YW5jZSkNCj4gPiB0byBhdm9pZCB0
aGlzIGlzc3VlLg0KPiANCj4gSGkgQmphcm5pDQo+IA0KPiANCmh0dHBzOi8vd3d3Lmtlcm5lbC5v
cmcvZG9jL2h0bWwvbGF0ZXN0L3Byb2Nlc3Mvc3RhYmxlLWtlcm5lbC1ydWxlcy5odG1sDQo+IA0K
PiBUaGVzZSBwYXRjaGVzIGFyZSByYXRoZXIgbGFyZ2UgZm9yIHN0YWJsZSwgYW5kIG5vdCBvYnZp
b3VzbHkgY29ycmVjdC4NCj4gDQo+IFRoZXJlIHRoZXNlIHByb2JsZW1zIGhpdHRpbmcgcmVhbCB1
c2VycyBydW5uaW5nIHN0YWJsZSBrZXJuZWxzPyBPciBpcw0KPiBpdCBzbyBicm9rZW4gaXQgbmV2
ZXIgcmVhbGx5IHdvcmtlZD8NCj4gDQo+ICAgIEFuZHJldw0KDQpDb3JyZWN0LCB0aGUgY3VycmVu
dCBsaW51eCBkcml2ZXIgaXMgdW5zdGFibGUgYW5kIGhhcyBuZXZlciByZWFsbHkNCndvcmtlZCBw
cm9wZXJseS4gIE91ciBpbi1ob3VzZSBTREsgZHJpdmVyIGFscmVhZHkgaGF2ZSB0aGVzZSBmaXhl
cyBhbmQNCnRoZSB1cHN0cmVhbWVkIHZlcnNpb24gaGFzIGJlZW4gbGFnZ2luZyBiZWhpbmQuICBB
bmQgeWVzIHRoZSBwYXRjaGVzDQphcmUgYmlnLCB3ZSBoYWQgdG8gcHVsbCBvdXQgdGhlIGNhbGli
cmF0aW9uIGZyb20gdGhlIDgwNTEgaW50byB0aGUNCmRyaXZlci4NCg==
