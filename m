Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458CE20B7BC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFZR5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:57:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:24928 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgFZR5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:57:48 -0400
IronPort-SDR: Oefu6pMk884BixtCZHkIS34dwtbEaqkc6rEn85FaORjPuzdfTVQcqsZiK+VPs7SvxGNrfeVK3K
 3kI7e94oazsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="125071334"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="125071334"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:57:47 -0700
IronPort-SDR: 8j57Nv7/6jDkCtPtSOl7mS5Gqy5el6R1VE/0gwbM0pC4lz/RnI0/CyFf0LCW9lBpkVzmar+rP6
 zb7DL8zeZICg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="320068022"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jun 2020 10:57:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:57:46 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jun 2020 10:57:46 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jun 2020 10:57:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:57:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck3A/fga3321klhn6q5Gsbk/s6JC8Gau0vfhETspSIOnFZ+LvX/8VpMSmotlnC1zkeIYTdvbhi0mAWhkOirVzBDLeqRhr8ZIQlmyEU7L4KelEzceULeb+FOgsZcZMRNIsPWB73zDt3HIjTs5ZPNA6DrfzcYtee9Hli0Rosp+fljD/JEvH1hKsW3FPTnysrz/P9msU4rhURJHLrEAa83rcZjTBL0s3g71jZW1AIaqD1mU/jGOvQ+HCWEt3xZeTgWcCvkBqipnu6OK1+oX3gpg5Z6rFHzFXXdbq2ldJ5nrHAb5D60uariF0NA193RXkHzYDksuw6xJue524JmyyU0hSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksqqryGAUWmbG7NklovvlaAAucbgTTPVeY9KODlegIQ=;
 b=kjN1jzTgf5hZJ/OE6/ONqefggo25DHG1azngLZBUXv+HDiXbFsinkrJb1+6z0b4PmJKYM+zA9mTL4JxKM4kgcyEpW9D6SPjkT5Mznwxc8ID1WhyLvQ0a5FGNndf5fVji3xa7VHkBwXZMteU8WcDBe2BvCnKV2U8bpxajb3uP0UX8DB7tRIPiejTNhep7AqpV6tNxCenLv/DalDSTUOOtKyEHBSlamkWEKtDpeyiJ/rKAGeJW87vr9B+gkzTYGsu3U1fk1Pz0zMGkQ3+Zr7r5dgoVtnQT71+u6t5xIWRsPvVbrqpSwUViynw+urs6EB0k+xFk+lAStOT9duLcSGkMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksqqryGAUWmbG7NklovvlaAAucbgTTPVeY9KODlegIQ=;
 b=lL3CuZx7HOdZjDt0jCMjpB3rf2IP2RQSP9saYI8PFbQOQWf0TFtkN4XQAUNvu3wVsSQFjWOeKAnp0rzsYXwPIeH7fHnf0zpPSqHooRhq4QV4Ym8tdJUVKq8C4j3CAsvhuxj8wW2zcGxckKQNPX0yQ2/oPHrRcjYH2pE2jkNNkjs=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1870.namprd11.prod.outlook.com (2603:10b6:300:10f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 17:57:41 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.023; Fri, 26 Jun 2020
 17:57:41 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
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
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jqPT2AgADxfYA=
Date:   Fri, 26 Jun 2020 17:57:40 +0000
Message-ID: <MW3PR11MB45220BE4350A3279E009AB178F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
 <2b2a00cc0198328f1a0f3c9ccb6004a611a60011.camel@perches.com>
In-Reply-To: <2b2a00cc0198328f1a0f3c9ccb6004a611a60011.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de520ad1-67cb-4715-6e29-08d819fa6ba4
x-ms-traffictypediagnostic: MWHPR11MB1870:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB187074E7B889C51BFB72AC898F930@MWHPR11MB1870.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3ZSdNA5ZnGkg+DM4paNu89nVVgVwEULBEEoSA4oR1f+ygZ4DGwmI5NNcjDWRCK7P7oL3hYmMwNlzBHI849cxfNKW38Ma5WU1CGlMeUGAgK96oxi1oZfFj/No/RRb6qrNgitqyot6mWxDf9oWBhoZL8Wb/FumZPXrNMRAkb92LNP2f0NNIstKGnbfCWwB0+Ys+PfkrYje45Oij8gYnK9ysCWQhDLocdb80FpJLRKSNaJk+TtkhAUGRbxWBrIJ4p8p3JbApnk9WRm9s9YJ3vl2QS0v2k+M8F8zpuPlI6YGbPpn16xqyamJ+wXgB4/li4k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(66556008)(316002)(52536014)(5660300002)(8676002)(9686003)(66476007)(8936002)(55016002)(86362001)(76116006)(64756008)(107886003)(33656002)(54906003)(66446008)(26005)(66946007)(83380400001)(4326008)(186003)(478600001)(110136005)(2906002)(7696005)(6506007)(53546011)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cG/u9evFLsiSF+VeIwhjda5TpdAjm12xUnYUfnc4C1pSbxCg2KX4Ea8FbJlifHPsBbGaiTcs53sO5q+LuryRgBfF2fPXvDNgSrIEBj6O/en20L2Ct2E60RvRsaMrReNtgijbjXmFTGsY1g6W+JOiVAHCwX6gLcGpBt8ougBdN/ALvPxBeGBjV2vyex7J4UtDcAeO8ls2PngCWWr/3oeBvkUXIO/cD3p7maHP87Gwwmx2bQi5AOzk3+TE0UXQ+H0uhcBgAZnmB56QNYbXbh8J9Eu+7JwdTUT4hbZqx6bQpuEaJehUKi62o+cv+RUESNFbA4sENYDc6kL8Ec9tSsaWrKF2bvyPrcau9Sr/JXeVYPMc30LjhmXTBUHDT0WOnpCfWpvriXtX/7gJK61B7CWC1DC5DokAJZ6gmfty3puUOqy+pd5rLMZu1JeUmws7CAvcDGXGrJRjwpGdd0ljU9KYOpjikMTc7fm/vP+RcpmAFGClyT7Gjf+mYoIs7+oIh7AJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de520ad1-67cb-4715-6e29-08d819fa6ba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 17:57:40.9460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFiKoTh4JHwexQoGcIvfMxlYuSdBEcPKFWgjSk/+n7m5AYLkKNdC6OWE2hXO8yqVcTcVN8CV8lsopX0wvDTZRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1870
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 8:29 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 13/15] iecm: Add ethtool
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > Implement ethtool interface for the common module.
> []
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
> > b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
> []
> > +/* Stats associated with a Tx queue */ static const struct iecm_stats
> > +iecm_gstrings_tx_queue_stats[] =3D {
> > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes), };
> > +
> > +static const struct iecm_stats iecm_gstrings_rx_queue_stats[] =3D {
> > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> > +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> > +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),
> > +	IECM_QUEUE_STAT("%s-%u.csum_err", q_stats.rx.csum_err),
> > +	IECM_QUEUE_STAT("%s-%u.hsplit_buf_overflow",
> q_stats.rx.hsplit_hbo),
> > +};
> > +
> > +#define IECM_TX_QUEUE_STATS_LEN
> 	ARRAY_SIZE(iecm_gstrings_tx_queue_stats)
> > +#define IECM_RX_QUEUE_STATS_LEN
> 	ARRAY_SIZE(iecm_gstrings_rx_queue_stats)
> > +
> > +/**
> > + * __iecm_add_stat_strings - copy stat strings into ethtool buffer
> > + * @p: ethtool supplied buffer
> > + * @stats: stat definitions array
> > + * @size: size of the stats array
> > + *
> > + * Format and copy the strings described by stats into the buffer
> > +pointed at
> > + * by p.
> > + */
> > +static void __iecm_add_stat_strings(u8 **p, const struct iecm_stats st=
ats[],
> > +				    const unsigned int size, ...) {
> > +	unsigned int i;
> > +
> > +	for (i =3D 0; i < size; i++) {
> > +		va_list args;
> > +
> > +		va_start(args, size);
> > +		vsnprintf((char *)*p, ETH_GSTRING_LEN,
> > +			  stats[i].stat_string, args);
> > +		*p +=3D ETH_GSTRING_LEN;
> > +		va_end(args);
> > +	}
> > +}
>=20
> Slightly dangerous to have a possible mismatch between the varargs and th=
e
> actual constant format spec.
>=20
> Perhaps safer to use something like:
>=20
> static const struct iecm_stats iecm_gstrings_tx_queue_stats[] =3D {
> 	IECM_QUEUE_STAT("packets", q_stats.tx.packets),
> 	IECM_QUEUE_STAT("bytes", q_stats.tx.bytes), };
>=20
> Perhaps use const char * and unsigned int instead of varargs so this form=
ats the
> output without va_start/end
>=20
> 	snprintf(*p, ETH_GSTRING_LEN, "%s-%u.%s", type, index,
> stats[i].stat_string);
>=20

Agreed this could be better.  Will rework without varargs.

Alan
