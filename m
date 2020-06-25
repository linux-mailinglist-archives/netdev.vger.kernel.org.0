Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A320A4F9
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406282AbgFYS1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:27:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:7607 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404270AbgFYS1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 14:27:40 -0400
IronPort-SDR: eRG7cfdEjLDTOwnPmQYQ6motNlMdhoLJBgo/EpJOm+MPyZz/75VmhP21ce6Eq2NJyvUbAZY73x
 qQYwCtkFaqbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="143258532"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="143258532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 11:27:37 -0700
IronPort-SDR: bRDgu9LGDb6P57DY5mzRPfDh53rCgUSWMIYrXzSsQC9+voIyYk9rvbq3X5B5zUyYXV1ifP+2BY
 yUCQHbUlkZUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="276115053"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga003.jf.intel.com with ESMTP; 25 Jun 2020 11:27:37 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 11:27:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jun 2020 11:27:35 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jun 2020 11:27:35 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 25 Jun 2020 11:27:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKD6U/lpn7HAWG7IPDqgdpLEMSqBOuOFh5dOcFBv2LPf8W2kn+NIyAjCMvl2oC95vO5jx26lA/35cFMSBa3FMc0xHM3ONpk5qL25TGgUiDw43ewIjGtdn/6gtjx7XLOFs201pANo2HBRP85PbSnm5nrOBMpTY7QztrtfGNsDJLacoOxkSy+Uyx5R+gCi0W3MZ9M7Wf7w8UjGKx1J+Bd8lrTjdPxYFpZrVTgy2Y1mSoWXQU7NoDTJMrePHZ+epzS98lpcgKZIT0k+tcfSf2i2YHTg2vg/XzFXqE0vtm1ohmdhnLvz+SYIG0awtWSxNCS1h63LWWvW6otuU06HlWgE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvkzO/U6lA1BU+nZeRCTa9NH0DcT2KkiDYJLW6pgHNM=;
 b=XbyRl8Dq4+JnO+/ms76j11O+QKEy6UvSUXwVCaDzw78eQaipBdII9+fmtwphdmdp0QLxYjXqtKd3K5haCKZ+XMHNiC9eYCIJDCQJxYEVSh6jVV5oUO7hDhhQ6IEMU4W2Lb7bNRxXXdYuD753a0NtCctMb9vhxyPr2KrcOGVy3e04yh9bP0R1wHaY7MgdAr+ksRHGOu4XUNWyudvkubSap6ctFdFw21/f9ZW8EdTI15QvkoruygLZXQV+Upwu7VXOWQFsDNftyVySrWFBH6WYtcP0xNtiDhF++Bov3Innl8hh78+4JnnRtb/AMooepkMKIq5s8JymY6pT16et5YBi+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvkzO/U6lA1BU+nZeRCTa9NH0DcT2KkiDYJLW6pgHNM=;
 b=wYXCSLrjVT2k08W0RT68n618ShddZhTJfej2ikhTlD4jMFJSPOUM9bFSEV632oEpd8A6C9sTcpgdhxda56u/ICt9UO9tIJLaZa8bg2T8Ei/iKyA6lLFaxdPGpwsQj1DM85P5baY7umU/0gNBDjDAZ2r9cJB1bRf3E4Q0UtQt2Js=
