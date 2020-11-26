Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC98C2C4E23
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 06:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgKZFBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 00:01:32 -0500
Received: from mail-eopbgr110130.outbound.protection.outlook.com ([40.107.11.130]:17565
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725846AbgKZFBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 00:01:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg8IlNqjt/qW+NipdHelqjdbWWb3z+H6kbOQuQJFznh1mAUWE/v+VgYWDVnXBLVJXFaPXRN2jwFoDg9R11QJ7yh3g4sV6JW9DwUk3+iwmAW0RcLYi2SlxnN1lhfT+x+M6vkHsDbnXqSrhXgxBC58ru4mq9yKKwQ9umVhHKyh5wZwIWmGunRgOay9Ev1sk1daCgZskU0bZPu/sA0IGMQiFyXOGNB+isq1OhHhS7FzJzyid5oDIyb6gfQh8Q4HFPoH2iZ7qKvxYPyz1ljWv2tZbaK8NUki4IIA8OGh2WGrCClQsofowX0ccII+gAff/gaNXj2oD3YMeuoJDS7eZUi45g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHYrsIFQP6xLkBg6mg8RoMXOyIYUJyyshQMi5sz0Bb8=;
 b=gGrNQ1nm/2Hdq9nXFq0lV+fya5oc9VmdGgn2PtJL2yFz5SiilotYxGyHJnrJBC2UC7ihkFKlLVPHxcT22Znkr8HUHZeZRozwMRU3k1UpQwNUxYSIZsvokvYJexK7Li3qc/S3a8xwGTCj6ungUgXrBDwn3QTSNwlei+l4pudmfwz9Nw3+M0jA0BzYC6RiToMdDraSamVQzVgTGsL2jfD3rMIo6QiJnx5dq071C8lBH/P0+MorNFnDLIGAA/7T+63dD4VWc/38QQcAh60xWIYsoukY4SX3vyt1Gj9p3nSmlG0Mg0fKaHO9u4fo0mh/LClP/bsl/m6Joo93fpwQM1XPZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHYrsIFQP6xLkBg6mg8RoMXOyIYUJyyshQMi5sz0Bb8=;
 b=qB0bxE2zBXn69m0UzGj733pYaVbEcTSEkGfUfJbYcNCEbVF4pL9bO0IVDO5U0WwZcEMYfyaLT1zysG3wIEm1i8wvgKYSX756YBhmxaX1WtneYcMB7yNsa9QzZWg5ZdpglRB04okXSKB/2adWFq8qDq++jm93HaPTdnDaAGYScyk=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWLP265MB0435.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:18::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 26 Nov
 2020 05:01:28 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f8b6:b3c:d651:2dde]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f8b6:b3c:d651:2dde%7]) with mapi id 15.20.3611.022; Thu, 26 Nov 2020
 05:01:28 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v7] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWu/oh8T+esyecpUerAB1FdPgUnqnXaMIAgAKA/Dg=
Date:   Thu, 26 Nov 2020 05:01:28 +0000
Message-ID: <CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20201116092253.1302196-1-srini.raju@purelifi.com>,<20201124144448.4E95EC43460@smtp.codeaurora.org>
In-Reply-To: <20201124144448.4E95EC43460@smtp.codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [106.203.70.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2963f816-652f-4b58-5fe5-08d891c8553f
x-ms-traffictypediagnostic: CWLP265MB0435:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB0435CEE6696F848D39FF200FE0F90@CWLP265MB0435.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NBJOmsUTv1thfZFUL6qILglOXyFQehkhrhs4gcUwnawbMw77C/egmvZWphDG00URS3NZUzLMEEt5+Gq6YDWSDneGb0q7UI/q7BfUp65muxzg5YKtHxLEgNWimJunJeJbnwkCNB80qX0FJW/Z2SLAQtFWX0yG2tMSZwfUYaYTH98fUBypkxvG659NDCr3g07MbFOnceJJ6fM3kROaJKZmVaDe9s4421tj5VMc0VrtJaZ66ahPzDsuIS5dVvJhoXVmFEDHWECYqHxwGaJEqJplLN6xBdlHkOkwx4HC9Ii3nmVnOVs/TTdeZzOAB4L2uQBZe3X3Id1sllr9nMTA+8iqefpnVQDNfhnY9LyAEsHipmOvlEYDcdtlSwvFkVgykSLAuFbaUvX0oYaMeHWN9IWXfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(366004)(376002)(39830400003)(346002)(136003)(186003)(8936002)(4326008)(71200400001)(83380400001)(26005)(7696005)(76116006)(6916009)(478600001)(33656002)(2906002)(86362001)(9686003)(4744005)(55016002)(966005)(66946007)(52536014)(64756008)(316002)(8676002)(6506007)(66476007)(66446008)(54906003)(5660300002)(66556008)(55236004)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mbqPLqMYYctQ6WYmhBYEWf0qoHtnbjGeeiI7fGaqsxd7GbXcfH3N49b3jj9WgD1+/pQFGc2JmDHhlELLZofeU2BwapjXR9zlXBdbLuw3WugCFkUs0xS9X8DMFCJfhIoqqzlzy6x9aNHFqzLOB+40zsQ3qlukuV/upRTrZir/KW1UFvBI7tR19t/TPjKR/0uZWnVFxzRL0UbGobx4WYa618JBs3Hjeu6f1d2D8ibklqNZCEYKm2aG1T6OLuAXevR10VXhSdmTepWHn2vjElgTV/QMIP1Gxk41G+sH1wILoA5JtTZ91o3MIm19QBUWgzX9lm7LQuwW62epJpxnfH8rIp53I7k9ECv0L+g5OADjQtLCo6vEdGYLyi6xMyn7OZ0sm9WlmLyhbCJFBpaOgw4l3jqaIhUcjnU32aRY+zz07+F5vTbl4kB3cSXb9ia+tz8DtUjztvU454vokUe/CTWutP3j0xv8sKcgjDq9Ca+N/yzKAl6L1vnbU1k9Fsdzx9g+FTh5elavjo81ei2vaW+kX12ojAkFbIQ3RCtup2P1pRX5pRK84nulc4ABs81wX8rrqiuT71aSxXa63g7e3K3ljnhh7Sfx6D5NATuBtYwr0lS8+N85mpMxMsRq1Nok26hV7XqTZxC88ZqqMa/upS9MRrFG3ysW6m0fGAX8+HYAO+TII4Jr1Z0LctL/dw9Ts2k2lChTlRV/lMBDA3h+2UNJboXHvFsoH469KbEff+EzeK01wvcLklr/3qP+EkDKIW757UV3q3ZOkiQmaV0aJnjaxT7/gENy+yRegC+55U0+fo6lwwH5gfn03VJMDa1c3Tn7/G+h54HD2jed2ioT+sAcNsPwoLPyCJ0h6yimD8YIs1ig2KQ1HfyJlFITsfibwz9ky74o2XmacPL/oPERcCX7HA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2963f816-652f-4b58-5fe5-08d891c8553f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2020 05:01:28.1722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +4HFlZNe34CZH+/6dJguqbbvy4UL7JNoEi8J+AgBqN5//dRPNpDbes9Svn561eeLiN19ZhH98RaFZ5fs2SbJNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB0435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
> I haven't had a chance to review this yet but we have some documentation =
for new drivers:=0A=
=0A=
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches#new_driver=0A=
=0A=
> Is the firmware publically available?=0A=
=0A=
Thanks Kalle, We will make the firmware available in our website for public=
 access and share the details.=0A=
=0A=
Regards=0A=
Srini=0A=
=0A=
