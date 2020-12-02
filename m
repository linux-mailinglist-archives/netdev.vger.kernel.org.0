Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BA2CB416
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgLBEy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:54:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6991 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgLBEyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 23:54:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc71dd90000>; Tue, 01 Dec 2020 20:53:45 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 04:53:45 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Dec 2020 04:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqIuC9dQGjlHL0xkYL8FSw7A7FBfMh0TqJO9y0S3SGIV5+6xEWk+NDke8mjzn8NMPXO1PgrNagUz0lBXlL+sNIb+XP1P58ebA2jjkX2B3nddPFTSvldTCU7E5jxSUotU9vNXgcUupRICaO2iAO8CtEhvJ0RtkkLs66YX4I0P3xKn0Mtx2lbZTUXUfZ0St6G1kZjwpL15gyn4Is/qxVQKkqW7rwkycd926kTfKRjzKdCgjr8DZvSuOMwlBR28m/8Z9vkhfvpOk5EhLdI/VvwGV5vG8/FZUW48u6Yu3EoI6QW1zfJs/dLM9kbej3fNV1mnH9lKwe3/CxED6h2PbeDtxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsCPvE3yJA08WCjJV0HD8JG5gjqZujwS56w5y93yp6Y=;
 b=UMQkGvmid3u45qccIhtJpRt+9VK9MS6FSsaZfcBWPNo8p95FQKdxPHuTO3VpLFo/DLIXsdq00bGXDiPUOEgiGQWOz5iYPcFPITDAKzUnhMh+Qnr6pYZA6x0UN7OcvgQMBsdqtzAXLkJVBc6g3iOrjnwGYD9eJvnrhPxnAf88q9oa5dJ82NlYlIotEFmkp7dqR4S0FNjZWV7wf2XYPB5nzPifXZJ2BSw3qUCj4G5xvbmDLRRCpStXuIGrmK5xf9AnY7K6mhGtgtZ6bdNvlTCNZQaIhBabUbjTsCPGRG5b2+E8bY3YgRBHl56bC7QLgl/e9Ac33Qbt6FhGxLiWsHFd3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 04:53:43 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 04:53:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yongji Xie <xieyongji@bytedance.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [External] Re: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgAAhUQCABJD4AIAAOuMAgAGGmoCAADrXgIAAFskggAAyq4CAABrrUIAAwhSAgAARXgA=
Date:   Wed, 2 Dec 2020 04:53:43 +0000
Message-ID: <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
 <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com>
 <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
 <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
