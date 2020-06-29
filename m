Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081FE20D610
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgF2TRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:17:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:63722 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731886AbgF2TQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:16:56 -0400
IronPort-SDR: QASPYF+Qn1iwo6MFs+FVI9H4+/bstmuFYABAHiffS9xbs+NAyWF/qbRr4D/LFbdbmpcFF7m5j6
 oxuXbNRR73MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="164045528"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="164045528"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:57:23 -0700
IronPort-SDR: YFTxRRkzQPzw1hh37OicOhbObJ8Vrx5W99QaXvbEmE0gdm0k0WIepH9AttiT+4i3PtWu05HoZL
 LYHzHl5dRiMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="264913937"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 11:57:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:57:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 11:57:23 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 11:57:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpJ/tsaxjpKZL0YxRUAYaaLUtR6cy6dT2iLo7L4F8rEoOeHGSsa1ak4tLzNFeNf3MDr+J5zpG1r2x8SbjXzhgYSLZIrum28W4QCdCkpsV+oJY+JJzoHcQMjuO+yEiYdAPGf6PRnJcgpujyB3KGc6uA2Nli7KTKfyZBi2iF/qqBz5f0m6vfQYaOtfDRwyyDjhtdqbHXCMycUU+CyRlGiFwTvcgvM1dJKJ3v/Rh5krKgsY+TGHmz7rdJzV/cY3/26/Nvd47Isr3jcUpM3xSuTOcOWC2fogKJ60DX3dLmwt1Q27t4o2IF27KhrMQj2rqJDUtkMDkKVsD1YQyodCO9r3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2AnBWc1YEJxdCIrIIt2jKZoyM11GahoHm92rH93krA=;
 b=a8sVHGwbPRfUb3teO4+L5UnjDa5HKbwQKacOdfd9FfHkwa4KB+frPrKTKjgW23mX91Td9jPtidu1vyBsP3ydUPa7bHhS1PshXhmw75nA/XIf32F5QeR3oz5YwXYEbaQyJKqjt9tLZdbjy3WxyHTxgMEIdILii78lQLBQlhtQq6HqxjaU35GkrOordHIezsKHOjONd5MM/YOhCDf+YFG6n2KI9CzdYZixsp1FOMP9FA6YlkUi201HRGkNSaY/vjGBjEIpRKFCG5hY4OhYvfb2k1DU2rpbh0k2ERuGRLnIb9ZItfD/IOud2S7xIPkAWEovw19vZuK1kMfY7XGluB+ODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2AnBWc1YEJxdCIrIIt2jKZoyM11GahoHm92rH93krA=;
 b=xyjdxcFySODORlGnqkS+IwqF2gRB1xOuKJS0a9lhU8yWbBTlg61PuGyizbTJhin1+wwoCEhqXySxg0hFKYL5uA/fouGeJ3nLdBPO71KVi0yVZgOToI/2gLxhUPtcYZlsGEHj5ikMEt3+5BLMnknhjqPCl6t4Asu3BDflqfS4o9Q=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1647.namprd11.prod.outlook.com (2603:10b6:301:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 18:57:20 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:57:20 +0000
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
Subject: RE: [net-next v3 11/15] iecm: Add splitq TX/RX
Thread-Topic: [net-next v3 11/15] iecm: Add splitq TX/RX
Thread-Index: AQHWS16bOoRDhMc4KkeGj6Rq1qwDoKjrUXkAgASlX5A=
Date:   Mon, 29 Jun 2020 18:57:20 +0000
Message-ID: <MW3PR11MB45229EAE28A5ECEE094329C08F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-12-jeffrey.t.kirsher@intel.com>
 <20200626125806.0b1831a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626125806.0b1831a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: ea10425f-0f7b-4e40-c045-08d81c5e409a
x-ms-traffictypediagnostic: MWHPR11MB1647:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB16477C7531C9531E83B20B1A8F6E0@MWHPR11MB1647.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCTGwIASrDyA4igKLFVcMQMLQZqoJ1BBxckzuudIWOIszXotRh8KxJjoWvwYQL9KtsdU6eLPlf+7MtPOoRUtKKyOnCFiAZo0ZvUOcmkysgOU0ICphxuQKOrE07TgMFUg7bQ9UA1APUqoTTOx0zHi49jfVSxvDceN7WZ5nXm4T0DRK3fx//xVfWGkR+5ns5irKTa5VKoC7piA+cJUEe667qMyXAf30Sp4+fu0uoylcneNuVX5vHBE3OKXos9cbRQFCsQUEdfYgC9BwX4h2M9HRryoqcTxsh1GsCGTfdFgAyF1AEL2y0cEXHfvYCKdhG5o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(107886003)(7696005)(6506007)(86362001)(6636002)(53546011)(52536014)(9686003)(83380400001)(55016002)(71200400001)(54906003)(478600001)(2906002)(33656002)(4326008)(26005)(186003)(8676002)(66446008)(76116006)(66556008)(66476007)(316002)(8936002)(110136005)(66946007)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Pxb67YKR8Re09++Nqkjp+PUC9Xo4M3D/mf1S8dDv4rfZI71VyByCWO4da43aJ6fh/1x9iw/+aBlr5W65/5jr31dxsPPoq5fOyKSNuFv6K1se8bR719Cuw5S4xoMlu5z8FEiAxVtA9I21oGUmYFDammh02fUnHEfuJAIM7ZP07QOWDI2IGBbdSP+1Bq5L8/PhzawaUwgcjIQ5JUjuhQT0QySkGP+HsSTT/fseo7NPTu5R88sYKmSAnvPbWstrIzzd7tVPQpiMTw87AfdOOXNjCNCj5O1WKa+zJhE6HYUQqwij02cf8pjbEAp365DJLGemzeHZX7VhMwkdF2KKDojmEWbeEIKEfY8vInm0+BIOPoNZAjx1O1c0aBttuvs1PYrBA/DtGrAFme7bzscaYNgnyPSkovBRu9NK53QYjniBgw4s/rOGSHvCuYEc0NfxGlMjpEWpKobnUVeG5JOjSg/qKh3qKzpDsUePanMYG8bnKC+thA7xv+hs7xbLwrEEFGdf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea10425f-0f7b-4e40-c045-08d81c5e409a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:57:20.8008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JN38xtzBteOVd0tjEuf0iPJUM6fF6B/KecxUSnXeilOIhk29I4fsscx6z22pAseADHJfFcB/pyKSHVIJJvvlYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1647
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:58 PM
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
> Subject: Re: [net-next v3 11/15] iecm: Add splitq TX/RX
>=20
> On Thu, 25 Jun 2020 19:07:33 -0700 Jeff Kirsher wrote:
> > @@ -1315,7 +1489,18 @@ iecm_tx_splitq_clean(struct iecm_queue *tx_q,
> u16 end, int napi_budget,
> >   */
> >  static inline void iecm_tx_hw_tstamp(struct sk_buff *skb, u8
> > *desc_ts)
>=20
> Pretty sure you don't need the inline here. It's static function with one=
 caller.
>=20

Will fix.

> >  {
> > -	/* stub */
> > +	struct skb_shared_hwtstamps hwtstamps;
> > +	u64 tstamp;
> > +
> > +	/* Only report timestamp to stack if requested */
> > +	if (!likely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> > +		return;
> > +
> > +	tstamp =3D (desc_ts[0] | (desc_ts[1] << 8) | (desc_ts[2] & 0x3F) << 1=
6);
> > +	hwtstamps.hwtstamp =3D
> > +		ns_to_ktime(tstamp <<
> IECM_TW_TIME_STAMP_GRAN_512_DIV_S);
> > +
> > +	skb_tstamp_tx(skb, &hwtstamps);
> >  }
>=20
> Why is there time stamp reading support if you have no ts_info configurat=
ion on
> ethtool side at all and no PHC support?

This is actively being developed and worked on.  We tried to get rid stuff =
that wasn't quite a full thought but this got through.  We can get rid of i=
t for now.

Alan
