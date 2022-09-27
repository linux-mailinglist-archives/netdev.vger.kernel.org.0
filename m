Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DBE5EB83A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiI0DCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiI0DAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D405F78;
        Mon, 26 Sep 2022 19:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247533; x=1695783533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WMZNwx0jMxWh+fLXsCafpUwYZTH6pOAfyIT4Ti0d3sU=;
  b=iXvL+43+7Eh5k4+pJ+Hvq/8IgF8wJfLt+lN5uCWIDDjEyRCm/C9hCWJW
   jFgUermP7lHccQVv+7ik+ldCW7Dvr9MivOhoS2mIDW5Adga8AYP/bJ3uP
   w2lp4++PMcXL0dcHXOUTT2KiUQHkLkHcBBV1Jw++M74L1P4KNZy0lNKsO
   Tb8XYG073HpsZH+GN7rvpOHO3M7DcJ/9LuwCBZI9pfTfRm9PGpCJSoeVG
   BPg54ddmwEIpSp8+ppVrAveqSqYJnHO3l8Ga5q21U3yFAGYcmFJLWn+s4
   1B2srGQgFnE2/YcHftfHfxqof69HzL2viaTqgQhi/PW9lCCoZRr5MLa5r
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="302105920"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="302105920"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="621343956"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="621343956"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 26 Sep 2022 19:58:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 19:58:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 19:58:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 19:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtOZ0HIQux+oSVKSwT1NlrfqCxJfmFJeZKQTaff2eWanqdSyqZ2ane/dBa8e6/oJ4GDpKqja4ik5TDSGSQvjiY5RYFOHdy2M71EZpUVxaL8kRUHLLbxe9gw7py1oDEeJJk99hNoK3zap164JAztmzOBMAvhSRz8LgZbeu8061oW4qYclBEqxB7i8udBynWI8V6tVoJCEx0H+VTOAGRKXQ4XDsLqCPvKXQg/oTee1AEajIFHBKJDkyx9/wfyl5JRWTYabkLp4CVE/ZlN7uYJNvwcW7jMpV1o/0aFMWYRHlJs2LBwlTg7skHL5WF3o4hKfpwjMxBCL9rjx8s/TmIhAiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmJXEi2pa6/tK1aqfzLnDU0eudwd+/X6S7tFtNjHv+g=;
 b=V6I8F4ZISHOAc1Fck0qNumByN7TTerTHfe6KHKLJzsQnQIOIcQZRinDO6KQSjCT8qzpo0MAYmh4gsRdoReOlr4K/ac7aCSOr8QNPqFMs1Lrc7i6Q1z0aBvhxTUM+nwMi3rNSTNKG6qj4QJ6BcO6bONmgtwRZfB1eBozpYohGMhY4dAJZm/RGO6KV7i2dWFRxLzwW6fPC9XS6ZcJP0HPzY0QYTEbSFjr6QOc0xm1X4sa9FIJN1AYf0XUANPLxXryeQv/EfAsCTxK4dOhKQWfX5Q2wsPGRgENAjiFgtN+VX8znrSb2EQ/AZ+MkPsXDHJUGW79isJbLuMCtRXBlmaKDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by BL1PR11MB5384.namprd11.prod.outlook.com (2603:10b6:208:311::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 02:58:50 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::8943:7a27:bfb1:329a]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::8943:7a27:bfb1:329a%7]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 02:58:50 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "Sokolowski, Jan" <jan.sokolowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
Subject: RE: [PATCH net 3/3] i40e: Fix DMA mappings leak
Thread-Topic: [PATCH net 3/3] i40e: Fix DMA mappings leak
Thread-Index: AQHY0ecbqw9DpsfTFUqG9bRX7s9TDK3yk/Qg
Date:   Tue, 27 Sep 2022 02:58:50 +0000
Message-ID: <MN2PR11MB40455480499521173E441D3BEA559@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
 <20220926203214.3678419-4-anthony.l.nguyen@intel.com>
