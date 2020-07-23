Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA13022B715
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGWUBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:01:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:15651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgGWUBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 16:01:05 -0400
IronPort-SDR: ltjL7AlXxSL9NTV3Fq7hxvUq3t/e2dELM9fDpRh00WtCVGw3KJqZRnWsNihY4kYbt0kVFkJlK5
 BNcldqZQM8gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="151909849"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="151909849"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 13:00:55 -0700
IronPort-SDR: O2W+Qh5fki5ttWxCW/Cr9dFXRDmN6zi3aIsl7BRvXthsBlqgAP4xZSzx7peIR594nlbuSRegXo
 28bs9zo/lfgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328678294"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 13:00:55 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 Jul 2020 13:00:54 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 Jul 2020 13:00:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 23 Jul 2020 13:00:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A47ji8uD1XWQvSN5rAAk8sEC2JOSGzL+bkBkQLVoz493LVs7sTzLCBLiGXrXomZkwNBUrOoL8rLq7heTCk10EVIB9W63LEKb/IdKSKwYw8z5Y48lVKBIN1mJ9rec3g/MUnRpzdoDEcJSgEHtbs5cHlqZHGbR8RWgEavAttbCZKoECXBSSwWn8vT8Ez9gpD5b2s/k6KKhJaWrbwv9A4uocDlHqb1ZLq2n+wggsE2k1OokcUkmLW0jcejC7GOhsj0XtKQvuvybea8POVwSGCxOQDLtTWGSRaqVdiEG6y8kJ15rGRsbNoWvZTCAa6nW5kv3Au8uAzyU0QgWsN9/zhTM3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt/4PB60XF5IQw3N9iHXBh/5ZLU2qLuaaWt3GwKTqUc=;
 b=Oz3QT7b7xc0VHNmP2FhEGI4q5v9SFbXghMhhk53VBeSj3HlUJaSWws3+gpqhXwvGLx/TsMyXK/xRWWfdsUCeT5JBhEW1OG+7F38NkucV10CLgFfZd5bOL5Khj+kBZIcznf05TULTg2FCsbyLvb+Tcb3Rcb+FhuUcWlXc5uoX3BQJ62vmTBf1tvWdNcUbhmBaGjQflITzHiREZFB7hEmP5V52xD+dZyRfNj1snaMyciYBmIngsW6oDnptuTUu5guahR05gmD8dxsAfxDLzAk81nRNTpAFpQEeuLXJffM/+l545tacb06Px1nqW9SP95wuOEdI7LJVEulyGLDNgVtWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt/4PB60XF5IQw3N9iHXBh/5ZLU2qLuaaWt3GwKTqUc=;
 b=o2DeMO03c8CieSk0bnS3bueEiKt32jr2aLa5AD7fgyHKhpW/cOyGa8NAy9oDZoKmqxVrvyHn3by5kNsJ46xAiIP5cl+Ni60vGQgtw3kf7w/7Evxz1iUoklChzbsqL7mdz6miHXV1LXOp82u3UyN5NtfpMrjJxX8RO1y0HbT0N0w=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3439.namprd11.prod.outlook.com (2603:10b6:805:da::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 23 Jul
 2020 20:00:48 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bda3:d65a:f390:f875]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bda3:d65a:f390:f875%7]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 20:00:48 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: Re: [net-next 1/8] igc: Fix double definition
Thread-Topic: [net-next 1/8] igc: Fix double definition
Thread-Index: AQHWYG+RPENy3S4ULU+NgANUjQxAW6kUM34AgAFjjIA=
Date:   Thu, 23 Jul 2020 20:00:48 +0000
Message-ID: <be2fef6e6f07b3fea067a8fd71d8d25c01891fd9.camel@intel.com>
References: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
         <20200722213150.383393-2-anthony.l.nguyen@intel.com>
         <20200722154814.184521de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722154814.184521de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 263cd18e-cec8-4f40-1e59-08d82f4317f1
