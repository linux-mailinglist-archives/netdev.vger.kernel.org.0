Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB61A20D8C0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgF2TlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:41:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:58002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387773AbgF2TlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:41:00 -0400
IronPort-SDR: OsNnmVNoJ9GPJUaxK1lFnWyS1mXlOcYXqxTWHOlmlSZaWBfb3MQBLu0d3O7UqUxQTomZplIfoZ
 NyR7h4nl4xUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="211111208"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="211111208"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:48:41 -0700
IronPort-SDR: qPWsxdnvYEth+a/sdzn0b7nCvAyn533WtyuMLJwJEDlksksvHvKVwouNrblOFWeL653afnUIEr
 RP+/ExvgcTAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="480663468"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jun 2020 11:48:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:48:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 11:48:40 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 11:48:40 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:48:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLBCyOpcUfgMvMXel4/hu2VC/C1NWf4Wb3Gupsfex596nXQZ8fYewxteEfX3XAqPa8nvfKX6D2cUxaL6/rQ6vt1SI2SNU0COM9nQ1s4iVz32skzcjs6Pate+3/qUvY1Qk0ocxdNm5AdunLeEjko/EbvfLY4+xBu3zpsXYkmdbStA87rIYQq6EJFQzUMLWP80WnwA1Hcmj7kEcZv+pTr5/49+0RoXkPDfVaGu4Qer4wY81y452NfOS6Q/uilfy83EWxmD8Ka6YtgiQZejouQtPDeIB1eMXXTmqbs/yrZdmcvsacYveftfZOyKvjndm5fLbPlJjpUL7cllHajCDsLZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ku1urBTKfNYQk9nh+LFmtfLdvkiMX4VFSEfJgwO7a1E=;
 b=XqPQCD+gvRBtUT0G0nd+MXMvJlG+77/WyF2ry4/TT3fwc1mYXxpznAmTsRyd0YaIEJWYbUJYhvepVN5M9mjCevM0UbL4N+Yo6cawabgpECxMPJ65uv0lMi6zes/BcmwQWdXegnqaXXGECxb3DyHmU8/emSXVdMPj7Ac7Zq0zUE9hhp18MRVW0uwG+AYwSw9o9uXBFx/CZFfoFVrYyOUcKTKTz7843kXdP6yzo2bJfqgSvqHpArlo4YrsTgPfdRP4iErvSjlcZb2zjI8upfqlGyZS3paQjGfXdX9SMi0NQR4pg6OjRbqTZsu2Jqbg/c3iEC+BfN/YuAnsTYH2zqFnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ku1urBTKfNYQk9nh+LFmtfLdvkiMX4VFSEfJgwO7a1E=;
 b=DelX1QQDpgblHfJMB8Bx42+HPcOqUdefq9Bp5sal15oBPo3lgV0qp5HSv5zAxO8pHkgPMku52MmMHS2McdOkUUYd3hKPujThylLnwYFCtxJgz3rdoFucSU737CUZU8qkjfWYYwUdB6Lo1XY3Q2eMmFlnPzWRCDADXI4gaQ0YLQg=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:48:34 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:48:34 +0000
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
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jrQGwAgAS0h5A=
Date:   Mon, 29 Jun 2020 18:48:34 +0000
Message-ID: <MW3PR11MB4522368189AECDC70E77E6688F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
 <20200626115704.1439eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626115704.1439eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: e3fcf0b6-d012-4bf9-9793-08d81c5d06c6
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4748D48A6A4B4C0E9C9EF23C8F6E0@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +zMqIuY6rjHznMriwEAEgLlcB19JApPjQNlWhxwmSHkAyweZaKr61roU+r/zkGRG/RoA4XtCwTEEOTQLSBbfh2oR4j0Avzd1/w63fmac4qeczDJTvDvbsE/iqN/4Nqk0I4iF4+36pz+RxaE3qqP/zMN010G1jFJ6nNkH2IMhndG+PU4XmZgmxeG0SNgzvJu3v26/QIjZm4pCUX0VWFAybmGymBsPNS8zTbAOFzgx+SR/KNje1uMiCXysomDu4XSSO1nwSgfAAh6uo9WsboLKXWcPjMS70lxa8Q8lyshYqTRZbEzegshDifa4fGhbOKFO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(52536014)(7696005)(6506007)(53546011)(2906002)(86362001)(478600001)(186003)(26005)(5660300002)(4326008)(6636002)(316002)(83380400001)(71200400001)(110136005)(54906003)(66946007)(66556008)(64756008)(66476007)(8936002)(76116006)(33656002)(9686003)(66446008)(8676002)(107886003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: QSOGEYPWKhzfAqkzl363AOGQ7Y3zvMcDI86JIwv1CRch9CCsjM4KUhzDZdik+WvRhF15Pk5LFg+kgKK/5MigK8SB0UHxMJlo3h8YS5JUnBYvSQDg0KutVBAilIWBd8kAoQQLIibDf1+GQnvMAZHTuKHNLVIU/UUIQD647sA9bXzEN/YpxIp/Bk9BDzjTxhn4gSvpSgS3FerVZInq8t57fT5BvjUfDphrLFYgurl+rEKwdVJbHa+eBAwXaM1tF7zXG4gg8/VOqZGaRU2zu2FcAT1OMUcP8tVpi8kPclHF1ozTs38DtBHCZmtPaf7NUfmjV9rUhpgGWp/tailcgBnZ9oV92Nn2BQpXqE/40kgvdp8fNYiJIAHrVohmJw2clamz1MxQme40s5posvb4amgUQvG9P+CAuchJ2nV8UJTgyngjcXUSnXQ0Wt/72H8m7rAv1gL9UMKK5RkESXtXZLtv+rajrl+TVyADQwHa4KCKE9Gql6OmcFxRWgEfnfxsDODf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3fcf0b6-d012-4bf9-9793-08d81c5d06c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:48:34.2715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NRQDqeYNpUfj9U/6CQb4F6dq0W0ZvkNgSM/OzX8HORLtVfb4aPTIypYIrjdTVu1IBNHz7PNfX0Fq/vHKYeIaAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 11:57 AM
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
> > @@ -978,7 +1059,20 @@ static int iecm_open(struct net_device *netdev)
> >   */
> >  static int iecm_change_mtu(struct net_device *netdev, int new_mtu)  {
> > -	/* stub */
> > +	struct iecm_vport *vport =3D  iecm_netdev_to_vport(netdev);
> > +
> > +	if (new_mtu < netdev->min_mtu) {
> > +		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
> > +			   netdev->min_mtu);
> > +		return -EINVAL;
> > +	} else if (new_mtu > netdev->max_mtu) {
> > +		netdev_err(netdev, "new MTU invalid. max_mtu is %d\n",
> > +			   netdev->max_mtu);
> > +		return -EINVAL;
> > +	}
>=20
> Core already checks this. Please remove all checks which core already doe=
s.
>=20
> > +	netdev->mtu =3D new_mtu;
> > +
> > +	return iecm_initiate_soft_reset(vport, __IECM_SR_MTU_CHANGE);
> >  }

Will fix, thanks

Alan
