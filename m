Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104A61B0008
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDTCyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:54:02 -0400
Received: from mail-eopbgr30055.outbound.protection.outlook.com ([40.107.3.55]:37958
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbgDTCyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXK6oeFqmk+cMcx+c2Bd4QyPUe+kMMfBbPemBCBv/5eSHPOlWftDTaVtlQCYuXXfbJd5PfvN5Pdk0SKubgeuNFPdSjrsNG12J6c7zS/AjlBWLPfzfv2QVusg6hPMXtCyHIXGEahOsGUWIuU1Ob02Vhmrx1kDKu9uow50l7o6qO7UcjB9HGFc64EQ/9rTKD+V7tnNeJngwVmFNY5RPj/IWHpkw92JzefyXItf4JUY1fthsm5aiMV3SNErDVYVbZfg9H6/+TXBmwiG6FwW+N96iAJxeTnUAkVZoF8bGcdmInk879Ge4nFu3vNsIoHSSbUIxOz0SOSTI8HRu8rip7dXew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a0cSmpQOEv3tWV1nKHiyRBzdnqnN4WnCuZfmyXXLYc=;
 b=hHRL/RPlczl6ebS0scPYq1m2wr/sfVUKOZCvPq7q5jywTXy3Vr6lUBXlt8NtSuyRInWpbriC1qWS11W9voa5eaihHoWQXIFUe94gvtsuR6ZY2TS3HuhOcEmISodgRtNQxYmpugt3NXh6aFsDuf3BwPu96QTnsAxiN4Nr1Bhv46clM29yoEFfx2CawCWgDqFfPi5TrxOhLaylocSPUBbnzFJgmivfIUcP6s7E0Z6AOrloKML+KmBPCJFtOXQKSICwIQnH+nXmo0w1w9YPeNsMt8S3b/0A8/JHOVnReUE20w7FYkSviyMIjNE93mEd72QPEt4UUMXPqjMpjjv3e8Qw7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a0cSmpQOEv3tWV1nKHiyRBzdnqnN4WnCuZfmyXXLYc=;
 b=rFPKZgkRwHg12dbco60OpkGq0g8FnbiHOLz45Dbp0JF0dgZFI8ita/fui4S08vMCdGsIz0ZmitxLzSMpkvAEHf5azWRJMB5XqKBhPFcj2lys1CDVqJg72sb3kPvnf21wvc1FVbcaOClFQvTQlD3OW6LJgsSgE0VG5oAq8UWtlio=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6871.eurprd04.prod.outlook.com (2603:10a6:20b:109::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 02:53:59 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 02:53:59 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: RE: [v2, 0/7] Support programmable pins for Ocelot PTP driver
Thread-Topic: [v2, 0/7] Support programmable pins for Ocelot PTP driver
Thread-Index: AQHWBxL03Cs51oqVYUqmHzAo138hlKhiG/oAgB9TUxA=
Date:   Mon, 20 Apr 2020 02:53:59 +0000
Message-ID: <AM7PR04MB6885C6159F01EC9EECB78885F8D40@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200331041113.15873-1-yangbo.lu@nxp.com>
 <20200330.213010.176136354629521349.davem@davemloft.net>
In-Reply-To: <20200330.213010.176136354629521349.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b24b98a-c49c-4cf1-c1ad-08d7e4d61338
x-ms-traffictypediagnostic: AM7PR04MB6871:|AM7PR04MB6871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB68710E41E252F193F94CE679F8D40@AM7PR04MB6871.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(8676002)(316002)(55016002)(66556008)(66476007)(66946007)(64756008)(33656002)(66446008)(9686003)(5660300002)(7696005)(86362001)(478600001)(2906002)(4744005)(26005)(186003)(6506007)(52536014)(53546011)(4326008)(76116006)(54906003)(8936002)(6916009)(81156014)(71200400001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0MTL+H44KS75AJuzG2UEQCEtMO5z/j501tdm4yAlVfudQH3n1uNWEyiwBuros2dfSOBjpVniMOpE3s5swlb6gRknqXM97eQ1xJVsQeMsVn/riQLzeohcFr+R4rGBzQSZIC6djFqs67pacHxkf8hWYiCKtd9pWPBKw6MEo1mvf4BZ9DX/k/EHiZLoXjEHaiYbrCu4wQUdEQlj8xsmPWTfmGuayJQ5iQGJDMUXElkxt1B1Z1B+HbHpmB7C7UaRDyNecODfxajEpq88rbevyuNq0+cU4Ow7fUp3gKZqhisJ23NVt0/pzZJlDZf+H4QJRr+D2Hx/LeqONfWjFKOnQLED2pREWj+D9BrwUqCU0xTDOnlNYxBBvSQpUzI04y/52Xy2Y1BHQAL/KjejL9MZgvh/rTERaKHv+EjkAQFVKThPuo8jwkuaOanPPexzi2j43Pa
x-ms-exchange-antispam-messagedata: Z8dty2FN8Yu2RVMOIliH2LKuBJ/bgrjkP2NK+XIi6MbEwgeEYPiOF0gv4AEFv/LFsPTm5Obd6aQhUF9p4v29+fZ3lvgBbAaynezx1gji9gvpUngWOaZ6hE0aP4aiEHjCygcTXkLRN8MMqWW21YhWoQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b24b98a-c49c-4cf1-c1ad-08d7e4d61338
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 02:53:59.1680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MGe4BT3GgNZfZGFmy8Qob9XyvvCFzAZG6h2kMIhBO/moamtt2Faqy+wLuIIPtjwwYwCcOoCTxl5uIDGJjBheDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Tuesday, March 31, 2020 12:30 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> richardcochran@gmail.com; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; andrew@lunn.ch;
> vivien.didelot@gmail.com; f.fainelli@gmail.com;
> alexandre.belloni@bootlin.com; UNGLinuxDriver@microchip.com
> Subject: Re: [v2, 0/7] Support programmable pins for Ocelot PTP driver
>=20
>=20
> net-next is closed, please resubmit this when net-next opens again

Resubmit the patch-set as V3.
Thanks!

>=20
> Thank you.