In-Reply-To: <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e1f0c1-e639-429a-7f68-08d8967e3ed5
x-ms-traffictypediagnostic: BY5PR12MB3843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3843918AD85E9D3D57A9CDCFDCF30@BY5PR12MB3843.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FOg8IObh5Reie9sAS94mfNFnGz4UXTUUtCdXb94CMNgOq25+o8uCNqdDU5PKbbYv4XEnO07YiucqQNGgIx3s5JkCQwxj8X15vun5gUgFVOB1vseCWpSHbYRC1hExF/rOTsyeVtVlHXroJxVjFlYRfBOelBwLhY2Uie1lXtnFBzseczmnaoi15BC4AQ4aDfHDns8l1qtvp01/QFUYGux2TwrLzu1dgJRDtDns4+F61fboj8qhUndRizehPzCDwP1+gCWs7NkQnnJ0pWgX2HdBrXPL8NEOx2KYI/mB7LoWDjRZYOs3wn2CIsSZH3nHIpw50Hy5XDaZg44Zp1m7Ljc5Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39850400004)(136003)(478600001)(55236004)(33656002)(83380400001)(4326008)(7696005)(2906002)(5660300002)(26005)(6506007)(53546011)(316002)(86362001)(6916009)(9686003)(186003)(71200400001)(8676002)(55016002)(8936002)(64756008)(66946007)(54906003)(52536014)(76116006)(66476007)(66556008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VjJOSGozY215SjF5MnQ1TTJXazVHZlZnMG9VczZlelBjMklzOW1ueXF2Ykd2?=
 =?utf-8?B?VHhLWGZySDhvVU16WGN3ZkQ0akJmaTl0a3h5SERNdHdZL0grSTBJZmI5ZFc3?=
 =?utf-8?B?V2hmWk9iZUluMDFqYXJHNkg3aXFjYWZMTTFHNWxCWlNjZ0EySWlzRVJPVGVz?=
 =?utf-8?B?WFFVSnRvcWdpRkZDUjZyMDNnTW5RSVJvYlVQRXozNDB5WjBOQW1zU1UydU5S?=
 =?utf-8?B?aWNkUlhHTGk2UUtzRVpXRFhhNkRwaGt3Z3drRSsrWDZiMlJiZ1VNdWN3aGdo?=
 =?utf-8?B?aDZEWHBEVWlpeGtaUnh1U2MrTXBYWHoxdWYvN3RxdEtOL1pHbFowWG0zcGhC?=
 =?utf-8?B?ZUREQ0oxNFVuYVJQS292OENPUnNpSXFwTlBUOHlYa2xUblhLQTRxTC9vakx4?=
 =?utf-8?B?YUhZMGFmY0NSY2h3bFNaVnZGR3NKcy9HLzZ5cG9qTVlESHNPQU5tcXV6UXJv?=
 =?utf-8?B?eGluSlpuZm9ZTk0zRkkwbWtnL0owOUo4Y20xTFVYZDFWRWpSSXpaWmRwTS9r?=
 =?utf-8?B?S3FOSEptKzdxQTI1WTNMQ2ZvbCsyZXdxZlZOU3Y0S2xCOFN2NzFJK09ZZUUx?=
 =?utf-8?B?eDhaK000QnkwQlJFcEN4SlFUOE9IbXZhNUFZNkpaVGUydFRaKzlQandON0RT?=
 =?utf-8?B?Y0IxWDJZbmdjVVRtS0lqTDB3RUsyZ0xPVjVlSFBUVFBaazBVYkdxWUpQLzhZ?=
 =?utf-8?B?TDdFOFB2bHRxZEZHOUxwb3BxTmxpQkFyU2lMaCs0YVBtL1c3MU14LzZIUzFX?=
 =?utf-8?B?MlZuSGJpYmJBYXB0UzNkSlo2eFpjK3N3NGt4dGxJSXNDdjhQdXBISTB3c28x?=
 =?utf-8?B?aGpwbWRzSWJjUVhKQWlIRWpibWs1UnRBbmp6eEtnM0diVjExQXlYR094NUNF?=
 =?utf-8?B?Ni9TVjNTcENLYWhCV1Y3d1pZZWZoUE9EYTczVStKb2hURjF2QzY0d1JybmZK?=
 =?utf-8?B?VkwrbWhQWWVQZ2pyR2xhRElYeEhIcWNXL1Y5cmhQaTczZkd6YkFVeUpuMGFa?=
 =?utf-8?B?SWVMUXFQWFRIQUpWNmRWTGE5RVdtOFlMUktyMWdzWXpyQ0FNK1hzOC8zejJL?=
 =?utf-8?B?dy9kdUEvb2J3QUM0Z1VaUTM4eDUyNUtBYTNTSWhVaWlKdnI2ZWc3N0h0dDE0?=
 =?utf-8?B?MDgxQzVvMms4cWRkcXl0c3JKVkZsUHRML2xmdXZPU1lqUTVyS3JQaFVPbWor?=
 =?utf-8?B?YXZJM3NmMnpsNmo0NVZFbmgwZnpBY0xGeGtkamVnOGIzVnk5ZXZLK0FZY2JK?=
 =?utf-8?B?L3ZUZURlVUovaHFMVXhxcXpqWUJKY280K1hBR0RLNVZTT1c4MU9EVHFVM1dW?=
 =?utf-8?Q?M0K5AzhihKEi8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e1f0c1-e639-429a-7f68-08d8967e3ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 04:53:43.5885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KxApS8R8FGGAkzHnp0+yizQwpeknCqR20aE83QTvKTU1USmK3kv70z7FwNNn9RLf7vu4RJawjnukp0OsIulcog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3843
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606884825; bh=SsCPvE3yJA08WCjJV0HD8JG5gjqZujwS56w5y93yp6Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=QnZpRWn7P5tQaqDrMe/8rGvbOJrZS+qZEAIX6tMY13xNCRILNi05vv6zM1eDAJP56
         hoVJKOzmkiLNBPwIYEioLlgrzTSl1rq2PjwDHh8rd8LznIYf0ZJRSD/dZx7hhiI+Iy
         JV9sB3eNyI+dGbstDv1mFiDZtafPd3iuNsNUVZMek/a1runbsst3mmBZKh1fcPV0ui
         z1U9mP/866OLGD9dlHsPF421PtO8nZIfbitcMjpko96IbUAo3jLoaPrEHrXYsJsH7k
         kkij7acfi3dpgHyTQ9ncXSwlBlztNxQNApMVMwrRP7yDdo5VS/1fkMVmnpN5XMoY3P
         IlxNWA7zX6OPQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+IFNlbnQ6
IFdlZG5lc2RheSwgRGVjZW1iZXIgMiwgMjAyMCA5OjAwIEFNDQo+IA0KPiBPbiBUdWUsIERlYyAx
LCAyMDIwIGF0IDExOjU5IFBNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBZb25namkgWGllIDx4aWV5b25namlAYnl0ZWRh
bmNlLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgNzo0OSBQTQ0K
PiA+ID4NCj4gPiA+IE9uIFR1ZSwgRGVjIDEsIDIwMjAgYXQgNzozMiBQTSBQYXJhdiBQYW5kaXQg
PHBhcmF2QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+
ID4gPiA+IEZyb206IFlvbmdqaSBYaWUgPHhpZXlvbmdqaUBieXRlZGFuY2UuY29tPg0KPiA+ID4g
PiA+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgMzoyNiBQTQ0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gT24gVHVlLCBEZWMgMSwgMjAyMCBhdCAyOjI1IFBNIEphc29uIFdhbmcgPGphc293
YW5nQHJlZGhhdC5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gT24gMjAyMC8xMS8zMCDkuIvljYgzOjA3LCBZb25namkgWGllIHdyb3RlOg0K
PiA+ID4gPiA+ID4gPj4+IFRoYW5rcyBmb3IgYWRkaW5nIG1lLCBKYXNvbiENCj4gPiA+ID4gPiA+
ID4+Pg0KPiA+ID4gPiA+ID4gPj4+IE5vdyBJJ20gd29ya2luZyBvbiBhIHYyIHBhdGNoc2V0IGZv
ciBWRFVTRSAodkRQQSBEZXZpY2UgaW4NCj4gPiA+ID4gPiA+ID4+PiBVc2Vyc3BhY2UpIFsxXS4g
VGhpcyB0b29sIGlzIHZlcnkgdXNlZnVsIGZvciB0aGUgdmR1c2UgZGV2aWNlLg0KPiA+ID4gPiA+
ID4gPj4+IFNvIEknbSBjb25zaWRlcmluZyBpbnRlZ3JhdGluZyB0aGlzIGludG8gbXkgdjIgcGF0
Y2hzZXQuDQo+ID4gPiA+ID4gPiA+Pj4gQnV0IHRoZXJlIGlzIG9uZSBwcm9ibGVt77yaDQo+ID4g
PiA+ID4gPiA+Pj4NCj4gPiA+ID4gPiA+ID4+PiBJbiB0aGlzIHRvb2wsIHZkcGEgZGV2aWNlIGNv
bmZpZyBhY3Rpb24gYW5kIGVuYWJsZSBhY3Rpb24NCj4gPiA+ID4gPiA+ID4+PiBhcmUgY29tYmlu
ZWQgaW50byBvbmUgbmV0bGluayBtc2c6IFZEUEFfQ01EX0RFVl9ORVcuIEJ1dA0KPiA+ID4gPiA+
ID4gPj4+IGluDQo+ID4gPiB2ZHVzZQ0KPiA+ID4gPiA+ID4gPj4+IGNhc2UsIGl0IG5lZWRzIHRv
IGJlIHNwbGl0dGVkIGJlY2F1c2UgYSBjaGFyZGV2IHNob3VsZCBiZQ0KPiA+ID4gPiA+ID4gPj4+
IGNyZWF0ZWQgYW5kIG9wZW5lZCBieSBhIHVzZXJzcGFjZSBwcm9jZXNzIGJlZm9yZSB3ZSBlbmFi
bGUNCj4gPiA+ID4gPiA+ID4+PiB0aGUgdmRwYSBkZXZpY2UgKGNhbGwgdmRwYV9yZWdpc3Rlcl9k
ZXZpY2UoKSkuDQo+ID4gPiA+ID4gPiA+Pj4NCj4gPiA+ID4gPiA+ID4+PiBTbyBJJ2QgbGlrZSB0
byBrbm93IHdoZXRoZXIgaXQncyBwb3NzaWJsZSAob3IgaGF2ZSBzb21lDQo+ID4gPiA+ID4gPiA+
Pj4gcGxhbnMpIHRvIGFkZCB0d28gbmV3IG5ldGxpbmsgbXNncyBzb21ldGhpbmcgbGlrZToNCj4g
PiA+ID4gPiA+ID4+PiBWRFBBX0NNRF9ERVZfRU5BQkxFDQo+ID4gPiA+ID4gYW5kDQo+ID4gPiA+
ID4gPiA+Pj4gVkRQQV9DTURfREVWX0RJU0FCTEUgdG8gbWFrZSB0aGUgY29uZmlnIHBhdGggbW9y
ZSBmbGV4aWJsZS4NCj4gPiA+ID4gPiA+ID4+Pg0KPiA+ID4gPiA+ID4gPj4gQWN0dWFsbHksIHdl
J3ZlIGRpc2N1c3NlZCBzdWNoIGludGVybWVkaWF0ZSBzdGVwIGluIHNvbWUNCj4gPiA+ID4gPiA+
ID4+IGVhcmx5IGRpc2N1c3Npb24uIEl0IGxvb2tzIHRvIG1lIFZEVVNFIGNvdWxkIGJlIG9uZSBv
ZiB0aGUgdXNlcnMgb2YNCj4gdGhpcy4NCj4gPiA+ID4gPiA+ID4+DQo+ID4gPiA+ID4gPiA+PiBP
ciBJIHdvbmRlciB3aGV0aGVyIHdlIGNhbiBzd2l0Y2ggdG8gdXNlIGFub255bW91cw0KPiA+ID4g
PiA+ID4gPj4gaW5vZGUoZmQpIGZvciBWRFVTRSB0aGVuIGZldGNoaW5nIGl0IHZpYSBhbiBWRFVT
RV9HRVRfREVWSUNFX0ZEDQo+IGlvY3RsPw0KPiA+ID4gPiA+ID4gPj4NCj4gPiA+ID4gPiA+ID4g
WWVzLCB3ZSBjYW4uIEFjdHVhbGx5IHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGluIFZEVVNF
IGlzDQo+ID4gPiA+ID4gPiA+IGxpa2UgdGhpcy4gIEJ1dCBzZWVtcyBsaWtlIHRoaXMgaXMgc3Rp
bGwgYSBpbnRlcm1lZGlhdGUgc3RlcC4NCj4gPiA+ID4gPiA+ID4gVGhlIGZkIHNob3VsZCBiZSBi
aW5kZWQgdG8gYSBuYW1lIG9yIHNvbWV0aGluZyBlbHNlIHdoaWNoDQo+ID4gPiA+ID4gPiA+IG5l
ZWQgdG8gYmUgY29uZmlndXJlZCBiZWZvcmUuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IFRoZSBuYW1lIGNvdWxkIGJlIHNwZWNpZmllZCB2aWEgdGhlIG5ldGxpbmsuIEl0
IGxvb2tzIHRvIG1lDQo+ID4gPiA+ID4gPiB0aGUgcmVhbCBpc3N1ZSBpcyB0aGF0IHVudGlsIHRo
ZSBkZXZpY2UgaXMgY29ubmVjdGVkIHdpdGggYQ0KPiA+ID4gPiA+ID4gdXNlcnNwYWNlLCBpdCBj
YW4ndCBiZSB1c2VkLiBTbyB3ZSBhbHNvIG5lZWQgdG8gZmFpbCB0aGUNCj4gPiA+ID4gPiA+IGVu
YWJsaW5nIGlmIGl0IGRvZXNuJ3QNCj4gPiA+IG9wZW5lZC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBZZXMsIHRoYXQncyB0cnVlLiBTbyB5b3UgbWVhbiB3ZSBjYW4gZmlyc3Rs
eSB0cnkgdG8gZmV0Y2ggdGhlIGZkDQo+ID4gPiA+ID4gYmluZGVkIHRvIGEgbmFtZS92ZHVzZV9p
ZCB2aWEgYW4gVkRVU0VfR0VUX0RFVklDRV9GRCwgdGhlbiB1c2UNCj4gPiA+ID4gPiB0aGUgbmFt
ZS92ZHVzZV9pZCBhcyBhIGF0dHJpYnV0ZSB0byBjcmVhdGUgdmRwYSBkZXZpY2U/IEl0IGxvb2tz
IGZpbmUgdG8NCj4gbWUuDQo+ID4gPiA+DQo+ID4gPiA+IEkgcHJvYmFibHkgZG8gbm90IHdlbGwg
dW5kZXJzdGFuZC4gSSB0cmllZCByZWFkaW5nIHBhdGNoIFsxXSBhbmQNCj4gPiA+ID4gZmV3IHRo
aW5ncw0KPiA+ID4gZG8gbm90IGxvb2sgY29ycmVjdCBhcyBiZWxvdy4NCj4gPiA+ID4gQ3JlYXRp
bmcgdGhlIHZkcGEgZGV2aWNlIG9uIHRoZSBidXMgZGV2aWNlIGFuZCBkZXN0cm95aW5nIHRoZQ0K
PiA+ID4gPiBkZXZpY2UgZnJvbQ0KPiA+ID4gdGhlIHdvcmtxdWV1ZSBzZWVtcyB1bm5lY2Vzc2Fy
eSBhbmQgcmFjeS4NCj4gPiA+ID4NCj4gPiA+ID4gSXQgc2VlbXMgdmR1c2UgZHJpdmVyIG5lZWRz
DQo+ID4gPiA+IFRoaXMgaXMgc29tZXRoaW5nIHNob3VsZCBiZSBkb25lIGFzIHBhcnQgb2YgdGhl
IHZkcGEgZGV2IGFkZA0KPiA+ID4gPiBjb21tYW5kLA0KPiA+ID4gaW5zdGVhZCBvZiBjb25uZWN0
aW5nIHR3byBzaWRlcyBzZXBhcmF0ZWx5IGFuZCBlbnN1cmluZyByYWNlIGZyZWUNCj4gPiA+IGFj
Y2VzcyB0byBpdC4NCj4gPiA+ID4NCj4gPiA+ID4gU28gVkRVU0VfREVWX1NUQVJUIGFuZCBWRFVT
RV9ERVZfU1RPUCBzaG91bGQgcG9zc2libHkgYmUgYXZvaWRlZC4NCj4gPiA+ID4NCj4gPiA+DQo+
ID4gPiBZZXMsIHdlIGNhbiBhdm9pZCB0aGVzZSB0d28gaW9jdGxzIHdpdGggdGhlIGhlbHAgb2Yg
dGhlIG1hbmFnZW1lbnQgdG9vbC4NCj4gPiA+DQo+ID4gPiA+ICQgdmRwYSBkZXYgYWRkIHBhcmVu
dGRldiB2ZHVzZV9tZ210ZGV2IHR5cGUgbmV0IG5hbWUgZm9vMg0KPiA+ID4gPg0KPiA+ID4gPiBX
aGVuIGFib3ZlIGNvbW1hbmQgaXMgZXhlY3V0ZWQgaXQgY3JlYXRlcyBuZWNlc3NhcnkgdmRwYSBk
ZXZpY2UNCj4gPiA+ID4gZm9vMg0KPiA+ID4gb24gdGhlIGJ1cy4NCj4gPiA+ID4gV2hlbiB1c2Vy
IGJpbmRzIGZvbzIgZGV2aWNlIHdpdGggdGhlIHZkdXNlIGRyaXZlciwgaW4gdGhlIHByb2JlKCks
DQo+ID4gPiA+IGl0DQo+ID4gPiBjcmVhdGVzIHJlc3BlY3RpdmUgY2hhciBkZXZpY2UgdG8gYWNj
ZXNzIGl0IGZyb20gdXNlciBzcGFjZS4NCj4gPiA+DQo+ID4gSSBzZWUuIFNvIHZkdXNlIGNhbm5v
dCB3b3JrIHdpdGggYW55IGV4aXN0aW5nIHZkcGEgZGV2aWNlcyBsaWtlIGlmYywgbWx4NSBvcg0K
PiBuZXRkZXZzaW0uDQo+ID4gSXQgaGFzIGl0cyBvd24gaW1wbGVtZW50YXRpb24gc2ltaWxhciB0
byBmdXNlIHdpdGggaXRzIG93biBiYWNrZW5kIG9mIGNob2ljZS4NCj4gPiBNb3JlIGJlbG93Lg0K
PiA+DQo+ID4gPiBCdXQgdmR1c2UgZHJpdmVyIGlzIG5vdCBhIHZkcGEgYnVzIGRyaXZlci4gSXQg
d29ya3MgbGlrZSB2ZHBhc2ltDQo+ID4gPiBkcml2ZXIsIGJ1dCBvZmZsb2FkcyB0aGUgZGF0YSBw
bGFuZSBhbmQgY29udHJvbCBwbGFuZSB0byBhIHVzZXIgc3BhY2UgcHJvY2Vzcy4NCj4gPg0KPiA+
IEluIHRoYXQgY2FzZSB0byBkcmF3IHBhcmFsbGVsIGxpbmVzLA0KPiA+DQo+ID4gMS4gbmV0ZGV2
c2ltOg0KPiA+IChhKSBjcmVhdGUgcmVzb3VyY2VzIGluIGtlcm5lbCBzdw0KPiA+IChiKSBkYXRh
cGF0aCBzaW11bGF0ZXMgaW4ga2VybmVsDQo+ID4NCj4gPiAyLiBpZmMgKyBtbHg1IHZkcGEgZGV2
Og0KPiA+IChhKSBjcmVhdGVzIHJlc291cmNlIGluIGh3DQo+ID4gKGIpIGRhdGEgcGF0aCBpcyBp
biBodw0KPiA+DQo+ID4gMy4gdmR1c2U6DQo+ID4gKGEpIGNyZWF0ZXMgcmVzb3VyY2VzIGluIHVz
ZXJzcGFjZSBzdw0KPiA+IChiKSBkYXRhIHBhdGggaXMgaW4gdXNlciBzcGFjZS4NCj4gPiBoZW5j
ZSBjcmVhdGVzIGRhdGEgcGF0aCByZXNvdXJjZXMgZm9yIHVzZXIgc3BhY2UuDQo+ID4gU28gY2hh
ciBkZXZpY2UgaXMgY3JlYXRlZCwgcmVtb3ZlZCBhcyByZXN1bHQgb2YgdmRwYSBkZXZpY2UgY3Jl
YXRpb24uDQo+ID4NCj4gPiBGb3IgZXhhbXBsZSwNCj4gPiAkIHZkcGEgZGV2IGFkZCBwYXJlbnRk
ZXYgdmR1c2VfbWdtdGRldiB0eXBlIG5ldCBuYW1lIGZvbzINCj4gPg0KPiA+IEFib3ZlIGNvbW1h
bmQgd2lsbCBjcmVhdGUgY2hhciBkZXZpY2UgZm9yIHVzZXIgc3BhY2UuDQo+ID4NCj4gPiBTaW1p
bGFyIGNvbW1hbmQgZm9yIGlmYy9tbHg1IHdvdWxkIGhhdmUgY3JlYXRlZCBzaW1pbGFyIGNoYW5u
ZWwgZm9yIHJlc3Qgb2YNCj4gdGhlIGNvbmZpZyBjb21tYW5kcyBpbiBody4NCj4gPiB2ZHVzZSBj
aGFubmVsID0gY2hhciBkZXZpY2UsIGV2ZW50ZmQgZXRjLg0KPiA+IGlmYy9tbHg1IGh3IGNoYW5u
ZWwgPSBiYXIsIGlycSwgY29tbWFuZCBpbnRlcmZhY2UgZXRjIE5ldGRldiBzaW0NCj4gPiBjaGFu
bmVsID0gc3cgZGlyZWN0IGNhbGxzDQo+ID4NCj4gPiBEb2VzIGl0IG1ha2Ugc2Vuc2U/DQo+IA0K
PiBJbiBteSB1bmRlcnN0YW5kaW5nLCB0byBtYWtlIHZkcGEgd29yaywgd2UgbmVlZCBhIGJhY2tl
bmQgKGRhdGFwYXRoDQo+IHJlc291cmNlcykgYW5kIGEgZnJvbnRlbmQgKGEgdmRwYSBkZXZpY2Ug
YXR0YWNoZWQgdG8gYSB2ZHBhIGJ1cykuIEluIHRoZSBhYm92ZQ0KPiBleGFtcGxlLCBpdCBsb29r
cyBsaWtlIHdlIHVzZSB0aGUgY29tbWFuZCAidmRwYSBkZXYgYWRkIC4uLiINCj4gIHRvIGNyZWF0
ZSBhIGJhY2tlbmQsIHNvIGRvIHdlIG5lZWQgYW5vdGhlciBjb21tYW5kIHRvIGNyZWF0ZSBhIGZy
b250ZW5kPw0KPiANCkZvciBibG9jayBkZXZpY2UgdGhlcmUgaXMgY2VydGFpbmx5IHNvbWUgYmFj
a2VuZCB0byBwcm9jZXNzIHRoZSBJT3MuDQpTb21ldGltZXMgYmFja2VuZCB0byBiZSBzZXR1cCBm
aXJzdCwgYmVmb3JlIGl0cyBmcm9udCBlbmQgaXMgZXhwb3NlZC4NCiJ2ZHBhIGRldiBhZGQiIGlz
IHRoZSBmcm9udCBlbmQgY29tbWFuZCB3aG8gY29ubmVjdHMgdG8gdGhlIGJhY2tlbmQgKGltcGxp
Y2l0bHkpIGZvciBuZXR3b3JrIGRldmljZS4NCg0Kdmhvc3QtPnZkcGFfYmxvY2tfZGV2aWNlLT5i
YWNrZW5kX2lvX3Byb2Nlc3NvciAodXNyLGh3LGtlcm5lbCkuDQoNCkFuZCBpdCBuZWVkcyBhIHdh
eSB0byBjb25uZWN0IHRvIGJhY2tlbmQgd2hlbiBleHBsaWNpdGx5IHNwZWNpZmllZCBkdXJpbmcg
Y3JlYXRpb24gdGltZS4NClNvbWV0aGluZyBsaWtlLA0KJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2
IHZkcGFfdmR1c2UgdHlwZSBibG9jayBuYW1lIGZvbzMgaGFuZGxlIDx1dWlkPg0KSW4gYWJvdmUg
ZXhhbXBsZSBzb21lIHZlbmRvciBkZXZpY2Ugc3BlY2lmaWMgdW5pcXVlIGhhbmRsZSBpcyBwYXNz
ZWQgYmFzZWQgb24gYmFja2VuZCBzZXR1cCBpbiBoYXJkd2FyZS91c2VyIHNwYWNlLg0KDQpJbiBi
ZWxvdyAzIGV4YW1wbGVzLCB2ZHBhIGJsb2NrIHNpbXVsYXRvciBpcyBjb25uZWN0aW5nIHRvIGJh
Y2tlbmQgYmxvY2sgb3IgZmlsZS4NCg0KJCB2ZHBhIGRldiBhZGQgcGFyZW50ZGV2IHZkcGFfYmxv
Y2tzaW0gdHlwZSBibG9jayBuYW1lIGZvbzQgYmxvY2tkZXYgL2Rldi96ZXJvDQoNCiQgdmRwYSBk
ZXYgYWRkIHBhcmVudGRldiB2ZHBhX2Jsb2Nrc2ltIHR5cGUgYmxvY2sgbmFtZSBmb281IGJsb2Nr
ZGV2IC9kZXYvc2RhMiBzaXplPTEwME0gb2Zmc2V0PTEwTQ0KDQokIHZkcGEgZGV2IGFkZCBwYXJl
bnRkZXYgdmRwYV9ibG9jayBmaWxlYmFja2VuZF9zaW0gdHlwZSBibG9jayBuYW1lIGZvbzYgZmls
ZSAvcm9vdC9maWxlX2JhY2tlbmQudHh0DQoNCk9yIG1heSBiZSBiYWNrZW5kIGNvbm5lY3RzIHRv
IHRoZSBjcmVhdGVkIHZkcGEgZGV2aWNlIGlzIGJvdW5kIHRvIHRoZSBkcml2ZXIuDQpDYW4gdmR1
c2UgYXR0YWNoIHRvIHRoZSBjcmVhdGVkIHZkcGEgYmxvY2sgZGV2aWNlIHRocm91Z2ggdGhlIGNo
YXIgZGV2aWNlIGFuZCBlc3RhYmxpc2ggdGhlIGNoYW5uZWwgdG8gcmVjZWl2ZSBJT3MsIGFuZCB0
byBzZXR1cCB0aGUgYmxvY2sgY29uZmlnIHNwYWNlPw0KDQo+IFRoYW5rcywNCj4gWW9uZ2ppDQo=
