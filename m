Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E07721F42C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgGNOfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:35:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:37616 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgGNOfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:35:21 -0400
IronPort-SDR: Pri9Y1iY5evbDoMtzIg4VpqYfB50nykbhW1/Sw4ZbiZod+q1geuWjO86uTFbqNk1NyUHg1oliD
 gWsImO8/6R2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="150333831"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="150333831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 07:35:20 -0700
IronPort-SDR: HppNEoFOk/fvoZ7X8Y/KMpOxkpML023p/3aVl0pDj6XGRtanwEjVplVXlo1DD9KrUh8qUUeKCT
 Br7I6Ubkl9Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="360402449"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 14 Jul 2020 07:35:20 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 07:35:19 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 07:35:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 14 Jul 2020 07:35:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxht6DnvJnW8LiUIs57SL+UMYlw/qgjZ/zOX1lMn2OtuXE/6LU8M+vNKFlzynMwL/e6qft4CWozry+q0vjG4leZGBUajHz7vjsSWIZIsTUXlbJ+Fp8aiY3vT0xoVrA3tfCaOzBGPtv7ShrR51KRByM0A66qEOAwbqzgEa5lisdUjhv5mj0kiY/KWCSl8C8CIuzcXUgiLJq4AXNLG6A0xoY35yrVuITtVc0XCqOf+fmivwPemSUIJF4DrbFGiAvR68KhGX9ueel5xiejTNrNA2XBLGT2mOe1ppixqcPonotxGgejaEyillHNRPFp72HHLC/4Gs+qjtanoc6sPfZZh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRojEnh3iYG11a0DkoUlHhEh8nPchMq6Ux2IJncGMZI=;
 b=UzoOwl5hT83Ez054CDeymRm+PRSqzXEt3kATRawFnNwwHqkA9Wh7E0rKfNGg6EcBn0HNTUskqDpXJvx0UvUneCJp+RxJkxUgzfpbkFn+E6WhTAn+7V8BHvnxc3lBohG6BHJi3tIi0IjzfInwn7Okxyuf8WMSpSXdJzoyyynd1sOFkH7XJvUq26FoR7KD72fsPzUaLpxMTl0WiKSi1OeO/Dx+GJSIvq1MNaLC0pHfCGO+4tivlm4ZqaG6awbN9Aduo1La+By0H+GJQLIXueSMIkBnKUEPxb5wIcse6Xno/dFakfzGOYMCKjGnf5RLRGzUQri648URKaAj0j1kNMPWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRojEnh3iYG11a0DkoUlHhEh8nPchMq6Ux2IJncGMZI=;
 b=aWICJJV4w/Wk0/TKI6p/z6wLnQcwdwsuUQhPDu0v2A9KHWNqvhF28tSbXlDI90VGa4TTUw86u007Dn+TVaSsZkfu72S8y8mPHr38LRe5/FI4wPbFLfhYI+cs+8gb5bWJbUsmioSnVa5ZUpl9yyF9gYaHTxuFEdCFSn87MoEkTkQ=
