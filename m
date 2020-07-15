Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF632201AC
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 03:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgGOBRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 21:17:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:22100 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgGOBRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 21:17:30 -0400
IronPort-SDR: MLCUPuwLrtz4ZYbhtBYCN4s+arWVVSXKsE78F9aGbYqj4u25HU9Uqq3iS7rSYv5N533QZYwNuc
 8uC7m4E9boCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="136516425"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="136516425"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 18:17:29 -0700
IronPort-SDR: NdM4J1c5HdqMrgCy4AnPmfTtacmzbSdasmqrx7IdAP/rKcOC34O/W7JPWFWtBRsh+3y92sOZNw
 E56lrRHk7T/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="326014345"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga007.jf.intel.com with ESMTP; 14 Jul 2020 18:17:29 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 18:17:29 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX156.amr.corp.intel.com (10.22.240.22) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 18:17:28 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 14 Jul 2020 18:17:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEoSsZWivpdNC2em4PY5WC20WIuyDZuBvgttQlWnilfBaUm2iOke2XbtvJeACqUME2GlUXMmzqvGYcQhS1o4HokML4XglczQmKSJ+YiqaR7wAy3lTlLHVfsbNdB9zkq3UhYxylp/XMe6OMMh7JwniTkJUVvg+gIgCKtIidFgUbiwB8+xWR50o1MXEC8kWwwuPJrbnFbXUxdMJHgMrzB0w564dv/Qc8hF7M5c1RgQrYLrYMZj89CVQq1qI7OIp8SPreN8eiUk5xQJXbHhW/F8dWHJ++h7NDwGskPNCvfxkQ8L7DUGxjSJsBY3jLm9qhmosfLO+jUFXgwKfDkcTl24hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2CW5q/9O4jXtZb2Ayh+GmWuvuV95EMkxsFKnX3p6W4=;
 b=mU7d6XvNUbaVDMvJKOFk+LvoHtrJGE2+iikhpgaG2FHUBpuuZZkjXGCMO8R6DGooiFsdpVeIOramTjRAxDdhEQ43/YDh731TbA35pauzh0Qsnx2kKwfGSiqm3yHxVvUE9PrIMfNBlRuKxDtlbmPRUWZvgz1LbnUBcnS/gt6Avs9Rrm70IRipy5o+QK3fR9uTKCa996vNM7WGCpa9JTHjqUqoxissiw9NY7m+WMr1MFu6EKexW1imk1m59ntzhQL/DYr1/toS5Xzk8MQcvdlgM5Hpc6sx+BGOPn5RQ9gm1NXprNkMjjEEG7fxvUfRdZoLywg0WKHdyPkJUau+zJNp/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2CW5q/9O4jXtZb2Ayh+GmWuvuV95EMkxsFKnX3p6W4=;
 b=FBwZCrRon+H2k4KELl6bSQ40UeBHpiHZKDIqavDKdt/fbU6d4XqmcAS/9cnF2nWaCEmMRuP1i/76m4j7VtX3t97hP+/OTm+yb/alKJjVdX2a4A2mapcT76qjUPsfQeCn/MBIkNNurMNzsqX8DnI0Fvf8yyyTi1EU9+3UYJD5RuE=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN7PR11MB2676.namprd11.prod.outlook.com (2603:10b6:406:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 01:17:26 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde%5]) with mapi id 15.20.3174.025; Wed, 15 Jul 2020
 01:17:26 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpw
