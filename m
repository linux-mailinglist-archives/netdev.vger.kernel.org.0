Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2730DF84
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhBCQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:17:42 -0500
Received: from mail-eopbgr140108.outbound.protection.outlook.com ([40.107.14.108]:10510
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234768AbhBCQGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:06:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVlSsW/4L2A1eGaWFWhPS57Ur8lofKupKVLeiSSfxh/vJTD3fH9xKePYnB0gFb6QpnrFiL5Dr5GwCBHz44nv0zYy/tB3t/nYNdgg5mdEgx7vgZjIBkxDcw+aTIwOKuT0Ao+oMDJzqTSfvteDurWG7xXM1yq509hFI7n83zUEueOhYCgwrN0fY66bDmlgT63Zn7GFST5n7XBAYdlUWyF1mbqZkCTBw3V12Wt9TG3iis7Py8R4gJ/vcIozrVY87yPBv9ObFVH9ndFwidzBF/Ls5PariIUVCF+ns9PKwXl2B5TGrT/BoU1+0QpyCi/lNQjVPQ/djrQ+TUNG+Xy1f0r2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQ22bvYes/Mcyc1fEW5RU4DbXCAgWhQi/bPEO/qucho=;
 b=jIb+BHhqFRf5+gcIOynz8JiRYxk0Yc49//edR9qGOWUvMeW12d/Bvc1cJ2qH5HhH5J8f+WKpkoshAxDFl5KARLAPog83FliszVfPxMVG3UjkKyIR1GQRwI03Cl1ThhQ3XWIF3rvZ+UHws2QeGChdORCB3Ix2Kmv67BE8FQAA7hZpXnc3mFjE4AA3GF9fMcffLpaomAQzTcx033ZtqAXEZz3SUkcfaGlUetA8AN214lSWTLKey65HZiTueABGL+0II8IS+TankUcP8FC9qObaPtGZQlsap6nZyNBPocFI/VjhSiFmcHPlTJhJmAJvC+AjuIjm+SK2pisirVZBNvX1/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQ22bvYes/Mcyc1fEW5RU4DbXCAgWhQi/bPEO/qucho=;
 b=ACQaD3eVF81/dfmaHvTwYKNzXOS21ubZTNQCBsZKZ6JmFXNAcGCGJWi/p/rfNvml0i8nydYckRd2czyiyB3GZ0PXpKEA4MeLYxrXI9mbi+6SlTnorDGa2lxplUmis6ix+AGsaRrDRqgIA+zU4k2csyxcSPlwP45SyGInB/JubXE=
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com (2603:10a6:10:10f::27)
 by DB7PR04MB4010.eurprd04.prod.outlook.com (2603:10a6:5:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 16:05:40 +0000
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9]) by DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9%7]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 16:05:40 +0000
From:   Pierre Cheynier <p.cheynier@criteo.com>
To:     "Sokolowski, Jan" <jan.sokolowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Topic: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Index: AQHW9mMY04hDD4/GNkeljus5vphnq6o/gv8AgAUiwUSAAG7wgIABbtmAgAAHK7CAAAw2lA==
Date:   Wed, 3 Feb 2021 16:05:40 +0000
Message-ID: <DB8PR04MB6460398CFCE47ADD5EE773E1EAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
 <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
 <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>,<DM5PR11MB1705DDAEC74CA8918438EBA599B49@DM5PR11MB1705.namprd11.prod.outlook.com>,<DB8PR04MB646092D87F51C2ACD180841EEAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB646092D87F51C2ACD180841EEAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=criteo.com;
