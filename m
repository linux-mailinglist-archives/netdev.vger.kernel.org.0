Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B005495A6C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378862AbiAUHNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:13:37 -0500
Received: from mail-dm6nam11on2122.outbound.protection.outlook.com ([40.107.223.122]:23936
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1378683AbiAUHNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 02:13:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcfmH8SpdNDxqDDlC02x6DLeb7mM93wgYSpCICeSCiz/jqLGHM93LNZLhJI5m2LMx67z8gfGsaeV/0wWxgTtVEscsfIY3rpVb4C+mbLjFUHgNMWDk9DDdP9StvUup/0a8g+abp2cWAeIYXoLbBMTSFBvAcR8GilhCrawQ8EfchBM7QfbEdBX3mtb/Zx5PZcxU4tpAmDVfbHo2LT3y64odYdSdDCpWYRbVdgGr4lGH2FrQ1qeXlnpUhMk+x7RaqYPAui0DBut7WJ0SsUfJ5zWwH0WQfgLjVuMLRTbX7BXxgKNupnH6BZcRfaXiOXWM4C8RqtIAI/eTHccnHPJAT2GuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYSv7jWB9JNlsyTtxf4o5vOk4LN2qDnD55Rh9U2JOFo=;
 b=GNvJwAZuMSAvNTuk7pR7y4ldmN+jF16Ol6wnhSEgYLdJqyW22jOhVPAdhTMOUsS3B7iEPATxsUAYSYMq/PLS3K0mZV6MfkMs/cqepde1u+QK+GVdA7w8Z7FpJ4gwY19O9FX+A3sceWSryLWzw3Mq0BO/vy3LtP0rYZ3DpptKC7XjwymuaRdz0EV/mZd87h41eD9edyGsU/EmGUS9roGnFOI3WEsinXt6t2L3riCfSYZN64nMkGCee0ULade7dpBpLB4piHRHit95rzU7MTZnc3sI3pddVKxuDnLUNgYG9XaHSwMvJRKl/VwAsife9tEsSdEJfn6WXHkgIRromDLKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYSv7jWB9JNlsyTtxf4o5vOk4LN2qDnD55Rh9U2JOFo=;
 b=CULAsRLnVQsWmcuf0bJ3gC2002DI4YyjptZPdLsu3FDYcADjyQ1u9sPWF6OKyx8KOrvRHXWRAukfvGSNJbb4w63oKrBA7GtJ08/W0y+DdL2epvLNnGte4poPB2v4xiyW2uUi38z6FaDWUFAdM+mejU11bku+yuGyfDsNGvFilsg=
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 (2603:10b6:910:43::20) by BY5PR13MB3254.namprd13.prod.outlook.com
 (2603:10b6:a03:18a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.8; Fri, 21 Jan
 2022 07:13:35 +0000
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::c9cc:2e41:f4dc:bcb7]) by CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::c9cc:2e41:f4dc:bcb7%5]) with mapi id 15.20.4930.006; Fri, 21 Jan 2022
 07:13:34 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: tdc errors
Thread-Topic: tdc errors
Thread-Index: AQHYDiJFrbUH5Hj6ykaVxH6AXj3zpqxsTPAAgADC/eA=
Date:   Fri, 21 Jan 2022 07:13:34 +0000
Message-ID: <CY4PR1301MB21674FE087906ABD054E6955E75B9@CY4PR1301MB2167.namprd13.prod.outlook.com>
References: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
 <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