Received: from BY5PR11MB3958.namprd11.prod.outlook.com (2603:10b6:a03:18e::19)
 by BYAPR11MB2871.namprd11.prod.outlook.com (2603:10b6:a02:c5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 18:11:37 +0000
Received: from BY5PR11MB3958.namprd11.prod.outlook.com
 ([fe80::fc92:5433:47bb:8961]) by BY5PR11MB3958.namprd11.prod.outlook.com
 ([fe80::fc92:5433:47bb:8961%3]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 18:11:37 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Wan, Kaike" <kaike.wan@intel.com>,
        "Dan Carpenter (dan.carpenter@oracle.com)" <dan.carpenter@oracle.com>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH for-rc 1/2] IB/hfi1: Restore kfree in dummy_netdev cleanup
Thread-Topic: [PATCH for-rc 1/2] IB/hfi1: Restore kfree in dummy_netdev
 cleanup
Thread-Index: AQHWSZ1ucAv91Kh70EuPD7g4d/RKs6joHlQAgAFpZwA=
Date:   Thu, 25 Jun 2020 18:11:36 +0000
Message-ID: <BY5PR11MB3958E9C1B56B55741BA95B6986920@BY5PR11MB3958.namprd11.prod.outlook.com>
References: <20200623202519.106975.94246.stgit@awfm-01.aw.intel.com>
 <20200623203224.106975.16926.stgit@awfm-01.aw.intel.com>
 <20200624185342.GM6578@ziepe.ca>
In-Reply-To: <20200624185342.GM6578@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfa60e7f-beb0-411a-36ae-08d819333373
x-ms-traffictypediagnostic: BYAPR11MB2871:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2871BAE909A959E718E3950E86920@BYAPR11MB2871.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HDMR8yJz3v3UIXpGJ4Nj33Ruzj8U33h04hku8v71P1cLaKuH0JDYge/YMZXmz5iUcxP3owA0+dqiozFFgelHqyT4DPtCfNK8fTE7Fl2aHJ0RTzMRcFIXBVVek2BrQVT1R04i1cGOUbX4flwANVFJAta3H6mzUwa3aEww2oT+3XaKdfboxQXH/U9u+XH9FVYYdUPjdZZn/IFZ3f4cAcTSRhD4ts7bz8ArXuh05246LmRmYmEye25++NdQ1Suj5K46Z/1ABGEUFeUC3okGVRBRBRH0i/T24sdM43Su2DDRjaivXzJyJD8k/icUG3Xewf4NJ+SzEnbdmnoUpQrERsQTEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(33656002)(9686003)(54906003)(316002)(52536014)(66476007)(86362001)(6916009)(55016002)(5660300002)(8676002)(76116006)(8936002)(26005)(66946007)(66446008)(71200400001)(64756008)(2906002)(186003)(66556008)(4326008)(6506007)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aMegVjIaOtYAdDAdtrSOQWKIZ/KKib1Tykk4pi5bxYTTYZS1fguSqJQisZn3BfMvo9LKeUeU3GSC0Wp0PXo3fGnZKMc/bSX7HnIuNcVeBb4JzR8MlUR6IRvZne1DEj3iDQIsDndxDW++fL0XAveYiMuBBeFlVt8Wt7RfEma3Ew2cdQ5uukv5gAf/N9LFG6Vi0l2tAOWrg/hZgePFOUOurZA+iNhj5y+zTw0QM05XL6KJ4Pl21I5pa8y8LD6xGnCaNLz8sI1AUpavJfVvjM+poA0Qb8GgmFGCp/W5DNL2cf15LpW0CwV+KIiyB162H1NfbMKDH3vu8Lm0vfRe86KBUiq6w0c59t4LjNnVwvz6d1aew+DC9J0f1lMzxGdqtx+0Xp7WTu3KyTGyg2HK1g7MksyNH5Q/M/3OhjRCLSL3G5b9jL2+s2BbowNH56jciJvYbI9GsaiM/kOMLSBnDOxoeUqN3BM0gJWdIbTWdFRtKEIlvRTL1OrIrbtYu/NYMnH+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa60e7f-beb0-411a-36ae-08d819333373
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 18:11:36.8751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CRPH/T02wdWsiBrIJTWfS84EEnTNcRzA+jGjuKGwmi5Gc0cWh2xyt+21crrNqZSjTuGbSEmAaZwPv8Z30a+J67Fx+7I5dm670LhVg8gJ7dE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2871
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Gross - make sure your rework allocates netdevs using alloc_netdev.
>=20

I don't think that is the correct solution.

All other users of the dummy net device embed it in other structures:

init_dummy_netdev(&mal->dummy_dev);
init_dummy_netdev(&eth->dummy_dev);
init_dummy_netdev(&ar->napi_dev);
init_dummy_netdev(&irq_grp->napi_ndev);
init_dummy_netdev(&wil->napi_ndev);
init_dummy_netdev(&trans_pcie->napi_dev);
init_dummy_netdev(&dev->napi_dev);
init_dummy_netdev(&bus->mux_dev);

There is NO explicit free of the dummy since its lifetime is controlled by =
its parent struct.

The fault with the current AIP use of the dummy netdev is that it confuses =
an is-a with a has-a relationship.

This code highlights the confusion by extending the allocation to include t=
he real rx data:

	const int netdev_size =3D sizeof(*dd->dummy_netdev) +
		sizeof(struct hfi1_netdev_priv);
	<snip>
	dd->dummy_netdev =3D kcalloc_node(1, netdev_size, GFP_KERNEL, dd->node);

and this kludgy code to find the rx data given a net_device:

static inline
struct hfi1_netdev_priv *hfi1_netdev_priv(struct net_device *dev)
{
        return (struct hfi1_netdev_priv *)&dev[1];
}

The solution is to embed the dummy net_device in a renamed hfi1_netdev_rx s=
truct like other use cases.

The lifetime of that struct IS controlled properly and a kfree() of the ren=
amed struct would include the embedded dummy.

Mike


