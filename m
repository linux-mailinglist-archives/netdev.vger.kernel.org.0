Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF831D76D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhBQKSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:18:06 -0500
Received: from mail-eopbgr100115.outbound.protection.outlook.com ([40.107.10.115]:9029
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232296AbhBQKRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:17:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2Ig+2ORydmhat8FVVGHAqNvaO8+qJ5zRJVVbgvAPXys87RANWwftb+crTUooiiPF34N/EAWMVvtMqVBboqVn6fVlfIt1liU+GI+GZyM0ji/yspS3GrdXbBOjjQUsALZ5PsLjs3OJCtyHwF7DeTc/ZlUZiwPc1BjaVsyuyNlRRa14HL9TxblZqbckGYY4S14dQ3RVMgMGMBPR/drCog4wok/XlagZsHU9xhkBqr0pQBC9hW063kB5BHT8QFPZEX2x9ZXb6of4w+zTUTtdX+KPLYLogOFIGB6M6mRGXVe5wX6YaPwAPDxyFNfGkZQUCqnuEC4YYAtoI7XTQ6CRfRpbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU323l1Mk0Td1HZ1AmwUDLjwUG2O6W/lA55uBOVmKy4=;
 b=C7MBv+aYRdu1lFnES21n6bWn7D5iKXEHbO9uWYkhxSF0o20qBsUyCRGZT7YiwSArkFzs8Z1eBdI4JXHQM8NZq+zV2eirLi/OAyguEiXH0uNb208Jy0rqSJDTsMKU7Ituxpi89vyfbGGhM4A+M2ihuvnWnvEmpVg+x/myTuMvym5Z9L4uz4U043sJlnuOMNfZmhGewAhgDe+kjbF6Us7brS4u+eITvHiTaID1XHmVs1axu7Wl+dt+BlMPhvF+6TMhHQeYZ1hctFYM7D8W+TXaDxP1MOBrEsFECN3fgwfB3Od20yCS2k2+dmC90VCwleeHYRM9/msRRRwznfdaGOIP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU323l1Mk0Td1HZ1AmwUDLjwUG2O6W/lA55uBOVmKy4=;
 b=iQ+aMfgDpJvX9ocIapu4KxLBzqOxXMEe/XVbhIOaYNCdr5vVKVl4oF2fseMr/qsehqX73X+ivfnmebl8MxW9gYf5urj26voN/a8eCnDDfNxGfdE1ZlA1avNQnAVtwJ9L6z2zk6tTt+y81o8S0x1tb1uD8xMqBjWrXZ9X34j5WVs=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWLP265MB2018.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:6a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Wed, 17 Feb
 2021 10:16:28 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::908e:e6f1:b223:9167%9]) with mapi id 15.20.3846.043; Wed, 17 Feb 2021
 10:16:28 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXATVZ5f5l6UkeM0GGLk69Yeo12qpcJb7ogAAC3eyAAABINA==
Date:   Wed, 17 Feb 2021 10:16:28 +0000
Message-ID: <CWXP265MB1799B0B574D34469A5C1811BE0869@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
        <87v9arovvo.fsf@codeaurora.org>,<87mtw3gfyr.fsf@tynnyri.adurom.net>