In-Reply-To: <20220926203214.3678419-4-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|BL1PR11MB5384:EE_
x-ms-office365-filtering-correlation-id: a5a75bf9-3812-45be-322f-08daa0343473
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gA3KbyVsduzscKyVLJ6inTLuvukWY4i8Qc/Ff0u8r7I1KE/z20BRqkPNCNgn1AU2xCJIs8RiyeQLO4uKWHK49grizyT4j6KCnqRLuZqYZXM7yuY6JlGrGjJ4nkz+W/DVHZX9VzzfTxUO8WL+ADYnf5+dmUdVqlD80/pdJm33ghjLtaFfav9OM46Ndzt81xD4XUYAPKAGROAO6g2/JWiiXv3GCpbnYC37Irg0Y7qZyI81uCQVJRTEBR12vxXYr0K6DlaaI/ncmWt4HCrjs8GTtcD82sUMoSyAzBKub9xBsCGkYJeiLLLW04sqtM5NlUV4NKmbZ/XpJPUHS7h2sDC/kfHz5yvINRMZYt51CT5iCRsb0lkw2y1JqTQppqcafcHKCblB/N+67CUUe+ysss7Q2BOHw7mBkiyTDptqWWsMFZS2Wj1A3VVoGN4FJ8jkWHD5Ur5DYfMnwvsw44/bX6MnwXpIhYz+jCuppaHAhgPlqanfZam4oTn+Om//dW6OXjad7z2p3wIULB4U2YpaBxG7cioPDgOq+tfn1ldZvrEWUr8EgYXf8xsP7CMpafhaMv8/ae3ZNCuiDCdav/YB+oGsbUFPXntPpH4GzZlQfa+coLSrM7mPiC5go7kQBsW4jAMRE86ooN5Zif5alhcts9Mvo+oovLaxMrOMN0j1tc/q8e5KT2eM86FiHGyi+mgTgiO5j0jvcD7xP2xile0WFLs6+MN9EKDdRT1k8Bk5kO/c6Gb6Rn6ZUrf79Wt5LVJy4v0dv54RRM0SPhwmoteMZZ9DVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199015)(54906003)(41300700001)(316002)(7416002)(5660300002)(8936002)(52536014)(8676002)(55016003)(4326008)(66446008)(76116006)(64756008)(66946007)(33656002)(66556008)(110136005)(66476007)(86362001)(38070700005)(82960400001)(122000001)(38100700002)(6506007)(107886003)(7696005)(9686003)(71200400001)(478600001)(26005)(83380400001)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I589NsYBWngufCoQ2yapEkbdOOTuEbroIwl1Ow1KiWML1AFkDQbDOD5HxX+C?=
 =?us-ascii?Q?/Hwd1cU26y+TzyrRO0mjXsQzJlKeZFCCOaXs5jVw57HSCBVYWHtYMYLWK0r2?=
 =?us-ascii?Q?MCK2gy1GcxuXQM6qJ65wcs4bpJmSNgOXmt/SXcwdvRQM8hLntIVODnX+3glF?=
 =?us-ascii?Q?bnfhalQVv+HkfCfS6RoF0rQdaIHZyJlrM52YeeNM+QO+lvyRclcukUnKSVZk?=
 =?us-ascii?Q?+Ly232iZRXtFnOz+invZuUp4CFA+S9coy0DpEQGKERrIa+O2B9NUJN2KdM3u?=
 =?us-ascii?Q?qAA1ehlJ6YR2T7y1K4LCYChxbpz5hhB7dOyyy/+SgEBVy8O7L/yBwsOn0Di5?=
 =?us-ascii?Q?M//Ma8MujUOjn6btsPU7cGyNCMibwOI8UUkYBaaLDkiwpezTGZNdQk5GOBFQ?=
 =?us-ascii?Q?N8yxRvCcQ0q7nIwZCfBZrwCTBtuZk/ZQ5qztF/UFN/KkFvm0bsD/V9q6jYqw?=
 =?us-ascii?Q?z+gVkI+yNfGGdCDViv2ZENIT6F/OT/XOMsDvULQxs+zc8G2DkgfoPv516c/f?=
 =?us-ascii?Q?jkNvAJg7ecmcZ2cHzwyZqoW4fPXTAZjll+bB9ytOL8oJsU/Nr5v/CjhanrJM?=
 =?us-ascii?Q?yXPRfdLNSAErNnYhckV/oNAnQQ2g1PwsJGi7h7oSErJJCZQZltuj2d2BQEj0?=
 =?us-ascii?Q?vZYVEkcxJNxKLZqsdrk6IXFm5URTegAYVpW+IKTnWLv4JCyAHZqV5Z1VxmNN?=
 =?us-ascii?Q?jdD/IIFY9FyzeG9W2Le1ZU3ePnNwp6StSxZz7H2IYsMAAVZuDW1lXPg1s+Ju?=
 =?us-ascii?Q?PQcboS29qlUzxYLND727a2ZQ/sv0TR9wFxPhAA0/ubw1eKx5iYVJsj+3S5Nd?=
 =?us-ascii?Q?zeH9EY4W7jn7UB+039MDLqZArdvay1dKnqUeAPuvP6pLbfsxbgDBe1yd+y3y?=
 =?us-ascii?Q?WXBl61Vmzaj3HuorqGHzLsoRq9JcasDPoseHem3YY3XW+laAk3vwvEWOAe0E?=
 =?us-ascii?Q?7cIKXesvjkgGsNSeg85S8ckINQ068yOn2mwZYxsWHVNXqzWOnxjDv3d695tA?=
 =?us-ascii?Q?RS1ctaEQw8G8CJ0CjVJI9MsmK9F52Fvw+4K0vYDPD9lHQbEil4oK+v/UuEmq?=
 =?us-ascii?Q?+58qeaYyveZcqYFilWitJ2OJmJqL//wVvxhgxTS7a1hku781ZR75bVl9y8s7?=
 =?us-ascii?Q?jmkGNcfm5jM34KKtJ4rVyaY0vOoREAT01uhT6ueWOUNQokpGs+ur5wloutD4?=
 =?us-ascii?Q?EjLd+FnsXrj7meBq8dDg18e4zw0PFy6oRCMWLKbgYKR2kYMO4irmxMrUEeqa?=
 =?us-ascii?Q?OHJUniBnfUAmsgDtbgTPwdBdozF5iDZyjsFy47ENKbvqoNOqbotKRXLqBvMF?=
 =?us-ascii?Q?VY9OXKyGD3doj95da+h80mqAVPjqKzRpMgfJYjvkN9m2rqL0f6kKsFlUaxD6?=
 =?us-ascii?Q?ddp1e/nHUzQCRwHQZy+HX4ut+JtYUM6ua0O+KdGeBE9C3Hb73CdJTgHZbNda?=
 =?us-ascii?Q?gywSqOA/NoCZ6p8b8L0R1ormdgQehB/TkEiHhAcm8dMnqsUEGrr9KwHkFl2q?=
 =?us-ascii?Q?e/R5upP4j5FB9xpeb+y+TZ3eP2Vo3UTgv4xd26+KSUmQ5NePnus49WBRJE93?=
 =?us-ascii?Q?dpgfEFvzsQbb67r+NwXK1V/FReeSEVq87lfiiL7L?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a75bf9-3812-45be-322f-08daa0343473
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 02:58:50.4898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwoSvtrsk+ezYOHeYbuAG/ZvVM5WG11ZnOG5cALZbAbNP74kZmucta3mN2qseINyHa9hivibxlJX4Wz6Uj/Gkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5384
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>Sent: Tuesday, September 27, 2022 2:02 AM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com
>Cc: Sokolowski, Jan <jan.sokolowski@intel.com>; netdev@vger.kernel.org;
>Nguyen, Anthony L <anthony.l.nguyen@intel.com>; bjorn@kernel.org;
>Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; Karlsson, Magnus
><magnus.karlsson@intel.com>; ast@kernel.org; daniel@iogearbox.net;
>hawk@kernel.org; john.fastabend@gmail.com; bpf@vger.kernel.org; Rout,
>ChandanX <chandanx.rout@intel.com>
>Subject: [PATCH net 3/3] i40e: Fix DMA mappings leak
>
>From: Jan Sokolowski <jan.sokolowski@intel.com>
>
>During reallocation of RX buffers, new DMA mappings are created for those
>buffers. New buffers with different RX ring count should substitute older
>ones, but those buffers were freed in i40e_configure_rx_ring and reallocat=
ed
>again with i40e_alloc_rx_bi, thus kfree on rx_bi caused leak of already
>mapped DMA.
>
>In case of non XDP ring, do not free rx_bi and reuse already existing buff=
er,
>move kfree to XDP rings only, remove unused i40e_alloc_rx_bi function.
>
>steps for reproduction:
>while :
>do
>for ((i=3D0; i<=3D8160; i=3Di+32))
>do
>ethtool -G enp130s0f0 rx $i tx $i
>sleep 0.5
>ethtool -g enp130s0f0
>done
>done
>
>Fixes: be1222b585fd ("i40e: Separate kernel allocated rx_bi rings from AF_=
XDP
>rings")
>Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
>Tested-by: Chandan <chandanx.rout@intel.com> (A Contingent Worker at
>Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> .../net/ethernet/intel/i40e/i40e_ethtool.c    |  3 -
> drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 ++--
> drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 13 ++--
> drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 -
> drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 67 ++++++++++++++++---
> drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  2 +-
> 6 files changed, 71 insertions(+), 28 deletions(-)

Tested-by: Chandan <chandanx.rout@intel.com> (A Contingent Worker at Intel)
