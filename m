Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3BB15A63A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBLKYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:24:30 -0500
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:9935
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbgBLKYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 05:24:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4VaBCJ+JkW9sD1D+kSGu7gEtbjW0lKTizgYklsReY7CMlWLZs7Jd8pjDGeQergJhnJcCiA90H+T2uBTNVZ8ZqvRx2KgnQBx2tvY8ktl4M7fQg0GGTvICyDWzfBSjsx2VfUV5/zCi+XblNVpV4iODkT8/D7IwGXEC322IxHEW30NX0dxg3X66T5YVJB1/2hyjU5hjF0CUkKrTpd6i6f1SOLNtUsvnWxZTX3T5aRAiwd8IgNUID3TVyEKBmvrJ8kPZ1H0/sAsOsFUSGd8fhJ+Gp0HjYjS8v7w5SxiBam6J+mgN9vHRw5h4EmpPs8+7Pn/02Lyr4P+LHohqvVZYQjRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDXLxzRI+u82dUfOtfz0yQYBRUPAn0XQ8rMzrbk0fBo=;
 b=W6Arz8K4kigNE04DyY/fsQxy9QKq8fAxpB6+UYwSFamUK3lpZXk9XjEAaFza1BROyTjzPWA4B4hUz2n+rxX3XD8GOExc0sAf7G7+ryiIjufwiqQHutYF7FoRhADusKmB6cO1rQ/V01WvCGg0XDYuaLstpvXF6bWSKNfxAY2omsrGwzDALIv5oPypzX8nvAH85zgWFDnBkeGnM50QvliL26uv6Nc/2ZW65k1jWepCF6JFZfJ0vVmMG7JF7Q106UhTn/oIk+aXbaZG0C5LCwSKe5CfRQlum2TbV8OcsfhYVXStgpgZUMIdRHpSxkC2zLRqzsl8Xewfcpl2ySaZr6wyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDXLxzRI+u82dUfOtfz0yQYBRUPAn0XQ8rMzrbk0fBo=;
 b=I+DoEscRjRA98DQO99QoYkEjlYHKcI2x+L2pnRDTnZl3SnK5W7BnoFj2J2iazDLMDgEYaAiBg0qJqvcunFzUf7m0ScCOurUBEGWR2rp5coxp68Z+6ho+XAMIMDTNrBDxTx8ky1wjnV9x0umESSk+XNeR/kLjCVNbjbGOKb9uE8w=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7141.eurprd04.prod.outlook.com (52.135.58.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 10:24:27 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064%7]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 10:24:27 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: RE: [PATCH] ptp_qoriq: add initialization message
Thread-Topic: [PATCH] ptp_qoriq: add initialization message
Thread-Index: AQHV4Jcxgewx58wIn0aNZKEUqjecgagWwCiAgACbX4A=
Date:   Wed, 12 Feb 2020 10:24:27 +0000
Message-ID: <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200211045053.8088-1-yangbo.lu@nxp.com>
 <20200211.170635.1835700541257020515.davem@davemloft.net>
In-Reply-To: <20200211.170635.1835700541257020515.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [223.72.61.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebba8b0e-c7d9-4d36-6dec-08d7afa5bd29
x-ms-traffictypediagnostic: AM7PR04MB7141:
x-microsoft-antispam-prvs: <AM7PR04MB7141A9711B24F76D62C91AC7F81B0@AM7PR04MB7141.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(199004)(189003)(52536014)(6916009)(53546011)(15650500001)(5660300002)(33656002)(316002)(4326008)(66556008)(8676002)(6506007)(76116006)(26005)(66946007)(54906003)(64756008)(66476007)(66446008)(478600001)(81166006)(186003)(8936002)(7696005)(86362001)(81156014)(55016002)(71200400001)(9686003)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7141;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8t1OlDBC6//7Kj8IGNrlMWu3ehFg9tiUqXSBmubK6wVLb2Yk4l/a5q1MZflMZBuqwMLRPGgtT2JjtvmSbK4KE7a5mNBTvwYB9IDVdsqxhJoN7KGEJbcko2W8DHZL/JpreDtN/uoIM1f+UlqI1rlGKIvJvcFjQMtiryGO4OIMFNVuh9lGr6VcUqW+hoikJj7wZHY6/q+EGW+1OSEpXD2lV1vrVPLBd/+kPjzFirukqU3gZTIivgA33h1aKQEvN6hUkvK1JzMfY/6b+98bGGdljjylp59SVRJJsrcQ0X9RhKJm635nQ8VbWwH8i8ugpradeeKoQLBJVZ2/y1Gu8fAxWpHsQRZT0COUELZ4Vo+PG5Ta8SClaY2LlXz98NXTP7ndDjXt/sqPhv5ixaplmL3tmSV+ChuIv3PsvicDyC6HyTYFVrXEUcWM0Jb6qIK22qK
x-ms-exchange-antispam-messagedata: 75sP9k1DcSQeiJUXlsRHqIl1jGJr+puYF0c3Ahy2iSWxdjn7f3hRXNv7jurnTWg+uXZkTlP4LAeNUACzk/r/A5Uu4EmpS0A2OwUIc/erbt0sK3++J7VO1JjSWtfbE4znvhgL1Afd/fZ6CKK/X+IN5g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebba8b0e-c7d9-4d36-6dec-08d7afa5bd29
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 10:24:27.3173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CiwNNKO7Z6xsrXT+If92YFkJWFiQcX7KsFAqSddu8kzZ3W8lIlnSGuneIdTHs+C6GSlUGYsOOD7atd9JGpmCSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of David Miller
> Sent: Wednesday, February 12, 2020 9:07 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; richardcochran@gmail.com
> Subject: Re: [PATCH] ptp_qoriq: add initialization message
>=20
> From: Yangbo Lu <yangbo.lu@nxp.com>
> Date: Tue, 11 Feb 2020 12:50:53 +0800
>=20
> > It is necessary to print the initialization result.
>=20
> No, it is not.

Sorry, I should have added my reasons into commit message.
I sent out v2. Do you think if it makes sense?

" Current ptp_qoriq driver prints only warning or error messages.
It may be loaded successfully without any messages.
Although this is fine, it would be convenient to have an oneline
initialization log showing success and PTP clock index.
The goods are,
- The ptp_qoriq driver users may know whether this driver is loaded
  successfully, or not, or not loaded from the booting log.
- The ptp_qoriq driver users don't have to install an ethtool to
  check the PTP clock index for using. Or don't have to check which
  /sys/class/ptp/ptpX is PTP QorIQ clock."

Thanks.
