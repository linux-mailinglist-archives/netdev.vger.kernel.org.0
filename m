Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A8A3ABAA3
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhFQRcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:32:19 -0400
Received: from mail-am6eur05on2123.outbound.protection.outlook.com ([40.107.22.123]:61857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231168AbhFQRcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Year5GlAbLrfNqY5GX6VZIfWsx4WHZLKd49uALQY5aPHizEbuu/XMJvyjX36/U9TL5eIlJqyIekLVYeNlwIYzsK7WGl9j0m/hPAM037z7ZgsFCVITZxpORvhBbCPY+mNolhxexz3Xi3g/gKzmETcOF6ttm0ygrw/Nj27X1IC5eBmarzNBDAXAikQJQm7gPmGPl4IVcxl7xCOj3ltnsfVKceT7djBvRcMnE+V5ssGSyWOD21lY/QjMgrEP//quj/9z6c/mduSR4v/TxNnNzhJZJfJSaLRa06rOqz+9FPbhqJBHmAvlRk1zhRQcY3hqFRU1/oGhNOWufc9o3f2Zb6A/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlrJSEtB7FoVNjIWm9OKlD1VDc4fhVhVh5+Q4tmFt10=;
 b=KM1U8zp0ZOREKhb7s0FPPOdwCkrFpLYIvNFUJXJqwARmJGXxb5xEpLJyJLdCMzGeJwZXkEdxUjtgmozErzMFAANEfw9cptN2y1dj5WMxjran/BK/fQJzuIxVaZ8Ai0mJUL+L9PuwCfXu44tas+F861Ba1dPTe7R6UP2Kb2VLE/YCXkMaa8a4F8bUFzi/nx900sZU59mssggdKrKpUZlNuzf0fHyVtqRqW5UojkIOUEmNEW8/YAUNh+5+Lc3VlzUJovlaZb4iKH0ysdLzD4X1DMCf2zzoLq8QRGOPJoGplZmCIOAg0+8nUjOO1jpUuzRedg5WksfNr2sJWetymMXIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlrJSEtB7FoVNjIWm9OKlD1VDc4fhVhVh5+Q4tmFt10=;
 b=o2UfJoi+ANsqz5w6HfaJgUYEPFWRDdYC5lNCDLJhJ5kzioVNgTM0rT10asLrcJcsVGPhVF64jlBEFTFfSpHht8cUmVXV2nRQvfevqA+T9S/50FeRtw6ssg2Q/CBvq1lKwtKHII4SnYGEEztYRFgX9ZBnzGQvSZB5va6uhu0BYn0=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0723.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 17:30:07 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Thu, 17 Jun 2021
 17:30:07 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 00/11] Marvell Prestera driver implementation of
 devlink functionality.
Thread-Topic: [PATCH net-next 00/11] Marvell Prestera driver implementation of
 devlink functionality.
