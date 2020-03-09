Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9817DD40
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgCIKRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:17:40 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:60574
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbgCIKRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 06:17:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHEyFw85Mq5+SABScAmit0WQb97oUc3XjZs+vNvwJaoxFAQRoFMZ0DVwoZJhiYLwMlN1tpnKHx/JLu4/AieQZTzTBq7wVwqoPTsLzfoSsHAdnAIxULCE1L/rdJHP9Bi7E8jgAoOxOtAmRDztvmSHLzMXyawbEm3hByfqhdeWeVqCizPxl19P63JTF6Eq5ssTKqc3vsa9Vhoxvhmluq9xKLoy+F4DfDVVp6vC2o2+akT8YSKQNiXyKz9NphIZ5NjhXIPudA1OGHaE/iLRZFa6T5vami4MR56ar3SYvEAvzKlCKM0KYnUuK1BMwyQ9CQdcWrIjuN96NTGZ2Pc8vxLpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHpDtX5dSDTKquhgOchTw8AC4aMTDnehvtU4h+znEQw=;
 b=TupCQiI1nrFaNwz2L8vTH762QQLI2KiDvibEsUITBGsnngaJke0r1EFuZc1Pmf8CqnkIjvOW2F8DRz8xI/ihXrE0diKLgLjLoFQHnPXYODKTPYvseWwJVzeH0cFHV4lFxPn1RER88vVd6NoIANRuHs1eYiHdYJlHHnKSHVzrKBBbIp93kjWCoFqyCQzNIVyJx9GmRb3yviWpwOsrOvp6+PyJkpE128Q+uUIc0l9XjDkiD6HUs2dIjHrEFhf7oLNdhj+bzpvZwD57sFUnx795ErOubk430WrQKyYDcsYfapZ/3BHhIcQVJn9iDwwotEXaE8IwQZPNDtaE5c05DEkJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHpDtX5dSDTKquhgOchTw8AC4aMTDnehvtU4h+znEQw=;
 b=kXoCHcZp0hoQNHIqmjb9z/TAXNXM0QkHAgKctYU5VoG1CvyoOPWGiXK58isdBKuhSq0uH/cXjW6Cd6GL4pNPXZmptjJfmNa/hESSfcz85+P8sDrSDVkmOWBoqoDhOPPDUHjCUwy1Wf1/qxIEbzVLJ0UL1W8J0B+jIfMswxI/cp0=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6940.eurprd04.prod.outlook.com (52.133.242.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Mon, 9 Mar 2020 10:17:36 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 10:17:36 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address in
 device tree
Thread-Topic: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address
 in device tree
Thread-Index: AQHV8xDKCmlsCwFVDU66wdJgWzXM/qg/1tGAgAA6gLA=
Date:   Mon, 9 Mar 2020 10:17:36 +0000
Message-ID: <DB8PR04MB6985A0B6A4811DCD5C7B8A6AECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
 <20200309064635.GB3335@pengutronix.de>
In-Reply-To: <20200309064635.GB3335@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8a24d22-1faf-4e5c-17f1-08d7c41316df
x-ms-traffictypediagnostic: DB8PR04MB6940:|DB8PR04MB6940:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB694074896D758CE4734A6F71ADFE0@DB8PR04MB6940.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:411;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(189003)(199004)(81166006)(76116006)(81156014)(8936002)(86362001)(186003)(66946007)(8676002)(9686003)(64756008)(66476007)(26005)(66556008)(33656002)(66446008)(55016002)(2906002)(53546011)(6506007)(110136005)(316002)(54906003)(4326008)(52536014)(5660300002)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6940;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +V8gUEfvGXw/Wrvzv/I6fGu2BqO2tY59FZsYYkpE5tJnWI7B5UEN5UeRtTW9WmoSDgmYEge1ycMRE13AP4B27UVhvPoduUkMePUvZmlLaDjjLIx+mNna0R7usNaKKD/WyKVzonpzv//r+xl5i9zkicXuJNNktwSAq+aDkg36lQQ7fUZQ0aAH4VJIBwvhxWgCZ3MBL4oj/ZIEj7FWZPEeOfyZKY8JEAxtwulomkBhMXnAIxYO4Gf47AQyEpezsiuBFORdRcyOPhbI4XUYtuTFQOijv04rJAR6dPiMnzYhFXuBlnJEP3swhMFOj5Jtt0KkvKrvHDXfe4k6nrsTktGqykJ4VtAJZj37/F3iJlGnE0lswnCVCVuoZFGG7giL3QsAyl2IRqsZqmpPY4ivEFa2oN1pGtU67K+hnHq2rrdN/PuwB5/rbf5Uoawus5aWojbr
x-ms-exchange-antispam-messagedata: 4HLglMN3127acLqofYYsan5B/VDfkzsjFV+TVUQyf2vQDFTThO/Bj3idKhPEaQyR4NggfkZcEsRodRkgfAQyNoy5F5SKv8FWqZJrjmOwG1CjE28QJLSorl0va4xELP6VfWjts4sMs9mMa7pwx+P2mg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a24d22-1faf-4e5c-17f1-08d7c41316df
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 10:17:36.2211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Midr5+pihmYsWe2Z5HLeHpX8ufrobkJGaMjRcwGdLNIlRfMYQFahZA31H4TDYwGYUH2zVTBeXPjVYC7TpYDChQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6940
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Monday, March 9, 2020 8:47 AM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC
> address in device tree
>=20
> On Thu, Mar 05, 2020 at 07:08:57PM +0200, Madalin Bucur wrote:
> > Allow the initialization of the MAC to be performed even if the
> > device tree does not provide a valid MAC address. Later a random
> > MAC address should be assigned by the Ethernet driver.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 10 ++++------
> >  drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++++------
> >  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++++------
> >  drivers/net/ethernet/freescale/fman/mac.c        | 13 ++++++-------
> >  4 files changed, 18 insertions(+), 25 deletions(-)
> >
<snip>
> >  	/* Get the MAC address */
> >  	mac_addr =3D of_get_mac_address(mac_node);
> > -	if (IS_ERR(mac_addr)) {
> > -		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
> > -		err =3D -EINVAL;
> > -		goto _return_of_get_parent;
> > -	}
> > -	ether_addr_copy(mac_dev->addr, mac_addr);
> > +	if (IS_ERR(mac_addr))
> > +		dev_warn(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
>=20
> Why this warning? There's nothing wrong with not providing the MAC in
> the device tree.
>=20
> Sascha

Actually, there is, most likely it's the result of misconfiguration so one
must be made aware of it.

Madalin
