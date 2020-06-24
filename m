Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3A2068E9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387970AbgFXAOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:14:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:22348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbgFXAOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:14:20 -0400
IronPort-SDR: FgsaY3eG/hFbfRoshFI1Cu2LLuqAFMlAs59sslRyQCoCiyzDpDKbSBfnS0jNYeGwhncNBi+DQ9
 fEPL1A8945zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="205777294"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="205777294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:14:18 -0700
IronPort-SDR: BVSRb4c6jE1UHtuS4VMPdT9Bt3mFF2H/2F6+SR6xGV2RXzp9DTuimvN20gJgDZEOBCkze9q1P6
 mrAAvDj4jbFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="319301693"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jun 2020 17:14:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 23 Jun 2020 17:14:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jun 2020 17:14:17 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jun 2020 17:14:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 23 Jun 2020 17:14:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvoW1s+9oZeai2A4q+WIjUWeifIy/3y5gin2TsyhZOLlutGVJGiBb7/YBDP20gMf78JMEi7FteHhawhqEN7HCO24AiPf6cE0eykzZBFouWeIGcILbQp0ODQwxdSIAUhZzlq46dIlP0AzQ9SotbovUoJiPsBCovCXWuA+IK1Fw9IKB7ZO1dEbUHgDlvTIvjP6OK1VH/rmtykNgo3NhI6G8K9LqvrSmm01Og66hNoDeTcBknHh7sOeYEoO+I8HN95ZVdtsEmRiDpLeFTmQN6Qpupk4DKFfXF7M4ydR6Dbi3SBvTC67ccKeY45Px7vUaG1I6PH+rw9cl5bwCIrSCIcirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMpeqQnUYPl/rDluPf/CunstRYbfFf3RC8rF6kGFTPY=;
 b=Xrciu0hht0MyMpfKHqBLvWuq7Wp3j1jvz2gfpLr1jLQXn9OiiLpXaAmpZCOkM8uqbnRexiOQAUuZaUc+8aBrn3/YvXbuRi83PJ2AqwJQ74lrmsYT7rD+Fzt/MwQReLkqJ2t0HOCvFSXs/t6DeS8yx1vxVnD4FzAb4QffpRwCKpxYy6cSWMbPmaEA1GVzZKr6ooPqAW698yRHBwZFXTqrMKI27YbHfj5xfzjS70M304ZLi0ulW705UEyLRl8ESCqfk5WkuPKM4uFnBAsdbTAqW3wMpH5WRefCJ11qpyCEJSx4Cb/IiFutlS27JLUfs2tCOiE2LuDousS4fkBbkSmk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMpeqQnUYPl/rDluPf/CunstRYbfFf3RC8rF6kGFTPY=;
 b=maRvTHZ9Cr9eq1nNcJbpkChzXzQ6zi1TGZ1vryKQR87sjDbPXeKn3VQ1fFIafIn/vnpvT3dTzS8++XUb5bbX7SnbhvtBbOKXijLLCN/fHKFCPMsmuPCGsNVXCbgNOyj1mkfbXpoYiRogS0FkvyAgtl+l0j349SplrDVP1P3FWsc=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 00:14:15 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 00:14:14 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Michael, Alice" <alice.michael@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        lkp <lkp@intel.com>
Subject: RE: [net-next v2 15/15] idpf: Introduce idpf driver
Thread-Topic: [net-next v2 15/15] idpf: Introduce idpf driver
Thread-Index: AQHWSa9oAKPTc4nmOU+fJ4+4ysT4gajm246AgAAIGPA=
Date:   Wed, 24 Jun 2020 00:14:14 +0000
Message-ID: <MW3PR11MB4522540636AFF28B307A3C8A8F950@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200623224043.801728-1-jeffrey.t.kirsher@intel.com>
        <20200623224043.801728-16-jeffrey.t.kirsher@intel.com>
 <20200623163857.4e3c219c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623163857.4e3c219c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 81a71e9e-025a-422d-51a2-08d817d38762
