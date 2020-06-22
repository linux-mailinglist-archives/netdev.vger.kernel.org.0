Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E672040B9
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgFVT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:56:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:62902 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgFVT4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 15:56:16 -0400
IronPort-SDR: boyNwlvSxPyRDKRFbDiSej9KAOtQDAONqqhQRZJRXWNn8adwexR0BNi24SlnuvJSSfY+PDmqTY
 8fjuRsTzL9BQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="161939424"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="161939424"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 12:56:15 -0700
IronPort-SDR: KtRvj7j1Tr0jK8tcPV3xJJkCoya9RD2VAtVevS5a7oz1FmKMc0aM++1N3Acjr1iMOBpOOKkXiM
 mG2gAqknwRzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="451952404"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga005.jf.intel.com with ESMTP; 22 Jun 2020 12:56:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jun 2020 12:56:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 22 Jun 2020 12:56:14 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 22 Jun 2020 12:56:14 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 22 Jun 2020 12:56:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCewVzYocT7afLPmHk6n1Xiw83ovorGmReuN1ioi6qdGcAAfoFsPeu7xrpJMJmpq+mANEs8LHpuHDpi96uWZ6n619S9hw4vO3h4SQ1TPGK5No9bOoaY93ZBISFP+MPKB7qVJrrRdtB23fSEqFZCpoadO1gvLbBjuDnj4okRaJT+D0TAJPSreXLPAq6AWoi25PmInxZXlA5dUelrb1nReby5mQO6GYGrKpJrx7Uw415wRpGvY6KOnhV/ho4g0wDKmkQIOrc+kZqRBnE/5wPee4gV5Zs+O0iPwbAJGn0kzWKCx2C6CyYsupFG/n7Ahdb7wes4zeYA1hVvA8weojsBXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBQzOHxiQln4S0YluHXsK5iY5zQtWI8p7CsvXmPOu+k=;
 b=KeVcY7/FGa/ww2Ut2RQwLVfY40R/iAoSmleKgtKnjY1oB1TEm2Q+cgDcokTjb1IjTCLLf/dwHu4EGadrRjVIDR5s5SIUiaBMm9m82jNsNio2JBbi2oDK1c6XhlyE0wSQrlBcFOgx8Xe9KhyFpDFDVYRWjWRs6FL94/TV2xRibYRSGBHbjtPLslCjYu8eQ3Z709QjTITuI+hP16vqKiO4fr4GWTQ9W1ZFniGvqCd7Iuln3ORiUcEXafHmx0NEBKZnpsPKEE74Iskk3q46RTAcW0aux3XpP8i3pnbpCbk0QRizhVRQbliURJo8QdqflpytuRl8i3iwcJ1HKiLBetVAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBQzOHxiQln4S0YluHXsK5iY5zQtWI8p7CsvXmPOu+k=;
 b=o/BT8e4v7pQ8j5Rc5Epr5QFfNKRtmKdcx+Eltv4XreLoyaeiu0BJVOrZCYacO162cmVaN/06BvdnBVZ8v0nircy2GlrcuB0SUNnsK1RGOvltSDcwLptIMpTwZqk9E3QOMpnQy8qzz+YyTNMnKv2rtzAaJ2b8Hhb/iNR4WnWnjLs=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN8PR11MB3843.namprd11.prod.outlook.com
 (2603:10b6:408:88::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 19:56:13 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 19:56:13 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] iavf: fix error return code in
 iavf_init_get_resources()
Thread-Topic: [Intel-wired-lan] [PATCH] iavf: fix error return code in
 iavf_init_get_resources()
Thread-Index: AQHWRXseqc3MJ/gkX0mo2/9+35qXmajlEzTQ
Date:   Mon, 22 Jun 2020 19:56:13 +0000
Message-ID: <BN6PR1101MB2145B27B777562A71BBB122D8C970@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200618141953.29674-1-weiyongjun1@huawei.com>
In-Reply-To: <20200618141953.29674-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d525de03-b894-45f6-929f-08d816e65139
x-ms-traffictypediagnostic: BN8PR11MB3843:
x-microsoft-antispam-prvs: <BN8PR11MB38434DBBE4AB5900EDB17E208C970@BN8PR11MB3843.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EhIZ9Q/viD2I+6nmCZJGQNlCHyNVDgNYBBTLnLe3IitTzWTpHsz8/e1jksQCEMD19fsy1dRjCk3HGBdeLUscmMNiuG8DBNuUzE7WOubfAQD3Jm+lDii++/nSsdo62a9fhaFTYB1XiJoP/GPQYAoXjp6Dp06b99h6GBNq8fJJI/CRR29uV3KVPxl38QhvIlm/sAryULVZT3iAuFmCEJaSLvSNID5MmmDvLVd9vcEx7acSy3NHe/lkbPM/KZ1j9WpuDoihkHu6HxNEkPjxdvo0DQ1HFWhj8hgx0dygQA2WmPt5QVWZWTqGdVcLh2IcrVj5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(86362001)(2906002)(8936002)(26005)(186003)(8676002)(5660300002)(52536014)(66446008)(4744005)(66946007)(83380400001)(66476007)(71200400001)(64756008)(66556008)(76116006)(478600001)(6506007)(53546011)(7696005)(110136005)(33656002)(316002)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2+MRlTvoa34sV4nAR673XnKh9ox5YFZbrY3/vnuFEEr0wWX6VXrbuGry07qkcupz7+d9iYBFKaAWUpmXW/3sPGBuL3RiuBlxhmoMZDutsT3pI/OdNUkNl7651nj8FrhOPYnEyOmexwtfJVQC6wA5mgHbz9g2Zd5kq6DFTCah6mjI1IU31HojMcaxL8zyGmnSetj3VUIZ2V6ZglcdjqVuYCDhmts617Wcb0MyiA1toNHO5PZ2I+zqSonS/OtgvylcFZzXoSj8gmkVyGPksWLGxwDAXUL7zuIHKxbQhjT+7kNVTlbIjt9RFqANdGUT7uYKRjxo7Abg22gvWmnEZgiikr7wH/Cz2oYE7lKTeyopZNXlw3j9r0JhFt7lCJ0WMUPxSTRMYd85aPUTmgA+7T/7Lo+I3PN+v7FnqOEUeEpYArMgQXMvRTRI702vkzb0aDq8lM1WGqwEeGf1mTGIm6cRwI2b96VW7iQZV/9sbhtqyGw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d525de03-b894-45f6-929f-08d816e65139
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 19:56:13.1992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FTOvsFP0owZB+YJDeULu7el0BL8hE+CpyND/PQgLR46pgYisYynk/0JpYZpnlN0TF85bOQ2uAMy+GjGQRnzlWSCo8819s4n01YqRNs40bZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3843
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wei Yongjun
> Sent: Thursday, June 18, 2020 7:20 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Jakub Kicinski
> <kuba@kernel.org>
> Cc: intel-wired-lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; We=
i
> Yongjun <weiyongjun1@huawei.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] iavf: fix error return code in
> iavf_init_get_resources()
>=20
> Fix to return negative error code -ENOMEM from the error handling case
> instead of 0, as done elsewhere in this function.
>=20
> Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


