Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E29478F8D
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhLQPYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:24:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:41855 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhLQPYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 10:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639754653; x=1671290653;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zo3URCvjbHm6LvbzuFduVtfyvbJUfLDgKtzuc3ohreE=;
  b=j++ugaS+9+YEojjzO7ErkqKfVkiI1N2MU9r2h9z4svBN6u+oBI4IX1Lf
   Q9ZYruCgNKQGTZuWpE1zRaEK7vigU9WNoe8DfmWrRIwHj51Q91UaphX31
   23hdGCGG9l+x8JN5jtBGeNdyInZByJGUBUdQ07Y2bJLnYYiXyUZwE8wUC
   B3bT2ZZFnve+Gz9MRJs4wschkvmgYpGiTw0Q4MnSvmxgB9rRfW8VXdAFO
   /UcO5IwFb323z6ZcNG/tYKEC/JJIHVUCD0IcauXfwBCVv1wOM/ZYanuD7
   jBJnd19ET8CC9yMgQkm1CP28NCeAykmfq4P5QEBLoxQotGNEWBMAsTfM1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="237311128"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="237311128"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:24:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="605921363"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2021 07:24:12 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:12 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 07:24:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hc/rMCkfr8y73tI3m30aGjMXmoZYqOeraVKUd2b1uRJVqEfPug2JPI2hXQH1iv/WL3/Aqqpb5Mz2Axt8Xp6d7Wq+1VtvFNjTkPGl7F2k4Y/pkw9/Xdwu6fECB/bCxMHBXib+Jfj/md5VlnJsp4+m2WcEB0NTfATh/WM26ACH6fLrTb+DwbYISyj27VFoiqVW/dog0/l551vxO1wO5A2MGM2bp6bWH8ScvFw8iU+v6Xf+uFsYnI1QAAoGXADGvDCYHbZsVd9dHmSUQgWHXa5TXbOdZjRN/HFlqMKXwc+nlbRLzO4bj+bP8lNo8OIe3teSVOO1NcCnJ346IOi4Xy3V+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZLhFor2tyPRlnDEeMJ2ylEk+dg8dDsHFyDfAFERVUE=;
 b=GZMeA9xpFkHRi8okA68JiV3pmcjU78Kbb+M85AYEA3wuuiuIqgej99xqG06rauXxHvz0YCcLKTCbRpl//JJYmTMWNIiORIl1th2lidNkSKZdhEwl8OchzdJs7Un69wEEk+OzeE7Y+Pi/cUSdWEC+Rd04EQLmiIuofTPP6ENF5/UK5NMHi25NjeYNE5HQeCAUmIHu4PcRz+WfY1Holo+xbEQs+O1sLeRlDUIeO2SUCs03jj8bM1/2FRZT3g9lkinzocUtb7YTy4p00uwlxztJ92fZOE/LIL8nGSU63XmAXqmjJQQgeQ7NlupUVQLhnigga2kqDkv39ZnqNb6rhrOlDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4297.namprd11.prod.outlook.com (2603:10b6:5:14e::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Fri, 17 Dec 2021 15:24:08 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4778.016; Fri, 17 Dec 2021
 15:24:08 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Mathew, Elza" <elza.mathew@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 1/6] ice: xsk: return xsk
 buffers back to pool when cleaning the ring
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 1/6] ice: xsk: return xsk
 buffers back to pool when cleaning the ring
Thread-Index: AQHX8DabuIDqR/zru0Wli4c/a6uiNqw2hRTg
Date:   Fri, 17 Dec 2021 15:24:07 +0000
Message-ID: <DM6PR11MB32922CEAA0F5B5C7476D3FA9F1789@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
 <20211213153111.110877-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20211213153111.110877-2-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: dc657ab5-5823-4fd6-eb36-08d9c17144de
