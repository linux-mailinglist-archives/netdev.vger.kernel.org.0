Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BFA20E232
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388424AbgF2VDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:03:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:7978 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731395AbgF2VDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 17:03:04 -0400
IronPort-SDR: HjlG374nqcrmMrc/+9dru48ophdbcLy8wasxOVmhIWwXOjpwPv3bFzLtjTZm57zI627qn7k1+n
 19FYCsyz2TWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="126208247"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="126208247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 14:01:01 -0700
IronPort-SDR: 2t+QWzjKb1x/dAHypGceBOi5/8Hcw3sugXnsxRuxLGQlPhZZQnNJ0OnOIxT4iKH/0pkInY9iWz
 fWEBIBCIOaFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="319506703"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga007.jf.intel.com with ESMTP; 29 Jun 2020 14:01:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 14:01:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 14:01:00 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 14:01:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 14:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAOt4cmjfSXiSeyr8API9ijMFqS/OaJ6Rkiq9y1/+ba+E4sXnBTdvf0OZr2zmIDN9RbZ1vBnpu4YhmrHgmrR65GFo3TlpyuTxAutVOuGGPV6RWIHo+d7jcAhy0mjajHAw9JQ3oQixnZdqoSJO+gD2XxhG5AeTsa7AC8PZLgsJHJG6TUzD+ss9BWM3f5Y4WBqlEuzRuIMop5WWW35dreMFviVpDxOPhNjYcgtwVp5xvKGMinhP7Wf1L9s2nimR9Mn0EBx718PvS9lwf09rc9/OwTrctLUWnCfGzNTe66ffbEw0vaIuaaTZOp623VsQQcB/ClUwAMA8QFGj0Nvs8CKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6W6edo68k9SKHumnGfR4Gf8CfPWni+5/AkXQ/oH3BE=;
 b=AV5dLgU5wvGuhyablZroQRGl3ai4eaYzWvrNLv+ZG+Ma6rIhfaXsCa9ZhINiR5Zr8JrWMNcrzRJmXX1B0vVRd1GgJZT4cGLe/iq40VlYMqOjfY8LT+DMdtuFa7FJHjuzP9RPIKIZea8Pw/dvGCr7Gg2YKfH/ys2t2ix8kuFNypOed1w28WnjD1vevHmxxLJhZsrwKwOfEU9I+hHhnETDKMZwBJVNF9x/KHTKJoIU8RroQYpccNZthRK0vip/gDYQKposYadNgLRycL2+YQntcCvKMUxfEh/7VwbNbBVDc09a/wGRHIOYtlqD5xtn5NR/yw0JJLyiQrNYLVhYu9j9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6W6edo68k9SKHumnGfR4Gf8CfPWni+5/AkXQ/oH3BE=;
 b=voiU3Tu6tR3rxQbiBEMkbY8ogS0HdHilnfIDwuYUn3z7BDkGFw7MF6qMK6MacKfzrTmkLXd+wTFI8oTMV/i7BNVWsOfmal0ZY2ABh6VeH4Y7V/f0P9H4TFZP/r4Ru6bWK7BGNW8rzynBzcBEHXLNog5dFY1YO2S5TAhR2WarQco=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (10.141.72.72) by
 MWHPR11MB1248.namprd11.prod.outlook.com (10.169.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.23; Mon, 29 Jun 2020 21:00:57 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 21:00:57 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jrSPsAgATIVnA=
Date:   Mon, 29 Jun 2020 21:00:57 +0000
Message-ID: <MW3PR11MB45223CBE134055CC3A4EA3958F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
 <20200626122742.20b47bb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626122742.20b47bb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 8a002389-0c38-480a-ca6f-08d81c6f857d
x-ms-traffictypediagnostic: MWHPR11MB1248:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB124899CCF1FF083830A587D98F6E0@MWHPR11MB1248.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:187;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: URWTpxgNQuOvhvKG69qjTFLKyfbOv6M/Al4gQQ4qhu3IJWt8yG30Nrwbx4Z59nvCI5LrzEopSldp88o6Pbv+y+u5T/IPZYCBY/SH+lkppti1XHpXg9C3c7FVOIhEC9tMm8k0sLZw24bCAMkDIi+7hV/UDUwzQqguXObHeDXzsn+WBoHBqLr+oWZ6ChZB76cL2bJyybtq7dkMMKsUJdkvt1twfZixbuauVEwtTtQoZ99R30JJ5/Txi9qQHARMIOKD8FG99CtM9rAXupJ92qe/M15iuTKx/GlYRdFKGuN3kQ2+zZ8pP7fK6u1860PYVhMw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(55016002)(316002)(26005)(8676002)(53546011)(83380400001)(7696005)(478600001)(6506007)(66446008)(4326008)(71200400001)(186003)(9686003)(76116006)(33656002)(6636002)(2906002)(64756008)(52536014)(107886003)(54906003)(8936002)(110136005)(66556008)(66946007)(5660300002)(86362001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2LgSm75MkuFU/B1sQ+x37I9E1v+wLQ45MZyqUkYnuJG7CF6VPEwZ6qlMoSGKITjHpJDhtEcjYwl+xP2M0q/g5G5dxF/LXfKMLibu4OK5TvJHoL8mS/mFmSTEv9aQzgJ2fRIprBWfaMJ21RoJR46zYzH7JtznLiijLBaVgxjKJwO/evTJKnX3zbtVTM73lZGnZBC+qwNIoEUOLs0pe2rbDbE2jJme1Faf1bkArpLlJ6DG5ksoicImMa4hciAlBdmxtQMDUu/FvRTzDk8OJbO8CbOfi+GYi6KJNZLm+CzQYPe921irNsszTNBv8iSLAV1C2NGwi5lIzNqRc5Uqiw8tCJsF+TDnYYD3J7PUBTKhoZei0fyT8Pe1ei5zjOTB2vB6gHtV5peCm8MRkOFbXf1qpPpPRwf51T3ruhX+3FJCjgbxYAQSPpO3FYA5NM1xpzAsBDuUaJBbPfbPf2Pl/PcF+P5tkqP5/ALruIzBqnb1oJP9Wp9EnTStmm17kWQX/dd8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a002389-0c38-480a-ca6f-08d81c6f857d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 21:00:57.8032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RWWSNyB9qAjUPDErfdO8Vt5DbsFTaWeplaKJS4/djkIByuUP912qsRzt/kj1ZxN5X/xkrqPjgUTps8nJn1yxZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1248
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:28 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 13/15] iecm: Add ethtool
>=20
> On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > Implement ethtool interface for the common module.
> >
> > Signed-off-by: Alice Michael <alice.michael@intel.com>
> > Signed-off-by: Alan Brady <alan.brady@intel.com>
> > Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> > Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> > Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> > Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>=20
>=20
> > +/* Helper macro to define an iecm_stat structure with proper size and =
type.
> > + * Use this when defining constant statistics arrays. Note that
> > +@_type expects
> > + * only a type name and is used multiple times.
> > + */
> > +#define IECM_STAT(_type, _name, _stat) { \
> > +	.stat_string =3D _name, \
> > +	.sizeof_stat =3D sizeof_field(_type, _stat), \
> > +	.stat_offset =3D offsetof(_type, _stat) \ }
> > +
> > +/* Helper macro for defining some statistics related to queues */
> > +#define IECM_QUEUE_STAT(_name, _stat) \
> > +	IECM_STAT(struct iecm_queue, _name, _stat)
> > +
> > +/* Stats associated with a Tx queue */ static const struct iecm_stats
> > +iecm_gstrings_tx_queue_stats[] =3D {
> > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes), };
> > +
> > +/* Stats associated with an Rx queue */ static const struct
> > +iecm_stats iecm_gstrings_rx_queue_stats[] =3D {
> > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> > +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> > +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),
>=20
> What's basic and generic? perhaps given them the Linux names?

