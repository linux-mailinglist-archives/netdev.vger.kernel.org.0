Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0646A2AE46E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbgKJXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:53:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:1171 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJXxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:53:45 -0500
IronPort-SDR: qviY55BWnQmrHijmPHftp10yfd8gVCIkRa7GovU5Fs/9pMZPE4n2K8DUpl7LzqBS8jNTTgsL9Z
 bjGmm6GTqZOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="157076179"
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="157076179"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 15:53:44 -0800
IronPort-SDR: F6IwIKzJf3pZidhj4wEvXt9sWoxIap2s9VxkAwRNgmc7AfGGS6qW9QMNZjz/ze/n0XGo+gI+A/
 t1kJl9CgrIkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="428570257"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2020 15:53:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 15:53:44 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 15:53:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 15:53:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEdRELGShE+750VFSuYFKOkqzJqPuqHYh8cunbD24Q9SE2gSYInLvqOFVOmPGJ5+vp6rQiqxaU7AEUlOd/UovvpYQoRtbgkMHNdgEwzF5z1oVw/PF9/hAWKCsL0lilOOdl2bBPRrVNiiPcEGfdjhJVqVws4ugqH0zASW7zt1YdxwsX1xHz4es3B5d2gqL63g4yI0/sLBm2cbHMFU/wmH29qHbfdVFMW7fjocvEqPSuOO37taKYHEby7qLZzJhhbjHW71tgysdhgIPekaC6mMk8GQbCcC3cjuleYBLtSZL2N6xpanFjEfC7++v0VwnQS8/uJnMpGXnTEyn9g3ae6b4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeNfE3TRhf4e6HFb1f9m5HkAZu/MAsowF17BT3PV9Ds=;
 b=PVkDcLsZD7rHFiN1FNlpn9jS8D7lWc4/QWWb6xPI1ftxUKKpfoNPX2PIxBA76xRyeBglba9Focgv1oElZcUKkAb7k2cjg4A88Pr34Li5zfhxNyxroPsf2sokb/BLzAKIB0HH0Gzpq3p8XOFTZPwdtSey+fqMHEHXiJDghEBMiGJAb6HVrVnYL9N7yWdyRu4VPKgb/Zf8jUpGvU/sJfSDfxOAi0Gcu+w7jzGdoL7olM+Tdpv4dGGLj6sE0J5FIrarH5dggBEDy/3F1o0iE3KbHDYbv8vMjpe1TI5hrYIETVXFL5x1Jb5kdN8TyMA04UwgIiChqXp9cJ7qXB+UAcjYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeNfE3TRhf4e6HFb1f9m5HkAZu/MAsowF17BT3PV9Ds=;
 b=kDV5Jspw9AuGFTJ2QYe0HpZBGnUU4bHaf2Prnzkp0sxqhOe03kLX7vvdByUqy7eQiNuoQ9sii0ZBauZ1cAOs2TtXUNVNWD/9m+oujE2rS7bquVVyY+aYOt2PBOBRk6H28lGJ8mnXaCa979MwYM7fwoHbBpwZoJgm1mV28m82cis=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 23:53:41 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 23:53:41 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZanCBAaAgAAGAoA=
Date:   Tue, 10 Nov 2020 23:53:41 +0000
Message-ID: <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
 <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