x-ms-traffictypediagnostic: SN6PR11MB3439:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB34395DC362004A26BCB0F007C6760@SN6PR11MB3439.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f/O74ES9m7BRDdI+Ads/73rKhl6JtGMYrxZwDp+nmk0RRB3A9fwAcatpNXfBVDEmINrTdH4u/Bu86afZO6ceibbV7zp1MmpL7WtALZQxgBWDCvkF327jfp/vCuGv0H9RkGlqsK0H70hlnpCMvwdecBuiF4TmjsRRu+jzYggnrKlyYI3h/tmqiOsS/xfe/En/1S93XjtIiZoIw/sK2jSJCLdc4nqqDLvCUhkGAfaPcwKYaOFaU4kj8L2ERnNotOTqpA3OBpBJjiG3gZk/hz85ndQE/YYMWfv6ZFUVwsEJljYMTLUuQXPrjwqxDCU83NCkGrKD/r3VeFuHpp2on/h4Gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(83380400001)(186003)(26005)(316002)(2906002)(6506007)(6916009)(478600001)(6486002)(54906003)(5660300002)(6512007)(4744005)(66556008)(76116006)(2616005)(64756008)(66476007)(4326008)(71200400001)(107886003)(36756003)(8676002)(66946007)(86362001)(8936002)(66446008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Wjx7heJWEAwxZb32eNU66NFahEi/ltUsEIX5ycN5K/AC64+sSVRVO+q7Ph5Wqpct2x4ol4SqkNQPkbyS0GBd2f0Y1/oLBsgKcFEy1kvUyOgfUHmUvththPqhx4IjtF5VxvYQfz2XxU+nWQJqcs9MED0LUgMghcpV6+n4Lnq+hrkuzDs6puEwR+EYZtQ70uckXn/u3kdavtZToG0Ersf6Q7HMXgF3nlJzwTE7S8MW9HMkHGtC4QzMZJePwwKP4uYIOpwxteFcsj33Po+gKHBVFvmbl1pfKFVK3Z48akXwZQKNxYeOsdZ3LEU1lmwIPLdV7D28hWH2bkRpdV3RWsTh0dbJqxhOf6lmlEkJi8GrT3ZZsgCcakZCUzsAzkksUc2w5hAIcvQABP7JUwcfsg5j1Y1oI5DnTAKDdhxPR78cIvxc7JN97jXdWVr0kUOcznghy+Jjt3WMoDZaBMI4QFTBeKVxNeeuKxdV622RcQNk7lq5UnU5jR9SIT5FaN6zrndf
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C1FDF007DA9604A92713803219B4F08@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263cd18e-cec8-4f40-1e59-08d82f4317f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 20:00:48.1778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgKqlc1Ixxv+DywLiMwrxwY+eR/NTMNtsW3SNn52xWVGrK1OsxJcm0tlwkIGVdTOE/XYNkHzydyKa3U1v+OnbiRLlwGY8AYM/Me74ho0yUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3439
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTIyIGF0IDE1OjQ4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyMiBKdWwgMjAyMCAxNDozMTo0MyAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBBY2NvcmRhbmNlIHRvIHRoZSBpMjI1IHNwZWNpZmljYXRpb24gYWRkcmVzcyAweDQxMTgg
dXNlZCBmb3INCj4gPiBIb3N0IEdvb2QgUGFja2V0IFRyYW5zbWl0dGVkIENvdW50IGFuZCBkZWZp
bmVkIGFzIHJlYWQgb24gY2xlYXIuDQo+ID4gSUdDX0lDVFhRRUMgbm90IGluIHVzZSBhbmQgY291
bGQgYmUgcmVtb3ZlZC4NCj4gDQo+IE5vdCBlbnRpcmVseSBzdXJlIHdoYXQgdGhpcyBjb21taXQg
bWVzc2FnZSBpcyB0cnlpbmcgdG8gY29tbXVuaWNhdGUuDQo+IA0KPiBBbHNvIGl0J2QgaGFkIGJl
ZW4gYmV0dGVyIGlmIHlvdSByZW1vdmVkIHRoZSBtZW1iZXIgb2YgaHdfc3RhdHMNCj4gc3RydWN0
dXJlIGluIHRoZSBzYW1lIGNvbW1pdC4NCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIEknbGwg
d29yayB3aXRoIFNhc2hhIHRvIGdldCB0aGlzIGFuZCB0aGUNCmZlZWRiYWNrIG9uIHRoZSBvdGhl
ciBwYXRjaGVzIGFkZHJlc3NlZC4NCg0KVGhhbmtzLA0KVG9ueQ0K
