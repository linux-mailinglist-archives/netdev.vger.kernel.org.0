Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF14220A38E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406526AbgFYRDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:03:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:63315 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403979AbgFYRDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:03:48 -0400
IronPort-SDR: rAQeG657atYP4QDKm+z2r601GJZEzfUNfv4sAfn6mZoXAf1IWGjQzy6uqSrsxqSESDdjiC6mj4
 AOTzKUxVAjxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="143219031"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="143219031"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:03:47 -0700
IronPort-SDR: 6rW98YnrqLZQDZl4xpMAi76lKXXLYgzdtlhtDss/QRDNnrfTqzQXuIag5wwHrsnO9lU5bg439E
 Xx1USGf8Szdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="263979339"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga007.fm.intel.com with ESMTP; 25 Jun 2020 10:03:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:03:46 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jun 2020 10:03:46 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jun 2020 10:03:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 25 Jun 2020 10:03:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEOgzOQKKEgsKeLbcuoM4OVTB7FZhFLn5LXdvJh6rRIepDDKZWSIBhtNa5/6tPJR/HeP2Tl6Z9cUJSm48fKmA0raQIFGbXLAGBHYvpexwDKh+sZZUMTXzETPFRp+2ny17AsulVTzlWNYxxzCFHJ13zTevWaT19ilUWQDtJGlwga02oD6KLwhD5dUwe7AhZU+LEBWSgjwv+GgBDc4Yyg9GzQxLX7pUJa1fNJi7hazhZ7pOofUBAxyFSYMg4jAploNr1ztwHlqlRPm+xkZY6E0olOP8JtJ6IFc3szzbMaWkfvK73WcFfGL7RkXlm0or60aKr3ABa1j6XT2Q/Ua/Q2xzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPX6CsEX92sybDc28GNjM8Id25vbKq3qA8xmdfx/XDE=;
 b=RZMscmfcQVa49A8YT576eqCoD17UpNjOR2bjtx7e/GOf5IYSKy4aIWydM4ryeYn1YwoC/G+l/5mH2BYeTp4gqojNho6xYfAHJEME7j44tGVQv420qfazKempCTlvvb/IP1NOroKxSMEK41hkTk/CWrE9wr8yAu8TM0x7NaXmI0TXba9QVoLSl6tsqiP3o4+2bekA62TP9IwKIh1wY9p6B2iG8RimNJBuY74rkCpEgcCRGZ1LCNvPLtF916xaWQdQFKmTRyVVz36PFD/cLPCyYaDlvSRYpW9O3Ax0ol0VodpJxgUoKlVQwXOFA8qEwv1L1OZQEO5JZg8G0O76rzx7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPX6CsEX92sybDc28GNjM8Id25vbKq3qA8xmdfx/XDE=;
 b=uNEt2e0ypYQ5EGaFFUVUbkLbl9FSUE5/IKQ4+sNPzyfuzzXOsIAMuSeeIncoe1XqLIL2XMJrK1Ue6xUM17DwoAMoXcxEuAZEIzxXZTYgDALhJubQbBSWP98TuqHIo/topMOEqeVM9+AtSpg4KZ949qMXf05mwj0TBsdE829M704=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB1700.namprd11.prod.outlook.com
 (2603:10b6:404:47::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 17:03:43 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 17:03:43 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: eliminate
 division in napi_poll data path
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: eliminate
 division in napi_poll data path
Thread-Index: AQHWSULsufGuttWNLE66xC8PSBTgUajpkoNg
Date:   Thu, 25 Jun 2020 17:03:43 +0000
Message-ID: <BN6PR1101MB2145FF352A257C2E96089FC08C920@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
 <1592905458-850-3-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1592905458-850-3-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b141e29-03bb-4b90-394a-08d81929b7a9
x-ms-traffictypediagnostic: BN6PR11MB1700:
x-microsoft-antispam-prvs: <BN6PR11MB17001383E1383D1D5A6E5D978C920@BN6PR11MB1700.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XspGlJH62UU0JafvofSmfjnBtDXaNxdRlYaKIEGWZxc+FCf7ZG5rhS2dMIA+gvqqECwy3M30CK93FRHeoKNJJ5d2JwMjR0WpoURcMawtBfFJZjR06hShZOcEzB1lUy4BmOQ5NFXo2yMh03bdbCRbI4OSerVG+u0h98nAU+XoKy4X2XZBsDKfrMS1bQfZkvPcg69qfi+YxJ/0VkI7V4gibfQXrkdfU4JudczqCCyycYpWHIpZhru7Pp3kzQQ1od4duqLyEBaWDKYLDNSmM6Y378e0CLb7UY6v0RVSW2m/01Dm2Xjj963ZN7GTyiikQD/t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(64756008)(66446008)(66556008)(71200400001)(33656002)(4326008)(83380400001)(26005)(6506007)(53546011)(7696005)(478600001)(186003)(2906002)(66946007)(8936002)(316002)(52536014)(9686003)(6916009)(8676002)(66476007)(86362001)(5660300002)(55016002)(4744005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: t1ff5q7SvK8z4Q85MaAJP80FnEG4YQ1KuRMcGqp3cTslXkPHUwiW8lQEdIg1xy2M3Ow4sqKKDUpUTE8enOrdenSVYelhtKiI8xhXQ58Gi30anQoGqRxRJ6P4sse/rK7B6FfTRHRkNya6kqRZkEQHuTGKUmVAeHAVVII05SMjEuRz6Mwz17OGjy1UBlTbX1d3eXjlqR8Ui2I6gMs+t3VvSVs49AqaSXuQV5SKoYJpcOViPu9ZOoae8MmhYoZdXLRPtKECkpnuAEqJMu8ep65ry54JIs9mRAtvhrC1X12H6/Q1oXErAKarNT8EekxAwKpaOJSp6I1UcMHXUZ7oW9m3ZDymRplCxkVC/DQxbMzj5Q50CKUy6fuG5nA08UbUb1d9o2gFI41EfXvP8vNKBl6eh1XVV0e89QypNT+kaW84NaUqZli+eoSwwU3Z9HkgXmfvEiOswT4+kcTpdK6XKL4410OOIhwrvXKLhACsG6WUCO7fxbFfEcPKkHukj10xRjeD
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b141e29-03bb-4b90-394a-08d81929b7a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 17:03:43.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgC10j1bRzCVCdzcllxLnUIlCIkPmU0ImQuy5QMDLNHAyjZcKgF95X7+HrxbIOCkOG/iKb/E+YWg2E8zYExz4kKHqsJicR9z9iOuyNbCN1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1700
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Tuesday, June 23, 2020 2:44 AM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Kirsher, Jeffr=
ey T
> <jeffrey.t.kirsher@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Cc: maciejromanfijalkowski@gmail.com; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v2 2/3] i40e: eliminate divisi=
on in
> napi_poll data path
>=20
> Eliminate a division in the napi_poll data path. This division is execute=
d even
> though it is only needed in the rare case when there are not enough
> interrupt lines so they have to be shared between queue pairs. Instead, j=
ust
> test for this case and only execute the division if needed. The code has =
been
> lifted from the ice driver.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


