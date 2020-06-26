Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48220B770
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgFZRjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:39:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:56377 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgFZRi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:38:59 -0400
IronPort-SDR: JaFx95yQtyShqp3QrRFkndWPdXtmr6GOHbcDy6+9BFClZ8EXiqu8mCBX2tJXDg51rlmr/bgOpa
 jrNGjkaZHF7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145484101"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="145484101"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:38:57 -0700
IronPort-SDR: 94+9ks1hvwBIWRJkZDQ/8M+7Rqu/aiOsKo9uO82o6JYJsFVxWedzQhc/K+UBqX0/E99n3CXA9d
 pSFvJXwkZ5Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="264264534"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga007.fm.intel.com with ESMTP; 26 Jun 2020 10:38:57 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:38:57 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jun 2020 10:38:56 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jun 2020 10:38:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 26 Jun 2020 10:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I88DSmmpbzl887mc6AvCQDVsMNH4pmMw3tZYB2N1QrYg6Jc+DyAyUPTs1XvhyODy3j00+DO/m2JS0BOCSxm0unV1eqZPeuT7J5lMfq4tuJQydOPcy75YB3FqjzvDlVeLpQ78hwadFFWWNRP9WZgypyC7JDwHBvWX2PwGk46Y3R6J57U5aiVCQo/YTahYdpI8zKmoz1XGjHyq6sXiOLpTxVc+CX1YCFjmUgr98R+D2mIuw5w550L5yty11OayZ10OPXnq6PM3x/50VqWgKRXlaIzlgJEpoq23DiUhl6hcBG0aZL3SVLfBPx4QNDE2KplCLIRsXDu1xsWItl8BmEUVuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HczmCSVU39SEA23FwQxVUyhCF9FMgAkZc1zNxCb1zuE=;
 b=JwF1MaQYL06Z+1eO8/fwkl5eCOwhZCGqGgYbhY4JGV5ShTbGAbvJ9p1NKW25i6VH+qUQyjzzglDelvwITn/CMtAwQveYl6h4L1cYGAl2VS0DbxN6gh7KSuYfRkpnI/EWyH9a11YJT/Jg/DvLZIwMpmUDJqVdwFsacz8rf1dFdABTRaRCp4yNrjsgV6a/wXPoS/9bBV22PZAWV4M2RVScG+58diELcDLycCmo491aq8DRYEBF3mZ76eFEFA/UX6O1Rt5fbEIrdKQKTpTs6XPu6XKDpP9LsybwxlzHUh82BzFmW0h86Y3VPIHUlrQqVS4G/01zH1aDi4qXN1qNS4mCBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HczmCSVU39SEA23FwQxVUyhCF9FMgAkZc1zNxCb1zuE=;
 b=hVjOc8Mww9jBgLNbhlVkkCrgOG/vcTpeHANOW9pbaFw0VJppEAp2fyzP8GPyVE7EFkZ63oJ9sWGF1unrggLox6qAZU9cqBHIJuhU5QU4vAupL1mZx92sIYeoQmkP392yaEn3FxGVCIYFLKnaCAEd683S0TtUczXFv5t1V08qXAE=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1648.namprd11.prod.outlook.com (2603:10b6:301:e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 17:38:54 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.023; Fri, 26 Jun 2020
 17:38:54 +0000
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
Subject: RE: [net-next v3 05/15] iecm: Add basic netdevice functionality
Thread-Topic: [net-next v3 05/15] iecm: Add basic netdevice functionality
Thread-Index: AQHWS16ZdZ1vBVhSZ02VDtWXOCPDEajqLyuAgAD6J0A=
Date:   Fri, 26 Jun 2020 17:38:53 +0000
Message-ID: <MW3PR11MB452247A68D61F34FE745358B8F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-6-jeffrey.t.kirsher@intel.com>
 <fbe69fcb9714123f36b6ed6d03873b0e47f23500.camel@perches.com>
In-Reply-To: <fbe69fcb9714123f36b6ed6d03873b0e47f23500.camel@perches.com>
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
x-ms-office365-filtering-correlation-id: db24f5c2-c7d6-43c4-b538-08d819f7cbf5
x-ms-traffictypediagnostic: MWHPR11MB1648:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB16482E4D5DD66BD1E6EEBE9F8F930@MWHPR11MB1648.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LjY3JPJtyY4jzQ8wT+p5J8Gp4pySWACi6LLgUzH/6udNrSGNWVU7KLfm8vulAZiEw6iwYlrFZwomskWUxMCeEbS7Fo8X2IDucitUH90lYre+sqvP988lIaLRbcr864HbP9ep4LDHJkXrABOMHHQmIvBfwyCYOxlgBlAp5WjKFVPtFbbLXVQyMvQGr33MPfHHfP3ziY3uN3Uv2vuy79pywSRSRxmhAe70mEMZDsuJet90T8S8qcuvB40E9Hr+pOkspEh8r25q2qBdnbcU3wcq1zRgna8hwjMs9rs2Ax8sah/QhLlt0uuCybMIqvOKitT/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(4326008)(33656002)(2906002)(478600001)(8936002)(7696005)(110136005)(54906003)(316002)(83380400001)(8676002)(53546011)(66556008)(5660300002)(55016002)(9686003)(66446008)(52536014)(71200400001)(107886003)(64756008)(86362001)(26005)(186003)(66476007)(76116006)(66946007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: b2s+onexNegj1IkEoQpIsTtAXDA9Hfmu3ssMmL2oLkTchg6CiM/+eaGxXxMqCmHo5j49y/Cuq7kBjyDhB2WyqUrHyanSQR6w6jRVgbUby7YRfaUOuYvYw7BbYYy9LcEmA+nP+lzcjTX3fNdMjA4OEtts/mGeMYDiqyfx/IDs/3NGydnTp/5xgC5nnxOgEeKccZDtazWioXb+AtZABwAS4k7LDZsM6batzQGi5JIgAuJLg47ZAXh5p70E55JiqYCGTyGbGBzcEWnRkvTGq2bwCbIY/lDI2+/YA/lZu41MZ9Hj/p18Or3N+cF+tacnWY2/8UCaRqWnCuBCkiSfRx/xjDt1l5yw68ecOe3Nr4wfdPn5mUgFSsK0zVUFPE1LXRMbipQzN3m+/Ap6GOrP+K9cOQzlbQO8DUGDLrHyEO8knKo5+xmQ/jcIP60IFcr4mBeIVDUk1oCPNmnesfAPwVNcdiAOdbzpwNc9Ek/BladqSL9KV8nCFfdhBlHyv8XCvVyX
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db24f5c2-c7d6-43c4-b538-08d819f7cbf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 17:38:54.0029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IBZkm3HCFbd8D7cx7gqcgODRLGe+SaqO1Z3aNnQx0LpBFsJtfRJ/jQvTZJG2TbbrLZ/PI23tK3170c8cmTm8vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1648
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 7:39 PM
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
> Subject: Re: [net-next v3 05/15] iecm: Add basic netdevice functionality
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > This implements probe, interface up/down, and netdev_ops.
>=20
> trivial notes:
>=20
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> []
> > @@ -194,7 +298,24 @@ static int iecm_vport_rel(struct iecm_vport *vport=
)
> >   */
> >  static void iecm_vport_rel_all(struct iecm_adapter *adapter)  {
> > -	/* stub */
> > +	int err, i;
> > +
> > +	if (!adapter->vports)
> > +		return;
> > +
> > +	for (i =3D 0; i < adapter->num_alloc_vport; i++) {
> > +		if (!adapter->vports[i])
> > +			continue;
> > +
> > +		err =3D iecm_vport_rel(adapter->vports[i]);
> > +		if (err)
> > +			dev_dbg(&adapter->pdev->dev,
> > +				"Failed to release adapter->vport[%d], err
> %d,\n",
>=20
> odd comma

Will fix.

>=20
> > +				i, err);
> > +		else
> > +			adapter->vports[i] =3D NULL;
> > +	}
> > +	adapter->num_alloc_vport =3D 0;
>=20
> If one of these fails to release, why always set num_alloc_vport to 0?
>=20

Basically because if the other side fails to release a vport for us, there'=
s not much the driver can do.  After some internal discussion, we think it'=
s better to change iecm_vport_rel to return void and report any issues in t=
hat function (we should still report in dmesg something appears to have gon=
e wrong).  This function will otherwise assume it succeeded since there's n=
ot much the driver can do if it fails anyway.

> > @@ -273,7 +483,40 @@ static void iecm_init_task(struct work_struct *wor=
k)
> >   */
> >  static int iecm_api_init(struct iecm_adapter *adapter)  {
> > -	/* stub */
> > +	struct iecm_reg_ops *reg_ops =3D &adapter->dev_ops.reg_ops;
> > +	struct pci_dev *pdev =3D adapter->pdev;
> > +
> > +	if (!adapter->dev_ops.reg_ops_init) {
> > +		dev_err(&pdev->dev, "Invalid device, register API init not
> > +defined.\n");
>=20
> inconsistent uses of periods after logging messages.
>=20

Good catch, will fix.

> > +		return -EINVAL;
> > +	}
> > +	adapter->dev_ops.reg_ops_init(adapter);
> > +	if (!(reg_ops->ctlq_reg_init && reg_ops->vportq_reg_init &&
> > +	      reg_ops->intr_reg_init && reg_ops->mb_intr_reg_init &&
> > +	      reg_ops->reset_reg_init && reg_ops->trigger_reset)) {
> > +		dev_err(&pdev->dev, "Invalid device, missing one or more
> register
> > +functions\n");
>=20
> Most are without period.

Yes agreed, will remove ones with periods.

>=20
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (adapter->dev_ops.vc_ops_init) {
> > +		struct iecm_virtchnl_ops *vc_ops;
> > +
> > +		adapter->dev_ops.vc_ops_init(adapter);
> > +		vc_ops =3D &adapter->dev_ops.vc_ops;
> > +		if (!(vc_ops->core_init && vc_ops->vport_init &&
> > +		      vc_ops->vport_queue_ids_init && vc_ops->get_caps &&
> > +		      vc_ops->config_queues && vc_ops->enable_queues &&
> > +		      vc_ops->disable_queues && vc_ops->irq_map_unmap &&
> > +		      vc_ops->get_set_rss_lut && vc_ops->get_set_rss_hash &&
> > +		      vc_ops->adjust_qs && vc_ops->get_ptype)) {
>=20
> style trivia:
>=20
> Sometimes it's clearer for human readers if all the tests are separated o=
n
> individual lines.
>=20

Agreed, will fix.

> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
> > b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
> []
> > @@ -594,6 +642,25 @@ static bool iecm_is_capability_ena(struct
> iecm_adapter *adapter, u64 flag)
> >   */
> >  void iecm_vc_ops_init(struct iecm_adapter *adapter)  {
> > -	/* stub */
>=20
> Maybe add a temporary for adapter->dev_ops.vc_ops to reduce visual clutte=
r?
>=20
> > +	adapter->dev_ops.vc_ops.core_init =3D iecm_vc_core_init;
> > +	adapter->dev_ops.vc_ops.vport_init =3D iecm_vport_init;
> > +	adapter->dev_ops.vc_ops.vport_queue_ids_init =3D
> > +		iecm_vport_queue_ids_init;
> > +	adapter->dev_ops.vc_ops.get_caps =3D iecm_send_get_caps_msg;
> > +	adapter->dev_ops.vc_ops.is_cap_ena =3D iecm_is_capability_ena;


Not opposed to this one either, will fix.

Alan