In-Reply-To: <87mtw3gfyr.fsf@tynnyri.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.213.193.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73eff9a9-a171-43f6-906e-08d8d32d1708
x-ms-traffictypediagnostic: CWLP265MB2018:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB201808C4FC03E8D99E1193C1E0869@CWLP265MB2018.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ZAYNktL9NfxU8Qk7G6Of6vzaMqZs5SNbjzGvbYkPTdA/N7dOe2imdk12NJJFk1Hk8bQAE92epoasS4Vx0wTbZSOfWWmV7PZcYR704XiqL/+dwFS5/PuagGSmCIv+3Ta0ZwkCKfmVhmwUNipd3H4HAZ4Y7flcesqWBPEwxDXP/XTs9Jqwu5B3ATW8sn5/RHiI5paaObVZLCJylI3sUbLo6zMcfVOzrPGjPvBaV+X//AjWfHslkEGlrNQbv8kfLPypXhtSksCyHhIb/TXu8mlprGyWnBSpnihRmd3fWt0rkhI3DQsTOIq7oG5jGVON4dBmB9+c7sSzIxAXzNCnWHXmDf/3+gGSNvIdy+/tA2Khy2hX8WJ/Ob7QoAfpjXu/5nG6HbI9hzwFp29h4Ejk1ghOshO+s0aAl2S+E33XVVqND3glh5pCah61la1xgwrw5xTGtAQ4MxNsuWY5M4I+i4Vsa0ig2n4RSxXwRvYajnhVMbYxB04gRhRyUw6JqYku9y7ilwIdRXKkewkNwoUnCb2ybtQDtUEGt/LfRU6yYD6cDz4INRlCVNym0c2q0DsgWoOlnuoQc8ybq4+L746q7l9n1u9dHzd24niKUHTB10ySIY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(136003)(346002)(376002)(366004)(39830400003)(8936002)(186003)(6916009)(478600001)(52536014)(8676002)(7696005)(26005)(6506007)(2906002)(54906003)(66946007)(33656002)(91956017)(55016002)(76116006)(4744005)(9686003)(4326008)(86362001)(64756008)(966005)(66556008)(66476007)(316002)(5660300002)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?bGzszH/WrGcEwU086uTap/7yiQoYMrS3nDcEWPF9E3+nk/tDDLmsLKsnjO?=
 =?iso-8859-1?Q?5ntYce3Ky/bEcrJqa4qKTvVyECVF4biFDf7IGzbUlWwL9G7LnWNeQB7oJ+?=
 =?iso-8859-1?Q?+27rAKbIO7m/erZ1SQ/sam9/8lF4QdLe+HP2K0BNDMzK3Y7eqH6NUJ4Qp3?=
 =?iso-8859-1?Q?C1c0OgIFjnKRS67AWCsnEgrdJS1SJ9hq2Pave89kiobmVAdA8W4Pe7DlZx?=
 =?iso-8859-1?Q?F7LBzwSjpqJa5Rxt8PFczDc5JiQ52qzOOKXEVItHthqZ3iSZKMuJd1CoRM?=
 =?iso-8859-1?Q?J/RywcuwCvAu2AN5QtvdQtXpvf/NKILQ96Mg8yeonXbpLWyqmewi8fZxjF?=
 =?iso-8859-1?Q?0tn6ZEcJW+8jqtZlRwVwqwpM6p7pGwd5ExqxhdpmhJ7l9ZU/5YSi16l3C3?=
 =?iso-8859-1?Q?eATylARzPpgXQ+b4dL+6I3E1jxyRpcO/GA1cjd+iIbTvmqlEFYIQfIvJwe?=
 =?iso-8859-1?Q?SvdsqXH4FwT8V/cnMSUh/t1nfxhKKckdO28gy3j0vmO6E9ES/JbKvxfjan?=
 =?iso-8859-1?Q?YEslywkVZdv/J3o8ZLoE/wfkV0PvkgYwZSvjMjGFezyt9nV7+R0gNHS2jV?=
 =?iso-8859-1?Q?z3eL2sFPUO3YboH6m2wMtAuCC4PNlILTVwlx+eFVi93oFmPx/xn2jEcsZ1?=
 =?iso-8859-1?Q?nhDnXBff4uzzzyIXBGew/SiYXbJTrvBMtfBi7FXDkG40pnyeznSK5FZlzs?=
 =?iso-8859-1?Q?nFAaX/6UiM+nqRCGiKwLXNP1T3O3nd4ZRQOPrG+9/3ZPyYKudge35V19yu?=
 =?iso-8859-1?Q?DDIb5rKBvm5wnvaYcOrc/nFFSrQtQ0G27BskPdSJvZwXtqgheI8oge83HP?=
 =?iso-8859-1?Q?KQ2d8j9uVjJJLqD8OmWuAgF4x9TkySRSJcBqm08DMSKtuDTw7jpUibS6rA?=
 =?iso-8859-1?Q?xbljr/NrKmr6C3egkocd1gCMudUcbABWa6KqSQu4um8oVacqGuG9tkozU6?=
 =?iso-8859-1?Q?jnCiOiHG4tt6ApzVspd3/+cbujxUJYBlu1EVk5/W+oHR7OLt712evbI5xn?=
 =?iso-8859-1?Q?WKF82X8CQvFRAXkhjWQYfOWssq/SvyxXV54FuJRdJcgTr2X4b3UCTFUJ/i?=
 =?iso-8859-1?Q?Uz0zqpJOZbk7cuZQgKtwns2aVkN/pRhjI9a0ZD5FKd4JNp3IEB27/gU+P7?=
 =?iso-8859-1?Q?d0/8CnAWYDh0zATFVTdL+n4ssNNwPygqFHZB0B8U0CqxYlqX3T6op3CHyA?=
 =?iso-8859-1?Q?Yd/p7w+87Jm6haHej31M3IIsqY1p8KoT7dOCHoSPwN3ab7Q/jOJuF6KxYE?=
 =?iso-8859-1?Q?yOKDawz8gY9VxHgXSuLVKf6rQKulyXW7kHH8L3nVfq4m867WV2SfsE3Esu?=
 =?iso-8859-1?Q?3vwC/0J1K0FYt/U9U/jJL9GYAtVWRarmXQRvr6pORFIVNpM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 73eff9a9-a171-43f6-906e-08d8d32d1708
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:16:28.5266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQ7hkByLjeXba0ciYm4TUSkoYIceAsoZaYrNR6HjtX38dkOilVPBwku9WgYfC6J4gPoxMKLmxoGIyYf3Tn1Xaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
> Ah, kbuild bot had already reported few issues:=0A=
=0A=
> https://patchwork.kernel.org/project/linux-wireless/patch/20210212115030.=
124490-1-srini.raju@purelifi.com/=0A=
=0A=
> Please fix those and I recommend waiting few days in case the bot finds=
=0A=
> more issues. After that you can submitt v14 fixing the comments you got=
=0A=
> in this review round.=0A=
=0A=
Hi Kalle,=0A=
=0A=
Thanks for reviewing the patch. =0A=
We will fix / address the comments and resubmit v14=0A=
=0A=
Thanks=0A=
Srini=0A=
--=0A=
https://patchwork.kernel.org/project/linux-wireless/list/=0A=
=0A=
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes=0A=
