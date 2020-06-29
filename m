Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7420E878
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgF2WH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 18:07:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:57468 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbgF2WHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 18:07:24 -0400
IronPort-SDR: qTftx6b1X6galSuYRD3T+iyecFPuCU+KjRoxwNu0e2kdYKs6mHSkVWDgvX4qrXV8vvr/7A8Zon
 NHRriQoo9eIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134392925"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="134392925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 15:07:23 -0700
IronPort-SDR: eNo/cm7d3ZAgGfwSVYTxK8Nn0zFPGcW7LSPmpjFgAe1LJO5yqrj5Cv5LAFqLfRwwq93GW2OAhS
 KfW+Jyorx1RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="320754353"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jun 2020 15:07:23 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 15:07:23 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 15:07:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 15:07:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfy6FqMs7O4dnN1S6PAXI+gKGCedxAt8/gADd8819rL7PcK9mFwPNdCJL93QNE51G9karJKbiUIMksQUu/opFIG0LzCAy9uT/jehpTlUcLE1Uqua2kHqGjDUHuYJhdqWw2wzn0UkSyGyKWFjcofm27YhzaHqEhK42Fm25P9ltnuAlXSvxMap3K21+cn2/a/gs4FABa1k3GZxZuSaF3+HGdfmLIVZeCnCB1AXLIsLIKyAFUqEQgalDtVUzTPzpVfnEEh/QlUQxiUv839OLHnJU2r0C7yBnXhZtgKYYluocw4nLw91+h5DlL1tCo0lLhuf721xMZ9jtz10Bj2DdkJrug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P23swHZjx0RYocR9CnR9MfJgDcMS80XH2RlZzKYQZc=;
 b=Nx31vfwEnhEJ3Zi+UhgkBV6uzf/AC33S7nFABUGofZHb+pz074m3s72PiVUaO6sNi5cTu1S6hOpbikaNft8BfIn99jqmNXtwSlBGZ13/2h/wjCcoWzuNrPNcBWrT6yaHsebO5Gm9YMned0RQxCPC1lQVFXqoQJxDniG/xfvDZ0VsfH9Mu+7vzxtpBqkAidOOiekZ/WGKl8/UAdl1LOuBxJbW65GurF6eF8dzSOS36rvEaPNgemYmRcIWHoC17hbQVCcH80Jv1kS6auRZXxW5jjdwQS5N0WCibH8JUeqUTgl1ulJSFlzm1G5lHwmlPltYlzz7j0Le29OllfU7eV7vag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P23swHZjx0RYocR9CnR9MfJgDcMS80XH2RlZzKYQZc=;
 b=ky4LtmdnP//0V8vY0juhV40r/c6wq0okSym/b5EDMBNiKDdVYQacgbdggHhV232wf7Je7QPvpS3CQD6suVoFs/63uiqPYEyx+CkeFT5NTkA5fc/lKmv37/wlCHtmhjk1eHbQR2aEF7hWyzroMQk7RwpRiww9q/AtzEEnXYtldo0=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1967.namprd11.prod.outlook.com (2603:10b6:300:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 22:07:19 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 22:07:19 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 13/15] iecm: Add ethtool
Thread-Topic: [net-next v3 13/15] iecm: Add ethtool
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jrSPsAgATIVnCAABEsAIAACH4Q
Date:   Mon, 29 Jun 2020 22:07:18 +0000
Message-ID: <MW3PR11MB45227D181B30EF093C3345BF8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
        <20200626122742.20b47bb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MW3PR11MB45223CBE134055CC3A4EA3958F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
 <20200629143114.64fca33e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629143114.64fca33e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26b71ee4-46bd-47bc-120c-08d81c78ca78
