Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853A8167D96
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgBUMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:38:42 -0500
Received: from mail-eopbgr680086.outbound.protection.outlook.com ([40.107.68.86]:30117
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726976AbgBUMim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 07:38:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9dpLENZaR02ClvEcVl+sMEDeFcgU67B0EHsU6otePENIHVPZnvdzj7v0b0SV/YOkyz2YoBz2CSQBn6R+p321SjbyQJVZorKivhQUunX4QlxU2o3Gr3SSI2tr/w8HKuHB5CE6N7viMRi1mA7H8kOl2RpO+i+TuHoQbRIoHWK8yeMD2mytwGGfrjyvKwMMmOxn5l3VSoY8qJjjKq1Bp5K7CIFzEfqQUsyLNHqLpN6DMK8sQNmSN/ZXwQiZmMC2KpRZIcx8IZIWkts27mtTsPuIVwhDnhFHl7NSSHWOzDdwgjbS02+6IUOSTpjvf0y3V2oin5ZyzL6BY48X77zYC84pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY5RNjBpuT223hlON31e8EY8SrvwN1q8f0F5o7mAVFY=;
 b=LYsRUN9pq+YmMuuUKcL0vm8ZAfKyTMDURSDosztfZCiUE8UcG/Z6ychaWCkDkct7z7GGBjr5V2EvWCupL6unY3d7ffvwDI0REhNYa+Oh+oT1eA25bgorYx2RcsizAvXAq9zTRQD/k77gJI3ZuDKykep9/MPQc79AhYpaFBHLe+WsLXy75Jj5sujcGHi5ZDUR9O71H+ZaO7NulU9J+HoxCCUAnhmWcVwfjXaed8kc60lS/3ZvaWwgILUDC2k+RfmVSdt86FQx34kjRm9vd0n4Q1NWlCJUxAoPcJKL+7qwBCTtkoaJwHECpNwxD9bRRP6O4nz+2DpO4zJKK4r8oQN4fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY5RNjBpuT223hlON31e8EY8SrvwN1q8f0F5o7mAVFY=;
 b=bGEO33SqZoKNTKBiQmxnY52Hotg65YC3/Y1k4hZM7P2vfjXIA0RZqvX/WA0T3rEyiYxvRc+Wc24pTJNNiBgcpfdTOuk5pEQ0mQnjbQ5cmNXNx5mRpn8Nu2O9kT5SChQ1ffbgmtuVxQ950cbWfmgegT6HaAJVxLPB77FA496ZHUc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.31; Fri, 21 Feb
 2020 12:38:38 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 12:38:37 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 09/10] cfg80211: align documentation style of
 ieee80211_iface_combination
Thread-Topic: [PATCH 09/10] cfg80211: align documentation style of
 ieee80211_iface_combination
Thread-Index: AQHV6K3zmkarmgxVQ0OGCjaD/lmZqagljBmAgAAKNgA=
Date:   Fri, 21 Feb 2020 12:38:37 +0000
Message-ID: <10411162.7U3r8zC6Ku@pc-42>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
 <20200221115604.594035-9-Jerome.Pouiller@silabs.com>
 <bc10669e0572d69d22ee7ca67a19c7d03bacd6ed.camel@sipsolutions.net>
In-Reply-To: <bc10669e0572d69d22ee7ca67a19c7d03bacd6ed.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afe8b2c9-8ce1-40df-ce90-08d7b6caf95e
x-ms-traffictypediagnostic: MN2PR11MB4429:
x-microsoft-antispam-prvs: <MN2PR11MB4429C96EDA0DCC176A672FB893120@MN2PR11MB4429.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(54906003)(6506007)(6916009)(81156014)(8936002)(26005)(8676002)(316002)(6512007)(64756008)(66446008)(81166006)(2906002)(6486002)(186003)(9686003)(478600001)(66946007)(91956017)(5660300002)(33716001)(86362001)(66476007)(66556008)(4326008)(76116006)(71200400001)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4429;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sVxHG1ckCdDm0slUXVrPQHldXkmDSAbpv9kLZWOPuty5gN6Dji7tu7HYuWC7TrHoPI8bGP54iEiBPDFpkhokm6ppw+RqkHoE/byNmkJrtnZzfQi9BG+ct4egjSpXzSe7NYxs3qh1SkOT4mG2gkfwR5d+gYkFFIb9dOJj1YppIgOqgUBu/qhf8eipFuLCpMeGnkKMcUHa3NnI7++rFTktZ0DTFc+LcnOQkppRYlvqZAlLQt9O95cbiaXI4CPmTPTctqukCqg3SUzsrJtVfbIQ2reFen0pRNECW6VvknqWZzyuYKTp5fd+Q2bDRfsrs1w3lNFlkkJgFeH2YRX1Z8oKECV3dURRi85F7ChLMD9Hz75Gn7crOV/XzoC4A5gMQt0CgBWShvcV774E7HFtsDtqBtORlLTuZoH6Q1BczHe4hZ2P1588oIDU8VC7FUAAR0xp5hY0Xy+EpYwIh2Bp8jQZpFQlOGvp/MBnM9eJqMaXndnNQgd37Ll2j8LSfAYn4Z6j
x-ms-exchange-antispam-messagedata: Q+dq32WYQ0Nmag6EAsptdq59S3Hvs1y0wdPlPObiDR6FsaOV4hozzHWEx40TZb0TN4926xe9AbasaRTNaxwVOHmrPaj0WoLNqpZmbvCgZo9a/BIfxWSw+/9busrl5HH5lTLNmvd0x9Btrc7ozT4fMA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <BCFE23D13A64184C8DDAFB92016F33AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe8b2c9-8ce1-40df-ce90-08d7b6caf95e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 12:38:37.8724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WN+2cji0lHB7gH8IfekoBhfxh+WBu1pOmwvgQ3bTNzR7/SHJxR/3+2h8UH8Te6ha5B4G/dJBOcE6OcmJ+dMKiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4429
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 21 February 2020 13:02:20 CET Johannes Berg wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> On Fri, 2020-02-21 at 12:56 +0100, Jerome Pouiller wrote:
> >
> > + *   intervals:
> > + *       * =3D 0: all beacon intervals for different interface must be=
 same.
> > + *       * > 0: any beacon interval for the interface part of this
> > + *         combination AND GCD of all beacon intervals from beaconing
> > + *         interfaces of this combination must be greater or equal to =
this
> > + *         value.
>=20
> Hmm. I have a feeling I actually split this one out because
>=20
> > -      * =3D 0
> > -      *   all beacon intervals for different interface must be same.
> > -      * > 0
> > -      *   any beacon interval for the interface part of this combinati=
on AND
> > -      *   GCD of all beacon intervals from beaconing interfaces of thi=
s
> > -      *   combination must be greater or equal to this value.
>=20
> This generates the nicer output, not with bullets but as a definition
> list or something.
Indeed.

Unfortunately, I hasn't been able to use the same syntax in struct
description: if sphinx find a blank line, it considers that the rest of
the input is the long description of the struct.

--=20
J=E9r=F4me Pouiller

