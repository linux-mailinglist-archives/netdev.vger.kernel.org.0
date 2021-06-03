Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8295639A1EB
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFCNOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:14:03 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:16812
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231235AbhFCNOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcMG2R23dw5kUDMDJrrNX+49tLFvsWb0UQIaFgvqVoVB5giGWBD6Y5zjsTlmUsegG+8re0701djzVHdpY++JAs9xOCEZaaCY6SrpM4FvUdJeYjPNlLrGbkBzOPjETUdVpQjd8XHXKgBgrHUTicbN0bgCLtxS0P0YLy0kPrZ3Mtej/qykNhHaYYGYYrXSsBbXr27q1VagPiVW9ssq5wRv1QjRWVaAFDCnAJIWmqEVhnuv3meGZvEdOehsbvWSa+0JVV20Rhw+bWdnq4myBh2fR94CV0VszgJg4g3kXmjfOw8RUgCPLYtJL6qcrh9a7XUWMVCOTtbVRZjU+C1lTiQ9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEXG81ZIASb2hXVFNZtvrZqkNpykR9Fldm7aYfU6QG8=;
 b=Hw3KwZUTArxU6znHfnbMdNHyjRpnj2f2ayEGVPMVb2JWv6sUYNvk23WQeED7seqmY6jizmHHkw3SkNWdj2cwfipmLA6vh9Yyktqb4MhZ56h179dg3qIdtlTJNWT0Wc8g1QL1wiRc5rxf8N5PIEOQP50WvVyZkFK7u+cSDppah4KwsZykniiu3SsCycqgPGZaYSrJRCm6nhJYLnecH/a45bk2qhPs/zsq+X0M8zSyTkCInFXDnegRNd/Q+cVViotDkrklYg/K8AacfK+Ipr74rAGR4TlwpQxmjQAddmEcNrGc50QRoU2IXEiuTJKSyZyA2eAHy0mtwcyVlyCNCkIV7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEXG81ZIASb2hXVFNZtvrZqkNpykR9Fldm7aYfU6QG8=;
 b=P4J9/QbRSi3iUHnBvjwzRwgdXGvmtF8qykbk1rfAuqwAzI2vfEZWpjTXntl1sLIOvPnuEWqaL3XGfIzz+n1jmugnTM5kVZ+QFy0luktt9uhF2evoe56uiHhj7bgr5lF0FZHu17llgA5eO/LGH25vd7g3Nvu74fX2iQrT+ygU9gA=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB5482.namprd10.prod.outlook.com (2603:10b6:510:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 3 Jun
 2021 13:12:16 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 13:12:16 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: /sys/class/net/eth0/name_assign_type -> EINVAL
Thread-Topic: /sys/class/net/eth0/name_assign_type -> EINVAL
Thread-Index: AQHXWHltyt+qV8FxG0GezI/QpvQ5e6sCQzAA
Date:   Thu, 3 Jun 2021 13:12:16 +0000
Message-ID: <5922a590219f3940a7ce94901b8d916daee31d3a.camel@infinera.com>
References: <1b61b068cd72677cf5f0c80b82092dcb1684fa9d.camel@infinera.com>
In-Reply-To: <1b61b068cd72677cf5f0c80b82092dcb1684fa9d.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 331752e7-d47a-4596-e61d-08d9269135b9
x-ms-traffictypediagnostic: PH0PR10MB5482:
x-microsoft-antispam-prvs: <PH0PR10MB548277B55FDEA01D88E9D6FEF43C9@PH0PR10MB5482.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kqPdwryTQ1W1xXmBoyQ/xHXAZ2OE/p0OcZ00+GXFLxbsa3iShdxEOjFfo6F2hnYfvr5nCbjGLE5dOQPNDqQVG7ci2nzga1xPjtkO+d+aQ5Q0iCgX5UhybOvyTwa45APK97StVLfW1t0RdoKyktdcxKOc1AuwWTbExvzMh8LgBBURcDMet2qZGctNh1QqVOP6I4sV2FvuhivTSuYzZf+99gIqSyGcnX4YuLrbcwj0U6UYdD9UJhTIUbXMBRp+3mDFTgnZKXK3WAK2gVigrc8F04c5GMFGd/Oy9aU8Ly9m00Al7wbkNH6A494x+Mhsy7xOA8QducU+vfozw8QYToMy3/cxhcOdSWPARPXmGPzss2w0j2jKvXLneXZ/f2Ua8tmTbjf/cBdWMiyHhCaFenI7maY6MoLV0OfZOp2iteGqUTR7+70zLzz2G/v8YVS/IuMup3bbXhg5vzh3UQ6bmUnsbSkKMc6/v/uErR0mmZNH92DwbcZQ3OBzwujZvA4Uyr79XkVZtWD82oXjpCgQKq/me3RNonvM85rLhquZiJ5r17+NTpMo9JB2zqE5YIMH2gz54XHkRldS2gjVEaYfyVyX4qgwSbYYCzmwWHH0OCcY418=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(6916009)(26005)(186003)(36756003)(6486002)(5660300002)(2906002)(66946007)(86362001)(91956017)(76116006)(71200400001)(478600001)(38100700002)(64756008)(6512007)(66476007)(66556008)(66446008)(316002)(2616005)(558084003)(6506007)(122000001)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dzZQb3FUUkFIRXBZTzZOWkpzUG1tRDFBMjlaM29XZTlLY0dvL0I5Wm5sc3py?=
 =?utf-8?B?M0pwb2xMYzluODk0UkIxbkxBZFdaNmp6Zm1Oa0tpNjNLbTRxQTVNMlJISjF5?=
 =?utf-8?B?bS9OK05sQUt2MmJBZW5HUDcvQVVIVlFkV0NwU1B4dGtVdk00RVJNVHpvWnZF?=
 =?utf-8?B?NjdSTm9waUJDKzFZcDlOZDYrMlN5K1dvU2UvUW1tc1ZpKzJ5Vlp2WklBb3ZT?=
 =?utf-8?B?UkR3dzVqS0xJbHY0N0xrWHlGTzBVNHB6bFI4Q0JNQVFyWTVlaHR2TjA2OHJr?=
 =?utf-8?B?ZHZobUczTjBFS1Z2NE5BUDhoYUFFWG9VT0plK09LRVRxc0ljMzM3aktJN2dX?=
 =?utf-8?B?eGc5QlR2bzdQTnZoWUJvLzhwU1FUTTFkWGlVeGZrL1hvOUUzcFdZdnhtaWFn?=
 =?utf-8?B?TVljYUR3dFBlazlpTGVhdmFRU0hEVTYvWThQQTdLY056Tll1UUFGa0w5V2J0?=
 =?utf-8?B?VXB6cWlTbC9KNWlXVE5MOXpDMmJycm1UYXc2WFo5ZUVVWDJEckJWTVRYS1Vt?=
 =?utf-8?B?Qm5SQlBKak51R0NZUHVLdjVITUlmS0lMdkFiR0xwdEZXNTgwT0xKOXpraDFD?=
 =?utf-8?B?Y3A2Mm9rc2FQWC9ZMXIvUTBxR3ZzTUhpQnQzU0ZZcFFlalBlUnVDTGFlWUp2?=
 =?utf-8?B?WlVtdkNKVGlZRkFuT1pxblljOWVBK1lTRi9OYml6QytHWTF5YjZCZkJPRmxh?=
 =?utf-8?B?YmxzZi9Pc3FzSGVmNkxkRDdQRW9weUUyN05SRXhTNUZTS2J0Q1lMOTZGM2ds?=
 =?utf-8?B?UHlmSHZMSlo4Y3g4UVVRUi9RbDYzcXNIRjVIdHVWenNIc3h4TGtQNjZmdTlj?=
 =?utf-8?B?bzJXYWNQdFRKOGh5aHllR1htWmMxSStqZ2NuOHZTTTljTWk0QTk0VXZLOGcv?=
 =?utf-8?B?RHVVZTMzN1BYTExzZi9WdnorTm1hdU8rZmtZbWMvZWdVRmR5dmg5Zm9jV2VM?=
 =?utf-8?B?cnpyeUdHNlVxbXBQaEx0YTJuQisvVU52cUJ6NkxXYk9QOWlqRzZuaUUvdTdW?=
 =?utf-8?B?eURENmx2ZStURkJHcGFRTU5vci80SHF4SGJlZU12RlVOSUdkaHpFeXA1V29z?=
 =?utf-8?B?QkxJR3NzRk5ocmhhdG5BcGFmM3ZnZi95MURxQ0I2Yk9HOExhalNWR0FDOWZm?=
 =?utf-8?B?RzlwOFd4STJBOGkyVTBLNWZ0b0liOGFmSGF4Q0JpNXlEbXZrdW8reGpIZW9N?=
 =?utf-8?B?V29EOFM1KzBwaDZKUzZ3eUFEWFRsd2R4QXVvK3dRUHR2VjlEMnJyS3ZFRXNz?=
 =?utf-8?B?RHE0RGQwekFaQXVNMEdLaVRpNituRXdCOTNCT0t5VDZzc1ZEU29aclZyKzVv?=
 =?utf-8?B?Umh2eS9MSytDNnNRU3FWcDA2MytlTVdpOGJqcUk5Nm9ualFVSFovc3kzdHpV?=
 =?utf-8?B?OWdLNi9iR3J3N1NlaUE2eWkrVnA2dUhZQ0ZOWVlyZTk0ckZteGVHYndHZVE5?=
 =?utf-8?B?Vkh4WjE4M1FzN3VxbnhEcVBGZmkwNC9rZ1p0eW5vY0RkVWpOVHltSm0wZWk0?=
 =?utf-8?B?a2NMZEt6ZmQ4SVEwQU8ra3JlZmpLL2VLeHhLaHZudXBranpSUjlVN1ZLTDVK?=
 =?utf-8?B?a0JESFRteTR3dm9ncXFKb1hPb0cwa2grZ284QnN0d0E4UDAvSkZ0cFhxVDRJ?=
 =?utf-8?B?RktscTBUUUZUbGVnN0RZa0hzdXV0aHpzMG5jeEhxejdYdXVTajZqUnJiaC8w?=
 =?utf-8?B?NmFuSjJPSVJyaVRMTTFscysyYXBIZEEyU0xBVmU5YWdnN3BGQmRjVkNEUUN2?=
 =?utf-8?B?dHRPeWM0WWxpTll3VmhNZVpDbGZMZEV5MitmOWc1ekE5S2h2eWF0cTlQeXIz?=
 =?utf-8?B?Q3B3MCtvdkZrTUZ4UGFXUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <432DD1DF440C8348A6FB31D3DC377AA8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331752e7-d47a-4596-e61d-08d9269135b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 13:12:16.1730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/m5frVlXZvQrDkuvYCVQeqxUo1DPPGBApUL49fcBAHt3h2UdM9XmqId3jsh7Abg8b9HpeBR1eo1Jj7TDRAvQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5482
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2VlbXMgbGlrZSBvbGQgZXRoIGludGVyZmFjZSBuYW1lcyBjYW5ub3QgcmVhZCBuYW1lX2Fzc2ln
bl90eXBlOg0KY2F0IC9zeXMvY2xhc3MvbmV0L2V0aDAvbmFtZV9hc3NpZ25fdHlwZQ0KY2F0OiAv
c3lzL2NsYXNzL25ldC9ldGgwL25hbWVfYXNzaWduX3R5cGU6IEludmFsaWQgYXJndW1lbnQNCg0K
c3lzdGVtZCB4LmxpbmsgbmVlZHMgbmFtZV9hc3NpZ25fdHlwZQ0KDQrCoEpvY2tlDQoNCg==
