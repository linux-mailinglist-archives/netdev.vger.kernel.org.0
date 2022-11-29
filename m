Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73BC63B69A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiK2AZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK2AZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:25:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0185510FD7;
        Mon, 28 Nov 2022 16:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669681535; x=1701217535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aE8hYB4SEtgfalzt3rXqtUeZ1RlZKt2dSK8LEstJX80=;
  b=EgyT20w+FmVvCRXsIVBi7RLLfnVe5DgGIdFYN/5DaVbspHC1rNHtB06w
   qzzPfjqtLatDNHyBK8nxVANPpJHmShANzxx5dT1+1OVzYCvkjzuD2TJ3y
   dy5F5PD27MlTn+H4doFsMxYc0sdQphZ9ZVPHRToaCuDE7NPSA1l8NgbSY
   KPBEVLJ7O2/NVrO0QctQNlP2KI6iyUNn0QK5vUDSqRe3rJJ5S+J0oHIJn
   /y+pBsrdIXaOFI3OAbBnmvejEKwUhpL7uy9IzlS4aJLUGrFYPe/3lZoZC
   nPwIVTne8/+JD6aucxm90F+/fFRpLf0xPmZKalncCD8GW41aW6jQOFsVy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295360786"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="295360786"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:25:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674424418"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="674424418"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 16:25:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:25:30 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:25:30 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:25:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzW6qD32y+52i6uirykA5OKW6An0A3jq3SblFOd0FghVgxI/C5FYwMFr+8NsmuQ0Um/nhLY8x5qR6Fs4gn/6ggEnP2CSb1WXcOPfiFnxuP4CCvVa+e2yCMoFEFcuwP9+fKPfo5GaQg+nfF0uQX02ofCjBdwICCSkGZWSCBXmLbvNWUcAtR4k2Gzfn9MCwa1UDOkQzHXPatRNZNtpjKmjoUuwt5eRIC/ycsHlhvSi6ykxPPF2OKxtaIdDtJzmkhmAnFLfcMrh7HnM6p/JqOPU593/2taUOuHs8Hgx11yV0W67BowZiwL4Bl+Lp2K2KU/iGwSxAfYzMQ8SskRt2UWCqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sW2syLRz5zXFEEn97NuTRY1CKFbMnAyV8koBwfw8U4=;
 b=QrLrfqlBr7JtzQqYx9XtzyBufqDItv9fEMVlOURqv8TdMfehPPxnCrsiQwboYUtyZ0uHyBLPfwyjxGsrDTmdofT7qaR3Ycczr2nDG0eWBw/IcoSfTnkzlj9kndsYeW4yKte0TUz835Ip88ygtzw6D4mVOsQhe41GkpIIV16ew0NWTkZtS7NpFs+kaUf9PLdYe/aHJiv0NMN5eo5tiHsbZwASIMlR84N8RBFsZMWMkqdhNaw6GYnvibgG2OFTpC/Th84fY9k9BqhEVmbF0UfTBpJrHUTVv+th60zE/MvY7QjkBgL5bHeAvSJ3pBucSTzE8r7fBeQccotxaxuPTz1m6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6165.namprd11.prod.outlook.com (2603:10b6:8:ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 00:25:27 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:25:27 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Boris Brezillon" <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Dimitris Michailidis" <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        "Jerin Jacob" <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        "Shalom Toledo" <shalomt@mellanox.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Subject: RE: [PATCH net-next v5 0/4] net: devlink: return the driver name in
 devlink_nl_info_fill
Thread-Topic: [PATCH net-next v5 0/4] net: devlink: return the driver name in
 devlink_nl_info_fill
Thread-Index: AQHZA4Zt5jz2jKTQ0ESKFphYbcYB4K5VCtug
Date:   Tue, 29 Nov 2022 00:25:26 +0000
Message-ID: <CO1PR11MB50891004D6603019D2920DDED6129@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DM4PR11MB6165:EE_
x-ms-office365-filtering-correlation-id: c529a1e3-aed9-4d2d-c7f7-08dad1a036b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SepPLQpTaGjgVppRQsPmW7V3ByvVDt0POnIxgLrVfWaE0yQx5l48adUxR9f1HNY0Bxa1FoxR4nLUuL+U2ILTc7Hx7/nE8zS9WLK4bN0ybnTZGqsKe4hdW71cFM9A24EPKZLq34s9Ls9pSSunnwptsozvvCHE7uDy/lMp2NmWWiPm5fyWUd6zDlF6dAD2QWQjpyNYXUjSb1ePaMLzO/j6QSHq2eeJnfON5C68vemALJ9ANccFyvXLI8MFadYlTkxcuVQqXb1ZjjKQ5kGnJ4GjXgPW6nKuh4ITEXyu8DFqNiVhV/S33HN2bzNeivFhea9HTO8WEPprkOMw8mhBX8iSRIeTcNrdcpuAInti9ug9TUZnbovKjf6UHWKJLqF//bVcm7r7dCDA2yqTGPs3hWGjm8ghHVuC+uyTS54BiNRPsae8kt3b8Q2WRsWX4WK8I14dt4/U4jpdPmeMtmuGFsecQbHcnSBO6iw6B7w6vAwUxVrQNHNn7jPJEHN/BFmHDG4Z8aQXgnZZn5pNUDvQPNDPNSIWRd2lbc9QIAcGWjavNHQHKw9eeY5+mpnHsp4A3L173G5KFya9YzmTmbPjguSLBrqoVpeK353Iw6oK/Md1T2sPq/AJRo3yX5obyaPsxFs5wM1CyInIDhuOnyEyAs/2jGD+YIn/nP7+Zu//QQN7cUXAChoDwJ7f/9GMv8zBK5gc8+NblVpWHqQAn1N7SwbTRU4C86/F/tX90pOjjhAS0SR+03wYG1BYPdQNwEauJarkA/GXr3UbWwlHBNnwbMHO2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(71200400001)(966005)(478600001)(26005)(9686003)(6506007)(7696005)(53546011)(55016003)(86362001)(110136005)(5660300002)(38070700005)(8936002)(52536014)(54906003)(186003)(4326008)(8676002)(83380400001)(316002)(66446008)(76116006)(66476007)(66556008)(66946007)(64756008)(38100700002)(82960400001)(7366002)(7416002)(7406005)(2906002)(122000001)(41300700001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v/ikFB2bxypZMLBr45Jh5cYHb81xXA8nXsDpPv4aZfIS7j1YdxPxPUoUfth/?=
 =?us-ascii?Q?LNOkfDr2TrXLx0y8E/Zqs4jhl/APBhc2B2gt1kEiWnJ9JzHKZH7UW0Y1dBEQ?=
 =?us-ascii?Q?5B5KUWIot29+EUbSRATYQdXHT0hzBcG8UVTGiPeeIBAKExUbl3dgLyd9Lr5e?=
 =?us-ascii?Q?My9aA4rjihCyroTFOcdZyCmzoamCgKK+V/cR4LbBAFi0cEbFFRDPvrkE1hk/?=
 =?us-ascii?Q?BtKfG2ldUJWIdaurP2ELiRyEsEz8qPYFs/JjuLRcTuVNBkxdMSTstdM1IHHV?=
 =?us-ascii?Q?a13tIsdFrPsvuuGLMKY8hCXWT60WD9DQtjxeDO5sM623gLGec9gkwykXGq2S?=
 =?us-ascii?Q?MsC5nLHgThGAPI2gQSlwslz8xFTvNc/YToph6zPRT/j0a2n1mIm/V2eSwnjp?=
 =?us-ascii?Q?9FvXUJXELsG1auPw8GfvVyU1TfGTTSg0qLOiWDZBp22MY//2sxUmx50t4xXf?=
 =?us-ascii?Q?FghOGCoYY7T0JPmU7um++bE/vwkMykyeqNkQQF32mauPmrDVbcmr0dwKU5m5?=
 =?us-ascii?Q?U9TMyiL9nkELUzOhcesxmZrOx5fDJyZYAyKVFGRNE1WOPg5nkHBV1N53pX/V?=
 =?us-ascii?Q?mnV8RO5/yms2YNRqZQrb9yqmS1s+dBJfyAmIyebnSL2YtofTGd78IzkA2J8k?=
 =?us-ascii?Q?e+5yxO4xPqFFa8NZFk6ZFhH3wrR9YV2/yFerv2Nso0b/lgvl8HJXYyKibvBU?=
 =?us-ascii?Q?HiKU5z//36abJ5uA4E3EdwK/4YliO6qIrpOdTwxTNlhZmlE3CGFfgTkV2JTI?=
 =?us-ascii?Q?sNmODte5z9BMUX8otI5aEvPR69nIey6hn/fWnx0FlbfUhsoWKYdBJp69OQdx?=
 =?us-ascii?Q?bjgFXzVJ1eNgi+vG5xS10IistW0pR5PejDudOTGVyEU+4tNbt+kVmyTLlY1q?=
 =?us-ascii?Q?YpRW3je14dvYmsVaLf4SAM+8WQqlJmqJQI4Sr7/LLru85CCRjpQJmcm2Bfq/?=
 =?us-ascii?Q?1sZmchreRF7g9mpN1Kgt6/nohOQMIIk0i0tu6wuGYXDISTyJ8HtlhnqR1nek?=
 =?us-ascii?Q?Ivjw1x6LleA6r0qiKsWkf/gZVb1sUgoUNLVTTdee1EWGKZwGPT2f8tDqMLxI?=
 =?us-ascii?Q?sG1JM620JYgQSwnG+LoXfFIoVbPed1uODKOPgcgv7OeSs5+06bVeij9RjnLn?=
 =?us-ascii?Q?GtNMypAwloXjZRm2WS50xQfJlMVzFKspKsa5F2tkSpQsystcgUZiPtk2VPzg?=
 =?us-ascii?Q?1/ZZQT4HRQmmZNQdlw2lCQJ5HquLPd/IvrB7W8luslVTL9R98r53ZKRvV9Lw?=
 =?us-ascii?Q?Kp+Md3xuz2CnJda5XXwqwCYJJQYJHqUCbtw2+0S+vyjBP5LdK+Jf15kWobC3?=
 =?us-ascii?Q?c4z2KEuTQGllrWA1SnL+NFb489c/lZkxS/bRPn9uP6vpoXM8MDtK5wm3SGXs?=
 =?us-ascii?Q?ROrA+//7SnLtsbxU46qOOKBsb56BH30tBPH43lwc4ZHuEIn2lKvh/rnv+NTc?=
 =?us-ascii?Q?EoXEM3Y1aY1XtFb++XdZ0+4BuWc1ZJiD2urdv0BiBvDwHlvS98xXWtyPKm7Y?=
 =?us-ascii?Q?hIuVLfPaXF1V0VgccWNlY6ptvgUtjunJff+eN1xSlobQL2m8z3H7Os9b9NlQ?=
 =?us-ascii?Q?7ePlosz1Wbb1YPvJeJZgAp8/bxgmA+n1yeNy4rK2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c529a1e3-aed9-4d2d-c7f7-08dad1a036b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 00:25:26.8995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnBB1QQ0o674NgKEefT0diO4Tn07YsZAhKpXGKzHoO1ARQ8E/AZv6NlFY9CKt2XMOec195zo0QRZGgrTXWnwQEzDWQMEVTijRjFOQj72Crw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6165
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vincent Mailhol <vincent.mailhol@gmail.com> On Behalf Of Vincent
> Mailhol
> Sent: Monday, November 28, 2022 4:06 PM
> To: Jiri Pirko <jiri@nvidia.com>; netdev@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>
> Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; linux-
> kernel@vger.kernel.org; Boris Brezillon <bbrezillon@kernel.org>; Arnaud E=
balard
> <arno@natisbad.org>; Srujana Challa <schalla@marvell.com>; Kurt Kanzenbac=
h
> <kurt@linutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
> <f.fainelli@gmail.com>; Vladimir Oltean <olteanv@gmail.com>; Michael Chan
> <michael.chan@broadcom.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> Dimitris Michailidis <dmichail@fungible.com>; Yisen Zhuang
> <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Sunil Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geetha sowjanya <gakula@marvell.com>;
> Jerin Jacob <jerinj@marvell.com>; hariprasad <hkelam@marvell.com>;
> Subbaraya Sundeep <sbhatta@marvell.com>; Taras Chornyi
> <tchornyi@marvell.com>; Saeed Mahameed <saeedm@nvidia.com>; Leon
> Romanovsky <leon@kernel.org>; Ido Schimmel <idosch@nvidia.com>; Petr
> Machata <petrm@nvidia.com>; Simon Horman <simon.horman@corigine.com>;
> Shannon Nelson <snelson@pensando.io>; drivers@pensando.io; Ariel Elior
> <aelior@marvell.com>; Manish Chopra <manishc@marvell.com>; Jonathan
> Lemon <jonathan.lemon@gmail.com>; Vadim Fedorenko <vadfed@fb.com>;
> Richard Cochran <richardcochran@gmail.com>; Vadim Pasternak
> <vadimp@mellanox.com>; Shalom Toledo <shalomt@mellanox.com>; linux-
> crypto@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
> rdma@vger.kernel.org; oss-drivers@corigine.com; Jiri Pirko
> <jiri@mellanox.com>; Herbert Xu <herbert@gondor.apana.org.au>; Hao Chen
> <chenhao288@hisilicon.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Minghao Chi <chi.minghao@zte.com.cn>;
> Shijith Thotton <sthotton@marvell.com>; Vincent Mailhol
> <mailhol.vincent@wanadoo.fr>
> Subject: [PATCH net-next v5 0/4] net: devlink: return the driver name in
> devlink_nl_info_fill
>=20
> The driver name is available in device_driver::name. Right now,
> drivers still have to report this piece of information themselves in
> their devlink_ops::info_get callback function.
>=20
> The goal of this series is to have the devlink core to report this
> information instead of the drivers.
>=20
> The first patch fulfills the actual goal of this series: modify
> devlink core to report the driver name and clean-up all drivers. Both
> have to be done in an atomic change to avoid attribute duplication.
>=20
> The second patch removes the devlink_info_driver_name_put() function
> to prevent future drivers from reporting the driver name themselves.
>=20
> The third patch allows the core to call devlink_nl_info_fill() even if
> the devlink_ops::info_get() callback is NULL. This leads to the fourth
> and final patch which cleans up the drivers which have an empty
> info_get().
> ---

Reviewed-by: Jacob Keller  <jacob.e.keller@intel.com>

I'm fine with keeping it 4 patches as-is. Thanks!

> * Changelog *
>=20
> v4 -> v5
>=20
>   * [PATCH 1/4] add Tested-by: Ido Schimmel tag.
>=20
>   * split patch 3/3 in two patches.
>=20
> v3 -> v4
>=20
>   * Ido pointed out that the mlxsw did not need to be fixed:
>     https://lore.kernel.org/netdev/Y4ONgD4dAj8yU2%2F+@shredder/
>     Remove the first two patches from the series.
>=20
> v2 -> v3
>=20
>   * [PATCH 3/5] remove the call to devlink_info_driver_name_put() in
>     mlxsw driver as well (this was missing in v2, making the build
>     fail... sorry for the noise).
>=20
>   * add additional people in CC as pointed by netdev patchwork CI:
>     https://patchwork.kernel.org/project/netdevbpf/list/?series=3D699451
>=20
>   * use the "Link:" prefix before URL to silence checkpatch's line
>     length warning.
>=20
>=20
> RFC v1 -> v2
>=20
>   * drop the RFC tag
>=20
>   * big rework following the discussion on RFC:
>     https://lore.kernel.org/netdev/20221122154934.13937-1-
> mailhol.vincent@wanadoo.fr/
>     Went from one patch to a series of five patches:
>=20
>   * drop the idea to report the USB serial number following Greg's
>     comment:
>     https://lore.kernel.org/linux-usb/Y3+VfNdt%2FK7UtRcw@kroah.com/
>=20
> Vincent Mailhol (4):
>   net: devlink: let the core report the driver name instead of the
>     drivers
>   net: devlink: remove devlink_info_driver_name_put()
>   net: devlink: make the devlink_ops::info_get() callback optional
>   net: devlink: clean-up empty devlink_ops::info_get()
>=20
>  .../marvell/octeontx2/otx2_cpt_devlink.c      |  4 ---
>  drivers/net/dsa/hirschmann/hellcreek.c        |  5 ---
>  drivers/net/dsa/mv88e6xxx/devlink.c           |  5 ---
>  drivers/net/dsa/sja1105/sja1105_devlink.c     | 12 ++-----
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  4 ---
>  .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +-----
>  .../ethernet/fungible/funeth/funeth_devlink.c |  7 ----
>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  5 ---
>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  5 ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 ----
>  .../marvell/octeontx2/af/rvu_devlink.c        |  7 ----
>  .../marvell/octeontx2/nic/otx2_devlink.c      | 15 --------
>  .../marvell/prestera/prestera_devlink.c       |  5 ---
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 ---
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ---
>  .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 ---
>  .../ethernet/pensando/ionic/ionic_devlink.c   |  4 ---
>  drivers/net/ethernet/qlogic/qed/qed_devlink.c |  4 ---
>  drivers/net/netdevsim/dev.c                   |  3 --
>  drivers/ptp/ptp_ocp.c                         |  4 ---
>  include/net/devlink.h                         |  2 --
>  net/core/devlink.c                            | 35 ++++++++++++-------
>  22 files changed, 26 insertions(+), 130 deletions(-)
>=20
> --
> 2.25.1

