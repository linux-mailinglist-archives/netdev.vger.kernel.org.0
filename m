Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15ED4A2D45
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 09:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiA2IzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 03:55:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:30530 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbiA2IzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 03:55:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643446518; x=1674982518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wZiO4T5THvsi9MTdufjIVBnufEzl6KJcvmZ8Tz52YgE=;
  b=jtGV17gLUkdGvGopwLithNhdqyHtwQ7IuUW29xSHFqC8EVy7aIlmzU4p
   53fHiRUhylOzoSpvGlgbWlIY+2xdltvmL90+D7J9+PuPK1VrtXwCAmvq7
   /XmVhZOSVlo2bPL730cq0gBA/QzHQoKFlD8tX6Wd1mnm3SAYfvj2nfwbr
   zlYp3DyS3SR+1a2yN00FySmbi53JxVIsoVEJ1Cb89Dwvjk4tn92ABQejL
   Jl5xY2nS+Gx7KHArVuruOgvhwQKexh5lYUQn5SSBjKlgykASN8qgbMhcs
   0wxpLefW2vWvrxK4HnF7H4XD7gQZGcA50wxLcDynzbKk1L7Ca1q6oPDie
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10241"; a="244855239"
X-IronPort-AV: E=Sophos;i="5.88,326,1635231600"; 
   d="scan'208";a="244855239"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2022 00:55:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,326,1635231600"; 
   d="scan'208";a="536441203"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2022 00:55:17 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 29 Jan 2022 00:55:17 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 29 Jan 2022 00:55:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 29 Jan 2022 00:55:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 29 Jan 2022 00:55:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/1pCeZ3choj1CLzOtTuoHiiSxg+HSmAPlvuAPprGLa5OORZEOHVEPSfUM4PUynFH0v3QeDfTAreYEma2i82IysKXlMcyyZj5u+HBlEEfjRzlXWVYlZTe7lWfS2CpGVs3yzU0+etPvTy8ywFZkuUl+Yipr1Ddy21s/TAmjHORv1JtC6RSubQf9iNAjyLLbdGSlfiIs6Z9b+7GmJ4Dwf5ox4TW6YIN0E6VCTygaVVVkhhWpb+yHp4rbqlbpPwAwGgm6CvAsxFSc4ASurYbY+spMhZGgEqgqgr8ZlDExef/5pjbKJyJ+BaCXkrOBlkOBBSCC2lJcQT5hqMkTNJuqUy8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1Nf11oV/bgf9x9i+FZSScdcgSvCUO2lCocHksr9+lc=;
 b=f9/AV6629dADnuSJWZU5mkh1AXmh207Uu1l4Oa0saidbYYZ5zcLr+lIA5vpqrHHrBYYNsizTK3FziGPTdV9MdtBO14O5R8rnZWA7MV1Tca27csHytVzkyNGMaDgj/xs+XJ32S0bdpE1p3yP12y3T2pmhk26BdOoBvnf1pkW1kSUFVdIW0mOR1dq5K55Gg6IdTrs62gzcVTDmbqwIfr5SxFZescx41V7ggaRdZYwSQo/tkNmmmXW009XpR/AYn2y4gWFQ7dmfEaG64ZyL2KxAq1AojFSWnCWNTAIkDV2LidQZ/e0oLolZg3/2jut82uvxvATaDnVDkkE1Vu5OQ30UhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR11MB1868.namprd11.prod.outlook.com (2603:10b6:3:114::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.20; Sat, 29 Jan 2022 08:55:15 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::d895:6ca8:380c:9585]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::d895:6ca8:380c:9585%4]) with mapi id 15.20.4930.019; Sat, 29 Jan 2022
 08:55:15 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>, KP Singh <kpsingh@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 1/9] i40e: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 1/9] i40e: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Index: AQHX7D0G03SWSKhTQE2oI21ri4lIHqx6AwZw
