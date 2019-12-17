Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE1122FE4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfLQPPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:15:49 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:37473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbfLQPPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:15:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwaGY4LZ+KUXp+h31hb25H9YYNzIiF6pFlpyEB/WJ/NRj9n9CFL9Oa9ZlL4aTzCkjpxVnFpltEYZOvUr8qHDjoCNYLwWps9zmtLhWf/Qg/2uvpCOBQ2yC2e0/oYIM+PmrzDsw8pXZncYjilk4eRqqPem6Q1rMt5H0kIrczk2MVTmsrHCSkM0hIxANssbIpOnkcYRm0+9P+ghD+pOYtYRL4JBCEK7C2lsfYDKk3egnV0S1w0MslRKfVTnCeadrxpJp73itNWnDpoww68EWyyJmPnSRyJLYs17StP7HeFQt2DR3IceJzr/CYMfqTyEguUCwW107sZi5iHRiYb9WNtCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZFxRT0GOi/Vsu5beHbq66xrGOfUhq7QJyQgnxawg+Y=;
 b=lBw9CsCszpQpUe6b+x1PqUpMgDmGTDJNzyZMMmGVPUCLVEi9QJIkP4WEtP4v8dw9mY2hR91GQ0D7o0NnI3jkGhazpOyNrHZGA4OAUDgQeJLlHJvpu6NXHFc2fGm8eWsTjkPQQSZi128PT4xDdUbmDC5Cz6U+hkDpURFTiF4xFZKi/kG+xGxJlp90vLcjR3F3W16Ets2nFEJC54/2SWb20hIRCIEmd0nAml0WQI4jKYUdtPxPI9zBxxkkbYqiw1J7ZEcHbbf37om4+pASfbD56rsBs7CDJgbVALTOPd5phldy5xg/gIwRR5tOqKsEg2mB6t7Lq7GLkDLOhJqwId/6zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZFxRT0GOi/Vsu5beHbq66xrGOfUhq7QJyQgnxawg+Y=;
 b=Qpf5jgnKhC4cXxacIfxHh3t3YT1D5kWhWXkONoIy+NjV5x0BM4pCu6GEqTCJ3ZTuFUh3gzWVWBTkG2dMdCOb6RsZMT18l03Da8swGw4ZGZw0yskMc0qbNLk07qt6TL1ryfS5P1570D//815wHFB9slITbMfON++by35L1vGcKxQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3759.namprd11.prod.outlook.com (20.178.252.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Tue, 17 Dec 2019 15:15:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 15:15:44 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Felix Fietkau <nbd@nbd.name>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alban Jeantheau <Alban.Jeantheau@silabs.com>
Subject: Re: [PATCH 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
Thread-Topic: [PATCH 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
Thread-Index: AQHVtDLBov0Pg1nqV0CYOt2kPrSx7ae9D0mAgAEbCoCAAAVOAIAAQayA
Date:   Tue, 17 Dec 2019 15:15:44 +0000
Message-ID: <3099559.gv3Q75KnN1@pc-42>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <3755885.sodJc2dsoe@pc-42> <f5a6b1b4-6000-04c9-f3a6-c2be8e5dcc61@nbd.name>
In-Reply-To: <f5a6b1b4-6000-04c9-f3a6-c2be8e5dcc61@nbd.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0efa2ba-0c83-4e11-8d81-08d78303fd03
x-ms-traffictypediagnostic: MN2PR11MB3759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3759B7FCF7DFEE1CD77D00EC93500@MN2PR11MB3759.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(376002)(396003)(39840400004)(366004)(136003)(189003)(199004)(186003)(81156014)(81166006)(33716001)(66574012)(86362001)(54906003)(91956017)(6916009)(107886003)(8936002)(26005)(478600001)(66556008)(66476007)(6486002)(66446008)(64756008)(76116006)(66946007)(2906002)(71200400001)(6506007)(6512007)(9686003)(316002)(5660300002)(8676002)(4326008)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3759;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: leuZBy7uSqJ2M3kgMi0fc1Nne48Mg92yAUO0UOj6UL+nKy8J5pLQjZzNjJYIW4IDJbALLlD/F27oV+f9e2+dsd2X1JlLUfxrSRjDDUAIDKho1t/t/7AmDJCjpMtby3es5DRWaubrDqIUydxjHWMpHOyJBDabuVsqL4t3zbMMbBZmY/HXV3hJpyzGFgC9dasykbpb7RE6cMb4nJZyS6hFq6MAQ0xJFaIuWnqgx501ROoZTJ3W2Czj1F6dDmjUeFiYPU0clp4HjRG1nU4N8rfwNJC0mFyfwIBXuxkZgEBzoumXr6Ow7V0KANWz8CVpG73PKu404LMjUNzSrrifd1jWVJfY9GHUxNTzY27dzpWJlTiNxVVKAq29vttdG7/LXDPbxng2y/vtC9dTShPFuGnmY9sgtgkkBE5cuSK9WomF2hpeoKIlonMPtKoU/MqQFPfTKb0zf3F8EcyDzxDhNM757PMRLrfj3JzHx8VOhblntfNnvIhEfxaLnEXRCGuG2jaa
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <85E93619B9622F42B50D80D4478C053F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0efa2ba-0c83-4e11-8d81-08d78303fd03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 15:15:44.7754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IHbKaw3bpDRPS/ibEPbmcdivgki8Mmxu8ey+QRN1lJh+W4clmCXPLGz201G2lJulD8RFOpchLf3Tei1/HehdbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 17 December 2019 12:20:40 CET Felix Fietkau wrote:
[...]
> Instead of using per-packet rate info, implement the
> .sta_rate_tbl_update callback to maintain a primary tx policy used for
> all non-probing non-fixed-rate packets, which you can alter while
> packets using it are queued already.
> The existing approach using per-packet tx_info data should then be used
> only for probing or fixed-rate packets.
> You then probably have to be a bit clever in the tx status path for
> figuring out what rates were actually used.

Indeed, I have noticed that we are are to react to any changes on the
link quality. Your idea may helps a lot. Thank you.

Do you know if I can safely rely on IEEE80211_TX_CTL_RATE_CTRL_PROBE and
IEEE80211_TX_CTL_USE_MINRATE to detect probing and fixed-rate packets?

I currently work on others parts, but I think I will try your suggestion
in January.

One last thing, do you know why minstrel appends the lowest rate and
minstrel_ht don't? They should be identical, not?


--=20
J=E9r=F4me Pouiller

