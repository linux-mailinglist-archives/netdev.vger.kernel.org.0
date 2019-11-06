Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6885F0E62
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfKFFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:30:29 -0500
Received: from gw6018.fortimail.com ([173.243.136.18]:59784 "EHLO
        harmonic.fortimail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKFFa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:30:28 -0500
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2059.outbound.protection.outlook.com [104.47.37.59])
        by harmonic.fortimail.com  with ESMTP id xA65UNtb028099-xA65UNtd028099
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=CAFAIL);
        Tue, 5 Nov 2019 21:30:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuRNsDy0JvHdPwMysSxl5827h08jahIKdI+Hcf3/R3vSkxK+RD+vwrcYqPonyp3nxnEz5xMJ5Aw/JULajr+woUe8mAnCXPLJTykQGTLvz7wzjfXSDuSFXs/ibkoz0BzM8hNTquI2IMFrvXdrZHqZMbGBvC8/SBhYhXcyOZrliJ0F2iMW3uca4DCCC95svdMG0un2vAxcwQMqIYH2GfPM3XjEWELFqaeVIXF9yr/lSU1cPnk2GllSWaLW7oYOLCbm6q+cYj9r3yOM3WuB6+z4QtaMCALuOijydIhiRaUvZq34NTsaWJLGSTdckQGgigd+pp/3BWO2/1C88cZ98f2VoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF9OkOttpe49xmKHm9VusmndaGUmFwOj13geeYSE7Jg=;
 b=XRDT3PnnqJBGigb7jgQKTkLWBN8ZrwBGo3p92NEsNPXCpbt0Dni5N/iBFU+GLE/iBHlMccUsuzQnbK/M1CcYjxUvDfL1Ohhd6cFYB1qEp0fyHI9pxk2mxtNmIoL0Ybkxw/vFQjB0yp3L6gvucpxLN9VYUSXVhmUSeSwJ3NS92KRazcbQWOX8/lsAxoCnzj/kMXDx6WobJXyLIFBs/xdty/rKuFAMmdjLlxMMfldgWXykXmw2dfM7jbbf4aAHy+1ARxMsrqlMSiP6nR+FRIwIrsnKMgF6JoIUL6pa104kFCdnFU8V8A0UDivYU33YKVZs2Epb0l9apOLVDvNsE+yagA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=harmonicinc.com; dmarc=pass action=none
 header.from=harmonicinc.com; dkim=pass header.d=harmonicinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmonicinc.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF9OkOttpe49xmKHm9VusmndaGUmFwOj13geeYSE7Jg=;
 b=TlIX9kCq6Og6gZ8Cweirhg2GysYWIaBK/Q5090M8/He06i6AcDYCiaMf3JTTmQ5N+H66pmNOcaL3kAG3v8cLq8Q5N3mb9wkVnlRCkbPFTZWkmmWgygKUW5S7MX0m51N9b3G1vtq+5TQwYeReG3gguLUUeGEfCvz/JlYHzo98bwM=
Received: from MWHPR11MB1805.namprd11.prod.outlook.com (10.175.56.14) by
 MWHPR11MB1902.namprd11.prod.outlook.com (10.175.53.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 05:30:21 +0000
Received: from MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c]) by MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c%8]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 05:30:21 +0000
From:   Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
To:     "Creeley, Brett" <brett.creeley@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     Arkady Gilinsky <arcadyg@gmail.com>
Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
Thread-Topic: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
Thread-Index: AQHVktE9LXQEe1tn8E2yMWCX6YmauKd7neLQgABu5ACAALtz8IAA2KwA
Date:   Wed, 6 Nov 2019 05:30:20 +0000
Message-ID: <1573018214.10368.1.camel@harmonicinc.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
         <1572931430.13810.227.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
In-Reply-To: <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [37.142.125.24]
x-clientproxiedby: PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::19) To MWHPR11MB1805.namprd11.prod.outlook.com
 (2603:10b6:300:114::14)