Date:   Sat, 29 Jan 2022 08:55:15 +0000
Message-ID: <DM6PR11MB329239287A3AC0FFC21A3DEEF1239@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-2-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-2-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb930a7f-efa4-4960-1e4c-08d9e305111b
x-ms-traffictypediagnostic: DM5PR11MB1868:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1868A5A8F355344DBA6CE0C7F1239@DM5PR11MB1868.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1/2fZbZeF0lPAbio0OzsKl5t6D1CbTn33F30FGRE1b9oB+cEilQrS5WCvZW0gZMgIByfMfGf6BgKtMWG5ZBLZYXFlwsXRnYEH1zHLJ+MR+Mni1M7ektIaLlIcKyi+GfpvdKauX9Vbjaw8wm0pO3ln9tBGUA4HMkHyJKTxGr4BTVyLJHf28wC29uaXLxp/oIrYSTzEtkEyQiWkahx+HMRIst88dGmIzqWa07+YUkA0vJU2gLzEKvRdKcPPsLPcQOj5h1LWQfp06+pNloUDmfNEkc74JlTbb3YTNAKatQRkOCyPkGVRoFlCfbcOzkexQfqWTxNJdocRLoIXMDqkQWffJB+FuBtsyluZF6DW5q2KzuvR9usDiuMujQR1bKOIVb37uLPtMKdbmOELZhPXN8EvhOpwhtkSL26hPmmHEjKCzckVaFyDKC9JM1oa6hI1AfZoQ4nKVYQdztG1gou/FNrOxJvw7KcJ6Exa/hao4Ng0Evx3eve0jwAP6uh0gyilK03xBgIuTVqkNUvyE71b3ATt+oSvmUhlkuE5zdsndRnEZGkF4k1ixo59Iwv0YZyD4R8VopH7OyD6gJ9iFzFMVV/9TNV5uoGIuxvU9RfwcG8/cgjzQr3SmiRClyT2DgUgVO1EwrgPnCJDY9nrbQysIgnpBqLLxSWoPbiIMNX+cmmTmTjOpsQ83y8v5hmuAMVoRQsLUmM/7wUK4luA9MjDmdVyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(66556008)(2906002)(71200400001)(6506007)(110136005)(83380400001)(66946007)(316002)(4326008)(64756008)(8936002)(54906003)(66446008)(8676002)(38100700002)(55236004)(53546011)(7416002)(55016003)(122000001)(33656002)(26005)(508600001)(186003)(38070700005)(86362001)(7696005)(9686003)(66476007)(52536014)(5660300002)(82960400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uoOXnXA+DoohKdisGUuenUHDfEf/s4zcYoOaw8OWztxr8/ZPjk35BAVT4G?=
 =?iso-8859-1?Q?EjaOrb6uAegoYxkE57BE51hTkZLoUDIhbuwqP5uo71kuvGFLRbiw+2c6Tt?=
 =?iso-8859-1?Q?ptPbwMW7c2oCLUFaFk/6quAE2rYXlEH/pcsiBehfAaSM9Ic6V9vHZScG2V?=
 =?iso-8859-1?Q?sHoJCOSnVkVfHilnnSChWxAeXbzcDqqla42bFu9Se+TbIDbaMlYhResc8C?=
 =?iso-8859-1?Q?eeXyCGjwx1ORQUHjj4lP7jBc38PX9IoQBQ+Wpy08qYSoY1nNl3ep+lHvUy?=
 =?iso-8859-1?Q?HaPLqKRwTiYAsqxOu+W8ZluaM6J2hxxDXP6kXY7KRUOTzTxGhnxMmpyWE7?=
 =?iso-8859-1?Q?14Hlen+tGU3KgFQH380vyj0qnYJ+8DQMYga92zv17cQBLbcEh5lCCsxvIQ?=
 =?iso-8859-1?Q?Y6IlPkiZwaBq17H/YGEUztbJQLAyh3zzF/1iiIt4JHbLON84N42Ufk5cju?=
 =?iso-8859-1?Q?ThVJ+Q2pGti1E/RTtaMMya97MhzDIosJ785iid8yzhSx3s5nPUrmj5ukRB?=
 =?iso-8859-1?Q?u/PU2pY+/wKhZgXR2RC2GpUEOQzojMISjrFtmCSOBsNFh63IGtBsfadNn6?=
 =?iso-8859-1?Q?arZTidZ02J6JA4oos1eWBCBNNwA8oNdGIFjCJGEtC9ywcntpznZHjEmPmJ?=
 =?iso-8859-1?Q?2sENhIKo8yyMKn/knBT+l9Re3x2BkBaX5ayprQ6WD/4GoLKuyMY057Kq1m?=
 =?iso-8859-1?Q?81eCL5h80qwvpjfnWiBIeAzuKHBExwVf9FWqY0XHrStRApPsdJywVbbABg?=
 =?iso-8859-1?Q?AWDNdWBX2Wf7EqUmxjGWFEKxXNr/XubEBdAzhKg3WnF1Suf9GW4LLD3abT?=
 =?iso-8859-1?Q?kwwwirWrY8xil80KlwuXWhqlaKrDGe96+G1TcEOyLzlBQw8nzUriqk0nQW?=
 =?iso-8859-1?Q?Pw0GE9rux1AGZ8nWdp+Lnwjcs3u1sLf8U1dNLvHIQnUBZ9mjwvMf+XkM1w?=
 =?iso-8859-1?Q?d0d9VKt4qqMEMiflpGpHKAnCfObGjtUD33ANajpF1qh2U5HVa5OFsE2G/N?=
 =?iso-8859-1?Q?1IhVXBdTxr8e71jzHOxR6SlXhiXoG120/aR4E4I7744FCc/zg1Hd3RRmbg?=
 =?iso-8859-1?Q?X5SLKsJ4fdquN9zaxcBRGjvWP6uKkqXM+fqM1Z5E2KPy3gD15PAxxhFdxV?=
 =?iso-8859-1?Q?+TmgVbHW//wdB/NinYZ8Cb+djJgBcz6ACkJw3j3jgxW6BpZ6l3sFtxERgf?=
 =?iso-8859-1?Q?Mb7Oyrs7OTAjzJeuc+g/+0IRLd0HAYdSLE/UiMw9KwSXYA8KSp90treq+Z?=
 =?iso-8859-1?Q?K15qpI7lv6EkCe+gNGyzg4viOQgTmuw6ZldylE1hlXhe37IORIBymJj6+a?=
 =?iso-8859-1?Q?7ZRZbZRLcjIbax12k2ukAl27a5egoP+UQHPgbot3bUn+GSr4UBf0I05PZh?=
 =?iso-8859-1?Q?8L6WL8QGXGCSJApvxCYSZ1jmZeXWmp4YXxbHUVfOB25hRUI/x0ePz85Yg8?=
 =?iso-8859-1?Q?TW+dn6VoWFxMB/cu6JFM22kZO11sogSxBR/UnMPToJX9J2zjhuGiKG+qKr?=
 =?iso-8859-1?Q?FE4m0A6Gu+Iy8LDrqFlgX7vzmq2zaJYwHzMjGK+ndrDtRFqBWDJ1HskjSM?=
 =?iso-8859-1?Q?gutNym414LSDqbMazV45/8AoHNYRJ927/nBQWfsf3Fq4Di8FWMbN9VZoT4?=
 =?iso-8859-1?Q?Ew8I9i4Mmbk87NHi/hELwB8nz8LBfTDh6gejHm5dQDS5zy2CnN1MFmcKci?=
 =?iso-8859-1?Q?ZwOrw8ZzBNJk1F730X41fbK5f02F4TzgyqydJ9KFJJwvcrnGKF6gAiBy1k?=
 =?iso-8859-1?Q?0wzg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb930a7f-efa4-4960-1e4c-08d9e305111b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2022 08:55:15.0498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwuD3R1jXnArK1T4l3EVoJmR0mEp91Ai1SWU6a8MDXsAIiXCsEoUXEHswjVmxFjIj4Cyz+VTb9Qvw7mWQarvq+kw4JC9zCEaF6Jj9r6qcJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1868
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Jesper Dangaard Brouer
> <hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Yonghong
> Song <yhs@fb.com>; Martin KaFai Lau <kafai@fb.com>; John Fastabend
> <john.fastabend@gmail.com>; Alexei Starovoitov <ast@kernel.org>; Andrii
> Nakryiko <andrii@kernel.org>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; KP Singh
> <kpsingh@kernel.org>; bpf@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH v4 net-next 1/9] i40e: don't reserve
> excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>=20
> {__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
> + NET_IP_ALIGN for any skb.
> OTOH, i40e_construct_skb_zc() currently allocates and reserves additional
> `xdp->data - xdp->data_hard_start`, which is XDP_PACKET_HEADROOM for
> XSK frames.
> There's no need for that at all as the frame is post-XDP and will go only=
 to the
> networking stack core.
> Pass the size of the actual data only to __napi_alloc_skb() and don't res=
erve
> anything. This will give enough headroom for stack processing.
>=20
> Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
