Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8B22A3CF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbgGWAoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:44:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:63070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733150AbgGWAoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:44:18 -0400
IronPort-SDR: u8C8sMsuwVjerDkXzMzfW10DmX6Ae8NzQZtlzIQdZ/V2v0FhtXPGeq2qQR1pzCes/gouTAUv0y
 YDW8+35QdGRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="130005696"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="130005696"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:44:15 -0700
IronPort-SDR: QM+OOW9I1LOdBQZNkkUvqWV1EPVNugcKoljzxeH4z6nuhVTq7n2uSOFust+CL3djDbajXdnyGC
 cmo39xTiu+ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="326855983"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jul 2020 17:44:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:44:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Jul 2020 17:44:14 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 Jul 2020 17:44:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 22 Jul 2020 17:44:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgkAb9l9J+1KOMHxCwNMAeRGuiGt98k2BNALPNZV1z6Xg0CCTJyACcCWHUOZXTZ7EFCIglFnsmhMNkwX/B/n66x6coVD+L2q3SNQ2zRtgLpzS891q8tt0UV/PAy+pGP/gCGBGK/HonaGWhVdnRuOg6j5oukVvzbTcEaRhwdZZYpPIcIt32YhzAygbSCuEwwu0U8NbmZlLfaXPgS8YcEah3WRL4Jcnn/qslk7B+6GTK9FUeU6A7HcCrR+L4o4FuSK0osyC0AglzmOyWW+SHk1rzk3sI+oCT6ZKoHMJLULbyFnD5ltPUaqf28Yghty8VSchEWksiz4ibX6J036igDISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6/Ogo4u7ypnujk21NqYZC8Jwv2/TkK+9NWFZBZI02o=;
 b=NXF9+NqFgyS8XKTELQGChrI4xZFFgDSe/rDjhWQfkxdrvyICjD6g+CYOMskdyCkAnOe4/NpMDaCFKL2EoDQckt+0YNLihgdXDn2NEu2zPt10hOHqs+OwaW00P5eNW8wff6PnHy4QdYcV8rxuMxxhWMBbFhNaf6nlAEmmdjwjmHNQP21OmnBdmC9aauxMdjB05EF3Wr3n5dAE2aW6U986gIi9SoUq+Dv6xXuPzDgR1d2pqwuW1FTFK1pu0995GMsEIPWtxXhZJ+dbLGgsGwI8GVMHMUeWurpAEJvzGvHYJNYzcWfSrZvtGUBqBpReApms50BpyMgyv4S8IC9nkjAxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6/Ogo4u7ypnujk21NqYZC8Jwv2/TkK+9NWFZBZI02o=;
 b=PMkVW7abH5elXBl4YyN/eJXTEkmoSft6647inhrldDo7SwgcB5ROio8av7WI/hGrROof0x2b9vYMC8TodW7hryhxHIgTeIoW9bpvCHYBKaK/1k4ZgU+HPy+OevGmw0dPeH5/Ar8H33McVV+xl6Dpf5wqwQ9swM5ADw2bTVMJdJg=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 23 Jul
 2020 00:44:09 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:44:09 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v4 06/15] iecm: Implement mailbox functionality
Thread-Topic: [net-next v4 06/15] iecm: Implement mailbox functionality
Thread-Index: AQHWXvdUsd8ZG91aOkup8VGE9K7Tj6kSXHCAgAH6GxA=
Date:   Thu, 23 Jul 2020 00:44:08 +0000
Message-ID: <MW3PR11MB452221AF72D15667AEE82A088F760@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
 <20200721113145.43c24155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721113145.43c24155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: f3e0d07d-3bcc-47d0-a776-08d82ea182ca
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4748334C6BB587186C17B0898F760@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BJaDdjDPK8ywhd6Oc7NcedemnCt921pQ85E/yf/JRW0acVEfajF8pJIIbjaZ//3rGb8BCpUGrlWDP/eIQSMdQqrUCrvKk2qyttqq+hkvOwaKHmktcFsmiw0Wk6aoGCzvbMiQsRuMri7/K2gK4lvfQmPEeN9tVVpC9F3qUr+xtkdbwKwbeRNjc47nMvu0+4HD+RKdg0J35F/PchV3R7QVoe37OPbBHTyEpRuVNCNzUKlBZNuMf8+g8+sPkImT8dUevTd7hNmnaTyx8sSV3uD6MNTsNYs1m5fvQbiysfq965hzJ9GSyhz3/QUBuflzYCi0gfLKf/MExvXyGk6Z2VFuzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(107886003)(54906003)(33656002)(26005)(316002)(110136005)(71200400001)(8936002)(86362001)(2906002)(5660300002)(4326008)(66446008)(66556008)(64756008)(7696005)(52536014)(478600001)(55016002)(6636002)(9686003)(8676002)(186003)(76116006)(66946007)(83380400001)(66476007)(6506007)(15650500001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hBMWR32fZL/wXo8/FpgBL9lVO0ZT3AUoWqoq96oo975vyqTBoRiHdjtCrXl5dq6biHrDwkv8db6w6YjsxfEQg00m4ptQY/5utWTtvxUmBSiQcWSeSGVuUzmxg8swywB/rrYNUa0QyWxjc8BZlrFp8+L33h73L/befn8DWe46hdqezUZyMRJoz17aoZzrxhJD9CGDritk5nQ73Rz5eJ+faDerQHC/8DenRDhITHBBqdxq9/W9lrRxqKN/Jcl/g7bCr03HdQ3P9jorrlvEWdmO/6urmQFW+msHFnqwM9On3kxpE3mVvyBk/8ivBU57LbMcJQ14oRk7T7sxbEtJd87nlkIoLpGWmCFxVeLBUASfAuAnI/ergm1pq5fKjxfR5TSDBf6rR1Rm4hThPPlqfkN9Vld4rKxVVKH9olB6TsS5AvVOUGSiM8JdKSTW+s8cLwAZmIeMsqYhxiSDXrWINWMNYQYh1AFbuB2JAevNn2+XyEPFsbP5YZeyOxugj7bpEPNF
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e0d07d-3bcc-47d0-a776-08d82ea182ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:44:09.0154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EdNOxEgj46LaYV1kXDwss7/e7ps22UX9Zi/UEfTAzZRMu6GWcLSTBpkS8PqkVUC5ySSESCTNFdNPXLwHjz4iJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 21, 2020 11:32 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v4 06/15] iecm: Implement mailbox functionality
>=20
> On Mon, 20 Jul 2020 17:38:01 -0700 Tony Nguyen wrote:
> > +	struct iecm_adapter *adapter =3D vport->adapter;
> > +	netdev_features_t dflt_features;
> > +	netdev_features_t offloads =3D 0;
> > +	struct iecm_netdev_priv *np;
> > +	struct net_device *netdev;
> > +	int err;
> > +
> > +	netdev =3D alloc_etherdev_mqs(sizeof(struct iecm_netdev_priv),
> > +				    IECM_MAX_Q, IECM_MAX_Q);
> > +	if (!netdev)
> > +		return -ENOMEM;
> > +	vport->netdev =3D netdev;
> > +	np =3D netdev_priv(netdev);
> > +	np->vport =3D vport;
>=20
> > +	/* register last */
> > +	err =3D register_netdev(netdev);
> > +	if (err)
> > +		return err;
>=20
> aren't you leaking the netdev here?

Certainly yes.  Will fix.

Alan