Authentication-Results: harmonic.fortimail.com;
        dkim=pass header.i=@harmonicinc.com
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=arkady.gilinsky@harmonicinc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Evolution 3.22.6-1+deb9u2 
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4bb340b1-f7f3-4791-45db-08d7627a6a4f
x-ms-traffictypediagnostic: MWHPR11MB1902:
x-microsoft-antispam-prvs: <MWHPR11MB190279D085DC95479B7E2AFAE2790@MWHPR11MB1902.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39850400004)(366004)(13464003)(199004)(189003)(2906002)(71190400001)(36756003)(52116002)(6512007)(229853002)(14444005)(71200400001)(7736002)(256004)(8936002)(476003)(8676002)(6436002)(44832011)(305945005)(50226002)(103116003)(4326008)(25786009)(81166006)(53546011)(316002)(6486002)(81156014)(102836004)(486006)(6246003)(5660300002)(2616005)(110136005)(186003)(26005)(64756008)(478600001)(66946007)(2501003)(66066001)(2201001)(99286004)(11346002)(446003)(6116002)(86362001)(6506007)(76176011)(3846002)(386003)(14454004)(66446008)(66556008)(66476007)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1902;H:MWHPR11MB1805.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: harmonicinc.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: REOOaDR11m+4x9jD5DGcutpKaAdC9CnU2LhuBaNX9hewfn8msFyb6xjwTTldKikk09CrMOlwCoR1gJq+HvVHpSHwT7srqX153PbxlnOPEgmEL4mJDwp6p0dyLHAvOlkKTUYFu+QVKRqCRZOVpBKH8MRyBeEv4oas6Ysh5xTykvCXnzg8e+HlYbA5evy7MZfH/N5xtSSZha0I9cHzmdxq77JH1eS+dlhmczmU3XaSaTNnQ6afYJ70F690USXd6/1fAsfwh3iWrNQbhf7v2vQcKQFJ4gcOEJY7hggUfh7r2K9ioxKPVJHEo0g609KTlljm/WHKJpn0dwQAcdXM78X4411u5w4NCphvhNMq67dcoXFF6yXfWJcfc8OvjkSRNHtWtsTKUdMuMf40irS+QeMluFDKxEEeuEeGJiFgKqo4WsSAuFyyNK2Arg9LTFVW4bH0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <790CB0E20D41A043A5B153CDD8918B78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: harmonicinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb340b1-f7f3-4791-45db-08d7627a6a4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 05:30:20.8195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 19294cf8-3352-4dde-be9e-7f47b9b6b73d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idvvuJUhF1DZ9BXXMxm8udlyCJy5krAHOedudq7iA54+5McPFbCRYwFxbA+lBJbcUqhvBQR+/oa8HwtMofcqwqOHAaZpbxhAFq+sgao44Xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1902
X-FEAS-DKIM: Valid
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-05 at 16:55 +0000, Creeley, Brett wrote:
> > -----Original Message-----
> > From: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
> > Sent: Monday, November 4, 2019 9:24 PM
> > To: Creeley, Brett <brett.creeley@intel.com>; intel-wired-lan@lists.osu=
osl.org; netdev@vger.kernel.org; Kirsher,
> > Jeffrey T
> > <jeffrey.t.kirsher@intel.com>
> > Cc: Arkady Gilinsky <arcadyg@gmail.com>
> > Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface be=
tween VF and PF
> > > static bool i40e_vc_verify_vqs_bitmaps(struct virtchnl_queue_select *=
vqs)
> > > {
> > > 	/* this will catch any changes made to the virtchnl_queue_select bit=
map */
> > > 	if (sizeof(vqs->rx_queues) !=3D sizeof(u32) ||
> > > 	=A0=A0=A0=A0=A0sizeof(vqs->tx_queues) !=3D sizeof(u32))
> > > 		return false;
> >=20
> > If so, then is it better to check the type of the fields in compile-tim=
e rather than in runtime ?
> > Something like this:
> > BUILD_BUG_ON(sizeof(vqs->rx_queues) !=3D sizeof(u32));
> > BUILD_BUG_ON(sizeof(vqs->tx_queues) !=3D sizeof(u32));
> > This is not required comparison each time when function is called and m=
ade code more optimized.
>=20
> I don't think this is required with the change you suggested below.
Agree.
If other code in driver not need to be adjusted/verified, then this check i=
s not needed.
>=20
> > >=20
> > > 	if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
> > > 	=A0=A0=A0=A0=A0=A0hweight32(vqs->rx_queues) > I40E_MAX_VF_QUEUES ||
> > > 	=A0=A0=A0=A0=A0=A0hweight32(vqs->tx_queues) > I40E_MAX_VF_QUEUES)
> > > 		return false;
> >=20
> > Again, from optimization POV it is better to have constant changed than=
 variable,
> > since it is compile time and not run time action:
> > 	if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
> > 	=A0=A0=A0=A0=A0=A0vqs->rx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)) ||
> >=20
> > =A0=A0=A0=A0=A0=A0vqs->tx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)))
> > 		return false;
>=20
> This seems much better than my solution. It fixes the original issue, han=
dles if the
> vqs->[r|t]x_queues variables have changed in size, and the queue bitmap c=
omparison
> uses a constant. Thanks!
Thanks to you for feedback.
I am trying to understand if this patch will enter into official kernel tre=
e
and, not less important from my POV, to official Intel drivers.
Brett/Jeffrey, could you, please, assist to make sure that this fix, or fix=
 suggested by Brett,
will be integrated into Intel i40e/iavf drivers ?
Or may be I should write mail straight to Intel support ?
>=20
> > > 	return true;
> > > }
>=20
>=20
--=20
Best regards,
Arkady Gilinsky

------------------------------------------

