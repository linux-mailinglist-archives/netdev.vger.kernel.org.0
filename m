Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155C647141A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhLKOCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:02:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:31781 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhLKOCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 09:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639231365; x=1670767365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PbNknTQLUjFLa9J/p5Vwqm57PvSkqwyqzxEPFLuTu8I=;
  b=h4aZfx8lGDUB+8lFEB1KWbzlvREqKm57YV43L5iuDuZVsdCB1ULfJWdQ
   XskfpEp+utBYY264U6zte4feIXcdTYnkBqIKBTAvkWpbgYCjwtk7BO6Y2
   vQanQd2fOJII+0Cg0nRgukYNvqjBOncZfmSxf+uMO4u0bJF9yHC1sav3D
   zewSujN9jNhWgTCq4nIXEIcphTK9AQho02krAS/x7AoVFF0nLl3tHAkwZ
   n544ok/3HJ4syU5SmSKa2F2ioAQAvr8UEyRQDlo2JvjJSpbbTPq16PQBJ
   PRlcGfa7dsjTHSgfgvyy3yZzfoAcFjgUZ0wvp13R9map9BDJoH9ksAs7v
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="219221339"
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="219221339"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 06:02:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="517154863"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2021 06:02:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 06:02:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 06:02:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 11 Dec 2021 06:02:43 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 11 Dec 2021 06:02:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjTsv/GqXiNNbNWCrR9I8BDKjwRbg6qr/FKYRW3P0eQZRuCrkoWouy7Lsvm2Kd+nbQM9jlRTnHiVTZGtu5wCwUPhgMSMZT9mfk/DMsOVmYTR/g8u6L+1R1x5hqPSypS8wI9nNAa/OnEZWxpRUjxFLs0kYMIuVgSek892Njjdj5igliXVZLRqyTvhjwVLS06U0TcPR1gRMgaVQTBW6tGjBcNJzXlX0X6j5Zq5EuCnTrBWJWhqN5y314g8HHKAOqOabYm4lUDCWoV30qkkfgO224YLaj25KsmDA4v5llVY4I5XrYVlhvnpwShPY+mt09uJXBwD1KKsMYtAdwk1rGmpcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqxF70L/qmaVLHi/rFvODO9XDW6xfZAOFBDMg18JlMg=;
 b=fKYWNAR/U0tLYmgPc5fqWsXxlAEUYx+L3JSowt3udbcS9G0mWn6MtKK6N1RIA/ecaQcsMJeiR3/PGNbO3vERlNRRLwXIWSObuKXaOyRw3CMi15BNumQ5E64UJPfNNd6eQReGayAl5HNIEkE6+BmdBgV2ab3mkqXt0deEmIXcHrTMGIZXfeAIqu3oEMvebVsrUm2jGBufTIGxOZ9IehTJJ0MX8LslDlg3/thkOEFgXqVTSC/zMJvicWOvalaclqt+GJ8x8rXQRUu/heieS0u4xM20sGQVjJhSsjXdjbKVXte3Zhg7W4Lgvw7FdLTygQH0WneT29hh7ss+zwKW5Fn3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqxF70L/qmaVLHi/rFvODO9XDW6xfZAOFBDMg18JlMg=;
 b=sGiC5O6P/je2n6P94I5zTYUWVIui4leLP5w5uVo5MnYHaGVeXQORFWLR7YT1BUzcwR6iBz75+7x71I1FPkQFCWgmnL1KAx+niV1cFxd2s1QLYGZdz1cTpTzZFz5h6BqT4TOEoUt5fLKIIsw7HGnVBY/43BycEEUIdWxg2YuMPU4=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB4219.namprd11.prod.outlook.com (2603:10b6:5:14e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.14; Sat, 11 Dec 2021 14:02:42 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d%4]) with mapi id 15.20.4755.026; Sat, 11 Dec 2021
 14:02:42 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: RE: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