Thread-Index: AQHXXUJjufes4y4eUEeZyWSkshehZ6sYf7W4
Date:   Thu, 17 Jun 2021 17:30:07 +0000
Message-ID: <AM0P190MB0738F58BF9FFE2ED8073FA84E40E9@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.145.183.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62802885-d987-4f67-2800-08d931b58cd8
x-ms-traffictypediagnostic: AM0P190MB0723:
x-microsoft-antispam-prvs: <AM0P190MB0723EFA9B7501EAE70FC0A3CE40E9@AM0P190MB0723.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxinUb8gRrPo3JzJd993y/deQPnXxSL71pWcVKVYe8SX3ECIDPJxIGD+MTFGhDHRycYqnLGYyiZviolTagCezDaA3rNxVKKhYyrpFy7Y0k9iWbAHrsOka3Z7w+gZ1dAU+TJr93B7gsuoZhAEC2qzVOlZnKisyu96tA26Gw4dOtlBRwlQOQFvtwsvoFuwFM85p9+PwL8O/+XHHsA0+2uQzF1DqdMB+h5w35eFJemeFJUS9ti+1THyU/b5M4Unu23iQV5PCN+cSARg8xIT/beamztusuWIXVc2Uyokk70tXEx1AJpTpThSB/DEV/muUYBY0DwaACfvPJWTF90CWUhDXuVG9bqOFh6MIZ4CY68IWtJ+aCWKxVaueVOau/b4u7nII3hxFVxBHszypLokv4ALnL4wulfxfyYvuqZzcKfQVkmYUQUfP2PpdLGxyBuKwFmxusQrynMA3vy4LmmoBU4r0UACOIla2sHGnuvhuwI4DzFFFDOllAey4sZstuXrTjo0q7ITNw/m0gsGxBRrcyLR9SdR6vLkOaIvFjYwy/kGn/VYSnlVHW+m1HKIiVf5jaCGgDH+sT9+Mzw+0fNP/nZzuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(39830400003)(376002)(346002)(136003)(396003)(83380400001)(8676002)(86362001)(71200400001)(478600001)(9686003)(55016002)(6506007)(122000001)(76116006)(38100700002)(4326008)(186003)(44832011)(66476007)(66556008)(64756008)(66446008)(66946007)(316002)(110136005)(33656002)(5660300002)(8936002)(54906003)(52536014)(7696005)(26005)(91956017)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uvDzsn0xpRCST6TsYqfT5XVa90iV5ENsopDNvgw7Ui3rgWcajbMHd/uPZp?=
 =?iso-8859-1?Q?liCFgJKYN+DUwLFXmiwhXk4kwAMzyTwBJrcplkD5Eot2LPlwP4Dq7lrsDl?=
 =?iso-8859-1?Q?sUFp9bs5Uf3/4CKk2IoOTaOrYCT0+mYFSHdZtke+XauImhpBCF55pArN/O?=
 =?iso-8859-1?Q?tma8SDSyuO23fOI3+T5ATQKigMnRNJMP5GsHo3vTwqRRdLHa22qumtwA34?=
 =?iso-8859-1?Q?12Mt2LNAEeL1j6GwXv3LCWpbSe2/c65RqcT3PqhZhKZrkwwPTCt7GttAbo?=
 =?iso-8859-1?Q?zu8LAnj3yIsHKOdOMc4JR7HW4D/boCnWFCGc4Ugunt1MrcHlsqdokFF6y+?=
 =?iso-8859-1?Q?8VMJkt6rIK0jtqtytIXWU+KgOBpsNuxOWu4K1+yUzHytA2NUWFN2Hxk5aF?=
 =?iso-8859-1?Q?kAcxdLzYi+66EbmJEPTrGv+7o+0LeDf0jByAT879/wvwAd7DTh8z9OEGlr?=
 =?iso-8859-1?Q?tz5vMiQMDPvg/vhd/66PpQ4od6GYOuj+GP4ZhK/eGqJitka3/2FNM+jFyg?=
 =?iso-8859-1?Q?looNhwVVjfBjDBM0pCCOIUfubusDqyVPDk4BonubOxfO5bPMCAaOrdKHe9?=
 =?iso-8859-1?Q?sPmUDJ0IzfqQCmKPkT+u5LqWFku40XrjTB3K3YkwJ8MDL9vJNKCZhsICPt?=
 =?iso-8859-1?Q?XKo+ruaTGvED9cgbkaqoLLon0jJwiLZpskhfotdxQjMyk+Q1kDnhitFg20?=
 =?iso-8859-1?Q?WU99yvSAW6wlIzTUfwYWB1A6DqeM2gJOShmoV5sKAvVtK6+lnEttmoTpe1?=
 =?iso-8859-1?Q?nBP/TVunb7Oqd8nKDdiArha6vx75nocXBv4t+8LEulkoyL5fwOp54/oqmr?=
 =?iso-8859-1?Q?yuSnH7IpnG2gklQtsGUYTGIceJf1IPA8dfkE6ZtOW2pka2GmuqTrNhzN8t?=
 =?iso-8859-1?Q?YvgXde84Oj6gfW37XrcprHMV/qgFpx3qMbQA7stgWXvo4h1X7JYUElO8UW?=
 =?iso-8859-1?Q?zH11XPr9o8pd8MADz4Z4MohGyhu07pa72Vwm2gvEQDu34ZanB0dgM+vUOM?=
 =?iso-8859-1?Q?/YmCey7pqcHfpmpVL/S4IQgrhNWNG9DqBlHzerC4rPqGsyL3fPI+GG7mpq?=
 =?iso-8859-1?Q?jQCnCjsK06xz8bSTLraikWcmJKFcvLuSLb/YjQ0tgE4Do2Hk17nm2sb2KF?=
 =?iso-8859-1?Q?6yzjbe7AKPrzpF1CXYa/Y7+nDAuvmQrCDx7F29gFX6AsBkTYKA3m9RFA6G?=
 =?iso-8859-1?Q?PIzsrvfa3EhjDg+WeEKKH1RXNkI1e0kuCtecHckyA5TcXschC2dpB3yhYY?=
 =?iso-8859-1?Q?WulsAGMYgz5ZrGWdXJICdJtJNQZaFDMI77os6PXA4hEOCfK9E47kFcKq1q?=
 =?iso-8859-1?Q?JzJ1qOfUW/dgUaku3lRImrIMk9qbI8/GwD6u4CLj7/FgrWA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 62802885-d987-4f67-2800-08d931b58cd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 17:30:07.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxJ7U48zS1tGvBDMzp3W1x0BrnP4qc+IhIBg854wSzxuAG32dhnxebthy9UkxOwyJu4a7frJTcw/s8uvhYIvPOyN70VNLA53ngh4W8nuU+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0723
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Prestera Switchdev driver implements a set of devlink-based features,=0A=
> that include both debug functionality (traps with trap statistics), as we=
ll=0A=
> as functional rate limiter that is based on the devlink kernel API (inter=
faces).=0A=
=0A=
> The core prestera-devlink functionality is implemented in the prestera_de=
vlink.c.=0A=
=0A=
> The patch series also extends the existing devlink kernel API with a list=
 of core=0A=
> features:=0A=
> =A0- devlink: add API for both publish/unpublish port parameters.=0A=
> =A0- devlink: add port parameters-specific ops, as current design makes i=
t impossible=0A=
>  =A0 to register one parameter for multiple ports, and effectively distin=
guish for=0A=
> =A0 what port parameter_op is called.=0A=
=0A=
As we discussed the storm control (BUM) done via devlink port params topic,=
 and agreed that it shouldn't be done using the devlink API itself, there's=
 an open question i'd like to address: the patch series included, for what =
i think, list of needed and benefitial changes, and those are the following=
 patches:=0A=
=0A=
> Oleksandr Mazur (2):=0A=
...=0A=
>  net: core: devlink: add port_params_ops for devlink port parameters alte=
ring=0A=
>  drivers: net: netdevsim: add devlink port params usage=0A=
 =0A=
> Sudarsana Reddy Kalluru (1):=0A=
>  net: core: devlink: add apis to publish/unpublish port params=0A=
=0A=
So, should i create a new patch series that would include all of them?=0A=
=0A=
Because in that case the series itself would lack an actual HW usage of it.=
 The only usage would be limited to the netdevsim driver.=
