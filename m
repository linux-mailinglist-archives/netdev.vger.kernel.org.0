Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5C62F0AD
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241852AbiKRJMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241786AbiKRJMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:12:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A08CB9C
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668762745; x=1700298745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FO7eXAi6KWNpMREs3pEfqGwRe2J4ehBmAmMqVude//I=;
  b=oEUwIzoset0n3KXXtMST34/RQszz+xa7bxKMPREN5ViKiuUr3hSKxdJ6
   Xg7c8shxzms/cTPeGMUl9X3v123L2zS3l2+Q8SE5vaPHbHwWv03ArOyo0
   QAJ10COVvuohMGIwc0ppb90dIe4MbyzQbQvQM0xilcnidUCASOAi72Qms
   SG7MT241lSnenW5g/mDL9mRotw01cSy0mJawO8D2QPnhnGHi+fnLKGlV3
   6LNMsa/FACkwOj/iRI7HjUCDzKGLE1Hpd/1k2zZPQsTM30pgY8imsGszy
   A5JC+XisVWzyC/sEEicopbDJ37mqTefEG8p8qqJTFU0Oxb1JhmFIHcFXj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="296458447"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="296458447"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 01:12:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="673138241"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="673138241"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 01:12:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 01:12:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 01:12:23 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 01:12:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE9ilkD7glEs+f8vIfWtHbGG3HHMsH2glKERCJhxRNuZz8seZVA094PS1ilcOqcWjJNcDJ13CAhtGZaqLd4K085qxLnmPeEPN5apkRJCptbG/u5PP8F9cCLFXkUKxvbVPNnh36sVsnX/hhWPmZSL/haMH9xFT9m9rCX8QbKSBBXJ5Arr5rIhw4hxRitTdOl4pd5AWncVgpRnp8wXas3kuYoSxOb1h6a2B1CgXOWh+OcggR8e/a2P7DKBEkMnut8/X0hJahzkHrg0JTgWvDwY3M+XOp7U0N5CQwjlwp5P1hUKj5SXMjh0KaRjTUxhsnGY02oLFnCbbV7vsE9ZSOVIGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbcGTJNuf3KrcaMps4u7NYuA5XLAjKl8Wo9Nd1EadNg=;
 b=SCOp/JFo3c6DePHDaHBxyDsjSc4TKHe4zmxwessQPsH9m47i0R4Osjw6sJS8LuwDl2V9gxVVS2QnXFzFBxwAAk8r9XC7QC/2BAAPoqCC2NYTlfuwmVD0JXwW3v7TVI0WRQzeWR2L/mPh+ENHAUHwf9uHujZlUwUARj6rUJUYB8224DHh5HiSLB3lG02p93qNRzORgoQVTDtoKe1rVfTLhmYLECGoyvXD0Hy9SUpI3TF6oVbWcF67iZGJ7gcFqyhoqSOf4XekgNWf+kMvs17j4yeCRQJAxjUQxrvLH+SfL4ad99bzQA1TjZ30Ltw3xgTm/ORNUuWLmyKxJy8hkDdMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by CY8PR11MB6844.namprd11.prod.outlook.com (2603:10b6:930:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 09:12:21 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::e5a7:740b:cc8b:7ff4]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::e5a7:740b:cc8b:7ff4%11]) with mapi id 15.20.5834.009; Fri, 18 Nov
 2022 09:12:21 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
CC:     "tirtha@gmail.com" <tirtha@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH intel-next v3] i40e: allow toggling loopback mode via
 ndo_set_features callback
Thread-Topic: [PATCH intel-next v3] i40e: allow toggling loopback mode via
 ndo_set_features callback
Thread-Index: AQHY+p/oS2Rx/vpGCUOQpluNeb5vp65EQhUQ
Date:   Fri, 18 Nov 2022 09:12:21 +0000
Message-ID: <CY4PR1101MB2360ADBA41DDF6BCCC91140890099@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20221116164709.9201-1-tirthendu.sarkar@intel.com>
 <20221117161518.3450087-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221117161518.3450087-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|CY8PR11MB6844:EE_
