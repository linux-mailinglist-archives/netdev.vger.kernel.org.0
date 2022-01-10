Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56604489666
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244001AbiAJKb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:31:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:33414 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243997AbiAJKbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 05:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641810691; x=1673346691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a7Rj3dSE9aVNrnWQXN0cboV9j26AEM+78oGYsLaVZWc=;
  b=gW3LofBEmrC8kbvDM5XEyfE4yUFpe3IGjmRlHhVEg+7F8b74de7VxZng
   HprS4YUvuXBTmKeMGRxg01KvloTwNcSZrYY6AJfj7QUyc2L1x4eaHHsKs
   iAfqfN16QTAAgzwpXv5eCPlXwWQkpYnu6nPWojeHH/2iOyqEzk+bseqOu
   mQLoYykxTSIPVbFMnFQ70to/v2hOYUs+7Mpg49WoKIIY/LKnB9Agk5OYu
   aXRwnU3j+45kjGQS66xl8qVFd2yMpTdIX6Wm+60ydTD9wOoKdZ80I0opm
   dyFkaTQb+YOk5/XrIsnk2BD5yYJDucgR3mZ4sRhH62gmUk1appS8pDk0N
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="242010741"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="242010741"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 02:31:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="557943068"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 10 Jan 2022 02:31:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:31:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:31:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 02:31:29 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 02:31:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YG84GMcq3k5C+bTsEND3yUz0dG+e8mhSZnW48RgZ2wWzHVREg2qW8DgOjnFMIMVzy0G43LVtOEcJq+OuY4F508Fupnc6B0VOFyK8W67Fuf6iHzKiRuv4lb74B0zEqF05XbE24c8Xh5589lYUIwUKym3Uyyd8cH1f6lpkxmjyNQywypJOHQIdGRNudqwq77x9X0SPO7Wq7zqsr6UMuCU0lCxJ0sgukZND7vvMnIpzl1nrVRWMXdosd52SrHXxF4gut0ef2SdxncldE2vOGQLUW54GPp789zmzGh4sek1lx38jJM3RyWT19lZ+94CM+VlKyZ9enDiZDcMR+fJA1hHr0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14fNWedD390Z2mA14WSY4uH8Tq+0Wc8oG6ZcH6WbXX4=;
 b=HupfQcfwjgB4Mo9TPNoNTZt8l2sdEmuKPYgmT+NmGHrKGGyeil37vjYESUU6rtH6l2DLwCGQFFjmIJ2Q+LJn5tsP7n2YS1lSdJGpKPOSeCUchzDwFwdeN36vF+WcVepO5a78f4QEb1RlLyswnTbOsNsmuzePe/8oZvba2ZgMfULfwY8DcuJI+mrLMP7jmWL4Hdusb5FqXNXZDo/jOM02OuCIOkyqhsQtr0Xz9/tSwLna7g/OcewU6WKVcrHVGESGeLskoiZSUfDsyg2lEQkJRlOjOl+XrSyxKeOy+16F6L+mwtj60Hd1j+fpqwX7skZAijlqaI4iv7AK8dJmA/inkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB3148.namprd11.prod.outlook.com (2603:10b6:5:6f::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.11; Mon, 10 Jan 2022 10:31:26 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 10:31:26 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Andre Guedes <andre.guedes@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Brouer, Jesper" <brouer@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vedang Patel <vedang.patel@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 net-next 2/9] i40e: respect metadata
 on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v3 net-next 2/9] i40e: respect metadata
 on XSK Rx to skb
Thread-Index: AQHX66z+/1NOFVPHTUGKdB0neu/5fKxcQxTA
Date:   Mon, 10 Jan 2022 10:31:26 +0000
Message-ID: <DM6PR11MB32929AFBEAB5A2F42AC17543F1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211207205536.563550-1-alexandr.lobakin@intel.com>
 <20211207205536.563550-3-alexandr.lobakin@intel.com>
