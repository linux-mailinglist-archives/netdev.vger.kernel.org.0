Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B21523488B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgGaPd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:33:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:64573 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgGaPd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 11:33:56 -0400
IronPort-SDR: bFBQgBAA6gBAwBfck9h6gcJ+h1Fm4qlUhoTcPARrd46k4arT/eKZAfaKH/2v4vu6bYuXCNjbgJ
 lQH3On8ckZ1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="139360461"
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="139360461"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 08:33:55 -0700
IronPort-SDR: XYaO7nNgZd/+xi/fQQZSr66N+2onNk7mR1lLGAwAIlPNuccPbXjl4NEYqiWfG2JQpUGQK0gIsT
 jeV7E0MSU5tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="465648359"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 31 Jul 2020 08:33:55 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 Jul 2020 08:33:55 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 31 Jul 2020 08:33:55 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX112.amr.corp.intel.com (10.22.240.13) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jul 2020 08:33:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jul 2020 08:33:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHarXHrqoBhk6dkLUqWBGoSEn3vhUi3bVq2QdqYuwyblJLdwWuZw1imVaiUsGdUBtd1eqp7TGRTg1nnNC5ge8iodMC80BanGaQNg32I/CaUDNb8DYyqJAIWX8EAlUh6VF0ZrvL3UBAHX5tdlKcfYQrNcM5MeanySBVcdUBLc9YHApV8TmtMWLm7/dmfW+DqlOUMrBWn/2RvKoMCHNaDois4FRQEYvWGBGJObcfZ4g47paEl3Hsby6xbIa61Us1JNxi7IvoAAGGhzcBA17zBmvbfjOT8EKn/yIyIFSYWTD8IYkaGpUxg6e96+VkhKJvk7zyOnn8fddKfHD0/U6HLw3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ux+8XwBR7fpyLAx3s6CWbEnzOF6FC/P0qudkvOC3iQ=;
 b=h7Z7pxIV2ZwrNo0V+wlJJ+IZzz9NT+W1Ah+85Ktm/SbtclvFfJ2kha3/JSceJ9Jh3XPhtqtC1YauOBtOugfUiRqbQbWdzvguQj9wBlKb1Y3MecIKmM27N7pRdMDLM5kGXl3VeUUi48HSLcMjPvEGj3lRXpZUt7lq7T9VhoxKzoGwhrkD+R0HElmGr9uRY4y4I0u4xN7PyeBbz5K1RSXhTcT7fPfXxKfpuLyWymhoZE7EIrhcz4AjW3JPxqnI4bRPUbI1lYMXHN13Sh3OPCoM0dvl2k8beweYEgOUthZhJ9q91HXVBzktrOhq4/tDqcXjH8dPK1URBP+Gmzrcad8FMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ux+8XwBR7fpyLAx3s6CWbEnzOF6FC/P0qudkvOC3iQ=;
 b=nDVecofbu033vlOxhmYslnv5b/7RgDwdil4VyWNxhmLcu9dv8wc6wWnuZnJVVzBo7njaEVlLPBarvhk5TBeI79Ev14+Tfk3NukrzdChVLLOCnfBU2nAAFLhs+jCspaKFMR0yPxDoZTQJroDktWscsTjZ6CdZ8/vPB0lMcMbajJ0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 15:33:53 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b%3]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 15:33:53 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net 0/2][pull request] Intel Wired LAN Driver Updates 2020-07-30
Thread-Topic: [net 0/2][pull request] Intel Wired LAN Driver Updates
 2020-07-30
Thread-Index: AQHWZpREp/Ta/XcPAkSpX8ZfypyQHKkgxLOAgAEOIQA=
Date:   Fri, 31 Jul 2020 15:33:53 +0000
Message-ID: <2e85c879b30f39cfb1ce3fab11cd7178179d51fe.camel@intel.com>
References: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
         <20200730162703.277cc07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730162703.277cc07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0228bf77-28fe-4d7a-8f1f-08d8356721a3