x-ms-traffictypediagnostic: MWHPR11MB1967:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB19673566423A062EFBA56F548F6E0@MWHPR11MB1967.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6L+kU0a3sLC+lKMs4l6JxrJZsudqsJEpPg2/45upgWeAf3OIvLPVZSZ/yGZ8lKqshIArSf+AeR8AKU+A5SQlCoWFW+Bjeh/0siZG790OAC0z2NeU8hnbY2zdPvGiTOZYniPUYfAfAtLx7J5wNgugP0GYETISok/Om76fpKYZZtkMBCNO9ugW2wiCGPuQQmntsOOFxZfR3XKcLbL5ahl4fZau07INu6GmXI0W7lfDbFtbYf4Ar9K0LJRCZLyhRi06E5S/uBUE2sEHii3XqhcGSq+wve1Bd4Gq89YNCGpHOEfMt4BYrInvbYA/Js6Roysz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(33656002)(66446008)(316002)(66556008)(478600001)(76116006)(4326008)(66946007)(66476007)(2906002)(7696005)(64756008)(6916009)(55016002)(9686003)(107886003)(5660300002)(6506007)(8936002)(26005)(54906003)(52536014)(8676002)(186003)(86362001)(53546011)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UoV3/XmhDOZr7Qj9+TYnR/YJ9b74NN6TozyYrQLiC/uTdJxXW/e5mmoqpd099fNPrkfroat/bNpT6326znlInDAgV7Z0TncnlLYazNXaYHnzeRJhjXXV9qyIKvMb5Ymf0zhKlpcQTyYIOTPbPb1KSaoXmj83RHtIlVrK9/yOYTC7xp/3n/wSEffD/03UcEQqBwlNIosoKQPZxOb5ssQ5dqqHMruVeyAoNWt6eTlFaEwAc2YTrALJnfW8NOAUFASTpBf0QCDr7nwVO3i4nWljy1oO/wUrK7kADJ6B9R1W/Iu4dCNdEmbF3An4zi2CiJf0daS1rGqBIkMITCBc1Y36theDvwK+rR8XOPNUTnEiOD8DHo9DiTXpBtelisuI4pRz37ACx3+5dyqcSYo8n/PNtD0XVBUlZoDFXqtLbuE2ABPky1+xULczlY70BpqN5hYm3fOdV/EmGTDAxWqAW2SyKEZef9MyEQRUsbwY3f+T/L0VcQ7PVtaJ2Yfxffd3l1w5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b71ee4-46bd-47bc-120c-08d81c78ca78
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 22:07:19.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxZb3wX1dJjyE0zhbYZTtHv/+vM2njJPUwoPhjId3LNbUgL7h6+oA7tZxdNFMC5GdRHamJItXFS8P9Fa+Qq7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1967
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 29, 2020 2:31 PM
> To: Brady, Alan <alan.brady@intel.com>
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Burra, Phani R
> <phani.r.burra@intel.com>; Hay, Joshua A <joshua.a.hay@intel.com>; Chitti=
m,
> Madhu <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 13/15] iecm: Add ethtool
>=20
> On Mon, 29 Jun 2020 21:00:57 +0000 Brady, Alan wrote:
> > > > +/* Helper macro to define an iecm_stat structure with proper size =
and
> type.
> > > > + * Use this when defining constant statistics arrays. Note that
> > > > +@_type expects
> > > > + * only a type name and is used multiple times.
> > > > + */
> > > > +#define IECM_STAT(_type, _name, _stat) { \
> > > > +	.stat_string =3D _name, \
> > > > +	.sizeof_stat =3D sizeof_field(_type, _stat), \
> > > > +	.stat_offset =3D offsetof(_type, _stat) \ }
> > > > +
> > > > +/* Helper macro for defining some statistics related to queues */
> > > > +#define IECM_QUEUE_STAT(_name, _stat) \
> > > > +	IECM_STAT(struct iecm_queue, _name, _stat)
> > > > +
> > > > +/* Stats associated with a Tx queue */ static const struct
> > > > +iecm_stats iecm_gstrings_tx_queue_stats[] =3D {
> > > > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> > > > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes), };
> > > > +
> > > > +/* Stats associated with an Rx queue */ static const struct
> > > > +iecm_stats iecm_gstrings_rx_queue_stats[] =3D {
> > > > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> > > > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> > > > +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> > > > +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),
> > >
> > > What's basic and generic? perhaps given them the Linux names?
> >
> > I believe these should be hw_csum for basic_csum and csum_valid for
> generic_csum, will fix.
>=20
> I was thinking of just saying csum_complete and csum_unnecessary.
>=20
> But generic_sum doesn't seem to be incremented in this patch, so hard to =
tell
> what it is :S
>=20

csum_complete and csum_unnecessary works.  Sorry some of the checksum funct=
ionality didn't quite make the cut in time for the patch series but will ap=
pear in a future patch soon.   Thanks.

Alan
