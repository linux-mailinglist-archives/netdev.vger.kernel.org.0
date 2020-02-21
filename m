Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755D0167DB9
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgBUMt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:49:27 -0500
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:64832
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727683AbgBUMt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 07:49:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsRGFh2bEGL26D3njAe9T26V4nFaKElcG4uzHhwaaopnHr+sSbYdt4AFpr5eWQaS0wjrj3rsDtUD2LUFjnMuAXSiE1tJKRtBOUarvs83/tKDnD8Pqnqq9RGB6vdxNhidiIhuzE8oN24OUDIuZ2xBAJBUpKbGduXtH5hKgp0W1Z01ekuX2Q/+wQDRcft96o60aUS+HorpdGk1sfeaF5gl51N3MwUFgvE+vqmx5+00PwILBMFRNiVFl6P1Gwl1i27Drc16ZnLt8dRsn1fVIcChU+AhID2nNb2YBDATdr8V6TNuJELIeoFpwk5FiFzT5DrzOg95b5fK/NERs/FER+LVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUYreOpvE64zcz4LKjYQaMrMrZvxuEb/ed22KD24eiI=;
 b=EX2ZnE5dzdRSon4llpqGuy3fGcwaxax+9x3qG3HCMUbYyi+k2zlLHPMuRHE1vBJ3eduweC9l0H2Fjl2T4vC4Z1xz8gmCIl1B88Wv6wkdIXbSf3VHkw18LXPFreRzHpT+rDjQLNJqf27YRN4sbvCzCiwUJJgiR6x20+j7M8VT6Qy0+IgA/OjPFVDuAAx0cnflEc03k0YnLC9KATgKZ7mDX8nNtISomYkx4YLHY62hGNi37bFTTTdl6CPt3u7t2l8w7APz/4VYR7r/TNsuCtVNWcpb9g6095+RwHu4JIXOWGoh69v2f6f+MiOBKPfTnSdwO/IC8O0mIJVx6/pPLyas9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUYreOpvE64zcz4LKjYQaMrMrZvxuEb/ed22KD24eiI=;
 b=dgna0+W8RuaMdFgG4AZ0AN8UIqAyLjUyKVUJBn6WS8BYB/niI2Um5fuUTUi/MHkgSQ0AwD+BzWfpAtVawVyO95zNZVXX/7LBTdrO1OEiAyhD1HaybIR8i+sor5S0CRYVYpipISPphGUNtEgbzoV3lVSmlJej06gp/BTKrIDc3V4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3871.namprd11.prod.outlook.com (2603:10b6:208:13c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Fri, 21 Feb
 2020 12:49:21 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 12:49:21 +0000
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
Thread-Index: AQHV6K3zmkarmgxVQ0OGCjaD/lmZqagljBmAgAAKNgCAAADIAIAAAjgA
Date:   Fri, 21 Feb 2020 12:49:21 +0000
Message-ID: <35962489.2oEhloAINf@pc-42>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
 <10411162.7U3r8zC6Ku@pc-42>
 <1cbc48003d249d3ce14941adbb32089b57573cd0.camel@sipsolutions.net>
In-Reply-To: <1cbc48003d249d3ce14941adbb32089b57573cd0.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3196135b-c425-42e7-c779-08d7b6cc793b
x-ms-traffictypediagnostic: MN2PR11MB3871:
x-microsoft-antispam-prvs: <MN2PR11MB3871F446CE8C2B344AEE4BE593120@MN2PR11MB3871.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(71200400001)(6916009)(66446008)(66556008)(66946007)(9686003)(91956017)(316002)(186003)(64756008)(66476007)(6486002)(76116006)(6512007)(26005)(6506007)(86362001)(478600001)(66574012)(2906002)(33716001)(54906003)(8676002)(5660300002)(8936002)(4326008)(81166006)(81156014)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3871;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3XgZwmxPKUJkBWztp1uEUVpkmY2f00AU0Ke++sFMUWiE9K5saohpC3DaEA/gRUEcmdRC/J8c5fTDPm6prq96sINdT5y5JQ8JToxqj9eN1e5ylKC9apx7SmHPPWSyriHmk2600VA/IQ15YE9Mfi+kN/TRdpFU2fM7Pn4eMPtNvAHtG7R0f9TEay/HwsbpjweAOlcmSc5v+LPEYRFZnF8zJR++fkLJR4e+yy1qf4p4ZM14htArQOyyVXXlnoOMYbUICqQJ26qQ8F+tfVsehiqEL0gUClDcBAFHBH6Ed7kHO/vyfs5f7XcBvr68t+CsCLVK2ruefOZR7C6ecWCpt67Xo9k5uxMELYmwuLxVHxsm6ur/CmYJoMy0BeSGUqHC0sdS1bwyKU/9aNkn0V3p2P7tNtXW+Ngv7dDv5mcgW0upqOOdVLvD1oZi5GQwMiS33OIWI/uHHW8yd3qLoAEddJs+bffmvnvxyZmRk2IIDYahtPWvO6myutW9ZUZ1/Ci81Ypo
x-ms-exchange-antispam-messagedata: KQWd8XwAcIcWZlAyO/E47TqKzXEbatMW5ukaka4y1I9H/mTKhzocqVb9pGkcLcDjjF2ufXYWptlCsoJgeKuwBoEVVIREpmg7dkYTvVVxCfW3VJjTV/jfDbfhYoSKvTOROCQEugbms3wcBHFh+qYZ9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5460CBE59039BF408F10650D567564CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3196135b-c425-42e7-c779-08d7b6cc793b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 12:49:21.8449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cw5ZrhIMYc5P/HIeTA9KxadenkWlrSYNMucpD7Hb/egRGaB/nSGuEkJ/36QbAF34+UHaIlbc+n62kK6L72j+3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 21 February 2020 13:41:34 CET Johannes Berg wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> On Fri, 2020-02-21 at 12:38 +0000, J=E9r=F4me Pouiller wrote:
> >
> > > > -      * =3D 0
> > > > -      *   all beacon intervals for different interface must be sam=
e.
> > > > -      * > 0
> > > > -      *   any beacon interval for the interface part of this combi=
nation AND
> > > > -      *   GCD of all beacon intervals from beaconing interfaces of=
 this
> > > > -      *   combination must be greater or equal to this value.
> > >
> > > This generates the nicer output, not with bullets but as a definition
> > > list or something.
> > Indeed.
> >
> > Unfortunately, I hasn't been able to use the same syntax in struct
> > description: if sphinx find a blank line, it considers that the rest of
> > the input is the long description of the struct.
>=20
> So let's just leave it as is. I don't consider using the same style
> (inline or header) everywhere to be even nearly as important as the
> output :)
Ok.

Alternatively, the following syntax generate an output close to the
original:

    *   intervals:
    *       :=3D 0: all beacon intervals for different interface must be sa=
me.
    *       :> 0: any beacon interval for the interface part of this
    *         combination AND GCD of all beacon intervals from beaconing
    *         interfaces of this combination must be greater or equal to th=
is
    *         value.

--=20
J=E9r=F4me Pouiller