I believe these should be hw_csum for basic_csum and csum_valid for generic=
_csum, will fix.

>=20
> > +	IECM_QUEUE_STAT("%s-%u.csum_err", q_stats.rx.csum_err),
> > +	IECM_QUEUE_STAT("%s-%u.hsplit_buf_overflow",
> q_stats.rx.hsplit_hbo),
> > +};
>=20
> > +/**
> > + * __iecm_set_q_coalesce - set ITR values for specific queue
> > + * @ec: ethtool structure from user to update ITR settings
> > + * @q: queue for which ITR values has to be set
> > + *
> > + * Returns 0 on success, negative otherwise.
> > + */
> > +static int
> > +__iecm_set_q_coalesce(struct ethtool_coalesce *ec, struct iecm_queue
> > +*q) {
> > +	const char *q_type_str =3D (q->q_type =3D=3D VIRTCHNL_QUEUE_TYPE_RX)
> > +				  ? "Rx" : "Tx";
> > +	u32 use_adaptive_coalesce, coalesce_usecs;
> > +	struct iecm_vport *vport;
> > +	u16 itr_setting;
> > +
> > +	itr_setting =3D IECM_ITR_SETTING(q->itr.target_itr);
> > +	vport =3D q->vport;
> > +	if (q->q_type =3D=3D VIRTCHNL_QUEUE_TYPE_RX) {
> > +		use_adaptive_coalesce =3D ec->use_adaptive_rx_coalesce;
> > +		coalesce_usecs =3D ec->rx_coalesce_usecs;
> > +	} else {
> > +		use_adaptive_coalesce =3D ec->use_adaptive_tx_coalesce;
> > +		coalesce_usecs =3D ec->tx_coalesce_usecs;
> > +	}
> > +
> > +	if (itr_setting !=3D coalesce_usecs && use_adaptive_coalesce) {
> > +		netdev_info(vport->netdev, "%s ITR cannot be changed if
> adaptive-%s is enabled\n",
> > +			    q_type_str, q_type_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (coalesce_usecs > IECM_ITR_MAX) {
> > +		netdev_info(vport->netdev,
> > +			    "Invalid value, %d-usecs range is 0-%d\n",
> > +			    coalesce_usecs, IECM_ITR_MAX);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* hardware only supports an ITR granularity of 2us */
> > +	if (coalesce_usecs % 2 !=3D 0) {
> > +		netdev_info(vport->netdev,
> > +			    "Invalid value, %d-usecs must be even\n",
> > +			    coalesce_usecs);
> > +		return -EINVAL;
> > +	}
>=20
> Most drivers just round things up or down, but up to you.

We should round this, will fix.

>=20
> > +	q->itr.target_itr =3D coalesce_usecs;
> > +	if (use_adaptive_coalesce)
> > +		q->itr.target_itr |=3D IECM_ITR_DYNAMIC;
> > +	/* Update of static/dynamic ITR will be taken care when interrupt is
> > +	 * fired
> > +	 */
> > +	return 0;
> > +}
> > +
> > +/**
> > + * iecm_set_q_coalesce - set ITR values for specific queue
> > + * @vport: vport associated to the queue that need updating
> > + * @ec: coalesce settings to program the device with
> > + * @q_num: update ITR/INTRL (coalesce) settings for this queue
> > +number/index
> > + * @is_rxq: is queue type Rx
> > + *
> > + * Return 0 on success, and negative on failure  */ static int
> > +iecm_set_q_coalesce(struct iecm_vport *vport, struct ethtool_coalesce =
*ec,
> > +		    int q_num, bool is_rxq)
> > +{
> > +	if (is_rxq) {
> > +		struct iecm_queue *rxq =3D iecm_find_rxq(vport, q_num);
> > +
> > +		if (rxq && __iecm_set_q_coalesce(ec, rxq))
> > +			return -EINVAL;
> > +	} else {
> > +		struct iecm_queue *txq =3D iecm_find_txq(vport, q_num);
> > +
> > +		if (txq && __iecm_set_q_coalesce(ec, txq))
> > +			return -EINVAL;
> > +	}
>=20
> What's the point? Callers always call this function with tx, then rx.
> Just set both.

As I understand it's possible to have a different number of TX and RX queue=
s.  Theoretically iecm_find_Xq will just return NULL if there's no queue fo=
r some index so we could do both, but then we have to figure which one is g=
reater etc etc.  It seems less error prone and clearer to me to just call i=
t for the queues we need to.  We can make this iecm_set_q_coalesce function=
 a little less terse, perhaps that is sufficient?

>=20
> > +	return 0;
> > +}
> > +
> > +/**
> > + * iecm_set_coalesce - set ITR values as requested by user
> > + * @netdev: pointer to the netdev associated with this query
> > + * @ec: coalesce settings to program the device with
> > + *
> > + * Return 0 on success, and negative on failure  */ static int
> > +iecm_set_coalesce(struct net_device *netdev, struct ethtool_coalesce
> > +*ec) {
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	int i, err =3D 0;
> > +
> > +	if (vport->adapter->state !=3D __IECM_UP)
> > +		return 0;
> > +
> > +	for (i =3D 0; i < vport->num_txq; i++) {
> > +		err =3D iecm_set_q_coalesce(vport, ec, i, false);
> > +		if (err)
> > +			goto set_coalesce_err;
> > +	}
> > +
> > +	for (i =3D 0; i < vport->num_rxq; i++) {
> > +		err =3D iecm_set_q_coalesce(vport, ec, i, true);
> > +		if (err)
> > +			goto set_coalesce_err;
> > +	}
> > +set_coalesce_err:
>=20
> label is unnecessary, just return

Will fix.

>=20
> > +	return err;
> > +}
> > +
> > +/**
> > + * iecm_set_per_q_coalesce - set ITR values as requested by user
> > + * @netdev: pointer to the netdev associated with this query
> > + * @q_num: queue for which the ITR values has to be set
> > + * @ec: coalesce settings to program the device with
> > + *
> > + * Return 0 on success, and negative on failure  */ static int
> > +iecm_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
> > +			struct ethtool_coalesce *ec)
> > +{
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	int err;
> > +
> > +	if (vport->adapter->state !=3D __IECM_UP)
> > +		return 0;
> > +
> > +	err =3D iecm_set_q_coalesce(vport, ec, q_num, false);
> > +	if (!err)
> > +		err =3D iecm_set_q_coalesce(vport, ec, q_num, true);
> > +
> > +	return err;
> > +}
>=20
> > +/**
> > + * iecm_get_link_ksettings - Get Link Speed and Duplex settings
> > + * @netdev: network interface device structure
> > + * @cmd: ethtool command
> > + *
> > + * Reports speed/duplex settings.
> > + **/
> > +static int iecm_get_link_ksettings(struct net_device *netdev,
> > +				   struct ethtool_link_ksettings *cmd) {
> > +	struct iecm_netdev_priv *np =3D netdev_priv(netdev);
> > +	struct iecm_adapter *adapter =3D np->vport->adapter;
> > +
> > +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> > +	cmd->base.autoneg =3D AUTONEG_DISABLE;
> > +	cmd->base.port =3D PORT_NONE;
> > +	/* Set speed and duplex */
> > +	switch (adapter->link_speed) {
> > +	case VIRTCHNL_LINK_SPEED_40GB:
> > +		cmd->base.speed =3D SPEED_40000;
> > +		break;
> > +	case VIRTCHNL_LINK_SPEED_25GB:
> > +#ifdef SPEED_25000
> > +		cmd->base.speed =3D SPEED_25000;
> > +#else
> > +		netdev_info(netdev,
> > +			    "Speed is 25G, display not supported by this version
> of
> > +ethtool.\n"); #endif
>=20
> Maybe drop the Intel review tags from this.
>=20
> Clearly nobody looked at this patch :/

Will fix.

>=20
> > +		break;
> > +	case VIRTCHNL_LINK_SPEED_20GB:
> > +		cmd->base.speed =3D SPEED_20000;
> > +		break;
> > +	case VIRTCHNL_LINK_SPEED_10GB:
> > +		cmd->base.speed =3D SPEED_10000;
> > +		break;
> > +	case VIRTCHNL_LINK_SPEED_1GB:
> > +		cmd->base.speed =3D SPEED_1000;
> > +		break;
> > +	case VIRTCHNL_LINK_SPEED_100MB:
> > +		cmd->base.speed =3D SPEED_100;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	cmd->base.duplex =3D DUPLEX_FULL;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * iecm_get_drvinfo - Get driver info
> > + * @netdev: network interface device structure
> > + * @drvinfo: ethtool driver info structure
> > + *
> > + * Returns information about the driver and device for display to the =
user.
> > + */
> > +static void iecm_get_drvinfo(struct net_device *netdev,
> > +			     struct ethtool_drvinfo *drvinfo) {
> > +	struct iecm_adapter *adapter =3D iecm_netdev_to_adapter(netdev);
> > +
> > +	strlcpy(drvinfo->driver, iecm_drv_name, 32);
> > +	strlcpy(drvinfo->fw_version, "N/A", 4);
>=20
> Then don't report it.
>=20
> The other two pieces of information are filled in by the core if the call=
back is not
> set, so you can skip implementing this altogether.
>=20
> > +	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32); }

Understood, will remove ethtool callback, thanks.

Alan
