Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBB25A277
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIBAyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:54:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:61825 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgIBAyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:54:47 -0400
IronPort-SDR: lw8QZQiXEUdQtddqnRUq4OsG7woC/KlPd1oFjx+zLPwIAh7i9gsHxFkrE9FkAsjD+dZ+/6PLSU
 Gc+mJfO/woMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="175342828"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="175342828"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 17:54:46 -0700
IronPort-SDR: whXFeRnsdRw1RbFOBfWV9Ihhk1B7FZB7XlkwooTAfS7eONSQUN5kB7Ul0neDetpPOUhj267wRi
 qbTMv4uSe0gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="446335761"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 01 Sep 2020 17:54:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Sep 2020 17:54:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Sep 2020 17:54:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 1 Sep 2020 17:54:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K41YyMpxisIVVpf5GLzvv+q6YDL0mUUJYg95e35iFQca91uFazIUAZMgKzVpcx4YFPgn1eXzXhIK5M7XUoa5dlOqjLCsRoSVZEORmX1R0kJW77XAEklUmKjzH2sspgnxWmWs0+m495wxYjJ6gE2wghkwkcrCpJbLcYBmDdMq+8r/blCMKVuGcBaP/fpVTo7r2WCb4Yokr4AFlAsH6pHlXZbKRqb++sYPhyM+/n0B+3sQ5lghy9m8sz3LMOkOU7H8fGh0VSdx89JnaVyGKssnyzcQmt5+IOB5iq+YSTeQuE2RWjT+Pg18tS9VvjZBYqmMWfPDpuAoef2rREXWVAD0VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9W/KWUgBWFwZwsFJMEivso80vkyRzr0gth4Ndcw8+c=;
 b=aYHIsXlyQ+afPvsFMjIwFc5TgZYuaUpfDCVNMKf+p2AYK4SZrIWkyzHxX5flR88aPbeZfCAmWQ2lRCGDb6MF302F4KEzTwotYlzzoQipb8Kan9cdtsZNta2M5p27Bj4uegWuzvVnUjarlDX06SoUZ7RuA83fExenraVHQz5a6GZKa+tqQuPo+S5bSbJYIY7dlP3hBLTRxloMKASvugs0GBzskSpz84Ba5Vy1M6LVpc0XPFYLJUmxuoYYAXClHSL+WNB7kyKFNT7YHrzEirxBeXQnv2EpMFiq36qT5UCYB3/R9R1hamBmKqkv7TrJAnM9KlNg6lo5cOQADxmJIMLHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9W/KWUgBWFwZwsFJMEivso80vkyRzr0gth4Ndcw8+c=;
 b=mzCqYDJncb//9Uj7awGTrkc35JcjsLN4x47dtLhwtskT5T77ocRGHomeP6VANJ02Cz3zCtNd3BT1dxZJgwkerMyWt1c+wyFLy1hRi3aukBmXnnYEG3q0PNLCM9TpajssevShCsWuyKMOEWXJG8i6bTkl3viNVnmpX22AEpQJ+QA=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR1101MB2093.namprd11.prod.outlook.com (2603:10b6:301:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Wed, 2 Sep
 2020 00:54:39 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 00:54:39 +0000
From:   "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: RE: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
Thread-Topic: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
Thread-Index: AQHWf8zo5S5nD8q420OtCeyQ23Z/hqlSrEcAgAHa41A=
Date:   Wed, 2 Sep 2020 00:54:38 +0000
Message-ID: <MW3PR11MB45225675894AFEE20F52BE7E852F0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
 <0333522d-7b65-e665-f19e-d36d11bd7846@iogearbox.net>