In-Reply-To: <20211207205536.563550-3-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: c2ba02e2-c4d0-4352-acc1-08d9d4245b60
x-ms-traffictypediagnostic: DM6PR11MB3148:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB31489EB474421942FFECCA6AF1509@DM6PR11MB3148.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /li/xJJWjOi91GKDLF/jIqf3a25Y6Y2Lj1YHT1pNISKhdqTGQettUyKwAY8GGNN5kQyT0NfCqgESMY7z9+M2DF4TIInJZkgvH4m6quc/DzKi89AnjqSkjB3E9eTQIIvPF/t61xZgUUgler03YxOr9NGAU2J4q2PpW66BTrEctfvZa1ai4Y1nS9KjjNjCZzgA9wIZo1/7lLIuefe+xXialUxHdLWf4WPwrckl1pv7R+bQ6vEUkhFrA2J43rPYSoQPQVei94wExr6rtPUri9LxnVkYw2uFS+B8lqKxHQrYsU1lZUaELYzn+4Jsc0j7c5btbtpit8HgG0nY6e6ARsN0Os7ybEARTUE1S5OqBm5pOrhKZAXpI2VVAYMMUKN+E0agc77qElmuDgqfYdbLLMr8ly8eO3AKCSPnL92hU+GEr6lHESNlbQf0WH6Y/clMM5FhxwaAHZXRPmIqpu8BwQCo+l051Wam8Ld4VbHnCVRpTNZbfslPC50WI+ZcjvLHk8wCmlxoJvdlQpAgfNyHK75Qq7Ixq89MAURSIWFUC80HHl/TA0gh6dFomHfOreqyKmkzkvI4u/PyzOyYcEcW7E2OVKFzJW8esq3Zbks9K3r1peYFRnh8y7gGxqIeURXTuUzFq3H3AEFoq0TBxsdlrhslwh/TJnLR0HXDGz5WogeeDardPz/07v4ZcHOxjfBY4gHW/nyuS0HkPskjVa0Da2PNRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(86362001)(110136005)(55016003)(122000001)(107886003)(508600001)(9686003)(53546011)(8936002)(2906002)(316002)(33656002)(8676002)(71200400001)(26005)(6506007)(7416002)(76116006)(66446008)(4326008)(66946007)(7696005)(186003)(64756008)(66556008)(5660300002)(66574015)(38100700002)(38070700005)(83380400001)(82960400001)(66476007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?nQoxPISnmUuGNMourHL5DIdrxMvglmEhtHnff++pGnY2ONe4Z2AK1CnTnv?=
 =?iso-8859-1?Q?5NQL+rXQNevN3cFJFm9SvcD0TG8Fg3u2qwGfSP7uuPO//ADBkTjhRwupWi?=
 =?iso-8859-1?Q?87SCh7vUDj6YXYbA98UQLVr0z1lDbEdlvCOF3nmisE+1wriTFl5FIFqFK1?=
 =?iso-8859-1?Q?knINMPjkbOC7TEdT1t+/D0ZKigEST/z1+H8Djlwzf36VKM+EY4LmOjp8Eb?=
 =?iso-8859-1?Q?QajwBnUSEvlbb2cdm0gdi0iRD4J+Pacxe5e0ytZgv7P/nVHfmbdQPZch5t?=
 =?iso-8859-1?Q?CGXpPDUvGdo0sAnC5z1hM55Hxid7yGH57acYpwJDwAdy8vyd5720ZODUqa?=
 =?iso-8859-1?Q?4Rllv+oTj/izc/60zTPzaKwAJWisLHANIe1Cg9sGXuXbtsq7lmoFgd+QsI?=
 =?iso-8859-1?Q?VCoPxS3E1tZA60y472USd0puBkahe8vn+vsJpTNiEdYZHNq29ogyIx9eBF?=
 =?iso-8859-1?Q?UFwN+Mvg7lrCmdhD8lSEwx3r1CdfaJQiUqTQR91eHECbbeoJM30es2SJLv?=
 =?iso-8859-1?Q?eNojnKHp7zpeYtPTY1NGZydpRPsenYG/wGnDZo79Youicq2z4RnfA6x+i9?=
 =?iso-8859-1?Q?j3FrVDKVtuWKgg2uwyvOb+xsqQUHhZdgu6OlWqu7z6azPq9+CNasmiwYnP?=
 =?iso-8859-1?Q?Q5lJROOIBFHtjrm+4c3uUut3V/Ls0XiBH4RFO/iuZAGeVlbL/a25A9cLlj?=
 =?iso-8859-1?Q?aQMM+Z1UvjwpVgrjlo+l1tMDOSgpS5QGXsnAvRH2nPKEGgHF40P5+cYvos?=
 =?iso-8859-1?Q?EFUSaWeifFjIZNAiUIDYXJEgFtYB6vg4wFhQ0XUxfNdYbREKFY/7KnHcE9?=
 =?iso-8859-1?Q?yQmNPyCMsjVHQTtWEYgyjoYUw6ChDbTLirkwh1+iX/Zy7/9ANUeC6Mv8oN?=
 =?iso-8859-1?Q?1/5p2rhetaFyFlaNIXZlzCEBZBpIToe2FJ79siAUP3t4ZI1YBa0kmJgZFF?=
 =?iso-8859-1?Q?WBZx9EKJ5N/C98HmjxEJ4nMtUE64164DHCOUYsj7cxVRUFzm1vM2P1kzdT?=
 =?iso-8859-1?Q?J61JQpXSShWFsZIbwdw6wn9XSKJCIIoa/uxEsajMqEwnVCMlvHukMXWPAC?=
 =?iso-8859-1?Q?24HmwC+7MA7OMVP1LOJGtqwD5cWHpNmk4E4HUpFP/0U3FyIhabPmS8xUPP?=
 =?iso-8859-1?Q?uFge81y0TOk1OZPomwxyJ1CQ8zlDl2f9I0mSbuC1RwpHZJek0nuAF7U9eF?=
 =?iso-8859-1?Q?1RQe4HhEPvuK59/NyP+RiXvvc3q7cgtLkcBsBFKSFJYOOHbg+AqqtJocoS?=
 =?iso-8859-1?Q?kQkTyW609OiygXsElvvkwP4Hg74/Th8EkQevrmgvBLPFJXDtvqOK/+xq8X?=
 =?iso-8859-1?Q?eqWpwMBVxNX/Iy4+kVGq7zw11uMDPDTzeDjYR8f4BlEOjr8jDQbntn+54B?=
 =?iso-8859-1?Q?Uj0zy0+AoLzS6KhIUxYGVmmO+wR4yw4G9y4x4EEkdIj44G15TA28g/dhDr?=
 =?iso-8859-1?Q?8y4SAO0Vjo9VZ3jtB2LsJiZ8p7vtpjWAP1WoRhlo6+00Q4idXP0GMEVJdN?=
 =?iso-8859-1?Q?ZDM25a2obNA+Gj4HBhFDvQ7hI0XN9r+AEFK7HtPBy9glWuujuDDz2xG2O8?=
 =?iso-8859-1?Q?pAFnVOVQFZbcA9mcpDCgCmm31So0KVFM9V9uOSoYpp4Jjv7ewJ5d5q297X?=
 =?iso-8859-1?Q?9jnpQn3sZmjJjoAofa56StOJ5YtoFNFr/anvVjqjRZio/xnDm7MPJuWf2T?=
 =?iso-8859-1?Q?T1aSdDRcrUt2omuwCSexj/cJv19jPyiU5YbWTonVT8M8EqYSplvCN3cJvC?=
 =?iso-8859-1?Q?jeSA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ba02e2-c4d0-4352-acc1-08d9d4245b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 10:31:26.5828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f3p4EvspL9090RyNvxE+0E8Vbx9wymAwrWvRpXdtB6jsqvS/vK7afPrDJWc0cdf8q7znDGiU3/L5Wzegh/Qk1vK/kXqeOuhGXuCT/3h674Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3148
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Lobakin, Alexandr
> Sent: Wednesday, December 8, 2021 2:25 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Andre Guedes <andre.guedes@intel.com>; Jesper Dangaard Brouer
> <hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> netdev@vger.kernel.org; Krzysztof Kazimierczak
> <krzysztof.kazimierczak@intel.com>; bpf@vger.kernel.org; John Fastabend
> <john.fastabend@gmail.com>; Alexei Starovoitov <ast@kernel.org>; Brouer,
> Jesper <brouer@redhat.com>; Bj=F6rn T=F6pel <bjorn@kernel.org>; Jeff Kirs=
her
> <jeffrey.t.kirsher@intel.com>; Jakub Kicinski <kuba@kernel.org>; linux-
> kernel@vger.kernel.org; David S. Miller <davem@davemloft.net>; Vedang
> Patel <vedang.patel@intel.com>
> Subject: [Intel-wired-lan] [PATCH v3 net-next 2/9] i40e: respect metadata=
 on
> XSK Rx to skb
>=20
> For now, if the XDP prog returns XDP_PASS on XSK, the metadata will be lo=
st
> as it doesn't get copied to the skb.
> Copy it along with the frame headers. Account its size on skb allocation,=
 and
> when copying just treat it as a part of the frame and do a pull after to =
"move"
> it to the "reserved" zone.
> net_prefetch() xdp->data_meta and align the copy size to speed-up
> memcpy() a little and better match i40e_costruct_skb().
>=20
> Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