x-ms-traffictypediagnostic: DM6PR11MB4297:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB4297A3698E09DEF893B6AE21F1789@DM6PR11MB4297.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bTiMZsZnz4wZulEJxKB8PP0hNQ3k8RwZCKfOn8iUKOIprhjC3iy/5xm3z19ZRvOL5DNUL/cdRIoQgMwLIougajtdJ1lqyTKFOKpn5EIxsAT2qfxcBZGt4sMo2ZQWEzFxCvXaMTuT8LZQSUoUrfrEX8wemuJhbga7Z5/pkRsQ1hDm/HXAZ6wLKx6HLiX+X7TujefFz2EtCtQaPTsrW6N/kxe011V0q3s86QqGEE0I8RrinN6XrCPpY/9zIIBZSx2jCfmtkPpzG/7Nl75B2FyA+BOOOPqM8sDOsJ8X8BJDQPiuCrnyzA5Pg6ou3pHYZTbvJ1fOPulOJ6aJQdNUK8C7IZyGGujSTfyu5tlDJ5t/5WNzirxb+pzOzgp9SZiapvpgk4MG6UUDNO0tdFvjj5i+bxxcbkVQVoZWnPP9g3DXOg9+g33IHksmMk7ssa0Fm6J335MqTHv1HSUqJCFuvUSHGVV1p+2WSY3JySwAUKGm8HDs4Z+IH3aCshRCOK22Ivpjl8EgO5vPDbFi9UyC0JybwZPGKxNCnU82aNEZWK8r8JCEfSJERHunnnq+9z/8EBQbtkA+ePI24/+vYpCIAm/ZM+xnbBH0Ftqr9lbvigGCir6O5UfCkfaJCyDsgzVpx1Ip6KUIut7eKQCn/NTyHwzDPsJbr6Uia43TNcVFXV0S5fsmMUL1ABurKLzMWoGFdwF+gH2tNwaMJN+4DFT2Q7N9UA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(26005)(2906002)(86362001)(5660300002)(107886003)(83380400001)(7696005)(33656002)(110136005)(186003)(54906003)(8676002)(316002)(4326008)(66476007)(64756008)(66446008)(66556008)(55016003)(8936002)(82960400001)(6506007)(38070700005)(53546011)(76116006)(52536014)(122000001)(38100700002)(71200400001)(508600001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6GT+43YoVofnD8QvShkf6eLouoUQHRLM1Xz6MfqLpSE2s+vQCzlbgU/QiXs9?=
 =?us-ascii?Q?06Ze4w4q9YpwDBlFfDht8VLlWVj/w1gRuPwf4ZyTT6BkB5B8MkBphsRDziz2?=
 =?us-ascii?Q?VIsUzklUZEFtz1yHPigUMgRVzNesouZTJIAnin49q6kDwLMgSjqVcj4P/RnB?=
 =?us-ascii?Q?RnzbrGA9CrIuX0UsW8dU0xhzofbacLyT9m24n6hVOmqsmMFhd6OWdFRCrxTR?=
 =?us-ascii?Q?gRPoUR7FiBnHan6TDh5ExsP1GcK3rhpFkgEDiReuH/64hPfamZY0mGYuzYfr?=
 =?us-ascii?Q?0AHKMfvoIlFeOjZJobzCV0amtlUBvPYf4a2Wqwy5uNkT/NjHweNAcg/DZ54B?=
 =?us-ascii?Q?YpuEzunRIE8yxbXLiMU/YIhgrq3EipXCu18Z0ua2tx0P0ggNFLshwqS0S+ud?=
 =?us-ascii?Q?07v4Ez4/5firRMCX/L68oGIKckZNiZwN8jzdP8JUCMMumbuXwL++jkQ4780G?=
 =?us-ascii?Q?M9LXeffDkamw4xslKMlSOatUmG1zUi1TNPoBUf3uRRGodLduyHL++HZoIU5x?=
 =?us-ascii?Q?6bMgM3jlgJw/p82yNdyQ5sDYkW6ZY/xkT3z/rZV4GQf1Lphv0yqhAyvQY9Yc?=
 =?us-ascii?Q?+OVoTmr/k/5JdE813Shnm18R96Z87VM+Q0FSmgjR0WN0U7ZFrKVVPiEFAwgU?=
 =?us-ascii?Q?uNShgxNklu4bHGZYTxSTqmiWcgoKd5rKhNQQ9oPOhdg+JIz5+qYhjYGxctUQ?=
 =?us-ascii?Q?b+FfVQEr6jjf9d28lTHpBpqSyTGq4e01T/bNexiZX4281w3N8JE4GXUItfOB?=
 =?us-ascii?Q?DLpTJeBfgIm7Yi0HsifM5SQvLBkwTBwrIBm+1GBmO4o8urcMTO2RUp0fkSb1?=
 =?us-ascii?Q?dvidbH533xXx89Drh4C947THPU4DtWISjf6wlDO0qS9HBhgK7RcjCEqEKJSa?=
 =?us-ascii?Q?m7fa5Vr0iwj2TtFpqlkAAY8DQZ6EBWiYw7Z7wxWBxZ3QT093TJBB13omemGB?=
 =?us-ascii?Q?FZqdpo9va3iUSf0PtW0+N7CQDYWv2Zw9Hty1V3Pr7AYoAQ2wJcFVKEF+oOi8?=
 =?us-ascii?Q?1axZPD/8F3JpkObu22O93t/47OH6R4gY25S4U4R18+XEX9512F07nhwNuFQe?=
 =?us-ascii?Q?OlNN5qvsxFuREscb/BNfyaGLeObk7O3uajnPzFFefOH1iPCGT9UZo4eo+AAK?=
 =?us-ascii?Q?z29rKGdiUW/tfv+PgPv9H/3lUEsCNnBq6haC0yuhjL42zD20KFECOa/aZ3yA?=
 =?us-ascii?Q?W/jG8owT7d9sL/IKGjEvnDj/f4rN72DZOAFk1WfphAH+pNW7rqQieXy3ufdF?=
 =?us-ascii?Q?WZO5qmsTyc25J7ftAG2GDJOD8lC+3NeTaaCkjxWDES9D0ibyrr1tYmOlWiPn?=
 =?us-ascii?Q?t8K2RE9PNeu+dEqCqCvy5kzgoc7hl9NBalJixxKvkLOszOCvV8pNgXOT1xOY?=
 =?us-ascii?Q?6r+AKopioUkJ9Ojz6R9wQ2pt7sza3nvD2ZJvQ7RdwRDOEBCPn7GDpxW6cFfQ?=
 =?us-ascii?Q?Nf782S6qFjIzomZdcltqQNxjn79KwT9NnMBT4ZWVPLkS+MEg3GCFBFKaXcP0?=
 =?us-ascii?Q?uTA+L804xFBMJAd/szLpv9KyaDnuoGTuB+2mdAUn+R5OSlgCEYXJt49VZxPF?=
 =?us-ascii?Q?R8PEEIAfvwDByntf8aU4idkZeHRkgNwxudRxlJZ4osKF1+fAQDRR2nFsFDZQ?=
 =?us-ascii?Q?QoIALtXaWpZANSrrbiEMCkAHsrjOIip5X3UbxwZOV9U9/m3i2nPG4YhNGrho?=
 =?us-ascii?Q?F5v+Aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc657ab5-5823-4fd6-eb36-08d9c17144de
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 15:24:07.9779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AX82UZLaJ/MStMbscNuVhDinE50sG7SxGgU0atXq8i1/KU3aMTBoFx055bGnCYqd8k8wpNLktVHBWPE7ksE0lE2CRySA1klsn0HqLiTTXeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4297
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Monday, December 13, 2021 9:01 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Mathew, Elza <elza.mathew@intel.com>; netdev@vger.kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 1/6] ice: xsk: return xsk =
buffers
> back to pool when cleaning the ring
>=20
> Currently we only NULL the xdp_buff pointer in the internal SW ring but w=
e
> never give it back to the xsk buffer pool. This means that buffers can be
> leaked out of the buff pool and never be used again.
>=20
> Add missing xsk_buff_free() call to the routine that is supposed to clean=
 the
> entries that are left in the ring so that these buffers in the umem can b=
e used
> by other sockets.
>=20
> Also, only go through the space that is actually left to be cleaned inste=
ad of a
> whole ring.
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
