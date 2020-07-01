Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924E6211191
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbgGARFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:05:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:54332 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732571AbgGARFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 13:05:46 -0400
IronPort-SDR: LIg/NOIpTWDzcSDnlEGPt3m6UgjUuUX6e99g/tI2xaOgkG/in8f0MkOKNRyNDWRrXxZ6hnoA5T
 BnrztApnaqgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="145732846"
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="145732846"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 10:05:45 -0700
IronPort-SDR: op1p91vP7Aji6w6cG4g8NXGlTt9ntr2dQj7oNlPw8l5K462ki+VM/9VjEUAaMCDoKgllWmtSqQ
 M6crB717YNWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="277837013"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga003.jf.intel.com with ESMTP; 01 Jul 2020 10:05:45 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Jul 2020 10:00:09 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Jul 2020 09:59:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 1 Jul 2020 09:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnmj9RQHd+I5oFX1Y8Jk2C/3fLxyrIngJHbpOoMxi+kDJjU9HBuo75SaHfVT+nogHXK4YlKhjVbxfGgMy1zEVlwPiFOaHVWsHQ6t6VTexV3odFgE2t2RiyZ9CF/7ssUFTVKj3Xi6cAdj16Hk1uPCxt/9EV2Uv8pShfIlFv9nOUpRLwxjcWlxeTxdnia3l7Lgy4z1p+6gdp1bjUHM137Z4h1HniO91Mal914DB0kOxX5P79BAJYFC0kIPNgP+lkmbeFD5/og1dkYnwRAh714DVXaxrq879TnaKZ6Lcm6udTojZU35Lof+J/dnV14AJw1Nl1atEpAI1+w/Vu9NmNzZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wgyQvCo9YQbnney/gruQnzj4O2i5NZ4oDOKsDRuzyA=;
 b=W2RVLVxYZ7l8zMUSByLvUtDo8Hx0J6Za9bHnJ3PtQQErY/WMK4zQcRzUSDs069p5CX0cZ6sO7U/9wh940ao8EFFNfA7GiXpZJY8myrHlEj1QPFH0xExwhYlZxivBj+Yyj5kgjkfabZGPO96mZexvJsY3nFzodZt/HnG6lJ0+s4nQggU4RqdO6+2e57DMWLvwRJK2FUKZdRhwOKwmt4P5dwVbAzGp2RqkL1ShBSVgl8NbDYnGR7PGZnO1Uk4E9dvD+DgLntTnp+ZvYqf4dh1x8nxualCl3VTcq8Vnjm7TvFKYZmtK/XCARin+8ZJWNDsQvY1Dcfbxe20Uiuw9YJCb+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wgyQvCo9YQbnney/gruQnzj4O2i5NZ4oDOKsDRuzyA=;
 b=rQqQTutmIo4/BpxTqIs0/F2zIEUtcweG+Z9tjoMmA2Q1niajssFw1VBzft/boH6rlnRB6Ov71vJaAyWfFctNOlrAP9/d+NY5I9julWvk4PH4oKJXJW+8jMlQafrG6UK9zreqaX4msa7xNKUvt3Fui76DuOiDg0At7L0QjovNY7Q=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN8PR11MB3698.namprd11.prod.outlook.com
 (2603:10b6:408:8a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 1 Jul
 2020 16:59:48 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 16:59:48 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v1 1/5] iavf: use generic power
 management
Thread-Topic: [Intel-wired-lan] [PATCH v1 1/5] iavf: use generic power
 management
Thread-Index: AQHWTfgrmiUZ62k5Tk23/CCLp/c1+qjy9eDg
Date:   Wed, 1 Jul 2020 16:59:47 +0000
Message-ID: <BN6PR1101MB21456FB6DC435BF22390B8478C6C0@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
 <20200629092943.227910-2-vaibhavgupta40@gmail.com>
