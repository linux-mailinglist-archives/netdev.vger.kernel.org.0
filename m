Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62303323AAC
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 11:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhBXKmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 05:42:43 -0500
Received: from mail-eopbgr110093.outbound.protection.outlook.com ([40.107.11.93]:34546
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233602AbhBXKmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 05:42:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRZse4WaAxPIC9xzhlT5vYATw/cCrqMJS5J4QvCnkaGSJKcaoBZqG53wVqZfn28Av/6DmVuZlWn+ffVaoEKxJ89JZaK8ARF8JJCmcdKQI/5s2+so2dinteL50v0UWtlVn4fzC0l5M+uPkcizVSHXw9UbGGA/Wb84jWBAYS6iRpP/Ru0Qvx132XnRmOVA3xB0gfzk5fXDAobEPUxWTTslUOVYdvcTdrDzoEqNOVsGDmd+N0LAWMP6Re3rrxRg7hN61wbeto6Wmn129Bap6bgTAx2Auh5oNB4p7P6PJrzJ562IYheL8unnkgeaZeRNNEuWNhF0PT042qnaMTQbNYLniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwW9fj/P3XEGPUXRErLz0ghkAyi1uN7VcJurY99MgfA=;
 b=lSGSQUXUtYn2KVLN2UU/RuQVbHVvid1RZD56VPZ7K5gErDYBvJ1Mb/4OnaVlJC/0G4opsru07YejytmJQuQwHwkBtNJoUHRuhkRCkiGyExTHMSzkIwYcicm3cUL0v6jXpiBkP8iMqBTbt6r8BiMpTBsdVwvXeSLkXiy2Ieucb7BV1FoG4BF8IWm1ndugk7H3oqMoWgUxoYloGETxvcxjRjTNwrXWKAprStxg5Je9rnbX7OZsWGLhqyMhYo38dAI3IEDddFc8bKw2nDQxlGbCtV+1UyKd/7v0GYoUZjUoClfNC8ISaqerEOnIs+yFHVgJQT/BYi9os0HRe/m9bVWSFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwW9fj/P3XEGPUXRErLz0ghkAyi1uN7VcJurY99MgfA=;
 b=KX++OEn+fUNTEwV1P5MrSYTKcuJfgFFRhDqo/zPnfS/ethLjVpxRGqua6+9XVLLq2cE8Kk/tMS/f1Byv6nOSEUEYv4KNtT+kqpmxbfuUP2kYIGTUMqbHzc4nw0hHhshUFYPo+BKqNOEF9cYgNVeWgfhfGGhGzRoEB9WND+RGs1g=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWLP265MB3892.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 10:41:34 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167%9]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 10:41:34 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXATVZ5f5l6UkeM0GGLk69Yeo12qpUh95mgApxXnuAADX2AIAH/w9A
Date:   Wed, 24 Feb 2021 10:41:34 +0000
Message-ID: <CWXP265MB1799D85AE9E812F733416E9FE09F9@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20210212115030.124490-1-srini.raju@purelifi.com>
         (sfid-20210212_125300_396085_B8C8E2C0),<ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
         <CWXP265MB17995C134CFC5BD3E39A7C08E0849@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
 <55e82d3019ea7f5dce3e1df88ee9188d47ae81f5.camel@sipsolutions.net>