Thread-Topic: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
Thread-Index: AQHX7RBhnX+l/Z3pgUiTshD6FpbQWqwrghIAgAHS7DA=
Date:   Sat, 11 Dec 2021 14:02:42 +0000
Message-ID: <DM6PR11MB2780FAD51DA7C55ECCC5A835CA729@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-3-boon.leong.ong@intel.com> <87fsr0zs77.fsf@kurt>
In-Reply-To: <87fsr0zs77.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8c21583-69d7-46b4-8ca8-08d9bcaee643
x-ms-traffictypediagnostic: DM6PR11MB4219:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB42191C5F3639906EE5BB5E4ACA729@DM6PR11MB4219.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S8zn8FkUwVYsQyY3xehC7MWyDKmsCONJNigWrO49mEsOsCILLzmpiI8XXdUTKU6QDTK/WUjq66qpeYJj2ll6WkMMCemAEwPXUjORBVtS79522u3G0DZTPz65pxOgG5zjSLU2PDf37BHe60Mdscu0WfvfU7sBvY0QY4ce/js5IzPBabcwRqeFLgz1msF7SxQDXX/ObgpbBygqcPC/tliApgbG8UVVcOLofCqdMh9CSMz5LMQfTfONwVGXXsOW/QIk+VZ7+FLgLzYNZnXBasPnRtl57zl4SXxsI1TCxKTemmOD4kdohXAWQQ7e/74/Yvj2DtqNdnW2e2PYUc7tILFGRb+Wy9ZIFszieLzMc/Nha4mpFd1+W537ahGcL5LFFvWGagmXxUhjF6ZcbOBe/BzrCyLTeAq+ODqnlyCjY6SwNbUV+xUAjjI2Xki4oNKRL4vKBLvstkcAyM9r0olKxm9diUFMWAnxH6U043z6vM23ryvrypMECc7op9b82NDwS+2CcxmMBRwa4wDEqxU4gMy5ISuypSD23qLQThz/Wrod/jBpEu8uNcq/sk7LaJgEEf4aMGJ6JcFKCXMp04t9dNupozR6ttIU038GQin7BBEd3ajRQk1BjHZuZ8G7pjDgZy2Py0/IRIdDYx9VvD2iGPmE0l+Kwhish98TqpzglhT8PM53d79Ns3vI9gGt9qBsfU9+7uNCjzPoRgp98wAhnIfYwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(76116006)(4326008)(52536014)(54906003)(26005)(66556008)(66946007)(66476007)(64756008)(66446008)(86362001)(7416002)(38070700005)(2906002)(9686003)(8676002)(110136005)(8936002)(508600001)(71200400001)(122000001)(82960400001)(186003)(7696005)(38100700002)(55016003)(33656002)(5660300002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qCmXGZXonHDY+2px8xBNdG34ekI6AJUidwRk6plwTvNzYd8WJFtxtQa7Ao7n?=
 =?us-ascii?Q?/lik7fSqkgMHwLvJEjywRZP1ckeWotYA0pLC+PgL1UmkiGIWRguv4t5STCsW?=
 =?us-ascii?Q?vTYUg3RPSTUVf2lh0AS7/GaEh5iIWVqH5j7AuRcotP1WTOJkoFvNyK+N2Ny0?=
 =?us-ascii?Q?Y/LnuV7nol31XijoJOeo3GM5JAml3WkTLlqit7nLmuWwC/m87WPsGBRS2esZ?=
 =?us-ascii?Q?hHvc3Z2Agag/20MwBf+BUCq0iXnksjSlR9NHkSdU67EEu890teFU+BGa9Pqd?=
 =?us-ascii?Q?cyHiSdH2nateZML7uKYAVa4enrzoRfuzjHun6khm69szM7c78mikwkhaqhTg?=
 =?us-ascii?Q?SS/1Xq/y/YAw7aVvW0qG4HZv0HuAXhU73Dd62qUNAkxcCN11BE7FrBrECtgF?=
 =?us-ascii?Q?j3lBPXw4QbQEtx2/ZUR142PxvJdgpKyVjYti9fqtoUFZAlS9LcpL0vP24jPv?=
 =?us-ascii?Q?J/CxqI2OiO5Yb8gqelL1QvyRYVf5E/2GB2VGZAG9dYfea2+JSPi+comeg2KY?=
 =?us-ascii?Q?KBkoCRdRhkZv5cMhTyZAY1QgPj8dWkMUX/1A/JISzcQq4y9wNHQI52Eu4kek?=
 =?us-ascii?Q?Tq1mzE11CGQyiHMY1/rHgClWTiXEObn9vOYsz4mnC7YvPF+MC4oGjX/5xkd0?=
 =?us-ascii?Q?uZfMAMJsNXBmdJPhmlyUlVHMts2hoFlM5FPV254IhmHIhvc86VdHMjfb3ufW?=
 =?us-ascii?Q?FJm9viF/zCpwMqrY0oaO6jrEkayMvYkxMtwpItVtm7ye3eqUsF8nwTZNMluA?=
 =?us-ascii?Q?0NHhfi8bAAFf6OSAH56/+aPUH0q0FXuSd5fJNPHgGUNJdIbh0XJm26kaPWSQ?=
 =?us-ascii?Q?TTzCa1Rf2bV07qrwqjxarO0uCHGoxmYA6Q2k7viLJGaR2npTu0ZCdowRshiq?=
 =?us-ascii?Q?ectK6ALVFCADjP60owkiU9OIUE71QtLNfBmGEMLSiZLzvC9H6JzhDICe5t3W?=
 =?us-ascii?Q?pStnJ+MC+Mpxd+6a8ltud9jlUX5wQuc0CABGjgcl2W+9sV4y+8FSnUHDrToD?=
 =?us-ascii?Q?YCEJAGMD2kbBVLB2odmx7YU9ZBAOMOApEW1Cwrh69yu2SdoqcVMk26ARymot?=
 =?us-ascii?Q?VYQgAaeqfHjxR1Wf9vciFOscYYcATGIAUoWBarmAdBMHOmXqOyZMae4DFFos?=
 =?us-ascii?Q?if1FId2BYDc8daF85APY/PWc5h4AXAneCgrCHEWeBTEBCirplbHUDnvm6y0z?=
 =?us-ascii?Q?+c6efPS4cOOnqYiTCUZd9/UFIf7lPTrxJMG9hlDcLB5qEehayqesJXavyVTB?=
 =?us-ascii?Q?bZNcvNI8T8RikcSc2lyPIGw9xTYOYg+8eZUSGFLdhpASpcdxuV7Cj/K7YTIZ?=
 =?us-ascii?Q?ctQ3o+te68FptLA0ypHCum8jkSg9wEw78V6gCsQqidKuBHh9tOf5/HZx7vsX?=
 =?us-ascii?Q?k27EYrLtKoXJDTuwZr98XW5flroCPGaQCOU/ZqwT7dRVYNnyGk7xHwExozRk?=
 =?us-ascii?Q?j0qDsaSTGXDLV4ccveDHaAnEWTw3y6q8lvzhUkJeMe9YsWB61cwTGF7GWXQc?=
 =?us-ascii?Q?2nO92GyUNPmJBHRjIU/trC/DBPEBNN6lfJa2PpWgafN9MNFo+li1djeK97vf?=
 =?us-ascii?Q?P82IGWWzw3qtS2nJC4q/QQLIZNDWCsOgkxzNlBKyGS67MzduPBF3qXOp8nq+?=
 =?us-ascii?Q?IGC1TF1aJY+DIjqewJmHJcYuvFizcy55E/qmYDsINArPui82ZRwUG+GtytZF?=
 =?us-ascii?Q?tCW+HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c21583-69d7-46b4-8ca8-08d9bcaee643
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 14:02:42.2685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbwSu38dnSui5srsm7yxiwzCuAm9Li815QYUZMNroOvH04pZeMe4kFBqUT5Uf1hliNTtXVduPsxmRnqc3PgeU78x9O5e/HionplkK2v9MPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4219
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>[snip]
>
>> +	if (match.mask->n_proto) {
>> +		__be16 etype =3D ntohs(match.key->n_proto);
>
>n_proto is be16. The ntohs() call will produce an u16.
>
>Delta patch below.
>
>Thanks,
>Kurt
>
>diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>index 35ff7c835018..d64e42308eb6 100644
>--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>@@ -182,7 +182,7 @@ enum stmmac_rfs_type {
>
> struct stmmac_rfs_entry {
>        unsigned long cookie;
>-       __be16 etype;
>+       u16 etype;
>        int in_use;
>        int type;
>        int idx;
>diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
>b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
>index cb7400943bb0..afa918185cf7 100644
>--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
>+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
>@@ -759,7 +759,7 @@ static int tc_add_ethtype_flow(struct stmmac_priv
>*priv,
>        flow_rule_match_basic(rule, &match);
>
>        if (match.mask->n_proto) {
>-               __be16 etype =3D ntohs(match.key->n_proto);
>+               u16 etype =3D ntohs(match.key->n_proto);
>
>                if (match.mask->n_proto !=3D ETHER_TYPE_FULL_MASK) {
>                        netdev_err(priv->dev, "Only full mask is supported=
 for EthType
>filter");

Thanks for the suggestion. I will incorporate in v2 patch after we conclude
if the tc flower hw_tc interface used for specifying RxQ queue is agreeable
by community. =20