In-Reply-To: <0333522d-7b65-e665-f19e-d36d11bd7846@iogearbox.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjEzNGUwYzItNGVhYy00NTQzLTg4ZjYtNmM5ODlhMmQxZDE0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSW9HTjVPanBtTENEQmE3Z0hnbitcL1Jhd1hBT1E0czFsXC92aVFQeTNYY0E2VzVOMkhhc3Q2Z0xKaXRBRk52aHJHIn0=
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-ctpclassification: CTP_NT
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.63.191.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ca57663-0b0f-4840-32a3-08d84edac53d
x-ms-traffictypediagnostic: MWHPR1101MB2093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2093847A4211353083AB0F62852F0@MWHPR1101MB2093.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMgl2RlxbVBi8a7tDxOED5gCGijP+V6kHAs8+2Ul/X9EibttY+l1IXuUgSWZnOgXItednUJBCpXAYruya4Op0NZlqrRk1pFo2SxQEFmurCz/53t39YfstHUjGBt/V8AMmeC+UpWp8noUXiGnp6+E1jFODpLNoXHRXf5DKBw8ezBsTYMpr/vkCkw8brYCdOHz49nKw8w++DyXULzs+L4J0x+knC62FIn55B8+NpPFSB+g1LyQaM72XGvSeTJL5GRr1nALOEMUabISis0LCpSxE6EDSXQ/3Gk9iHieuB03z3HM7c7822nTmpAnorhdCrIJ/0dplj9+ZU2qHS1tcHoUsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(54906003)(66946007)(86362001)(110136005)(66446008)(66556008)(66476007)(55016002)(64756008)(76116006)(107886003)(71200400001)(9686003)(2906002)(316002)(8936002)(8676002)(5660300002)(33656002)(7696005)(26005)(52536014)(4326008)(186003)(478600001)(6506007)(83380400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +aTd21K7eEY0BfjYaCg/ghniBMkpdu1rp+tRYDsPYeWMjnF565BiT2Tacqg4iodXBB/TXqZshFVq638i6piKS1HgJyKl6uu+49h2X3jt84ag69QwFGtnJ6tkyO91PE3QIpBry3xh72HgLffByMlnfM7N8t5FpKLZdtN/yFogmBB5VAUuWkr3yeBYjJMWoBeiG0tPjW4+1VipgH+dscV4tE85Bzb5Q6W1NJoTfJDT5I/BnjGVwqwejaazItulpIGBzNGU0jBDLrGN3+rSKrxl87plsu3T/hwryiUuFoatAw44sQGhObhGc6TihiYePoznG+o84f39pGp1L0vOq/zZMm+X6xJa1wsnHjQruGkNF6npBDNBUIRj26r1G3qCSeefcesQI6AhtppAfs/l9yHQYHI7bSaAoNJbR8L+9Oi4AsXBcLGEmQrAJ+i9V9u+8gcOalhuINqDFktn/pdN9V/j74LFnEl420/9ytqiCGNIosd09SUFMMDoq5xadKIRR+28Kg+6wzvOz1hNOo3Ue1vHzinX6rP+Q84BsRQ1AznmlvisepUdBvf6edJ91T04fyHaYuCUwMTapYBy1IS4NR3cE4Vsi4C+R7Zg/35yHSwOSigw40WdM1YW4brtk3KDNjCrJcN15fo23EsMfEvM2EJSNQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca57663-0b0f-4840-32a3-08d84edac53d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 00:54:39.0261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6335lEjPHWipLg/NwKklpHWudEJIgfci7HLzudnchDv5UboGS05gafF5WN+jQETxc16mn9aXPB3d6LnzYC0CM7yr4UXJbxemdMRNr5Wbuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2093
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYW5pZWwgQm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0Pg0KPiBTZW50OiBN
b25kYXksIEF1Z3VzdCAzMSwgMjAyMCAxOjMzIFBNDQo+IFRvOiBSYW1hbXVydGh5LCBIYXJzaGl0
aGEgPGhhcnNoaXRoYS5yYW1hbXVydGh5QGludGVsLmNvbT47DQo+IGJwZkB2Z2VyLmtlcm5lbC5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOw0KPiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IGRzYWhlcm5AZ21haWwuY29tOyBEdXlj
aywgQWxleGFuZGVyIEgNCj4gPGFsZXhhbmRlci5oLmR1eWNrQGludGVsLmNvbT47IEhlcmJlcnQs
IFRvbSA8dG9tLmhlcmJlcnRAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGJwZi1u
ZXh0XSBicGY6IGFkZCBicGZfZ2V0X3hkcF9oYXNoIGhlbHBlciBmdW5jdGlvbg0KPiANCj4gT24g
OC8zMS8yMCA5OjI1IFBNLCBIYXJzaGl0aGEgUmFtYW11cnRoeSB3cm90ZToNCj4gPiBUaGlzIHBh
dGNoIGFkZHMgYSBoZWxwZXIgZnVuY3Rpb24gY2FsbGVkIGJwZl9nZXRfeGRwX2hhc2ggdG8gY2Fs
Y3VsYXRlDQo+ID4gdGhlIGhhc2ggZm9yIGEgcGFja2V0IGF0IHRoZSBYRFAgbGF5ZXIuIEluIHRo
ZSBoZWxwZXIgZnVuY3Rpb24sIHdlDQo+ID4gY2FsbCB0aGUga2VybmVsIGZsb3cgZGlzc2VjdG9y
IGluIG5vbi1za2IgbW9kZSBieSBwYXNzaW5nIHRoZSBuZXQNCj4gPiBwb2ludGVyIHRvIGNhbGN1
bGF0ZSB0aGUgaGFzaC4NCj4gDQo+IFNvIHRoaXMgY29tbWl0IG1zZyBzYXlzICd3aGF0JyB0aGUg
cGF0Y2ggZG9lcywgYnV0IHNheXMgbm90aGluZyBhYm91dCAnd2h5Jw0KPiBpdCBpcyBuZWVkZWQg
ZXNwZWNpYWxseSBnaXZlbiB0aGVyZSdzIHRoZSAxIG1pbyBpbnNuIGxpbWl0IGluIHBsYWNlIHdo
ZXJlIGl0DQo+IHNob3VsZCBiZSBlYXN5IHRvIHdyaXRlIHRoYXQgdXAgaW4gQlBGIGFueXdheS4g
VGhlIGNvbW1pdCBtc2cgbmVlZHMgdG8NCj4gaGF2ZSBhIGNsZWFyIHJhdGlvbmFsZSB3aGljaCBk
ZXNjcmliZXMgdGhlIG1vdGl2YXRpb24gYmVoaW5kIHRoaXMgaGVscGVyLi4NCj4gd2h5IGl0IGNh
bm5vdCBiZSBkb25lIGluIEJQRiBpdHNlbGY/DQoNCk9rYXksIHdpbGwgYWRkIGEgcmF0aW9uYWxl
IGluIHRoZSBjb21taXQgbWVzc2FnZSBpbiB0aGUgbmV4dCB2ZXJzaW9uIGZvciB1c2UtY2FzZS4g
DQoNClRoYW5rcywNCkhhcnNoaXRoYQ0KPiANCj4gPiBDaGFuZ2VzIHNpbmNlIFJGQzoNCj4gPiAt
IGFjY291bnRlZCBmb3IgdmxhbnMoRGF2aWQgQWhlcm4pDQo+ID4gLSByZXR1cm4gdGhlIGNvcnJl
Y3QgaGFzaCBieSBub3QgdXNpbmcgc2tiX2dldF9oYXNoKERhdmlkIEFoZXJuKQ0KPiA+IC0gY2Fs
bCBfX3NrYl9mbG93X2Rpc3NlY3QgaW4gbm9uLXNrYiBtb2RlDQo+ID4NCg==