Received: from CY4PR11MB1253.namprd11.prod.outlook.com (2603:10b6:903:2d::7)
 by CY4PR11MB2040.namprd11.prod.outlook.com (2603:10b6:903:29::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Tue, 14 Jul
 2020 14:35:17 +0000
Received: from CY4PR11MB1253.namprd11.prod.outlook.com
 ([fe80::a420:1acb:6c09:c5a8]) by CY4PR11MB1253.namprd11.prod.outlook.com
 ([fe80::a420:1acb:6c09:c5a8%9]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 14:35:17 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dalon Westergreen" <dalon.westergreen@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>
Subject: RE: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Topic: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Index: AQHWVPkVfRS7e+4eCk6tElo6txFdaaj+OToAgAj0JEA=
Date:   Tue, 14 Jul 2020 14:35:16 +0000
Message-ID: <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
 <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [1.9.122.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea084ed9-d205-46a6-d87f-08d82803209e
x-ms-traffictypediagnostic: CY4PR11MB2040:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB2040CEC31C37CB2852B48DF7F2610@CY4PR11MB2040.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dwdDbKxeFx+h5/ru10y56K71DQs0sGQ0qISt0tdaJQZRj6o0RkfAWX0Yof46dOZAn/CVudI7cu5QiCkHTgF8GYPlI8170Unh7VJSFCd3NbzdWlY1aBQFlGK+ZTBjyRjmZklgXPcQ00gJ0aIFM22nMJJgS+P5z2c35qyaL5QvmKyQ1MZWLL0GrowvHpxSo04rqwO454i0RKqmjPB60JRU/oaeMHfS7MwaKXJonkunmGxC4WMADxeOi4/vB89aIHr0ZTxTpo3oVdNmMsFjPrvD/guGNtGd3hxrccuOf044CRB3mAVqbqVCMPNsPlGdy50kZATg+9NSOma5dyvSmnl1MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1253.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(2906002)(6916009)(316002)(186003)(83380400001)(76116006)(26005)(66476007)(64756008)(9686003)(66946007)(55016002)(66556008)(86362001)(478600001)(66446008)(5660300002)(52536014)(8676002)(71200400001)(54906003)(55236004)(7696005)(33656002)(8936002)(53546011)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PBaavtzrdoOeOHyMPCfLBpTdgf/TJF9RZSik9e2HPe1HwHGjxJCn9jfrZCkpWTQLadOIBIP1dkM0IqHg/0OLOuZtcwcdzKoPYEl9/rNUPTXKBz6Z8KViaZdvF+u759LHh/a0NAdRew0sK7uZKttFMuFMhYxaG3dzTQjU6m3fmrt9So/3rxDcaFUxU5gDMqT7aD5pkc2wmOMH/o0SOwiwjDbRdNIpNPGXvSslTm/XmaH9UAmf7OFnoCI7L+rgmhj4jVzj7y4FOO9GQcOQfZiERiGhvoeK4YNfVNxxPAbkAQDDcPykau/ZsMMkL6HsrutNx5om21C8kBFjsoZa5VvF2cQcf4hdHIsEWLUtrKntAbS/a8lxxJEV2JcPfVdbCAsxIuMvwp3n/SKGVTfAwoWobruqgAGwmmJIKyY1kSjT2wDgSzYaslfoBrCAq7Uhp5aIVbHALXGe/ltsXSxHQbHU04Nict7PtIRsygoZbQ0OdqA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1253.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea084ed9-d205-46a6-d87f-08d82803209e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 14:35:16.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofra6ByhKqI9BqVFpUj7OxqH9klBY2CBZP6O6+iH9fJSzkR1yauIT6Hk2Ex8UjdA+azPXl9Qz+qEC5V3MjaeUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2040
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 9, 2020 5:49 AM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Dalon Westergreen
> <dalon.westergreen@linux.intel.com>; Tan, Ley Foon
> <ley.foon.tan@intel.com>; See, Chin Liang <chin.liang.see@intel.com>;
> Nguyen, Dinh <dinh.nguyen@intel.com>; Westergreen, Dalon
> <dalon.westergreen@intel.com>
> Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
>=20
> On Wed,  8 Jul 2020 15:24:00 +0800 Ooi, Joyce wrote:
> > +		/* get prefetcher rx poll frequency from device tree */
> > +		if (of_property_read_u32(pdev->dev.of_node, "rx-poll-
> freq",
> > +					 &priv->rx_poll_freq)) {
> > +			dev_info(&pdev->dev, "Defaulting RX Poll Frequency
> to 128\n");
> > +			priv->rx_poll_freq =3D 128;
> > +		}
> > +
> > +		/* get prefetcher rx poll frequency from device tree */
> > +		if (of_property_read_u32(pdev->dev.of_node, "tx-poll-
> freq",
> > +					 &priv->tx_poll_freq)) {
> > +			dev_info(&pdev->dev, "Defaulting TX Poll Frequency
> to 128\n");
> > +			priv->tx_poll_freq =3D 128;
> > +		}
>=20
> I'm no device tree expert but these look like config options rather than =
HW
> description. They also don't appear to be documented in the next patch.

The poll_freq are part of the msgdma prefetcher IP, whereby it specifies th=
e frequency of descriptor polling operation.
I can add the poll_freq description in the next patch.