Date:   Wed, 15 Jul 2020 01:17:26 +0000
Message-ID: <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30f625d3-7bb9-4e3a-4866-08d8285cd5fc
x-ms-traffictypediagnostic: BN7PR11MB2676:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB26765AAA283E8F3867384CAFF77E0@BN7PR11MB2676.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yBJrCCOv0l3QAGqO+GTCYtzPKKPaUtS81gHQBTzi6dfVDIZWLWkutxLe8HM9LXa1OV5sYhzJHFB4aN7AdPuE79CtnJdAHBWBcF9gsl2QPvWV4VuB6oSp6BS4uJi94XtA5fmGLCzvg5cj1sqb3ijv6/rPJfQ0XPdZJcACWBUHBpDo80GXYPydeCxXFd3+XMVh3goa2Lx3OET3+6V6fEUzHH/dwsyNAokmgRWjC+dUDy+OAWNl2UjhX3AcgaUh4crsZqgVqts8D5zt/Jbbn7vt0x9F5ZEXBC3MTOureS2AKtm7r7E48nsFwGrV6iURswm4PyMHLZ+AnX8/qptmBtOmC669jntrT5TaGiEOkswWlDvy5Yd8B6ngE5nozqPpn1jh8zx9zPMQHBLAocqxRlcaC/sQyTnLDjDLZljD+88p0lLD71QQaBZIgjhr/4McLRi7/f8b3q6sst+PTgGiQbhNjRqEkclfXpk2KKmtUeifaJo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(186003)(6506007)(53546011)(52536014)(66946007)(54906003)(5660300002)(76116006)(2906002)(83380400001)(26005)(64756008)(966005)(107886003)(55016002)(71200400001)(316002)(86362001)(4326008)(478600001)(66556008)(8936002)(7696005)(19273905006)(33656002)(6916009)(8676002)(9686003)(66476007)(66446008)(562404015)(563064011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7G9vXL3LCqvctAg/ISNKnTXg1GTJ/TOxR2bzvHRjb94t8dG8i5nKeM/Hc9yVDOYkTL/MdhfvBaS5u41DmrhVf3d5OC2xllHmL8UCJH1hKZG34wiRrdJH1V5e9oQkslsbgxlZYjeMIilIY51LWLN9koVuIjlDUVx0JCNu0/3Qr5+Zv3aiZJsuAXPgpCj5VMOX4GqhVdSHCnr0X4iNufTSHPCPXfvxxPauu+gu7b166YaoFMzOFwUGKzAR3RMl4gAWa4z9BrW6jBTqrKpGQCKZvxJIsMTTSDPF1SEhbXgKGrDgG68DD8BTmpfnG3SHXb+p2WynA8sSrQVpR2+Ifs3bqWxoZUDHDLrf3AshJRnOZ1YhgCdDJb0sLTfvbuCxWJisV0KSkfJls2RBk/jXJMmL42C+MP0CNcQh78xN7brnxExhhc2aFY7wVKeNm9A1jTN4aLnQPo0VUXlypEKfFVExHl1Gt4UbcCA3ddYN3BIhyEXDtmR/UpPtCfOwntRE1ZWM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f625d3-7bb9-4e3a-4866-08d8285cd5fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 01:17:26.2239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ah9EuTdupo7md3apETkybk69OfOEEIoSurkVpZCS98abax+z4LK03MKdAdhiLef6zGWGh4Hyj+DURhp6sTdanQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2676
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, July 15, 2020 02:24
> To: Wang, Haiyue <haiyue.wang@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; =
netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kirsher, Jeffrey T <jeffrey.t.ki=
rsher@intel.com>; Lu, Nannan
> <nannan.lu@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> On Tue, 14 Jul 2020 01:29:40 +0000 Wang, Haiyue wrote:
> > > On Mon, 13 Jul 2020 10:43:16 -0700 Tony Nguyen wrote:
> > > > From: Haiyue Wang <haiyue.wang@intel.com>
> > > >
> > > > The DCF (Device Config Function) is a named trust VF (always with I=
D 0,
> > > > single entity per PF port) that can act as a sole controlling entit=
y to
> > > > exercise advance functionality such as adding switch rules for the =
rest
> > > > of VFs.
> > >
> > > But why? This looks like a bifurcated driver to me.
> >
> > Yes, like bifurcated about flow control. This expands Intel AVF virtual=
 channel
> > commands, so that VF can talk to hardware indirectly, which is under co=
ntrol of
> > PF. Then VF can set up the flow control for other VFs. This enrich curr=
ent PF's
> > Flow Director filter for PF itself only by ethtool.
>=20
> Could you say a little more about the application and motivation for
> this?
>=20

Sure, I will try to describe the whole story.

> We are talking about a single control domain here, correct?

Correct.

As you know, with the help of vfio-pci kernel module, we can write the user=
 space
driver for PCI devices, like DPDK. ;-)

We have
  1). user space iavf framework:
	http://git.dpdk.org/dpdk/tree/drivers/common/iavf

  2). user space iavf driver:
      http://git.dpdk.org/dpdk/tree/drivers/net/iavf

  3). user space ice driver with no SR-IOV support:
      http://git.dpdk.org/dpdk/tree/drivers/net/ice

Nowadays, the concept of control path and data path separation is popular, =
we tried
to design a software defined control path by the above software portfolio, =
and the
scenario is described in:
      http://doc.dpdk.org/guides/nics/ice.html 23.4.3. Device Config Functi=
on (DCF)

With the patch in user space ice driver:
      http://git.dpdk.org/dpdk/commit/?id=3Dc5dccda9f2ae6ecc716892c233a0dad=
c94e013da

and this patch set in ice kernel driver, we can now promote the VF from iAV=
F (data
path we called) to DCF (control path) for each PF device.