x-ms-traffictypediagnostic: MW3PR11MB4665:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4665F41BE6B13FF21D1F5EF18F950@MW3PR11MB4665.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jb8PumaIL8couou0jIrT24O+2E8zyms8kDkorgciNXcb3Zc/NdTXgpOAEbJHVZF+/RzaYzqnkvg3tFQoP5YjBjCIjaIpkdyVhXVmDV5rAlJniTF9SV9uXgbV90yT4ZkhljgZEG9Mogb/zd1sR5jYfP65BKVD4HsprJCrrUhS5lxqhKzTe20z34dnlGXnILFkfG0sh2fcHuMsP3xTXnrdQ/P2TgpCUneRXyvqVAjdprPtzlEJbozq24FhozZfWk593ioD3o0C54Erdzjtc6zbvUSgDI8LIt49TVN73+0Dc5A4fZ6/nL5Q0LoUtwTFXAkwOoFNTYcbZ0e1Cqo8fRolIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(66476007)(64756008)(110136005)(6636002)(316002)(71200400001)(54906003)(478600001)(8936002)(8676002)(66946007)(107886003)(2906002)(33656002)(76116006)(66556008)(186003)(52536014)(53546011)(9686003)(6506007)(55016002)(26005)(86362001)(7696005)(83380400001)(5660300002)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RrTbA0wRXHcKv/a/IVBhgTMC14yr//108r6KOcS0YtE7TTRxVuoDAgIMx01K0NJpV3/mYDDCMzLh3TvQ4oO8z9dklt+5YknXDjwOvvvzhkMq+XxlMa2eGDKuw9vyquK+D11fRz6OjVJBfxo6K+QCGk9k6vVTQH4+S8+rafRgXiQ0ubyYR9zdP0vj5KMpgYi6c4tny/NKj0S22kMyijKle17TJemIW3AdF0UgjqoQunke1MUTjdllJNfv3vb7J4rC2l3BN3ViGbgGLvyHebEu16jjYabpIE96uT+LnMK629COzgAdKIpeLFjlX8+0vgX9m4wwBq6a4+XJi9bdfZV6gJwsfjQaaq7MZUDC/85bY0C9x4U32MMIApsxn67NxoJnsQY6NzwW3/Ne+uvGDJWNLBn7fAapM00dz7o5qr3pEqZBOsJLhC3GOZ/u+xxjx3iuwgdge5ceXJjUldVZJBQFl1WoybyNERwFC/pNJUxNiSxmqdN4j/ZdclbcelIsvf7e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a71e9e-025a-422d-51a2-08d817d38762
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 00:14:14.9134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LrzJvU6jqvZTvYh2kxCRglvzaazFq6KIa4lvhUcnx1zTMaLwBxl//1wU9Iy/s9lu+AW1wRuE6rTR8mO19KfTuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, June 23, 2020 4:39 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Brady, Alan <alan.brady@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Michael, Alice <alice.michael@intel.com>; Burra, Phani R
> <phani.r.burra@intel.com>; Hay, Joshua A <joshua.a.hay@intel.com>; Chitti=
m,
> Madhu <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; lkp <lkp@intel.com>
> Subject: Re: [net-next v2 15/15] idpf: Introduce idpf driver
>=20
> On Tue, 23 Jun 2020 15:40:43 -0700 Jeff Kirsher wrote:
> > +/**
> > + * idpf_probe - Device initialization routine
> > + * @pdev: PCI device information struct
> > + * @ent: entry in idpf_pci_tbl
> > + *
> > + * Returns 0 on success, negative on failure  */ int
> > +idpf_probe(struct pci_dev *pdev,
> > +	       const struct pci_device_id __always_unused *ent)
>=20
>=20
> drivers/net/ethernet/intel/idpf/idpf_main.c:46:5: warning: symbol 'idpf_p=
robe'
> was not declared. Should it be static?
> drivers/net/ethernet/intel/idpf/idpf_main.c:46:5: warning: no previous
> prototype for idpf_probe [-Wmissing-prototypes]
>    46 | int idpf_probe(struct pci_dev *pdev,
>       |     ^~~~~~~~~~

Woops, missed one, sorry for the thrash and thanks for double checking.  Wi=
ll get another version fixing this soon.

Alan
