Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446EB1CB5D8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgEHRYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:24:45 -0400
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:6064
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgEHRYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 13:24:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jL0O7sW0ggsyZnqn2dlNJhAXr5C+nouujGIQstORhJ8z9SfaJU8kR5jwH9PmuXyuLW4AloHpDnCSAKVLpXZB+VIlEqiRc7W2dYgRNGItnzojmUrG1LBq3j0lqzG4YXofBdx4pvOIEbksufBELs/JDrmv0Hi3pU9H6Yo4+uxyMOs3hFIVDdYfDHoPVBhnrd7EubaMCwmkqFcZZJLJYQ5ujm20cJ720JSzIBAeoscRRH7xXMr2mlRWQ/Ak4xJ7n7cX9N7w8u2zYOTYhwvfwQ3NfGDNvubis59aAA0w8ngW4k0ZS2Lyn28ZmIEtVsAJ3ZFrtaKKuOZz9gnEj5zLOSaPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRb8t9s7nBF5SaRiVargJS+3qmhbZEn2w0paa2C9tBY=;
 b=TGv0WvdouKnmSwYuH3MfWTCyWG6E19OjLkLyfXGtE7dybARQBZz9NL6ukJf53YMLr7BcMzwU/YN0gdjQIaqBmuQicY2WFBxyMwpcfqqVOKWO6VUg4JHocZmCVkRp8xC3EcdTVMfSBgzFsgVdZ+q7H2QL6Ci5/vZcR77oK2uacAl/MkPY9brnKP7dt0+qvL+I6ElzegITRGjJeqeI/FDjxInsRHHnRAljos1KktsGgSAvIt05hcmK923j6OPtbpjdKzn1haQl90o5hVT7/GsifuyMfGm2q5jrh6A+fN2Y1TT4D/89fuxAZeHiDBf3fliXTiHRA0pZSXbCk0TVr9eTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRb8t9s7nBF5SaRiVargJS+3qmhbZEn2w0paa2C9tBY=;
 b=edw9rl17NT9z3crwLC+mpQI+CuE/f6zvio8enezC9Qn6vDNVkr8KnIBkXKM65LE58wGPhH5nDzeuWryYi4CkL8quadYPDD3IttnrcTQTfQe2SmXD0Y2m6+vBP3tKH402RFgKPHftG1+AwHPekagDBBUEapieaIYnFRIUxhxK8G4=
