Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD6157D5D
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBJO1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:27:02 -0500
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:48077
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbgBJO1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:27:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsUy3IQaOEwfwDHCxkPvHB1swFIbYNMmdq1fj5DrU805hqXexwWyXnBueQ6TJhlLigZ0GPzNQfWK3w1c3SLhUy9u2mZ6IPzSTAPLwfG+/lsIK1j612m9bAeQj+1hHWo4nVVDcn46CKMxbFkVi5Eg8j/BWnD80ypEw28T4XpC6B7syrpwzPI8pQtlnNu7QqdOaAr83VRFTOWeeQHgu4CETlhWYZ+NJL7noyUUK0F9Qh7gGRULF/QeDQwkzBrVIO5MXfCeV5EbvciJn9m0lyeaL7uJnoTWp7XUy5QbSiFbH/PYTik2Tf09kwvQ4nXcxq0UhMNq6hgu2o0SLciU8axHow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2jghlmnoNzrIgJWVj8VB0g1zUmeOH1JbRpIjKkvJy8=;
 b=dIkSDDuGmjlU4U322VdzEcFpaBxBum64AUfFcy8wSMKDpRBoKqyusUR9nADtIHpbXndLKcANF632v1C98qv6n0ZbRgUtBS0ObHTmObgtDKFZES2AAWnSWYTdAws7/im53egMOC9+9UbDH7hBBEYtGw2kW0tmWZHt/SwQp8JCATrbvVr1HsmCIUuN42A5m/JzZtAm2e4QeVPMnewXZIq6ncmdeNslDebpZ9DrxRVlfCPjsTt/MCoskukZbrKG+SrY+XwKhwBmQhuiQ3Ay98okYce4zrqIoSxFZNzAFOTIQfYdvdOVay7wCLfCHmAIm6+/eGrc2aTtp54m9jm7HPlP+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2jghlmnoNzrIgJWVj8VB0g1zUmeOH1JbRpIjKkvJy8=;
 b=jxWK6JMZnsjj5lROJkFC5y7qLvP+A5kHRzdxhkX038+RuTNrM9xtFSCf7/bOz2u0bU7z5aat0n/cOyMxp6+7ngwV+h2IkHJ7KT2GjdM9QDQtHaRq3qnbaLa5asv9wxG5v1zwPKHZy9nzKZq0YOAFr3OrTealbj6Enp06dcCTNI0=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6037.namprd02.prod.outlook.com (52.132.229.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Mon, 10 Feb 2020 14:26:59 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2707.030; Mon, 10 Feb 2020
 14:26:58 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        John Linn <linnj@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 -next 3/4] net: emaclite: Fix arm64 compilation
 warnings
Thread-Topic: [PATCH v3 -next 3/4] net: emaclite: Fix arm64 compilation
 warnings
Thread-Index: AQHV2CxSaDCeJb8y0kOpuFNYK2kDbKgExuAAgA/AohA=
Date:   Mon, 10 Feb 2020 14:26:58 +0000
Message-ID: <CH2PR02MB7000E00674D836639F371E35C7190@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1580471270-16262-4-git-send-email-radhey.shyam.pandey@xilinx.com>
 <20200131133742.GD9639@lunn.ch>
In-Reply-To: <20200131133742.GD9639@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c9f6bf1-630b-4aae-df56-08d7ae35496c
x-ms-traffictypediagnostic: CH2PR02MB6037:|CH2PR02MB6037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB60374800D590E1B0D155A289C7190@CH2PR02MB6037.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(199004)(189003)(76116006)(66446008)(33656002)(64756008)(2906002)(52536014)(55016002)(66556008)(9686003)(66476007)(66946007)(6916009)(5660300002)(478600001)(7696005)(81156014)(54906003)(186003)(71200400001)(81166006)(8936002)(8676002)(316002)(26005)(53546011)(6506007)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6037;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sL1z/s1BqQfbl2YR+xlApDs5BGr+/sOQRmb+8F5fjCfnYMdfg0DGPfpcMU824RssTbFcf2Wl+dwiWK4cMPHEEpAjX6qsz391OubkkIz7WKxrERHnJ2WShhwjZ/3SFls3B1lw3iI5mN7ecGnefniP1Kz71y5EniJAqP1Ylc3VheDfLY0n571G5BvzcGPPESV5UO1kxW9HGgnyHo7wc+xAUQuj2AO+1aacpDr2FOJK4ZR8PFYtYB3twPF4u8XhBEn+w14Cq6eV5egtjZ4XNoLgQMaxprHbJQLrgu/QJO+AgniWhXhiyJj/+jiIN2WBHFsvlNFYqOc6Om6HmXpLpn5UMgHGE3rA+ZGs9hG/Kkxcc0K8ydtV663ETm+3woy6oAPMEm8OJxq3ESvLNMroti7YIZrGxVNLXVOb+X5EDIDVMeotczauy7BnELbf6EQp/Kc+
x-ms-exchange-antispam-messagedata: HG0pT4yE+O3yw7ArxvNiLFGJlzR1T3UOySS/Q2Ewj4KY6i36+/PqGsdrq/Q1W38P4B4kQOzx5r1CqEFTSo7sDDzcKcbhn94jkKXRjUjjpOWlWiuDLVMqsviboIIaJqM7WWlnk1pklJu3V/eCQtmLqg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9f6bf1-630b-4aae-df56-08d7ae35496c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 14:26:58.3341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAYmJptx/L6rrAFX8PIdPgcCcO0zj5Wr+CKQawSaame7W9oIM3jltlTCD/PL4lH6vL7fxYLx+48VuvsywsolFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 31, 2020 7:08 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Anirudha Sarangi <anirudh@xilinx.com>; Michal Sim=
ek
> <michals@xilinx.com>; gregkh@linuxfoundation.org;
> mchehab+samsung@kernel.org; John Linn <linnj@xilinx.com>; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v3 -next 3/4] net: emaclite: Fix arm64 compilation wa=
rnings
>=20
> On Fri, Jan 31, 2020 at 05:17:49PM +0530, Radhey Shyam Pandey wrote:
> >
> >  /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignm=
ent.
> */
> > -#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
> > +#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((ulong)adr)) % ALIGNMENT)
>=20
> Hi Radhey
>=20
> linux/kernel.h has a few interesting macros, like
>=20
> #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
>=20
> These are more likely to be correct across all architectures than
> anything you role yourself.
>=20
Thanks for the review. I agree using a kernel macro is preferred. However,
as a second thought it seems we can get rid of this custom BUFFER_ALIGN
macro and simply calling skb_reserve(skb, NET_IP_ALIGN) will make the
protocol header to be aligned on at least a 4-byte boundary.

> 	 Andrew