In-Reply-To: <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ef2f80e-c145-404c-3ed5-08d9dcad89cb
x-ms-traffictypediagnostic: BY5PR13MB3254:EE_
x-microsoft-antispam-prvs: <BY5PR13MB3254910D0BDC893ED9DFF2C7E75B9@BY5PR13MB3254.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t6Bhj8zYtSi9cDnBxLrk7n/4BNtLvp68DzWS+J9m7R+G/UOSZ3+Mu1ioOmrfXfedQxY4GmxBpQNjktHKsB2D03X8SrGX8notw2X2tpC9DuvbjO57nNJoVw+AQXYbLi/lSSSOV0e1uSwThF367eDKSDi8lOYEeq3PjpYLlUZKPRJZgsAW7ry8Yq8sTkRamyCbg4dmkGjqIk1AqRsZEBJ52nOL0lR+0OnsBdJZuES1kuP25M6kUj0lS8DUVg0d8ENi32F1SS0G5xUAb2mG7NYAM6rzTh3fH51d5lJvtnpamsTQPzCuxlmgmMHAQp5fjssZEaPwEZQdNPZI5D0NaNcvlhVzVGq9OmoUIJSe4juWLZ02V93qupAR1WV+3bvIplk2BnlnCKfVWFlyz5G9MMoXXsLjqv38tF8kfINuAa3izbq5Fa2IsU6uKFgmcM97gii1mS1neK0nk8fBqrVjynzGXHQCtQpj016Vpqj5Mc6IrnNhsYOCM6vuAv0hcC89j0HmIh1doYC4fialLWF6yTqFkgeXpCdcp+hbCT6oXoxt4XMXe7AHDH/B/dhRHknXgUyaCS6qwvkfrTdgjkMbZeCcrwBjn1GRndj5fnPaP8pXM/pQbOQ5+QHqhZnLdt0SiaiNQ0bD9OK2oGaCBH4d2P3vc9swH8k7WkDwDOE/X6k9uJb9CQQh1OYq0WLc5QwEmGjHmtvuwM+HvbIjCd2LVic7cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1301MB2167.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(376002)(346002)(396003)(136003)(366004)(38100700002)(122000001)(110136005)(54906003)(26005)(186003)(66946007)(316002)(86362001)(55016003)(76116006)(9686003)(83380400001)(3480700007)(52536014)(5660300002)(71200400001)(33656002)(66446008)(64756008)(7116003)(2906002)(66476007)(7696005)(6506007)(8936002)(8676002)(4326008)(53546011)(38070700005)(508600001)(44832011)(66556008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnNoa0QycVVpdENtOUdSbmRtY25nRTZ3aW5zUWZQQ2dvRi9vU2RwM2pqZlFD?=
 =?utf-8?B?blc0Z2VTU2JHMThJUzFVQi9TdDhYSTlyNTN2VTlvcHdUTWlselFCckFrd1VU?=
 =?utf-8?B?Tzh4WmNxZDJHcUduSXZrUjU1dTdHM2RtUGlDMkYzTHZBZGFJcjZULzBLT0Vx?=
 =?utf-8?B?R01LY2lTcU5vL1VBdXBSL1NkQ3FMME83SmpYYjVwRlpGd20xRVpiRVEyMXpU?=
 =?utf-8?B?eHRtZzFOY2gxNHhYMTNHNEJ0NDhVN3dFT21mWXh5R0ZKaEdvdDJ3bmUwSERU?=
 =?utf-8?B?ajlZTG01T2xZMTNub1NNUnZPdkw5YVY5VmNMRnpqeG9MbzBQNVpoV0dsQm1u?=
 =?utf-8?B?RkhwY1VOL09CdC9vdVhPcUtXVm1jaEVpQXh1MmsyOUNzajNSaEJ1SHA5U1Nj?=
 =?utf-8?B?aHUwZjZmVlhkNVMvZlpvQWxwUGJySWNwcXNkNVovUWNZbTROSHpKbzhwMmcw?=
 =?utf-8?B?azNwNldDNXNUS0w0YXJzaG51TFptTiszeDhyUnc4bndKdlJGNlFOQUZVN2dp?=
 =?utf-8?B?c3NtMUFGSGhzVzNZQkY0a0dwanlmZ2VRaGdyNm10empKeHdLNFNyWVVtWEFQ?=
 =?utf-8?B?Ty9mOXBHOEQyTTl4OUN2WkJITWRjRVEzTzB0Y3JQM08vQkZWaXErRVJtTnRh?=
 =?utf-8?B?RmM3SXNXSmpUbGJZNVA0RDVnNU5xdWNFWmlpVXFxSVJkWHFnWW5VS013bUIw?=
 =?utf-8?B?dDhqVFpmUCtNZXFXVmNSNW5PcTBsOXB3a0s2Y015bHRzUmJYVVd2UEhPRHNl?=
 =?utf-8?B?RGFNRjBneEVpRk1aUTZDaWJiVGFhNUhGYTcvZ1dPOHdiQWkzY1daOUhlNzBy?=
 =?utf-8?B?R3VXUmdSMU9XOXgvbTdUb2kvbnVYSTNnQ3hjdU1QSWhDT3ZVRVRuL253RDhx?=
 =?utf-8?B?OU5rUkg2eUZqdWhpNUdLTEU4QitrQ0xOMzVZRmgxWjNvZ0VuVVoxWWJTeHBO?=
 =?utf-8?B?a3F0TGd5Tlo4OFlKcllhTmNxQnFjVXJBdkZpeC9USzRBMW93RkNibTdJcm50?=
 =?utf-8?B?NVFVUENuRFdDYmhyRmlmUEVRWkhFRDF5bG4xRTh0ZVhlcWs3TTVUSnJPOGdZ?=
 =?utf-8?B?aE5ZTHYxMjJoRHd3RTdEVEFuTUdSQ0haNFNHWlJWM1hUUFQ5YU16S21MV1hE?=
 =?utf-8?B?clB0OU9MTWU2dWhiVHB2bDZTdXpoSTFiUGZ3eUlOTjhkbGUzOE56dzlvM1Jm?=
 =?utf-8?B?NE5QdHA3QldseC9iVFlhMnMzUGRkRHJ5RG5pTnlGQ2pUTi9wcmowOTNpNGg0?=
 =?utf-8?B?MStUam54bnlVM0ZlanNXOG90RTVIMDJRdHZLcHY2SHpqWldBNng1RHBvUGtB?=
 =?utf-8?B?TGdBTDdJWjh3MkF1cEhCTzQwZkdmNUI5bjcxUjcxbjFBWkZjSXI5K0xpajFO?=
 =?utf-8?B?RkpKdFRKTjBrVTlhVGNTLzNNelFLdk00Nk5VaTB0MmVtcUp0TDVBQ2Uvei84?=
 =?utf-8?B?dXI0YUcvYVdJL0IxeTNrenRLbWJtRjR5Y0lRczRoeE1lUHhmem1GSnhPbVkw?=
 =?utf-8?B?RFhidDNZVVMyT2tBVmJRelBxbTN0L1FVS0hrbWh6amFNUHgwamNKdzZoeXRx?=
 =?utf-8?B?cDhPZmEwc0xJZDYyTWtnQjNncEZEZlMydXdaVytpY3d5UUNLc3Q4TmNtcXZY?=
 =?utf-8?B?WU1tTFVxQXJ2ODI3dXpLN0FOdnNNUlNSeTNFcXFydmgxOHcrZlNyQUR4WHN2?=
 =?utf-8?B?NjFSUTM4UE9HelFSdFcyM0x1YldjdXhCTUthR2xUcVZtdml3V1ZpOEwyaXZa?=
 =?utf-8?B?cFdvZWFxQUxzRVRLNi8vWTB5QXZtZFRBVmpsVyt0TVhQelMxeWdaZWRsSUds?=
 =?utf-8?B?dk1TRk5DWGVHZmwyT0tMR3pRYWxQRUtvZmgrcEZLNkRpU21JL00zOTlkaHJX?=
 =?utf-8?B?cm9WK1J4UTZiQVdVWFduQUhmb0krL0M4bmdEdzhTcE1FRUpNcU1jamxiMUlr?=
 =?utf-8?B?NEUwOGU2SmZlU1hZVXBMNm5oV3E3NWt6QlZvVy9UMVFhOWFQWDRDZE5wakw4?=
 =?utf-8?B?OGF3cEZUNk1KVkpCL0paVFpqSlRnQmd3VFBRU3pnRmJ1a3YrSFowcW9lRDMx?=
 =?utf-8?B?MDhnTzVKZHJscDZoc3FoTkFwQjF0N1ltdS9uUnJqOEc2QmJuVjVwSGY5ajNi?=
 =?utf-8?B?TU9DRnFWYzBaMmVIMklORWtwRi9ZTkZkblBteE1jOUVRRVA0RVlBclkybUIr?=
 =?utf-8?B?SHhqU24zSTliaFdkd3U3Zi9DcmdvTXY0WDIzQlNTRk1NMnQxK1FnLzVydWI5?=
 =?utf-8?B?Q1dQaEhVNEFWSWNTZWFLc08yZTdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1301MB2167.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef2f80e-c145-404c-3ed5-08d9dcad89cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 07:13:34.7637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zxbPticoFhkT4ZcPrngrN8K9ON+xYS1KFd4aqmgxeoaB0R0JCKDmrxUXsch8sNExjfAPGooqkX965ZGiSbQfgnXaEaqnI+kFbEE19UubzUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciBicmluZyB0aGlzIHRvIHVzLCB3ZSB3aWxsIHVwc3RyZWFtIHRoZSBzaW5nbGUg
YWN0aW9uIG9mZmxvYWQgc3VwcG9ydCB0byB0aGUgaXByb3V0ZTIuDQpPbiBGcmlkYXksIEphbnVh
cnkgMjEsIDIwMjIgMzozNCBBTSwgSmFtYWwgd3JvdGU6DQo+T24gMjAyMi0wMS0yMCAxMjoyMiwg
VmljdG9yIE5vZ3VlaXJhIHdyb3RlOg0KPj4gSGksDQo+Pg0KPj4gV2hlbiBydW5uaW5nIHRoZXNl
IDIgdGRjIHRlc3RzOg0KPj4NCj4+IDdkNjQgQWRkIHBvbGljZSBhY3Rpb24gd2l0aCBza2lwX2h3
IG9wdGlvbg0KPj4gMzMyOSBWYWxpZGF0ZSBmbGFncyBvZiB0aGUgbWF0Y2hhbGwgZmlsdGVyIHdp
dGggc2tpcF9zdyBhbmQgcG9saWNlDQo+PiBhY3Rpb24gd2l0aCBza2lwX2h3IEkgZ2V0IHRoaXMg
ZXJyb3I6DQo+Pg0KPj4gQmFkIGFjdGlvbiB0eXBlIHNraXBfaHcNCj4+IFVzYWdlOiAuLi4gZ2Fj
dCA8QUNUSU9OPiBbUkFORF0gW0lOREVYXQ0KPj4gV2hlcmU6IEFDVElPTiA6PSByZWNsYXNzaWZ5
IHwgZHJvcCB8IGNvbnRpbnVlIHwgcGFzcyB8IHBpcGUgfCBnb3RvDQo+PiBjaGFpbiA8Q0hBSU5f
SU5ERVg+IHwganVtcCA8SlVNUF9DT1VOVD4gUkFORCA6PSByYW5kb20gPFJBTkRUWVBFPg0KPj4g
PEFDVElPTj4gPFZBTD4gUkFORFRZUEUgOj0gbmV0cmFuZCB8IGRldGVybSBWQUwgOiA9IHZhbHVl
IG5vdA0KPj4gZXhjZWVkaW5nIDEwMDAwIEpVTVBfQ09VTlQgOj0gQWJzb2x1dGUganVtcCBmcm9t
IHN0YXJ0IG9mIGFjdGlvbiBsaXN0DQo+PiBJTkRFWCA6PSBpbmRleCB2YWx1ZSB1c2VkDQo+Pg0K
Pj4gSSdtIGJ1aWxkaW5nIHRoZSBrZXJuZWwgb24gbmV0LW5leHQuDQo+Pg0KPj4gSSdtIGNvbXBp
bGluZyB0aGUgbGF0ZXN0IGlwcm91dGUyIHZlcnNpb24uDQo+Pg0KPj4gSXQgc2VlbXMgbGlrZSB0
aGUgcHJvYmxlbSBpcyB0aGF0IHN1cHBvcnQgaXMgbGFja2luZyBmb3Igc2tpcF9odyBpbg0KPj4g
cG9saWNlIGFjdGlvbiBpbiBpcHJvdXRlMi4NCj4+DQo+DQo+DQo+U28uLi4gSG93IGlzIHRoZSBy
b2JvdCBub3QgcmVwb3J0aW5nIHRoaXMgYXMgYSByZWdyZXNzaW9uPw0KPkRhdmlkZT8gQmFzaWNh
bGx5IGtlcm5lbCBoYXMgdGhlIGZlYXR1cmUgYnV0IGNvZGUgaXMgbWlzc2luZyBpbiBib3RoIGlw
cm91dGUyDQo+YW5kIGlwcm91dGUyLW5leHQuLg0KPg0KPmNoZWVycywNCj5qYW1hbA0K