In-Reply-To: <20200629092943.227910-2-vaibhavgupta40@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3251fbc-685a-4ac6-5ce1-08d81de02999
x-ms-traffictypediagnostic: BN8PR11MB3698:
x-microsoft-antispam-prvs: <BN8PR11MB36985E4F6343EBCCED0412E38C6C0@BN8PR11MB3698.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uwtzu3URZ5Wi83TcRFO1FBKGd9rTRcEJrkSOYncBYxCGQNVC3L7RKx0K0HlR/c1gp2Bz+7rBHoGsr4ziULP+FoRbEVTPS7irjuC6aKUVNaO5EFuZIGS2Z8lkJna3dOCmVDRZ0/jGDKYZgT9/54bke//GGBbNMHDHmdo8oRNUsYfDy5ltrCLVcxLqMLmw+a4N2c1637GTw8mOklM0rQyf2aUC4dxdiDApxg9rujdplrfhmMnrG/ZeP7rkqFCg++gqESBc0HKtjWzjlSasr1rS0DxV/R/cCrBPMnkDeiMqc2XrkU355roOXv12b8rV/X+LrgB6hgrTnq8REuBDLs4TFgB2zS5433dGfQQtmTUU5BOMmx0ZFRRa7y4A8m78ZvCt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(2906002)(55016002)(9686003)(8676002)(86362001)(52536014)(33656002)(478600001)(26005)(5660300002)(186003)(6506007)(316002)(8936002)(66446008)(7696005)(66556008)(76116006)(66946007)(53546011)(64756008)(110136005)(66476007)(71200400001)(83380400001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uODgLvqRtQXeGm10s3BVl0yV5QmM1JYr9DhHiWJ6jWVAu9iMfgIcm/uBhvjbE02HA+ckqLgYOGLJ/ftRV3kJy5v9y0DNMVSaJRMvSFMDh8uetHw9m6dyNMMVw70qWNybSvtH3yzXjTp6Yy4pkSqmrz1npAy9j/N1b/yJVJ22FKHhqS4vhmMQVhzelC5G9OqUMqXWSUwGfnbnA437xcy7E4lfm7zSrsBkXFvEZLFMiy/4R6JvWb/zKeF9XB0hv8ioercA+vy8BM8hny4XLmTcrlgiHyhh2cSH6TLBs2QMHNzCUUPa+/npXYaQiECsv6RhoUR5xeTJRbspIPUVUOh1XCcf2wyeEASaXjzATfS8S4889L6mO8hMYoK3LtfzJODPea9LfFkYjJBNEunKtuVnJbVT6cGRXNxRZnLWn3xenz6I95ZfMawxyrQyOraOkK7dZvbWkzMtV333bs8x68l5MKKnwXBjPEVwrvwM7L8wK7c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3251fbc-685a-4ac6-5ce1-08d81de02999
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 16:59:47.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R6jF0UhxuEvld2OLRguGqIx+RVyb9q6+84SY15DYXhgoIkocefl9mgQthwjkqPnuA0dl0Kk8Qgs/iqjnT1ndG55jqMf2gELbGOH32Jf2MFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3698
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Vaibhav Gupta
> Sent: Monday, June 29, 2020 2:30 AM
> To: Bjorn Helgaas <helgaas@kernel.org>; Bjorn Helgaas
> <bhelgaas@google.com>; bjorn@helgaas.com; Vaibhav Gupta
> <vaibhav.varodek@gmail.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> skhan@linuxfoundation.org; linux-kernel-
> mentees@lists.linuxfoundation.org
> Subject: [Intel-wired-lan] [PATCH v1 1/5] iavf: use generic power
> management
>=20
> With the support of generic PM callbacks, drivers no longer need to use
> legacy .suspend() and .resume() in which they had to maintain PCI states
> changes and device's power state themselves. The required operations are
> done by PCI core.
>=20
> PCI drivers are not expected to invoke PCI helper functions like
> pci_save/restore_state(), pci_enable/disable_device(),
> pci_set_power_state(), etc. Their tasks are completed by PCI core itself.
>=20
> Compile-tested only.
>=20
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 45 ++++++---------------
>  1 file changed, 12 insertions(+), 33 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


