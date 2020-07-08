Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937072191CA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgGHUqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:46:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:50064 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHUqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:46:07 -0400
IronPort-SDR: bPUVvVfuwsWpUMuM0Z2S06S/2/FGFFpLeeL/Jj9xWA3Qro/kkO8ysB+RnKqk+lqeE3vTcY2hU1
 TXS/wnrMnAOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="209427252"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="209427252"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:46:07 -0700
IronPort-SDR: WJ2Yig5fUx6t8WNqGuACQfe5orligqKtNJgUvg3tNaPe5vgwhCthKk85R/a/2T9RyanMWSRxeP
 4S2PuLRUxP7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="323995422"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 08 Jul 2020 13:46:07 -0700
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:46:06 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:46:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 13:46:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqQv+XNPPpPPxRBZ9LytB+u60YCpCzd4l+4SjB08NqMRElWvQhj1tMuRyUSxSrGX2FVL76NYFI2VDXkB63ccJzobl5lOdIs3nD6JrI0TvJ1n9urS3An43B26KtDMzwJcXjimFyxDEcglm/Sc3/CizE4gzrsRXA+D3US9eWDFwncAF3Ctt9qlpnEKwi1TaJ4bVHBvYfucrMnZqteDFV+hDA3JXGFWiPcnaTSrBsTESW6kzf9F+JrFbSiuIzcA6mhScigDzr8tRGJgY0+QBgcLD4K6KzqzCw2ObjBGj2I5txVJgnti2j1sew+lTE1kQuND23wS1/BFDTwQw6kdLDTtog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ba5pp3K1vTuQ0YfrhD4LUwV5dnxirZLLAZulx2dJtI=;
 b=W165HuN3tYxhzfBGxXN4qdOyhGcPzHLZvn9py2R6uICbAxxXLKlvnkE+cBFHcjbYrzqr4ygndxQSMnj4pKkdsBzRrwtDkdHJNB9Ue8SP5G2GBzvCSg1AU08+yPKV/lifua2Vq8EeAb31qffru2y8V2q1rVYA0Rvt9Ozrd/c6mNgYjncwuICANe9BPzlHemZODWxNc3gE+EuHcIT+XTG75csoXVoRwSufBkkvgXc4zN2jbGL8fWCOLYHhva83MDdiUnCYnSMfMzlfx7oH/RSzlfleU/GTcAbGzxkRahgi+wXcZxxSE0d8ZJEZBuATCvJ9Hjk4eJLP8gmFwixppGvIWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ba5pp3K1vTuQ0YfrhD4LUwV5dnxirZLLAZulx2dJtI=;
 b=l1xJ8OPVHI+hKd0xvS+quo6vivHckTnO3du6Ls7EEtfriyheYHhRMVGIVpQ1b+LGk/PVUQHa3MfRotaQiN0bZMtEBWNnjWK1ZpDDd5dxAKBEOmWnnwC3sVk4wh+BimtwjZWMb4eUXUaniIlt19IBoIXkBuTJXpOlRToJF3S5cR8=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2594.namprd11.prod.outlook.com
 (2603:10b6:406:b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 20:46:00 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:46:00 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: not compute affinity_mask for IRQ
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: not compute affinity_mask for
 IRQ
Thread-Index: AQHWT4aUJGy/NdGn2ECyZeiJ2wPy/6j+Mm4g
Date:   Wed, 8 Jul 2020 20:46:00 +0000
Message-ID: <BN6PR1101MB21459A2A4814EEE38E4B76918C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1593593693-31299-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1593593693-31299-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53455c03-2f07-469d-71d0-08d8237fec62
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-microsoft-antispam-prvs: <BN7PR11MB2594AEB0D73220383A807DE48C670@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:153;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTgaCXldkE/+SM+U0K0IYKpUebXTZyH2DzpmLEToiGDc+KDlm0AO6b9g/342UoCVHHhYJ5zCpThTAquxcS9pAdJDVep0ZD8jV2ga8bsdemWrJwUfuX9l+GxNynPThBSiTLITU3bHohsIWPovfi/26HtmBD91JWew+urDwrZ4luz6H3kJYIDRsfwTKByXtDHeT3F7FppciiIYhOQyc0wp1vYnmNJwSv+4pc+Bz/zG/9BJJmlje+QiNu+Tz1atVpY8LqpMNxH6XAhbowgfgkoU373rrxzSYWgylKdGH2iecPqYh4TmVI4qaROossnD3Ulw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(478600001)(33656002)(110136005)(4744005)(186003)(316002)(71200400001)(9686003)(55016002)(7696005)(64756008)(8936002)(2906002)(66476007)(76116006)(66556008)(8676002)(66946007)(52536014)(53546011)(86362001)(6506007)(26005)(5660300002)(83380400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Fztv4+uNBB23nVxYideIWnFtMuUCVSddc1VjeNSO2HdFdlcHdMvPlFav4nTgc+x6SyPtJmu0Ss/RjKr2Gbr/v/3x26fXlxM60ygGjdQTYUD5+T5PWNN9owxaWwouh6F4QwIrmzgUGnxiCM3W5z7lGxQvl7fr6HCO9oUuHLBCz0m/PxFAmk8JZEglX5wiTAdbcO4CFAa8NX5eMA6lk2YNxpvtBrl162/klIBIgMAL2sFRGSDltV0YWbNELSb4VjpdEWPGdFOSaB6+KabBRuxPGDTADeaQRKJEkZiAG2hRwxpsSTf3CXX10B/BZ3ZG7H69QTbyQ1P7fVhYpbAJS6m0pBVl62aVoexKsD2VWLmDZah3jVXDq0XHCuOq5czIXee4ZCVUZLfs14NKT44QpHdel8CFlX5dqFt6cQtzFOys6vhNroX6JI5/uteuwM8w4Cjc6jqYIL8dDBeJqYzuE2pOkRjxG8MPelI6pYTZW5IWfE8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53455c03-2f07-469d-71d0-08d8237fec62
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:46:00.5599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XvqKDcK5FJWhTR2He62kwj3VL8RSCyMtysqcAH7uccnaSUOAUW9MLlaXtFlOD2D3Gd+73oP2ow8+o1Xug3IfcSN0sC39SlgHG8SIT/oUaO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of L=
i
> RongQing
> Sent: Wednesday, July 1, 2020 1:55 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; intel-wired-
> lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] i40e: not compute affinity_mask for IR=
Q
>=20
> After commit 759dc4a7e605 ("i40e: initialize our affinity_mask based on
> cpu_possible_mask"), NAPI IRQ affinity_mask is bind to all possible cpus,=
 not
> a fixed cpu
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