In-Reply-To: <55e82d3019ea7f5dce3e1df88ee9188d47ae81f5.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.213.193.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8cc1461-7266-44ac-e606-08d8d8b0c19a
x-ms-traffictypediagnostic: CWLP265MB3892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB3892D04076F671A9F8D542E0E09F9@CWLP265MB3892.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qt+pzlKxsK54ekJuG3jj8E7AoKLDcqyGwHwQ0mspIW+qi4HAgwnfc3w018GrBTTJoKDYKCQm0vNYH+2iGL4eSFSIea9C8mY5cwQEUvs80XZDMM3d4hp5IZM2pkA+MZZOcctofiCeYIOTNmapU2j6sGKnhByQIhkxaQupDOLZ9PT4fKplDLX9ubyB2CPkIkvSd3FpFT5vxP3I/2WAjgdD8fAPtOuUVYcbCfzQfSJKGUEFpn0FOCD8NUVHobEl6PC2LjN6wx8o5otSoWaYh9n2O95yS/l9QSwptBW5alABw2c8/i0IYzG9JyvEugl/eQHRDJgsw6bb2U/JCKpxkjbfsGIcWmPeiGPXFc0g7RSqHgeoxqdk4E0bj5efg9sWvX4Fq7i5HVoDcc/yPT05z3vHQInpxXKnxWs8Bdu6flbtS1AmKcdflfYK8czNIpLLUW8SCJalquFpJNWX3yQHcr5qkXR10jhviQGxfE91axStMHdkox5QweoyT76o1BaVPnkz8r+IyjYcpGZMK07aqooPKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(376002)(396003)(39830400003)(346002)(366004)(66446008)(76116006)(64756008)(86362001)(55016002)(52536014)(9686003)(66476007)(66946007)(186003)(8936002)(66556008)(26005)(7696005)(5660300002)(2906002)(478600001)(4326008)(6506007)(4744005)(54906003)(71200400001)(316002)(8676002)(6916009)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MnpLa2IxdDFTdkgyTXdDVFloQjhTNytIY1lWN25rSnZVaEZ2d1pneVdKTUlI?=
 =?utf-8?B?encyZ0lreGhaS1lKQ0s2WVA1ZXh4V0hlWFQyZ04vSzRRcU9DOVhjbTZLU2lL?=
 =?utf-8?B?c2MrTEIzdVZKSU9SK0JURTRHR2hHTjM4ZGJzWFp0K3FvQVFuQ1h3bWlQUnVx?=
 =?utf-8?B?UWdwRldNUGtnTEtFZU5KTUNEeE9Ra1hWMElzQWVHSTF6Yms5VVJmY3dIdjRG?=
 =?utf-8?B?dWRVQmo3Z2R3L0cxN2JkTHNBZitWNlowOVV1NW9PU0tYaDVkRlR1NnZqNzY0?=
 =?utf-8?B?NG5vaDQ0cFIwNHZFdG9wbnpGWkhON1BYQWsyR1U2TEgvL2ZlOTZNTUtHa3lK?=
 =?utf-8?B?Qm81cFdjbldYeEw2aFZPeDVCUnhRZnZUdlFPVWgyUzV2UUZtZ3JCckdJL0hX?=
 =?utf-8?B?L1dXcDNVS21oZllKVHhSWFl6bDZobk9BdDliWndzZjhCeUJsNWtPTEkwSm5h?=
 =?utf-8?B?TkNWeFJvOURETVFyN2Zaa25wM0puU0M0bDVCa3dkMzlIc3d5TndreWltNzAw?=
 =?utf-8?B?WmVQTEtrY3ZkQmMxQ3hwb2p0ZkJlTXFYc0oyTEdoTys1S1ovek5FdWgzbHlT?=
 =?utf-8?B?WVVBV3VFa0tsbnNaeTE4RWh2cFl1aXV5alJxckVmbWo0RVF6alVsby9OQkw5?=
 =?utf-8?B?cGRFTytNYXV0ZFpKRFAvN2hnTndtLzRYeXB4T2g5YzRyYnNWRnhEankxQ2l4?=
 =?utf-8?B?cElHNS85YStpVDA0NjlFNTd3WVY1YUxDb2FEN0JtYS9ZQ3p0ckFpbFJMQmFr?=
 =?utf-8?B?N3o2dzBFOWdOc2REV2hsQTVpV1FyOTQvUEpDbHEzdGtUNEpWa3pQWWptOGVY?=
 =?utf-8?B?M0xZMUtrN21zaWNYNHVSNmY4MGswSlBrNVZISWFucFNneEh3K1JSWmNMZi9Z?=
 =?utf-8?B?emRkRXBxbWxMZy9EcUxUbVFZNWVlMkNTZXl5c1d5OG5IVW5tRDBmdHptSnQ5?=
 =?utf-8?B?bWh4Z0xZbG5SaXo3aE5pRG5aVDdZMlMrcW5iMTMzZ3FMZkZWVzlHOFF5Y0FH?=
 =?utf-8?B?bm1WSHlCTXVXMzhxR29kbm42bmtOZUlXcHc2NUdxei9MVHoxWXVKTXVVcm5I?=
 =?utf-8?B?cGNuSmtYcnpVMXdrME9mMWRnTllNYzFOZWRqV3IwcytIcVNZMWFzdDFJZi83?=
 =?utf-8?B?RlRlOXkyeFlVcDhiWHZkMU1qMGxvZlo3Q0Q4MlpQWFZGdVh4TFFHdzkvSE0r?=
 =?utf-8?B?YUZGd3VDdzVQczZCUGxNa3pDSCtkOTlxWmVVTzVoMXl2RU9WcnpRQUg5a1Y2?=
 =?utf-8?B?d3dlQWY4VUY2R1dhQzhraU04OUhvTEswYUIrWklQOFhZVEViN1dhOFlpaTlp?=
 =?utf-8?B?OGFwS0Z5UVV2N2U4VFZzQWtVd2EybmhoL3RpNlFxUUxXVXVkWHZNSDU5MUUw?=
 =?utf-8?B?bUF5R0pxbGVaSzFXTmhEUTFVZWRtRGt1bzdPYTBSMXlRYTR3UkpsOC9oZUVP?=
 =?utf-8?B?dGxkZysyTjMvQ05CL2RPR0lLcFFSdFI5YmZYN2w0NXVna3JSZFRWOU05MVN4?=
 =?utf-8?B?d3pHQzlFS1dJUXExdkh2WkUxdDZNSlRUMURpeXNjVmdZNnhiTWZhclphM3hD?=
 =?utf-8?B?alNFNXF1MFZOOHcwS2VHeTRDWHFDdnFSNEdDVGhTaS9UeFdSKy8zUDlQakpW?=
 =?utf-8?B?KzdidVNCblY1dzBXTlJBVyszWnp5RUFDYmJHeGo3dkxtSk9SUG8zSlRvSUtv?=
 =?utf-8?B?NmpyMTVnb3J3NTNBT0xieEIxWmZObnVmVDNpd1lkQVE5VG1Cc1VYV3B4QjJT?=
 =?utf-8?Q?8Rzmh0YlzCmaQtafNoQtbyUO+JWNTEpEj3+Zzed?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f8cc1461-7266-44ac-e606-08d8d8b0c19a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 10:41:34.5977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KX0hVLDdUC2WE3jF0qL5ADet4XCedWyIJ8xZwf2o1qFXzvBrAMTKmx37rAkyDLLuerOLAME5CA0RdjtQ1KiAcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB3892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUaGF0IHdhc24ndCBteSBwb2ludC4gTXkgcG9pbnQgd2FzIHRoYXQgdGhlIGtlcm5lbCBjb2Rl