x-originating-ip: [2a02:8428:563:1201:cf2d:ab43:77bb:deb7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d35fdc2-5ba4-4def-28e4-08d8c85d8d71
x-ms-traffictypediagnostic: DB7PR04MB4010:
x-microsoft-antispam-prvs: <DB7PR04MB4010B76AFC21B1EBBB070C9EEAB49@DB7PR04MB4010.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m47hNrra+uiOyLeeY8p5ArtT2W9YnEURG3/j0WTSEX55yWGCWvwnuywGHLfND07+o2xfbPAJSsWjS4RiGQC0peXNaDZilaWzRndhfhD/yIlvB/fgdTPoqisxcdwFGhHQvwfgZfi6r0p1mXZOHjsoUi7swOFZSn5n3LRuOFgfckAzlyEZ0urNvcWxwKrYsnQzBeM/jRg3fVbcCFscpnD6RY+Yu/ik9475+n0/qSB1YIBlC3UvObtF66m6DWzmLlJD0khnGN1baLVrnFWBezV8VbeQTGJVU0wlwSfVGGEuIMTns/x7fmKKcGD3K0CbnuEAe7ZD4QrKSGjpE7Fah1gZ7z3+BNBOagFHt9TlbNCeU6IwyKLDt95jSwHGgSCg7hNW/aDXt7JSqIalzpUw+rzg7SMVkv9Z7FBDBUtS9Cq5FlCu55W4MHhJkGSL4vmiK5TgASlSfUKd3bmshCjXF30ZHWI5Ee5MTN/L1Je88YN19XV0BZwBTGo+uxbeuvCH5EaXjRJDw2Qihkep/7mOTQWDkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6460.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(376002)(136003)(396003)(8936002)(71200400001)(2940100002)(4326008)(86362001)(55016002)(83380400001)(186003)(9686003)(52536014)(33656002)(64756008)(66446008)(110136005)(316002)(4744005)(5660300002)(66556008)(66476007)(76116006)(6506007)(2906002)(66946007)(478600001)(7696005)(91956017)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?M0AjZi85woVYnoCxmRBSgtvDgddiwab7V9b0jie4HjFsFCVJFUna8pEDtI?=
 =?iso-8859-1?Q?vN5cq9VyDWCikBS/iE2L1JGZr1V2XEE5mF0sP/S7jTRyjtGruDSbpdUjB7?=
 =?iso-8859-1?Q?j5CWxUzxyKBp0Kfnf3WgLDx4QgyCUMfqQni+zO/5AcKvfM9sYiXgzFmGiP?=
 =?iso-8859-1?Q?ojV4gcoIqwiPJTysy1luzJEeDy4AdV3iVIDltnKmagxR0uYwR2XtEkOWxE?=
 =?iso-8859-1?Q?4HelGobIroVOlK3w9Qd3hYSbvBIW5icl4WVfJ6u0XZUZGI2VuyzmkO0ZwS?=
 =?iso-8859-1?Q?7vB2RbdUDSmRru+BOzWUmpRjdnMq1LqscUAjZqn5nYxtUL17DT/zFdfN8/?=
 =?iso-8859-1?Q?0q4z5/2n3RYRHxWzz6cpzTdpmbIuaKro0iki4CpHfwicjBveUVR/ImSZmq?=
 =?iso-8859-1?Q?mOAPtkR5eXgWfVV5V1DU2uJg+P645uzk4A+WJda5QAQPpD4n5cFnpPNV/8?=
 =?iso-8859-1?Q?uDEGTuU3wWVyfHIjfnxAhN/K+3sjgeckxi+hG6wWnJzmQ4kc3U4NHPoKdc?=
 =?iso-8859-1?Q?jUhWV0DC1D4PbTceVY8B+8Fte387G8RqFBTRcM2+8e5ICLwBP75A0+Bokh?=
 =?iso-8859-1?Q?iqfIowRoFIbO2CCBYy059z869TS3QEKWQfz3qjBKoiuUU/IOWeazYhXVE6?=
 =?iso-8859-1?Q?HJ9MvrwA4WXDx72oe9CLs5Sf7o1XmLHqlQML3zjO8JoEYOrehj9JX90dJX?=
 =?iso-8859-1?Q?JfbLUbxEGAGjoyX9NGFJiGpvz6pb3fpYlHthnYDovJFhxhlL/VojPctkE1?=
 =?iso-8859-1?Q?g1S9N4+Xk0hm3Rly/b6dSupoJUhofhSj741QmAQ9wGE1FHOdJlYz7Xodwc?=
 =?iso-8859-1?Q?zLn7TJ2KEWlLXK2+ReCCxPY+eO693SNSHfpg1zpj++Y0KxwOMRDAhqJLLk?=
 =?iso-8859-1?Q?sNSDK25Kak4S34+xzRTeH4XEr6/ruXD6DFcXKUZ6lCLZspV4goP7byioAD?=
 =?iso-8859-1?Q?dRWENW/2F7TtxrARsSVUbcCzekAoElQTSB9PTTtOEzs0Mw6PXa7VYpQIZF?=
 =?iso-8859-1?Q?ZSrF8MaJ620ZYSEU1WLuhmYJpuOyQZF9r5GRoUdCEcjWtZIhq9rAYDb+sh?=
 =?iso-8859-1?Q?vC8M0xRpQ+5QoyD/330F1uvYCLepJpXNUUjc3NNTfY07LE4lyZ/sq6JiEw?=
 =?iso-8859-1?Q?IJsjLKOdJwlR+YVFVWzWU9iet6b4CLTviMxZOj+DjOjECXmqXf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6460.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d35fdc2-5ba4-4def-28e4-08d8c85d8d71
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 16:05:40.2392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Slk5BLhcl0ktWeo84KlUXIM2HMowtpsc81U5CSAwBeuTbPpNIhad6ZH9fowNihIhMgvkfw8gpZR4OegkBR9AOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
On Wed, 3 Feb 2021 16:25:12 +0100 Pierre Cheynier wrote:=0A=
> On Wed, 3 Feb 2021 15:23:54 +0100 Sokolowski, Jan wrote:=0A=
> =0A=
> > It has been mentioned that the error only appeared recently, after upgr=
ade to 5.10.X. What's the last known working configuration it was tested on=
? A bisection could help us investigate.=0A=
> =0A=
> I unfortunately moved from one LTS to another, meaning I was in 5.4 befor=
e, and this UDP tunnel offloading feature landed in 5.9 as far as I know.=
=0A=
> =0A=
> Maybe Jakub can give pointers to specific 5.9 or 5.10 kernel versions I c=
an eventually try, so that I can help refine where this was introduced (or =
if it was present from the start)?=0A=
=0A=
So I think I was incorrect, the support of this infrastructure for i40e app=
ears in 5.10.=0A=
From what I'm seeing, and Jakub will confirm, I think this started with the=
=0A=
initial implementation for i40e (see 40a98cb6f01f013b8ab0ce7b28f705423ee168=
36).=0A=
=0A=
--=0A=
Pierre=0A=