x-ms-office365-filtering-correlation-id: c3a3f677-00e0-47d6-7dd6-08dac944fff9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLEb6dxKZb2DUTkYxuLkRTytYwytlb2FL/BG3/2NiiZR9ozZrIeXuOLKSPg4+M97juHCJuYdhSvTfJIBIdcTNboABPIhs8W7ohvE6eNgQqxFW/rZ6K7TujGu2CGs6Myg+Y0ZsAcYr8gm+n8qw4klIh7Lg6hNJ9/jaaDMe/dq9bjlESkpg0MaoB3Rv2mHBXCCAoDdqCDlxsuwlRbe30KawRHuPjDth9jwwBHtcj9rkxmdK2I5ePGwzdgQ8Hm//6d8ejwcsFCPEdShGqB7xYrUIymYf+O2fRyctPqNr1JKeSbqVy5wmkPHLacUTfGg/08BOhvVZfJONd9TKK4LTUKP5BvqQf2u+ZbSd+qxv+0c9TXo8+dM7tCyuQgOpkpDbAah2tnCettOTGL1Wo6uC+Dlhe2ODmueBVBdzTtXOmbeHwB6dSqo/0HuQhZI0PnX7BxRBqzWTEIn25btjAM1U7mlLoDo647tFY8H2JJGM6k8qdzaqcoqHekIXTm+rSKdznH1IrZuPeyuZ13MJVHHJg0zd84pcuTSAuISUwisKMNInGVcnIp/EuAmUbvFmplCfHcBITdrUn/0mqgnifK6YTr4QkvJzhoqzU1PFoTCIYp9m3rhyM3M18nF7+CthczrbjX5ErIDqoFJnCsN+4V4NfoVidRToPrxYe1PsKmQNiHj3cmm6FAs7CnUc/qLsOArZiCTZBqnjwxHu89P/tG5MTfBNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199015)(54906003)(7696005)(26005)(9686003)(6506007)(186003)(6636002)(66476007)(4326008)(66446008)(76116006)(41300700001)(66946007)(66556008)(52536014)(478600001)(6862004)(5660300002)(64756008)(8936002)(8676002)(83380400001)(2906002)(38070700005)(33656002)(86362001)(38100700002)(82960400001)(316002)(71200400001)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ll+30a9CCY0pnYPNjCtEGzpB5aZ0ZcFSc6N5GB/E4+OpUI5ryTZQ7eSvSFRR?=
 =?us-ascii?Q?ufeThxZ/gCmjYlz2/WmIh08tZ/LXFsqpiYVRoK47SqragasLsx4H1H8jWPSK?=
 =?us-ascii?Q?vODQPahaBqz/bmi4qRn5J7vY2K1g5RAT5nBuEFK3gJXHhHxfwURvXfDFvidw?=
 =?us-ascii?Q?dahhvzb1gUXalTeVNhFEn7DnHsdk+IMw3plarEv5cjMPxdzZfiHFYQFOjENX?=
 =?us-ascii?Q?9tFK8cHzppqL5QnuwICWC2ThkLps0dre52cks7O2iGX3oGrRBd9m4+gmYF5t?=
 =?us-ascii?Q?GlLp+bxfjtRYIRW/Iz7YWwOlD3ZsdThMQD70nTpY+Im3iGjKX6qX+iOdxWrE?=
 =?us-ascii?Q?njegZrgvHj0AdkCBUR+8Ff8SE9EtE+Sclh+yfESNSx83NBvv4pYebmiIzJoX?=
 =?us-ascii?Q?9tu+F5yKuFjja8FN10HOHMUfcbWNPs1jUkiHcmAaSfixg2ridruBMf5t+KOS?=
 =?us-ascii?Q?0HMgxB3qV1X/+H96oiA3PqeTmuV6y2S/YZO+IGRdtLdDHRn/LnlXDeCC/IJ3?=
 =?us-ascii?Q?VuXIDGwAYa4P+ciYB68gs+caLz+9lJXL6gBa3cfNMVSsy5lYYeRJSs/KA/F9?=
 =?us-ascii?Q?GxwzaOK5EaqTovEJqizl+2dAMF5aIuVtB7X3hM2wfqGcLzspdbC3Tj8sKdS0?=
 =?us-ascii?Q?5vT0Oo6z9f7DkTUyGdo4qqT+vcNvWxjDECm8R/KtC/9Cy2Kwtuy7wdRlID6l?=
 =?us-ascii?Q?IVnkB5r4/DiqGt5FDYdeA6NkJfW68a54uU31emilx6BnUKI9LuiEXyZagJCv?=
 =?us-ascii?Q?IRu+RDsCl2Dc3yATslyF3i87hbaljFVnMEmceTlYqwfnaltlbOV3Ygap/fma?=
 =?us-ascii?Q?Fpm5vHkU9DMbhyMvJv0Yn940f4aSuPaXhB+t8KCS9VoLI9VuUXSOMTzfELpH?=
 =?us-ascii?Q?fXByrxqwYN9xILdEhOzAcFgvY2Chs5RWoid/XqasH0n52Ji+j+ABZXaRuGqx?=
 =?us-ascii?Q?rEqIIUwPyrQilbBBEWD63YzC8ypl7ymTtclAnA3FrKpqf/eRrOHN2/rt9BE0?=
 =?us-ascii?Q?tO+cqC/ATcgToKeS1+mmU/2Pd72dmtc7zBhiWLEv2cNR0cHK27Li9DCeB+tT?=
 =?us-ascii?Q?5F5Dr1T/kl6+I6jBww+u0Lxe3EAN1A3BOPinxPb+HJm2rMBmiLmtR+f8RDIP?=
 =?us-ascii?Q?XjkF509Nd4h6qQfMLZ0C4NWT5CbanKVp3y2ch7sOw4FDV4pabnUjEg3/EWfR?=
 =?us-ascii?Q?EdlfoJ9o1LcZXD/24MimynNqNmgAeOklEvSZWA4FA7Zeucgq4t/ONwXMCUfR?=
 =?us-ascii?Q?8ZPOWm6ow8PGEJEol0QRwcUKstPr1EuInDCvzQr6IyOgZZucP7TONNhP5j6f?=
 =?us-ascii?Q?I+uS1yFlvhWF0DF1HRHjmjXLKycY2ox6xPCRjfvSfmmNpl1K026paA3Av7uN?=
 =?us-ascii?Q?xoousHuLTTyN8myKONTcpxO2C3JKB5UvBZaW13jZXdepOeVVgYf1k4FoZtgr?=
 =?us-ascii?Q?vB9c1lW1Pu6rUW9ynifU2f9fhXRQXo5MVXtxlP7QEDkbNwLJ2VhuVhNdrU1w?=
 =?us-ascii?Q?SqXOSDeUAe7H+38HkWAgj7iCKOPdGg8qqLHGyztp/ZbhEyqfBQ/PakygAwy2?=
 =?us-ascii?Q?LRcRRIeMtzlx5+B1jVECaNUCixvZa5B+mG9UyrwVQxL8DrxPHYwEFgUdJCqU?=
 =?us-ascii?Q?8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a3f677-00e0-47d6-7dd6-08dac944fff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 09:12:21.5377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxD+sT2jB+8kRVft9ZkCAtVRZuH3D5QXLt+9bCjLpTFLYXNnzUlBr6TyYvLKr6FM5YLYkNEbiAC9Kmh1QspSiNSjXpqOsGHz47yN4IjNWNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6844
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> Sent: Thursday, November 17, 2022 9:45 PM
>=20
> From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> Date: Wed, 16 Nov 2022 22:17:09 +0530
>=20
> > Add support for NETIF_F_LOOPBACK. This feature can be set via:
> > $ ethtool -K eth0 loopback <on|off>
> >
> > This sets the MAC Tx->Rx loopback.
> >
> > This feature is used for the xsk selftests, and might have other uses
> > too.
> >
> > Changelog:
> >     v2 -> v3:
> >      - Fixed loopback macros as per NVM version 6.01+.
> >      - Renamed existing macros as *_LEGACY
> >      - Based on NVM verison appropriate macro is used for MAC loopback.
> >
> >     v1 -> v2:
> >      - Moved loopback to netdev's hardware features as suggested by
> >        Alexandr Lobakin.
> >
> > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > ---
> >  .../net/ethernet/intel/i40e/i40e_adminq_cmd.h | 10 +++++--
> >  drivers/net/ethernet/intel/i40e/i40e_common.c | 26 +++++++++++++++++
> >  drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 ++++++++++++++++++-
> >  .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
> >  4 files changed, 63 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/driver=
s/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> > index 60f9e0a6aaca..7532553a6982 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> > @@ -1795,9 +1795,13 @@ I40E_CHECK_CMD_LENGTH(i40e_aqc_an_advt_reg);
> >  /* Set Loopback mode (0x0618) */
> >  struct i40e_aqc_set_lb_mode {
> >  	__le16	lb_mode;
> > -#define I40E_AQ_LB_PHY_LOCAL	0x01
> > -#define I40E_AQ_LB_PHY_REMOTE	0x02
> > -#define I40E_AQ_LB_MAC_LOCAL	0x04
> > +#define I40E_LEGACY_LOOPBACK_NVM_VER	0x6000
> > +#define I40E_AQ_LB_MAC_LOCAL		0x01
> > +#define I40E_AQ_LB_PHY_LOCAL		0x05
> > +#define I40E_AQ_LB_PHY_REMOTE		0x06
> > +#define I40E_AQ_LB_PHY_LOCAL_LEGACY   	0x01
> > +#define I40E_AQ_LB_PHY_REMOTE_LEGACY  	0x02
> > +#define I40E_AQ_LB_MAC_LOCAL_LEGACY   	0x04
>=20
> Do you need any of those, apart from MAC_LOCAL{,_LEGACY}? I think
> it's better to keep only the values you actually use.
>=20

OK, I will remove the rest.

> >  	u8	reserved[14];
> >  };
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/ne=
t/ethernet/intel/i40e/i40e_common.c
> > index 4f01e2a6b6bb..8f764ff5c990 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_common.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
> > @@ -1830,6 +1830,32 @@ i40e_status i40e_aq_set_phy_int_mask(struct i40e=
_hw *hw,
> >  	return status;
> >  }
> >
> > +/**
> > + * i40e_aq_set_mac_loopback
> > + * @hw: pointer to the HW struct
> > + * @ena_lpbk: Enable or Disable loopback
> > + * @cmd_details: pointer to command details structure or NULL
> > + *
> > + * Enable/disable loopback on a given port
> > + */
> > +i40e_status i40e_aq_set_mac_loopback(struct i40e_hw *hw, bool ena_lpbk=
,
> > +				     struct i40e_asq_cmd_details *cmd_details)
> > +{
> > +	struct i40e_aq_desc desc;
> > +	struct i40e_aqc_set_lb_mode *cmd =3D
> > +		(struct i40e_aqc_set_lb_mode *)&desc.params.raw;
> > +
> > +	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_set_lb_modes);
> > +	if (ena_lpbk) {
> > +		if (hw->nvm.version <=3D I40E_LEGACY_LOOPBACK_NVM_VER)
> > +			cmd->lb_mode =3D cpu_to_le16(I40E_AQ_LB_MAC_LOCAL_LEGACY);
> > +		else
> > +			cmd->lb_mode =3D cpu_to_le16(I40E_AQ_LB_MAC_LOCAL);
> > +	}
> > +
> > +	return i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
> > +}
> > +
> >  /**
> >   * i40e_aq_set_phy_debug
> >   * @hw: pointer to the hw struct
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/=
ethernet/intel/i40e/i40e_main.c
> > index 4880b740fa6e..1941715b6223 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -12920,6 +12920,28 @@ static void i40e_clear_rss_lut(struct i40e_vsi=
 *vsi)
> >  	}
> >  }
> >
> > +/**
> > + * i40e_set_loopback - turn on/off loopback mode on underlying PF
> > + * @vsi: ptr to VSI
> > + * @ena: flag to indicate the on/off setting
> > + */
> > +static int i40e_set_loopback(struct i40e_vsi *vsi, bool ena)
> > +{
> > +	bool if_running =3D netif_running(vsi->netdev);
> > +	int ret;
> > +
> > +	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
> > +		i40e_down(vsi);
> > +
> > +	ret =3D i40e_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
> > +	if (ret)
> > +		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
> > +	if (if_running)
> > +		i40e_up(vsi);
>=20
> You do i40e_down() only if %__I40E_VSI_DOWN was not set. So I guess
> you need to do ifup only if you did ifdown. So I think the function
> start must be a bit differen? Like:
>=20
> 	if (if_running && !test_and_set_bit())
> 		i40e_down();
> 	else
> 		if_running =3D false;
>=20
> To not do an ifup when it wasn't you who did an ifdown?
>=20

This was done similar to ice. I have now modified this.

> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * i40e_set_features - set the netdev feature flags
> >   * @netdev: ptr to the netdev being adjusted
> > @@ -12960,6 +12982,10 @@ static int i40e_set_features(struct net_device=
 *netdev,
> >  	if (need_reset)
> >  		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> >
> > +	if (netdev->hw_features & NETIF_F_LOOPBACK)
>=20
> Isn't that condition redundant? I think you add %NETIF_F_LOOPBACK
> to ::hw_features unconditionally, it's always there?
>=20

Ack. I have now fixed this with correct check.

> > +		if (i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK)))
>=20
> The double negation is redundant as the second argument is bool.
>=20
> > +			return -EINVAL;
>=20
> Why don't you propagate return value from i40e_set_loopback() and
> return only 0 or -%EINVAL? If you don't need the actual return code,
> just make set_loopback() return bool, otherwise
>=20
> 	if (changed_features & NETIF_F_LOOPBACK)
> 		return i40e_set_loopback(vsi, features & NETIF_F_LOOPBACK);
>=20
> 	return 0;
>=20

Have fixed this.

> > +
> >  	return 0;
> >  }
>=20
> [...]
>=20
> > --
> > 2.34.1
>=20
> Thanks,
> Olek

Thanks for the comments.