x-ms-traffictypediagnostic: SA0PR11MB4528:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4528AB0E70491E931FB3AB73C64E0@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wvyWDi4bXgZfkqFwhfMo6JHGojOvJToEfdbCxk3raRQfzfwMt6Z4mzJT86xSsc5b+HnQK7P6k1tH4SS/IGUksnYftdHCN7V8I5IxRyj/EQx+sspNRIV32N+2Ym1Hsg0zrwRXRy7q0YUsyvudpjJO8HlORhm5knrPfTX8wmdR3d9aAbanY4h1mYHdyU1bNYcFRijDffMNx1/owoNb8otjmUMm4ebwZof5UcT/VggazZ7Ge3vpvi8lTZ5tBqv9dx0vfjjszP/sS40gk8sLUc6nKHGKohmw0EIl1s21n8XRvw1/oMx+GRT4RFP2zqXThI2yI8qO01aU7IGfhQwjEseVDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(15650500001)(66476007)(64756008)(5660300002)(66556008)(4326008)(36756003)(66946007)(2616005)(6486002)(6506007)(83380400001)(91956017)(316002)(76116006)(66446008)(4744005)(6916009)(186003)(8936002)(2906002)(86362001)(478600001)(26005)(54906003)(71200400001)(8676002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SVAISa6AeAVqLUKD4odyRDQYcEyiRzI5VpiCiSUGj/bGGsVT7NTLCfaCJBerwKMTqOR5NE2VAy8ftokJNts7RaZ/DKAkULdNm5EGCSUYxSnDiTPJ3DI8IudT2giGyzO25/rA9gv49L/O7i8+GwjM/LwgVPndWTqRARDSoi+8dD3qqAAM0ryByAZkNl1gAfLTFflqCdscJIv1Ylfa8P2VR8HXaUhWOsVGlDyxFIVgwUq1Gcr3Ni7aosztX5b8ExcJH41WPSO4ndtIHmJhHv0lHBD7ab4+E4Er66qOlLdv/btv5v1LzL3rCHt+EyVV3ZzZ3Tqev5JungDiy7QJVJmyg4BaTCbhEaLYy7xfYuC2v4sahbRpDReO4wzN+3JrAjyMpX8UPylSKNSeYY59RpQHfmr+GDnAexecT3yTU+M/xvP+lcmDoXzixrMt6sjNoq1CW6Z6RdOfZH3MJF88Jnv8//T5XcmyfBE4HA2pvjevwmNq3/24tQDpsDM1nye5ml40
Content-Type: text/plain; charset="utf-8"
Content-ID: <AED3089A1363A748AD3A53FBF5FCF07C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0228bf77-28fe-4d7a-8f1f-08d8356721a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 15:33:53.4056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +vqSoSw/E37L5l0sZ+6FLHDOSupb8MyyNgA8DKXZTsk1LvHGyyBT2Emm623kSwCwopraCMAYSCTSELPRg/l8fmb3rEm1q3laDpkWbB3Pqjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTMwIGF0IDE2OjI3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAzMCBKdWwgMjAyMCAxMDowOTozNiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBUaGlzIHNlcmllcyBjb250YWlucyB1cGRhdGVzIHRvIHRoZSBlMTAwMGUgYW5kIGlnYiBk
cml2ZXJzLg0KPiA+IA0KPiA+IEFhcm9uIE1hIGFsbG93cyBQSFkgaW5pdGlhbGl6YXRpb24gdG8g
Y29udGludWUgaWYgVUxQIGRpc2FibGUNCj4gPiBmYWlsZWQgZm9yDQo+ID4gZTEwMDBlLg0KPiA+
IA0KPiA+IEZyYW5jZXNjbyBSdWdnZXJpIGZpeGVzIHJhY2UgY29uZGl0aW9ucyBpbiBpZ2IgcmVz
ZXQgdGhhdCBjb3VsZA0KPiA+IGNhdXNlIHBhbmljcy4gDQo+IA0KPiBSZXZpZXdlZC1ieTogSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gDQo+IEluIHRoZSBmdXR1cmUgcGxlYXNl
IHRyeSB0byBhZGQgRml4ZXMgdGFncyBvbiBhbGwgbmV0IHN1Ym1pc3Npb25zDQo+IChwYXRjaCAy
KS4gDQoNCldpbGwgZG8uDQoNCj4gQWxzbyAtIGFyZSBzaW1pbGFyIGZpeGVzIGZvciBvdGhlciBJ
bnRlbCBkcml2ZXJzIGluIHRoZQ0KPiB3b3Jrcz8NCg0KSmVmZiBzYWlkIGhlIGhhZCBzb21lb25l
IGxvb2tpbmcgaW50byBpdC4gSSdsbCB0cmFjayBkb3duIHdobydzIHdvcmtpbmcNCm9uIGl0Lg0K
DQpUaGFua3MsDQpUb255DQo=
