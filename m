Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0880519E7
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfFXRpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:45:18 -0400
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:60960
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727236AbfFXRpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RuZTeX3jJeS1R14BvpGDq7rZYbTrpGlfpKrVf2u5yw=;
 b=LF0kiEGnJ+RkHYlF0xSuxdbixsWgfesJXlB7pGN2hJzDYAQiUqXAKhvheV8QElAOHx6iBTTawOAmJEkiyk0BDiP+g19f9abSJTgWvoLzS7clksONXORcj3qqUrNuOtMrueO26ImD/h7HYp6Z4k1wNMbojJg1XMBItcUxKvAxpQo=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (52.132.228.77) by
 CH2PR15MB3637.namprd15.prod.outlook.com (52.132.229.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 17:45:12 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::11cb:ecac:61ed:9a48]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::11cb:ecac:61ed:9a48%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 17:45:11 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     David Miller <davem@davemloft.net>,
        John Rutherford <john.rutherford@dektech.com.au>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next v2] tipc: add loopback device tracking
Thread-Topic: [net-next v2] tipc: add loopback device tracking
Thread-Index: AQHVKlnfC03kVDTe8UqVgqJfs0BjRaaq3bUAgAA2VjA=
Date:   Mon, 24 Jun 2019 17:45:11 +0000
Message-ID: <CH2PR15MB3575F5AE6B64F926A5BBAB819AE00@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <20190624064435.22357-1-john.rutherford@dektech.com.au>
 <20190624.072918.1626161455453937687.davem@davemloft.net>
In-Reply-To: <20190624.072918.1626161455453937687.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab8b84b1-257a-4c35-8d44-08d6f8cbb51a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3637;
x-ms-traffictypediagnostic: CH2PR15MB3637:
x-ld-processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
x-microsoft-antispam-prvs: <CH2PR15MB363763F6A9F289E3B5FA72199AE00@CH2PR15MB3637.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(13464003)(199004)(8676002)(74316002)(81166006)(52536014)(55016002)(9686003)(26005)(6246003)(5024004)(44832011)(486006)(86362001)(64756008)(66446008)(73956011)(102836004)(14454004)(11346002)(316002)(478600001)(66946007)(66476007)(66556008)(76116006)(446003)(476003)(186003)(7736002)(229853002)(5660300002)(99286004)(110136005)(305945005)(6436002)(53936002)(76176011)(8936002)(68736007)(33656002)(71190400001)(71200400001)(2906002)(6506007)(53546011)(66066001)(25786009)(3846002)(81156014)(4326008)(256004)(6116002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3637;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C40uq08HNprH9rU6xO9Dxx4bkFwhoRS2KGanWxaunqVqMLaC1fgq/6axSVB19MtC1BMOj7p3Nc7LgbKViEAbypCKy9Cv3qBmTcOMiitqgUSH3M7UPlRYslNa7+9IMrM/CnmeCJIcRoJuThSn6n1bgUIx4Ha9fGzzloWzoMAUIBuOikK6lakpfuM9H5BXn9986r0FHI0m1trOxkwkZvVCHmFx4xcNj6xi+GsJwvW4eI7D6/ZdIF0zBoT4RaxG6rED1q/3LhQzadrg3EJaOVNMSynpRzdjMkUi9A9soQg7NcKFbvDl4+rc4uQ7Oh7pvBCHEa22Yp0rHx4EiUGmPEO8b/ZLbUPhlsXQBR1T6FmBnXQ4gcno8EGYxlg2VJ9XR+6/OEaPjGr4pbE9+AlbOxrLzfDp/Fy5P9zJig5yfb7v6dQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8b84b1-257a-4c35-8d44-08d6f8cbb51a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 17:45:11.8360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of David Miller
> Sent: 24-Jun-19 10:29
> To: John Rutherford <john.rutherford@dektech.com.au>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next v2] tipc: add loopback device tracking
>=20
> From: john.rutherford@dektech.com.au
> Date: Mon, 24 Jun 2019 16:44:35 +1000
>=20
> > Since node internal messages are passed directly to socket it is not
> > possible to observe this message exchange via tcpdump or wireshark.
> >
> > We now remedy this by making it possible to clone such messages and
> > send the clones to the loopback interface.  The clones are dropped at
> > reception and have no functional role except making the traffic visible=
.
> >
> > The feature is turned on/off by enabling/disabling the loopback "bearer=
"
> > "eth:lo".
> >
> > Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> > Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
>=20
> What a waste, just clone the packet, attach loopback to it, and go:
>=20
> 	if (dev_nit_active(loopback_dev))
> 		dev_queue_xmit_nit(skb, loopback_dev);

I was never quite happy with this patch, so thank you for the feedback!

///jon

