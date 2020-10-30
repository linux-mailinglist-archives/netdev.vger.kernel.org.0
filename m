Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE75F29FCAC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgJ3EUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 00:20:17 -0400
Received: from mail-eopbgr60090.outbound.protection.outlook.com ([40.107.6.90]:28064
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgJ3EUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 00:20:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJkFpqeD3g/fuhCH5fwJ22oSSPyzUOa7QTWmUOcZvU62G/1psLCa+4XFD8KfVdBjI3mq3XTcdzK7aeD7GT1ApMXbZZATUl6tVt96PdtMxWuW/xuWJkWNtGAuD7bkWGTOKiImCXR4oa6Sei0GkxZ3aVdd5/NPxtiaE3fJs7yyLAAMSUxXI5na69eFoNzmnkdcLr67uPv2oppCCaq5/DXhHzqBevLjWh9KF08p+BnQSTzR8fd+COlIitVi4Hcm2xoUwCBAUSfnT9himowu9gGr7hPlbXeu/Ss9cMtHJMg0xUkcgIDm+/53+IY9OL5Vokxyk53iFWptncdsIl5qm861UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5Wlgc5vmbqklbbdvr57vnUvRabENL3/HkBvy6TXWNk=;
 b=j2OHEeTZ8tMegQCZAZeTLOnfy7YSxjV5TgMRzkwa8M/YqYp6ztpvgeNcF5pUiR0JeBmK7GgLGUepRE8dktTYQvEeJxysQzWHUIv7VFme8EMwukFZJjSPyWHmbqZgD64EpwUm5lZU86P2ujZ7wfnSKaRNnR5CLD7l5U992+EI+bCFK0oLgYS4K8P5PMK0tq8yJnO4PyYnW+PgSgNjAj7k0E8isRT0cY2Gf3FxwIfRsrBrs0lFksVhFSlgkmeKaKlEbZVDwwesXVTq6er2KcqEIUKFLuxvjvOkgqeXVC0F3vTqGRWFVm3YxodSl6ObRFyxnz1m2h51nTzA7A16qo3DOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5Wlgc5vmbqklbbdvr57vnUvRabENL3/HkBvy6TXWNk=;
 b=LOPYCyUfr7yjOFQoyDQsYpdhcOg1U1dgcwU+js3AYHXguwpfMq3Ro47CtUwhVj5oDUYw8nOWXJU7Nx6ILruw2huFKwzbWPrEAeggpBXMNH8tQjvDaDZNNbZQLrnB9fr2E8lk7msAYQpS18elnJc92vqVBsS3Zf84yGl3MV46oQw=
Received: from HE1PR0701MB2956.eurprd07.prod.outlook.com (2603:10a6:3:4c::15)
 by HE1PR0701MB2841.eurprd07.prod.outlook.com (2603:10a6:3:4e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.13; Fri, 30 Oct
 2020 04:20:13 +0000
Received: from HE1PR0701MB2956.eurprd07.prod.outlook.com
 ([fe80::550c:fd5:b1be:2d62]) by HE1PR0701MB2956.eurprd07.prod.outlook.com
 ([fe80::550c:fd5:b1be:2d62%6]) with mapi id 15.20.3499.029; Fri, 30 Oct 2020
 04:20:13 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] selftests: add test script for bareudp tunnels
Thread-Topic: [PATCH net] selftests: add test script for bareudp tunnels
Thread-Index: AQHWrVTx8JQc5GCbqkaYOkhb08rGgqmvjAWQ
Date:   Fri, 30 Oct 2020 04:20:13 +0000
Message-ID: <HE1PR0701MB2956A07E30A9ED0DCC2C4A57ED150@HE1PR0701MB2956.eurprd07.prod.outlook.com>
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
In-Reply-To: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [2409:4073:402:164d:f520:6268:2e8:9af8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc38f765-05e9-42eb-edde-08d87c8b1918
x-ms-traffictypediagnostic: HE1PR0701MB2841:
x-microsoft-antispam-prvs: <HE1PR0701MB284173B50E580BCB27BBECFBED150@HE1PR0701MB2841.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSYf3moUjkKyR4W6JjAuijw+Oms6gJ7aNzGzWcXt+NlvOnw/Iy8f2BReeysmfA5GssCrEncGBxq1L3ZJQHag1Mi/ArvzVO7sjPUgX6sKIxY6wnAJfuxHF9yT6LwalWFS4/3wp4bNfSgoRpaQibACSBG7TCbfDnoTFNNWSTNoEcQWoJ8htX3p92mTVKD/xNzbM4FtL/JnnIloivKwRWK7G/kLriKJidiNxLrivteK6c0V4muj92j/spaEHSgHw9NZUimO+XYthJfJaFcL7xcIN4vTogd1zisYExZRka82whZTgR0LbKCh2Ydsw2cptr2C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0701MB2956.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(6506007)(4326008)(8676002)(55016002)(86362001)(7696005)(9686003)(76116006)(2906002)(66446008)(66556008)(66476007)(8936002)(66946007)(64756008)(33656002)(316002)(71200400001)(110136005)(558084003)(5660300002)(478600001)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oNMYOhyyKGZaL4h2aJ/uqN/NTszc+LI6FGRLQLv4vMmrWPl+y2Tg5T0evHb7ILzvhoq3scze5RTrM3tc+z/TMe7ACqoJjspHNWYpaJa5qlA5Bv/E8GzVbmKSKs02t44ZcAU/lg4aUajyOnpHT3jfZR+Iy58Eoo/7glnqXQGHhRTvENZUPPLVKv6XTgiy3EIMLBWPymBUKzJlGOxNgwpej3mFAyfZ0HgwLRcrAfbkBDzwtN01DNqt2o8ZPq4KdPIy5k6VXPna5vRNblu74bavPHk2/n9f/I9nH+m31fS0m8708ZXgZStcZ3DavsouEeXcw4eRlQgyPK19g7eWQED5xy3rnlG3iJxnt57J9Xf7aqSggxXhz+5iZMn2sjDDRVITJyJ5XkINwyvb5iGzo0YVt55tmL3HVzLeLyM5Lw9hF/ozs2guUirg9HOjdwSt1UPOGxkA8zfVSSqTmZ6Pf3oiuiVRVag52dftT1zX7oyhfpKwt86LuNART4tlORNBloJBvEpxtcjbPFl5Rk83sPkeLVuMSBvFqK1jgW7VVjOg2ohQbg3YAtEnnrtshF2qOqWW+RYXYyBsjsucnhpZeroSJa1ykgqWx1y5K75ly8SLtIZaw1MWVbZnBZ1sS1uM7zu4cSd9XmNEiZmRZu8KZRoNsM/vZipDg9QUi49qw79L7q8/2iyAPXR8TDA0/3zYsAD7NTYauReLXngZi4Xk5ovqDg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0701MB2956.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc38f765-05e9-42eb-edde-08d87c8b1918
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 04:20:13.5498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DiIt0Bi77Jadnx9rsZzRu6X3ZdnZxwU5piN+Uj6CzUdWtt8uysAYAGx5waLPywVeb+m0OsLNHvNwtoXu3umDlr5TzFDZxqBzQDt76vCY3Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
>Test different encapsulation modes of the bareudp module:

Comprehensive tests. Thanks a lot William.


