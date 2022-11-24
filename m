Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BAF637D7F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKXQL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKXQL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:11:57 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E8614F50F;
        Thu, 24 Nov 2022 08:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669306316; x=1700842316;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9qCKpSybO4dji0KuQ+/yMiuK3k8aF2Fup7Sk+B7ippg=;
  b=AQvsaHyqDK+D8EEd10DTrlwZ/b0jBcWGrujCjYazFTQ5/pwh/ek11h0l
   B3vAbOzaJHK0Jkpo5A3XinYDKT+Y3fu5KY2wq+KpRRvKUAyhCuM9AV9Lj
   Lhc5LIAYn9HfNRwNj6SH3ytrLwOLyXIwra9uZvCmR4Wh8pXJF9davVMLc
   gAwEEmwM3M4RTKMFnIwaEKDRJLKYaN7wVeUYrt32CYTTY9FmQ1T8EIost
   bI+0eZpxN+EC+/500u4rtrYRL/d8nx8xzP+4x8Je3l+Ms9xU8auM4gAdC
   kqQS4Wc/hTlE5ty797u9oK4nsfuQ7Y3x5UoVynWhIVu/br0FdIvEkXF9F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294033080"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="294033080"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 08:11:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="620078633"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="620078633"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2022 08:11:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 08:11:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 08:11:53 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 08:11:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2ipqDWFb+OwPoiQ5z2iLWxZR2UH/2xnivDIjrijmh6CuJRFC9u/1gXLVtEhirtBzQAR431oK1SH/FKDFyTjrh1mKQuz0xzY5Tocb+jf/1R+vK8TEK9ObWG+ffk02qKSyLVE9EBh5gJzcwegf2gGg+0fyGZEkAGdXTD8BZum8tQ78VSA3cDIX0RtRy2va5DIPJUNkWkubIFl5+LnNZgkCqoraK3W1vhiydA/ttN9mrTm4Gj8FCbrqkBDEwujGG4yi5bNKp2Qu9A4PiJdh7i9WwLes8Qc3JToPqjLt5t0dbS1/o2usRrF3dq97rlyjFp+hBpbOFJyLW61o0IpXOL6XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRm3UaxG3D+GF/zoLDNW51T3SEWzLqpzHk9Jt6WIBC4=;
 b=UtQRfRgOegPOPPNepMTcGzqbdRkj4z78y0vLYfWTCyJkK0X4HNnMz6bvZvCeiskG3CTjOMaoAbeeBN5hb27ZGJRdmfwyksVQxf7+qWq4o1K/H/JX2rAPDK+zkgF8RsJmdDP0udrF4T3TKGcL5TxK9tSiV/kbb9C3Fu1o4nkWE42Kpj9+ZwLSLjp4TMgEM0aCdX4bLrNfshmhCwUyDFUjxevDyBA0KxvxVo9jmzspPU6qJzsg0p539J2MqZaGO9yy2TM9qqX6ynzA1FM0gVYk3VBgUzM7ZRO8GMrj9yPW9uWc011KtT8NohK/0pGRCa4kZoXIkd1CHsWhjjBYhpVf+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7033.namprd11.prod.outlook.com (2603:10b6:930:53::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.19; Thu, 24 Nov 2022 16:11:49 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Thu, 24 Nov 2022
 16:11:49 +0000
Date:   Thu, 24 Nov 2022 17:11:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <sdf@google.com>,
        <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
Message-ID: <Y3+XtkkIh0o++Dgr@boxer>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com>
 <874jupviyc.fsf@toke.dk>
 <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org>
 <Y3557Ecr80Y9ZD2z@google.com>
 <871qptuyie.fsf@toke.dk>
 <20221123174746.418920e5@kernel.org>
 <87edts2z8n.fsf@toke.dk>
 <Y3+K7dJLFX7gRQp+@boxer>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3+K7dJLFX7gRQp+@boxer>
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: c52c222e-629e-484f-8e13-08dace369775
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GoDLPTjaU8jGndFFerAKxV3LbaJvPqFwKChsvedbBfQYkQd4CbzloMutvdc5XT7M72zYyEyToVL2kpVvqcUeQR20vMLwuMfQtoXblkoWURRUGpUWWqg3pxXNGEk0JOMGPctpM8rWb+jnmGWXAIdgEksIHZdx2ofyJzwgUPdBON9+kIHzlyimkDCvKycu4QKDnxDlj8k2B+phpMoUAUaUQjffjb5CBneI9EjvMGlgk4tr6Z1hxFyhDH632A0I0R9wki7+cBaABeyQCMC9ocSdzxCcGH/6mCc/VMuNegD0F6juv1rc3vr5mp3MPkxFYigOMAu0Hu0d+CBywVJ67v9yHvZRoXmqP6XylkQ/flVqXGN2/UhKmPHfcK+tANH867FU6tgnYhfMh8pXS4AEGFKQbohkbccv29Dogu1OfCsyqkbJcQlDVI0qClPxMrbBZqv+Pjvc6XlG22Za+GzDHW4NXsGvI14rIfX0mmp1sQvKD3bN2gl2oJjLvFAwCUJ4nTYOPOtijQk0jI3vjTo5qk0P+ziBfYLzW7mG/pn5b2XMNagG3Sf2Lr9eAhYoMdMN01EyiYtXgMO0OPG2XHGqCrwwNOytKdgtBBUt5QF0OQXAcNU5QUc560ZYBjPPDAOn+amEJUY86/2owraQIXQhqxDZfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(66946007)(66556008)(478600001)(6486002)(66476007)(4326008)(54906003)(8676002)(6916009)(316002)(83380400001)(82960400001)(38100700002)(33716001)(26005)(6512007)(9686003)(6666004)(6506007)(86362001)(66574015)(186003)(5660300002)(8936002)(7416002)(44832011)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HrquS9uiLuAgpV38ek0YBtdXdw6e7EmWv6GzZLuWE1ioQW1KTdaxDvIws9?=
 =?iso-8859-1?Q?oLW553PLcslov2CzBPLTy+VREx2SXmSM3pWYPa7qquHoHnyN+sDiA9cZFR?=
 =?iso-8859-1?Q?L8O4XQQyq68dEfwUeEI0z2YroPanfCEJ8Oh9SwfuxwJpVpgXorvdxFlFAh?=
 =?iso-8859-1?Q?Zkonu42kvAAt6BsPKa3Il/NKFAVcbRat9aqb+TwML84fK1zEnu8bg7fzmn?=
 =?iso-8859-1?Q?6VR+UltvTUvaD8F3V7JnIbU5R481XUQVgKlJ5IEdmYgDfbmYS3R+8mxbep?=
 =?iso-8859-1?Q?WdorB/ZP0uFf3ydXt/i0ES5XHo3UIoJR5tRKqTbBbbk6q7qUwgHqwSo75Y?=
 =?iso-8859-1?Q?FZ9Rh6Uq253Mkvw46ziU23AJilTMBoOubLY9PYbA6lLu0gwa9nv+EPnm3u?=
 =?iso-8859-1?Q?TvfR74ENkRmFJBpvRbh8Kyi0WKBnK/Gdt0uAHsMuDs/mY5oyS/qYb2bIEm?=
 =?iso-8859-1?Q?ch72h2E7TqZHjCL8QrEP3JoFqzl7DfqGbDtFlmOTEi2p6OG88v2OpiCQsC?=
 =?iso-8859-1?Q?Y4Swwx1ZTVK3quic8lpsmuwuuy7EYMMsU09QbI+voG8SuOtHVmTFmCVFkg?=
 =?iso-8859-1?Q?JVxWE4+PMFTq6a+yxQijHirpS8IWZMfKlCaFadKuG6nvsM+BOcmJcbP5hX?=
 =?iso-8859-1?Q?XtnGjEndQMqpykEAZ/oq/hapELgIT/m8tyr526qKhBteVEkS0KrTVdjo7D?=
 =?iso-8859-1?Q?ZYa6CXSelWPwhwK9xPGNq45D+2iMW9COGMbq6fqnx7cI70zbUWjgVZzdm+?=
 =?iso-8859-1?Q?M/Vd5ReH+S6EANmGb69mMc+DDTewpjChxxFuJQVtXY/WaA8SmDKCX4dSpu?=
 =?iso-8859-1?Q?LHYlr21OozN4TonrmNplysHigVbctW95+ohWbe4hygnrmdDg+b5h3T7GZC?=
 =?iso-8859-1?Q?9Extb6J5KuJ9hOB4QdLd7EgHJDvkquAUwHxAh5KlxnlQgnhDFAJwtNKYFG?=
 =?iso-8859-1?Q?z5CF50J97Xl3nQoKp3Vwi1spdgGfSmwCe6cNsQShQBmThur1623ZNFp+jT?=
 =?iso-8859-1?Q?2CkeZkSXf193l/CKulvl2Qtrh5xpbgd+brjm6JGxibPtS9fTozLuof7Zie?=
 =?iso-8859-1?Q?Iuwt9pMI88KexnkjhKWupFvcGmriw9qbZQxdQrfMuCE62ElD15rOC0uPfj?=
 =?iso-8859-1?Q?/a7MVxhcdeY2YtiXT+K7Ljb8R46vHzSgDqFFEvhP2hrLARngOHAeg27BPj?=
 =?iso-8859-1?Q?EI1byfbNT8JZ0p81fBFzXmtz1gO+0OnBrDZt+WiOVtvf12I+y9Yum7q3p2?=
 =?iso-8859-1?Q?PDSTH4uJZNhI251Fn5sRkK/E4joapc0e3v0cbf/QK3ugowoMsH0THcyRnw?=
 =?iso-8859-1?Q?W5wEKHAsEvXis+K/TJE5bxa4qbPfsERlkhtf/8u7MJHIYoXdiLcHjIkGcK?=
 =?iso-8859-1?Q?66prFAbiGuGauPl5PqCCkKqFadooG6Y3VRCcEH/FybM0enjqXU2+/QrIzZ?=
 =?iso-8859-1?Q?4GWFIlE3Ixuj0hSpK4eJF6NzvJNXAKKB/25mUHlbsFKNbcYGCGZmjZ5eF5?=
 =?iso-8859-1?Q?A3BUtkSc+vnqiekxb8CmBKrTPvpEIWUyltJpyh/Ue6BuoMeLWJFzdWbcRt?=
 =?iso-8859-1?Q?FCmCeCIpbZXnWfyduOTmzPZJFq6n3nddrL+3l9s+ABJBy23tIZBnOBWniG?=
 =?iso-8859-1?Q?ifHwnimE+K+RiAea7WjaKbP6sH0qffnYuhQ56dXsHgZ6gwTCeHqg3zmg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c52c222e-629e-484f-8e13-08dace369775
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 16:11:49.2528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlH1ULxZbNJuyvOo3V8wEuLEYVVLBs4tKpt1GbzpTKlvx5viyVaz2iKhhk7XX1TiPA9QquVW1gJ2wyE/WBVYSVXh3s3yPR9kR6aVTSEoQEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7033
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 04:17:01PM +0100, Maciej Fijalkowski wrote:
> On Thu, Nov 24, 2022 at 03:39:20PM +0100, Toke Høiland-Jørgensen wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> > 
> > > On Wed, 23 Nov 2022 22:55:21 +0100 Toke Høiland-Jørgensen wrote:
> > >> > Good idea, prototyped below, lmk if it that's not what you had in mind.
> > >> >
> > >> > struct xdp_buff_xsk {
> > >> > 	struct xdp_buff            xdp;                  /*     0    56 */
> > >> > 	u8                         cb[16];               /*    56    16 */
> > >> > 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */  
> > >> 
> > >> As pahole helpfully says here, xdp_buff is actually only 8 bytes from
> > >> being a full cache line. I thought about adding a 'cb' field like this
> > >> to xdp_buff itself, but figured that since there's only room for a
> > >> single pointer, why not just add that and let the driver point it to
> > >> where it wants to store the extra context data?
> > >
> > > What if the driver wants to store multiple pointers or an integer or
> > > whatever else? The single pointer seems quite arbitrary and not
> > > strictly necessary.
> > 
> > Well, then you allocate a separate struct and point to that? Like I did
> > in mlx5:
> > 
> > 
> > +	struct mlx5_xdp_ctx mlctx = { .cqe = cqe, .rq = rq };
> > +	struct xdp_buff xdp = { .drv_priv = &mlctx };
> > 
> > but yeah, this does give an extra pointer deref on access. I'm not
> > really opposed to the cb field either, I just think it's a bit odd to
> > put it in struct xdp_buff_xsk; that basically requires the driver to
> > keep the layouts in sync.
> > 
> > Instead, why not but a cb field into xdp_buff itself so it can be used
> > for both the XSK and the non-XSK paths? Then the driver can just
> > typecast the xdp_buff into its own struct that has whatever data it
> > wants in place of the cb field?
> 
> Why can't you simply have a pointer to xdp_buff in driver specific
> xdp_buff container which would point to xdp_buff that is stack based (or
> whatever else memory that will back it up - I am about to push a change
> that makes ice driver embed xdp_buff within a struct that represents Rx
> ring) for XDP path and for ZC the pointer to xdp_buff that you get from
> xsk_buff_pool ? This would satisfy both sides I believe and would let us
> keep the same container struct.
> 
> struct mlx4_xdp_buff {
> 	struct xdp_buff *xdp;
> 	struct mlx4_cqe *cqe;
> 	struct mlx4_en_dev *mdev;
> 	struct mlx4_en_rx_ring *ring;
> 	struct net_device *dev;
> };

Nah this won't work from kfunc POV, probably no way to retrieve the
mlx4_xdp_buff based on xdp_buff ptr that needs to be used as an arg.

Sorry I'll think more about it, in the meantime let's hear more voices
whether we should keep Stan's original approach + modify xdp_buff_xsk or
go with Toke's proposal.

> 
> (...)
> 
> 	struct mlx4_xdp_buff mxbuf;
> 	struct xdp_buff xdp;
> 
> 	mxbuf.xdp = &xdp;
> 	xdp_init_buff(mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
> 
> Also these additional things
> 
> +			mxbuf.cqe = cqe;
> +			mxbuf.mdev = priv->mdev;
> +			mxbuf.ring = ring;
> +			mxbuf.dev = dev;
> 
> could be assigned once at a setup time or in worse case once per NAPI. So
> maybe mlx4_xdp_buff shouldn't be stack based?