Received: from MN2PR05MB6381.namprd05.prod.outlook.com (2603:10b6:208:d6::24)
 by MN2PR05MB6048.namprd05.prod.outlook.com (2603:10b6:208:d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.18; Fri, 8 May
 2020 17:24:41 +0000
Received: from MN2PR05MB6381.namprd05.prod.outlook.com
 ([fe80::7803:13e7:2e4d:58ff]) by MN2PR05MB6381.namprd05.prod.outlook.com
 ([fe80::7803:13e7:2e4d:58ff%3]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 17:24:40 +0000
From:   Ashwin H <ashwinh@vmware.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory
 accounting
Thread-Topic: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory
 accounting
Thread-Index: AQHWJV2OLJ4VENrfGUuOSXVovv8jKA==
Date:   Fri, 8 May 2020 17:24:40 +0000
Message-ID: <F958DF99-EF43-4522-87AC-55C24ED93D4F@vmware.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
In-Reply-To: <cover.1588242081.git.ashwinh@vmware.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1e.0.191013
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [49.206.7.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 066e4a0a-1d58-498b-e319-08d7f374b118
x-ms-traffictypediagnostic: MN2PR05MB6048:
x-microsoft-antispam-prvs: <MN2PR05MB6048A3E9702FE4F61B47A0D8CDA20@MN2PR05MB6048.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qmh1A5IT70xVWQhVx9rUZKlKOSQsfbUV82/2Oi0+Ke6v+WOhYKqatie3z2W2VAiXb0pjdzxHL2dZg3eGfSrYzPKtb/MpQ0pDcNqf8E+fmdQENfa3jDjs2CyA/2P2cZjOZjq+t0rcEhjqOp7TSPGVXOqqEYwe6mLPqaSIz/bWhD1yNZJc37IXEKtvEGZkzGn+w4jfH6XRDbipuNx54KJD9jUcnOtJj4s/6zYWo8FbZJiKbKNWQAVin2UsNS8DohB+1sxPqHxbC7IOFpdsJvIs6TUacVHpaXJbY7DLdMIfGrnjQge4BLEaRVgN8QwsT+ZNjdEdiEXHRqct4GoVPV/uPa9/P6dYfTuaqFN7eQfsUwGyVzmjNuR/0N/wXVQIWcRtWcm2rL47nTK5WS/ubVI7xTcHbrXjbEqOicWdiC3luqjcricLibJiXSp8PLJDAZk2GHMPJkL0kDiPpqU8f827sAoO+UxO0RZOP5n7JfF9i4/ZVgkd2dT39PV6dZS9JrpAlMr6mifHX349GqvA3oentw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6381.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(33430700001)(6506007)(15650500001)(26005)(6512007)(186003)(91956017)(316002)(478600001)(5660300002)(83310400001)(83320400001)(83290400001)(83280400001)(76116006)(33656002)(83300400001)(2616005)(36756003)(33440700001)(8676002)(64756008)(55236004)(2906002)(66946007)(66446008)(66476007)(86362001)(6486002)(66556008)(110136005)(4744005)(8936002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xfLvKVwZdgMJZV7tRXpzYgUeIC2tw7i7lflD7HQxr5+GfQge7FoLJpld2gwIqJ9t8qmPfWPrZlFzyIBRgQouV24GyGa1ugmhM7FHXtbCjSRJ7VTA1mB32VWpY3WVc0sNluboRGrQkfmip+ChxsN7D6zjtWQ9xwJq7+4ijDQ4pIaZHuFQL+pNwVH48ya0o6DrvttDEujxuT0ddgCPiOZ7jujeNjxL7gylQ9xkYXpZ5oYkNVjhSlM/Du64Jo27vwKm8zhbP5bo0UTmCb8SqF30nzwIc7Ij8IdMr+SzKjnZolU5Y54NzSlC2Xb7H7wUaSagB/M0nRiR2UzG9/0wYShgPbNUArF3Zz0XbESc1fAP7OB/SbhYa09rBpCum1aBc9heM0X3kEcQhslJhQc0o4f8MswuNFalV2ouhZhL6W85u3tR16xPmI1EBks7qVhfybkinCj5h9e01oxJOhr/FMNxtlef8cA2VneiWAj71C3fzQo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B550C403196CA4CA246A6F5870DFA7C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 066e4a0a-1d58-498b-e319-08d7f374b118
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 17:24:40.8399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o6CPvFOYkVR+oudkHkJ3ezBdMAkFjBAcwXv1QhUXyaXaIDPcxBnVdWWCBhko3KOL45KWd3ISUJPbnsl57MBhoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCkNvdWxkIHlvdSBwbGVhc2UgbGV0IG1lIGtub3cgd2h5IHRoaXMgaXMgbm90
IGFwcGxpY2FibGUgdG8gNC4xOSA/DQoNClRoYW5rcywNCkFzaHdpbg0KDQrvu79PbiAwNi8wNS8y
MCwgMTI6MDIgUE0sICJhc2h3aW4taCIgPGFzaHdpbmhAdm13YXJlLmNvbT4gd3JvdGU6DQoNCiAg
ICBCYWNrcG9ydCBiZWxvdyB1cHN0cmVhbSBjb21taXRzIHRvIDQuMTkgdG8gYWRkcmVzcyBDVkUt
MjAxOS0zODc0Lg0KICAgIDEwMzM5OTBhYzViMmFiNmNlZTkzNzM0Y2I2ZDMwMWFhM2EzNWJjYWEN
CiAgICBzY3RwOiBpbXBsZW1lbnQgbWVtb3J5IGFjY291bnRpbmcgb24gdHggcGF0aA0KICAgIA0K
ICAgIDlkZGUyN2RlM2U1ZWZhMGQwMzJmM2M4OTFhMGNhODMzYTBkMzE5MTENCiAgICBzY3RwOiBp
bXBsZW1lbnQgbWVtb3J5IGFjY291bnRpbmcgb24gcnggcGF0aA0KICAgIA0KICAgIFhpbiBMb25n
ICgyKToNCiAgICAgIHNjdHA6IGltcGxlbWVudCBtZW1vcnkgYWNjb3VudGluZyBvbiB0eCBwYXRo
DQogICAgICBzY3RwOiBpbXBsZW1lbnQgbWVtb3J5IGFjY291bnRpbmcgb24gcnggcGF0aA0KICAg
IA0KICAgICBpbmNsdWRlL25ldC9zY3RwL3NjdHAuaCB8ICAyICstDQogICAgIG5ldC9zY3RwL3Nt
X3N0YXRlZnVucy5jIHwgIDYgKysrKy0tDQogICAgIG5ldC9zY3RwL3NvY2tldC5jICAgICAgIHwg
MTAgKysrKysrKystLQ0KICAgICBuZXQvc2N0cC91bHBldmVudC5jICAgICB8IDE5ICsrKysrKysr
LS0tLS0tLS0tLS0NCiAgICAgbmV0L3NjdHAvdWxwcXVldWUuYyAgICAgfCAgMyArKy0NCiAgICAg
NSBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCiAgICAN
CiAgICAtLSANCiAgICAyLjcuNA0KICAgIA0KICAgIA0KDQo=
