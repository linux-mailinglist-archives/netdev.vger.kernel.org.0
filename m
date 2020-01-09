Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB77135506
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgAII7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:59:33 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48950 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728919AbgAII7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 03:59:33 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0BF48404C5;
        Thu,  9 Jan 2020 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578560372; bh=I9it5sMMzHZOSKiILnapjKBqxViwI5B7OtpPCbqPFMg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=g7ADZpUpWRmNfdFcSRESjcJ11fHtovrdNK/oY0TiPQzuZzWBcRyVntsdI39kl/FZ3
         pM/bz00iHG3vajRO/SMLmMMKW7PKalqNcM9eRqJ60DFSELDF+haGUxJig65KxbB5R6
         Bym9K6iBhZjyQ64gFR55O3Bb5qxGqxCjOpSwsjSq+cHk2GHZsf0tJAPLTNGNhYNGPb
         oiSPRPeEROuK+am6BmsvsVXO+C4q1uXL379hP44AhnB09IaywjMFxTVeruWJWiEygs
         E/llx9RcEU9Iorl6lGMyNXupcdyToUfly99KGYYZTeDz03vuffvGXSVZbYPUNS57kU
         VUsyPkrvXkasA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7D2B6A0079;
        Thu,  9 Jan 2020 08:59:28 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 Jan 2020 00:59:26 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 9 Jan 2020 00:59:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEF28rgqyE13VomjAvpDBYuQRV9/XMTEwgVh/p+BfinDdEu4+ARwLqnRtzE74veq9M3NvqbktsM+ZMr9cPHFaJib8Ky5fwR+2nze4iTwZTpFjt6ZI/+RAQeNoEtZFiIr9AUUyiW9kxIm2WstccijQcqDBLXcYPSBIoQ3BLo67n1k+5qyjOTEpOdw9/7zARhkz8XXsjie/8zoMEiOQXIFXidfCRkEMLjrJyoX1YRjoIy+0ujAi8pBFR6WnU1lkuvBx3jf2cC0QrfRxGsT/iqLlqGys+lE8tkwgqUsEtuE+WPkcdFYGi/Dyh6tPm10wHFnL6FSJVeA2naOVn3xZhWZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9it5sMMzHZOSKiILnapjKBqxViwI5B7OtpPCbqPFMg=;
 b=jsNxrrM3chv80gFcRW5+0psYk4xr8AZY/M63HvUBZMotaIPuYyDc4oCXi+1rE/sOIO0J/hy6XPl5gLBIH+5N8yxIGBvL/jQifOtNaPVR+d2q5dWx2Bg9P5B+xz7SiUIIyAoFkvzwH/rP66Cf7r5dzKCY4oGOBiUUYnen4njhiUiIA/pG5O/58n849n3MRR0vF1b8E36QvUkecxAILHEiISbheD2d1TcYL5BW72t8vYmtCS6yjV1kVCwO9CABebnyHsl0k/9lifo3bM0chjycPBm2JZQWM5PyjIu6GjjaOlMUoWEgmmMAWMvrnogrRNm+8SHB0eicfoJEUhJKm4v7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9it5sMMzHZOSKiILnapjKBqxViwI5B7OtpPCbqPFMg=;
 b=TIlzKjJp6baeKQnozdp9foliIpd2P6PgpOuoRnKWR+586Cdkk9mNICYOhZM1M+sTMKwn9RTrIxONJ3n+gGYMwiFm5iHmLYLy1z17+Cxa7qQgT+FQSUcvgUGnrokD58gv8u44tQUJ8SAVLFEsp9nkkUYF+QfgdrKLwccWXoKxm+Y=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3187.namprd12.prod.outlook.com (20.179.66.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 08:59:24 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.010; Thu, 9 Jan 2020
 08:59:24 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Po Liu <po.liu@nxp.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiae0UhKAgAfLu0CAAUwKgIADVrkAgAAT1YCAEke6AIAOrCuAgACCOSA=
Date:   Thu, 9 Jan 2020 08:59:24 +0000
Message-ID: <BN8PR12MB32663AE71CBF7CF0258C86D7D3390@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <157603276975.18462.4638422874481955289@pipeline>
 <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan>
 <87lfr9axm8.fsf@linux.intel.com>
 <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com>
 <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
In-Reply-To: <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 849bee75-9bfa-4057-8ff7-08d794e23966
x-ms-traffictypediagnostic: BN8PR12MB3187:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB318731DA00D93F45CF72EC8BD3390@BN8PR12MB3187.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(376002)(39860400002)(346002)(199004)(189003)(316002)(107886003)(81156014)(55016002)(81166006)(2906002)(7416002)(9686003)(110136005)(4326008)(33656002)(8676002)(8936002)(54906003)(478600001)(52536014)(6506007)(5660300002)(26005)(66946007)(66446008)(86362001)(66556008)(186003)(7696005)(66476007)(71200400001)(76116006)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3187;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmzvAnmnwXMcCT83DdQO7AuxlQf2wiyqbkK9dYsw1WcsX0hkQVvtyMsiLq0AZVtPdPFG/kLsYts/Cl0yPEyDXOfolWwOKXe0+8Wg1woGLwqX7o4XRQk6D7g0PmIK3kZXDXybAfZMEcutRmeCo1/UhkUi/+GKwDEOWxsHLDaB8d6lX6DyC47JEbmoxHkEubSfk/zzUpB8ewslLqOerkmGpDrS0evKPY4SsbOK98Zz9s4axPNZk3YlYV81EH+9XJis/7IX5qCYiZ5cAIoGHeCjFbA3PK/SLikSEMezIfRdXngG5yYqcYz9m82+UACM349WsXa7zgsYuU/1rJyDcuCMGa0JpPq2cam01e2kw0N9v++vzxCEtgfikNB3VAeP8tSMfSJtidq0Yz4KHLcITOAUC4TKPQ6GSYWZa4ClCMDUpDiTvzccRRqsIbUp5sKVhhmP
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 849bee75-9bfa-4057-8ff7-08d794e23966
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 08:59:24.1947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bzN26GzfobA2AzR3fKFo0XoVyUE0N8hl5O0mDCR4FlznBnssuxG31usmfMEEMHPQ+RBcoNdtl5/BTpYHj8luQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3187
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmUgR3VlZGVzIDxhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tPg0KRGF0ZTog
SmFuLzA5LzIwMjAsIDAxOjA3OjM3IChVVEMrMDA6MDApDQoNCj4gQWZ0ZXIgcmVhZGluZyBhbGwg
dGhpcyBncmVhdCBkaXNjdXNzaW9uIGFuZCByZXZpc2l0aW5nIHRoZSA4MDIuMVEgYW5kIDgwMi4z
YnINCj4gc3BlY3MsIEknbSBub3cgbGVhbmluZyB0b3dhcmRzIHRvIG5vdCBjb3VwbGluZyBGcmFt
ZSBQcmVlbXB0aW9uIHN1cHBvcnQgdW5kZXINCj4gdGFwcmlvIHFkaXNjLiBCZXNpZGVzIHdoYXQg
aGF2ZSBiZWVuIGRpc2N1c3NlZCwgQW5uZXggUy4yIGZyb20gODAyLjFRLTIwMTgNCj4gZm9yZXNl
ZXMgRlAgd2l0aG91dCBFU1Qgc28gaXQgbWFrZXMgbWUgZmVlbCBsaWtlIHdlIHNob3VsZCBrZWVw
IHRoZW0gc2VwYXJhdGUuDQoNCkkgYWdyZWUgdGhhdCBFU1QgYW5kIEZQIGNhbiBiZSB1c2VkIGlu
ZGl2aWR1YWxseS4gQnV0IGhvdyBjYW4geW91IA0Kc3BlY2lmeSB0aGUgaG9sZCBhbmQgcmVsZWFz
ZSBjb21tYW5kcyBmb3IgZ2F0ZXMgd2l0aG91dCBjaGFuZ2luZyB0YXByaW8gcWRpc2MgdXNlciBz
cGFjZSBBUEkgPw0KDQo+IFJlZ2FyZGluZyB0aGUgRlAgY29uZmlndXJhdGlvbiBrbm9icywgdGhl
IGZvbGxvd2luZyBzZWVtcyByZWFzb25hYmxlIHRvIG1lOg0KPiAgICAgKiBFbmFibGUvZGlzYWJs
ZSBGUCBmZWF0dXJlDQo+ICAgICAqIFByZWVtcHRhYmxlIHF1ZXVlIG1hcHBpbmcNCj4gICAgICog
RnJhZ21lbnQgc2l6ZSBtdWx0aXBsaWVyDQo+IA0KPiBJJ20gbm90IHN1cmUgYWJvdXQgdGhlIGtu
b2IgJ3RpbWVycyAoaG9sZC9yZWxlYXNlKScgZGVzY3JpYmVkIGluIHRoZSBxdW90ZXMNCj4gYWJv
dmUuIEkgY291bGRuJ3QgZmluZCBhIG1hdGNoIGluIHRoZSBzcGVjcy4gSWYgaXQgcmVmZXJzIHRv
ICdob2xkQWR2YW5jZScgYW5kDQo+ICdyZWxlYXNlQWR2YW5jZScgcGFyYW1ldGVycyBkZXNjcmli
ZWQgaW4gODAyLjFRLTIwMTgsIEkgYmVsaWV2ZSB0aGV5IGFyZSBub3QNCj4gY29uZmlndXJhYmxl
LiBEbyB3ZSBrbm93IGFueSBoYXJkd2FyZSB3aGVyZSB0aGV5IGFyZSBjb25maWd1cmFibGU/DQoN
ClN5bm9wc3lzJyBIVyBzdXBwb3J0cyByZWNvbmZpZ3VyaW5nIHRoZXNlIHBhcmFtZXRlcnMuIFRo
ZXkgYXJlLCBob3dldmVyLCANCmZpeGVkIGluZGVwZW5kZW50bHkgb2YgUXVldWVzLiBpLmUuIGFs
bCBxdWV1ZXMgd2lsbCBoYXZlIHNhbWUgaG9sZEFkdmFuY2UgLyByZWxlYXNlQWR2YW5jZS4NCg0K
LS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K