In-Reply-To: <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef0c4481-bbe5-479d-5519-08d885d3da39
x-ms-traffictypediagnostic: CO1PR11MB4948:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4948154A4E96BA912E908CF292E90@CO1PR11MB4948.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zbj1z52+0xWhTZpqnqETORU3HbXl0dJfY6DJnLFYkIlWuR5bqtGjiA+lh9iNVxO8si/rJTR97iBleQVVXJdQAXqU1yscOV1JADt5uTfhKdSvVutQDo0HxfZYjbLmSyMHa+rPGTVzfL5ongN4gu3vPe+42KuOF7u11jV97yJmUnvw0cLlNKVuwV2zUQC4kmv0B4LnlnsmsP6ZqqqQzZ75z+5u4CDSnOXwI0oUqB/r4FPgYpu5E1Z/PQ16Aj0dpFgG1YAaGudFg4TDRPcb3N81pK0uX6VXROdoRmTScgRnldHPCLkr6LUGSZUVqqzdRHVCtwMRhuvogqbA5l1s72rJB9409gVYYJnXlOX2IRcrSCrdGg9f4TZOLCSjI1sLyymWg0zpQH1+jTmh3R/pVNteKDnjxkJBvne8Qk0tCzsDi0LxbwGRLXoQPUcfbx5Yk1Rb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(33656002)(86362001)(71200400001)(107886003)(8936002)(2906002)(36756003)(4001150100001)(5660300002)(66446008)(66556008)(66476007)(66946007)(76116006)(64756008)(6486002)(966005)(83380400001)(478600001)(54906003)(316002)(2616005)(4326008)(8676002)(6506007)(53546011)(26005)(6916009)(186003)(6512007)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9jwidrV+peeuYHBGlfPw5ScziYRLaxggWyppc69ZaZ4Qiglm67rVUKNXKPNHpGrQ9TVoIebhlTVxFCbXV3WkUGMcmGVLVZTMmUXNBuWDwLP8O12IbWK4Z7R6F+YxoLZ6sO9fhPT6pdYBfOKsVOG2X0maXG/CSPRuFZkvgt2VIzOXVp9E1qdBVBn1s1s8S0Q9d17p3EDdjcpO1JaTqVBipTVksBCJcahxze/CDCVlbVnA5ZuXPpLSeytXzjRzZy8ZrgmD2d1bLQ2VBqGOIDWs7fr5ukGLy/5fEXcLkB4m6vnWutU78f49YjLAXr6uC0zzutZaqltoWWEM0oRt3cHcR3SBKPpSDmz2pc/nRndzURoh+nkjPX6S0fznrGFFgcfD9hYmbhLfkjNjk/GK3Iiwfcv7B8IOyP1m8R6oRvgVamaBXqabM8tkSp0bXYEaSWDRXuyxFDYjakRxEE9NR5cyVf2ydBxp0tH2+xxtNRRMz65CR9FrVPkn9z8sZ2b5x609w2tfsmW7DerFqz359m6coARz3d64DlbxXQQciPMbho1U78lNlypTBTlOoEfQT1VjN4yqXZCI70Wpuxzt+2QV8Du4szmTcvVXtMmu02pU8XFYrw+QvtaNiiP8EE6YnmrCOgLQyE8MMrDP3HrQ6M764A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A34274678F90B542906566D3BFF3C199@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0c4481-bbe5-479d-5519-08d885d3da39
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 23:53:41.7609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YV5H0HflsMJ97ca8b4OQKxrDyLKDUAWKmYvUoEXqCmtmHBif/MWKxOkLQEjIBU+J1n9nKhBekoDiIrQbJW3TVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsIA0KDQo+IE9uIE5vdiAxMCwgMjAyMCwgYXQgMzozMiBQTSwgU2FlZWQgTWFoYW1l
ZWQgPHNhZWVkQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCAyMDIwLTExLTEwIGF0
IDIyOjQ0ICswMDAwLCBQYXRlbCwgVmVkYW5nIHdyb3RlOg0KPj4gW1NvcnJ5IGlmIHlvdSBnb3Qg
dGhlIGVtYWlsIHR3aWNlLiBSZXNlbmRpbmcgYmVjYXVzZSBpdCB3YXMgcmVqZWN0ZWQNCj4+IGJ5
IG5ldGRldiBmb3IgY29udGFpbmluZyBIVE1MXQ0KPj4gDQo+PiBIaSBTYWVlZC9KZXNwZXIsIA0K
Pj4gDQo+PiBJIGFtIHdvcmtpbmcgaW4gdGhlIFRpbWUgU2Vuc2l0aXZlIE5ldHdvcmtpbmcgdGVh
bSBhdCBJbnRlbC4gV2Ugd29yaw0KPj4gb24gaW1wbGVtZW50aW5nIGFuZCB1cHN0cmVhbWluZyBz
dXBwb3J0IGZvciBUU04gcmVsYXRlZCBmZWF0dXJlcyBmb3INCj4+IGludGVsIGJhc2VkIE5JQ3Mu
IFJlY2VudGx5IHdlIGhhdmUgYmVlbiBhZGRpbmcgc3VwcG9ydCBmb3IgWERQIGluDQo+PiBpMjI1
LiBPbmUgb2YgdGhlIGZlYXR1cmVzIHdoaWNoIHdlIHdhbnQgdG8gYWRkIHN1cHBvcnQgZm9yIGlz
IHBhc3NpbmcNCj4+IHRoZSBoYXJkd2FyZSB0aW1lc3RhbXAgaW5mb3JtYXRpb24gdG8gdGhlIHVz
ZXJzcGFjZSBhcHBsaWNhdGlvbg0KPj4gcnVubmluZyBBRl9YRFAgc29ja2V0cyAoZm9yIGJvdGgg
VHggYW5kIFJ4KS4gSSBjYW1lIGFjcm9zcyB0aGUgWERQDQo+PiBXb3Jrc2hvcFsxXSBjb25kdWN0
ZWQgaW4gSnVseSAyMDIwIGFuZCB0aGVyZSB5b3Ugc3RhdGVkIHRoYXQgeW91IGFyZQ0KPj4gYWxy
ZWFkeSB3b3JraW5nIG9uIGFkZGluZyBzdXBwb3J0IGZvciBCVEYgYmFzZWQgbWV0YWRhdGEgdG8g
cGFzcw0KPj4gaGFyZHdhcmUgaGludHMgZm9yIFhEUCBQcm9ncmFtcy4gTXkgdW5kZXJzdGFuZGlu
ZyAoYWxvbmcgd2l0aCBhIGZldw0KPj4gcXVlc3Rpb25zKSBvZiB0aGUgY3VycmVudCBzdGF0ZSBp
czogDQo+IA0KPiBIaSBQYXRlbCwNCj4gDQo+PiAqIFRoaXMgZmVhdHVyZSBpcyBjdXJyZW50bHkg
YmVpbmcgbWFpbnRhaW5lZCBvdXQgb2YgdHJlZS4gSSBmb3VuZA0KPj4gdGhhdCBhbiBSRkMgU2Vy
aWVzWzJdIHdhcyBwb3N0ZWQgaW4gSnVuZSAyMDE4LiBBcmUgeW91IHBsYW5uaW5nIHRvDQo+PiBw
b3N0IGFuIHVwZGF0ZWQgdmVyc2lvbiB0byBiZSBtZXJnZWQgaW4gdGhlIG1haW5saW5lIGFueXRp
bWUgc29vbj8gDQo+IA0KPiBZZXMgaG9wZWZ1bGx5IGluIHRoZSBjb21pbmcgY291cGxlIG9mIHdl
ZWtzLg0KPiANClN1cmUhIEkgd2lsbCBzdGFydCB0ZXN0aW5nL2RldmVsb3Bpbmcgb24gdG9wIG9m
IHlvdXIgYnJhbmNoIG1lbnRpb25lZCBiZWxvdyBmb3Igbm93Lg0KPj4gKiBJIGFtIGd1ZXNzaW5n
IGhhcmR3YXJlIHRpbWVzdGFtcCBpcyBvbmUgb2YgdGhlIG1ldGFkYXRhIGZpZWxkcw0KPj4gd2hp
Y2ggd2lsbCBiZSBldmVudHVhbGx5IHN1cHBvcnRlZD8gWzNdDQo+IA0KPiBXaXRoIEJURiBmb3Jt
YXR0ZWQgbWV0YWRhdGEgaXQgaXMgdXAgdG8gdGhlIGRyaXZlciB0byBhZHZlcnRpc2UNCj4gd2hh
dGV2ZXIgaXQgY2FuL3dhbnQgOikNCj4gc28geWVzLg0KSSBoYXZlIGEgdmVyeSBiYXNpYyBxdWVz
dGlvbiBoZXJlLiBGcm9tIHdoYXQgSSB1bmRlcnN0YW5kIGFib3V0IEJURiwgSSBjYW4gZ2VuZXJh
dGUgYSBoZWFkZXIgZmlsZSAodXNpbmcgYnBmdG9vbD8pIGNvbnRhaW5pbmcgdGhlIEJURiBkYXRh
IGZvcm1hdCBwcm92aWRlZCBieSB0aGUgZHJpdmVyLiBJZiBzbywgaG93IGNhbiBJIGRlc2lnbiBh
biBhcHBsaWNhdGlvbiB3aGljaCBjYW4gd29yayB3aXRoIG11bHRpcGxlIE5JQ3MgZHJpdmVycyB3
aXRob3V0IHJlY29tcGlsYXRpb24/IEkgYW0gZ3Vlc3NpbmcgdGhlcmUgaXMgc29tZSBzb3J0IG9m
IOKAnG1hc3RlciBsaXN04oCdIG9mIEhXIGhpbnRzIHRoZSBkcml2ZXJzIHdpbGwgYWdyZWUgdXBv
bj8NCj4gDQo+PiAqIFRoZSBNZXRhZGF0YSBzdXBwb3J0IHdpbGwgYmUgZXh0ZW5kZWQgdG8gcGFz
cyBvbiB0aGUgaGFyZHdhcmUgaGludHMNCj4+IHRvIEFGX1hEUCBzb2NrZXRzLiBBcmUgdGhlcmUg
YW55IHJvdWdoIHBsYW5zIG9uIHdoYXQgbWV0YWRhdGEgd2lsbCBiZQ0KPj4gdHJhbnNmZXJyZWQ/
DQo+IA0KPiBBRl9YRFAgaXMgbm90IHBhcnQgb2YgbXkgc2VyaWVzLCBidXQgc3VwcG9ydGluZyBB
Rl9YRFAgd2l0aCBtZXRhZGF0YQ0KPiBvZmZsYW9kIGlzIHVwIHRvIHRoZSBkcml2ZXIgdG8gaW1w
bGVtZW50LCBzaG91bGQgYmUgc3RyYWlnaHQgZm9yd2FyZA0KPiBhbmQgaWRlbnRpY2FsIHRvIFhE
UC4NCj4gDQo+IHdoYXQgbWV0YSBkYXRhIHRvIHBhc3MgaXMgdXAgdG8gdGhlIGRyaXZlci4NCkFs
cmlnaHQsIGxldCBtZSB0YWtlIGEgY2xvc2VyIGxvb2sgYXQgeW91ciBsYXRlc3QgY29kZS4gSSB3
aWxsIGNvbWUgYmFjayB3aWxsIHF1ZXN0aW9ucyBpZiBJIGhhdmUgYW55Lg0KPiANCj4gDQo+PiAq
IFRoZSBjdXJyZW50IHBsYW4gZm9yIFR4IHNpZGUgb25seSBpbmNsdWRlcyBwYXNzaW5nIGRhdGEg
ZnJvbSB0aGUNCj4+IGFwcGxpY2F0aW9uIHRvIHRoZSBkcml2ZXIuIEFyZSB0aGVyZSBhbnkgcGxh
bnMgdG8gc3VwcG9ydCBwYXNzaW5nDQo+PiBpbmZvcm1hdGlvbiAobGlrZSBIVyBUWCB0aW1lc3Rh
bXApIGZyb20gZHJpdmVyIHRvIHRoZSBBcHBsaWNhdGlvbj8NCj4+IA0KPiANCj4geW91IG1lYW4g
Zm9yIEFGX1hEUCA/IGkgYWN0dWFsbHkgaGF2ZW4ndCB0aG91Z2h0IGFib3V0IHRoaXMsIA0KPiBi
dXQgd2UgY291bGQgdXNlIFRYIHVtZW0gcGFja2V0IGJ1ZmZlciBoZWFkcm9vbSB0byBwYXNzIFRY
IGNvbXBsZXRpb24NCj4gbWV0YWRhdGEgdG8gQUZfWERQIGFwcCwgb3IgZXh0ZW5kIHRoZSBjb21w
bGV0aW9uIHF1ZXVlIGVudHJpZXMgdG8gaG9zdA0KPiBtZXRhZGF0YSwgaSBhbSBzdXJlIHRoYXQg
dGhlIDFzdCBhcHByb2FjaCBpcyBwcmVmZXJyZWQsIGJ1dCBpIGFtIG5vdA0KPiBwbGFuaW5nIHRv
IHN1cHBvcnQgdGhpcyBpbiBteSBpbml0aWFsIHNlcmllcy4gDQo+IA0KWWVhaCwgSSB3YXMgdGhp
bmtpbmcgb2YgdXNpbmcgYXBwcm9hY2ggMSBhcyB3ZWxsIGZvciB0aGlzLiBMZXQgbWUgZmlyc3Qg
d29yayBvbiB0aGUgUnggc2lkZS4gVGhlbiB3ZSBjYW4gc2NvcGUgdGhpcyBvbmUgb3V0Lg0KPj4g
RmluYWxseSwgaXMgdGhlcmUgYW55IHdheSBJIGNhbiBoZWxwIGluIGV4cGVkaXRpbmcgdGhlIGRl
dmVsb3BtZW50DQo+PiBhbmQgdXBzdHJlYW1pbmcgb2YgdGhpcyBmZWF0dXJlPyBJIGhhdmUgYmVl
biB3b3JraW5nIG9uIHN0dWR5aW5nIGhvdw0KPj4gWERQIHdvcmtzIGFuZCBjYW4gd29yayBvbiBp
bXBsZW1lbnRpbmcgc29tZSBwYXJ0IG9mIHRoaXMgZmVhdHVyZSBpZg0KPj4geW91IHdvdWxkIGxp
a2UuDQo+PiANCj4gDQo+IFN1cmUsDQo+IFBsZWFzZSBmZWVsIGZyZWUgdG8gY2xvbmUgYW5kIHRl
c3QgdGhlIGZvbGxvd2luZyBicmFuY2ggaWYgeW91IGFkZA0KPiBzdXBwb3J0IHRvICB5b3VyIGRy
aXZlciBhbmQgaW1wbGVtZW50IG9mZmxvYWRzIGZvciBBRl9YRFAgdGhhdCB3b3VsZCBiZQ0KPiBh
d2Vzb21lLCBhbmQgaSB3aWxsIGFwcGVuZCB5b3VyIHBhdGNoZXMgdG8gbXkgc2VyaWVzIGJlZm9y
ZSBzdWJtaXNzaW9uLg0KPiANCj4gaXQgaXMgYWx3YXlzIGdyZWF0IHRvIHNlbmQgbmV3IGZlYXR1
cmVzIHdpdGggbXVsdGlwbGUgdXNlIGNhc2VzIGFuZA0KPiBtdWx0aSB2ZW5kb3Igc3VwcG9ydCwg
dGhpcyB3aWxsIGRpZmZlcmVudGx5IGV4cGVkaXRlIHN1Ym1pc3Npb24gYW5kDQo+IGFjY2VwdGFu
Y2UNCj4gDQo+IE15IExhdGVzdCB3b3JrIGNhbiBiZSBmb3VuZCBhdDoNCj4gDQo+IGh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xpbnV4LmdpdC9s
b2cvP2g9dG9waWMveGRwX21ldGFkYXRhMw0KPiANCj4gUGxlYXNlIGZlZWwgZnJlZSB0byBzZW5k
IG1lIGFueSBxdWVzdGlvbnMgYWJvdXQgdGhlIGNvZGUgaW4gcHJpdmF0ZSBvcg0KPiBwdWJsaWMu
DQpUaGFua3MgU2FlZWQgZm9yIGFsbCB0aGUgaW5mb3JtYXRpb24hIFRoaXMgaXMgcmVhbGx5IGhl
bHBmdWwuIDopDQo+IA0KPiBUaGFua3MsDQo+IFNhZWVkLg0KPiANCj4+IFRoYW5rcywNCj4+IFZl
ZGFuZyBQYXRlbA0KPj4gU29mdHdhcmUgRW5naW5lZXINCj4+IEludGVsIENvcnBvcmF0aW9uDQo+
PiANCj4+IFsxXSAtIGh0dHBzOi8vbmV0ZGV2Y29uZi5pbmZvLzB4MTQvc2Vzc2lvbi5odG1sP3dv
cmtzaG9wLVhEUA0KPj4gWzJdIC0gDQo+PiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3By
b2plY3QvbmV0ZGV2L2NvdmVyLzIwMTgwNjI3MDI0NjE1LjE3ODU2LTEtc2FlZWRtQG1lbGxhbm94
LmNvbS8NCj4+IFszXSAtIA0KPj4gaHR0cHM6Ly94ZHAtcHJvamVjdC5uZXQvI291dGxpbmUtY29u
dGFpbmVyLUltcG9ydGFudC1tZWRpdW0tdGVybS10YXNrcw0KDQo=