IHRydXN0cyB0aGUgdmFsaWRpdHkgb2YgdGhlIGZpcm13YXJlIGltYWdlLCBpbiB0aGUgc2Vuc2Ug
b2YgZS5nLiB0aGlzIHBpZWNlOg0KDQo+PiAgKyAgICAgbm9fb2ZfZmlsZXMgPSAqKHUzMiAqKSZm
d19wYWNrZWQtPmRhdGFbMF07DQoNCj4gSWYgdGhlIGZpcm13YXJlIGZpbGUgd2FzIGNvcnJ1cHRl
ZCAoaW50ZW50aW9uYWxseS9tYWxpY2lvdXNseSBvciBub3QpLCB0aGlzIGNvdWxkIG5vdyBiZSBz
YXkgMHhmZmZmZmZmZi4NCg0KVGhhbmtzIGZvciB0aGUgY2xhcmlmaWNhdGlvbiwgV2Ugd2lsbCBz
dWJtaXQgbmV4dCBwYXRjaCB3aXRoIGFkZGl0aW9uYWwgdmFsaWRhdGlvbnMgdG8gdGhpcw0KDQo+
IFdoYXQgYXJlIHlvdXIgcmVhc29ucyBmb3IgcGlnZ3ktYmFja2luZyBvbiAyLjQgR0h6PyBKdXN0
IHByYWN0aWNhbCAiaXQncyB0aGVyZSBhbmQgd2UgZG9uJ3QgY2FyZSI/DQoNCkFzIHRoZSBMaUZp
IGlzIG5vdCBzdGFuZGFyZGlzZWQgeWV0IHdlIGFyZSB1c2luZyB0aGUgZXhpc3Rpbmcgd2lyZWxl
c3MgZnJhbWV3b3Jrcy4gRm9yIG5vdyBwaWdneS1iYWNraW5nIHdpdGggMi40R0h6IGlzIHNlYW1s
ZXNzIGZvciB1c2Vycy4gV2Ugd2lsbCB1bmRlcnRha2UgYmFuZCBhbmQgb3RoZXIgd2lkZXIgY2hh
bmdlIG9uY2UgSUVFRSA4MDIuMTFiYiBpcyBzdGFuZGFyZGlzZWQuDQoNClRoYW5rcw0KU3JpbmkN
Cg==
