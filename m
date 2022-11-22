Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568E7633A6D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiKVKqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiKVKqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:46:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DF21DDE6;
        Tue, 22 Nov 2022 02:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669113786; x=1700649786;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Vv3D73OdIpML3ieqalFnqy9UrsJs62nwEbglnh5UzmI=;
  b=lAdAw9mOl9bKSQ9CKoAgTxcYOe7N0kkwpZyW1bekbne75GnvPRy1gnlk
   lQIFx4YF9qQnp/zZC2w9DUN1Z7Y4aaOfDUPCw1zaHQdAY38icUpUmPkJ1
   j2OUkBOPAD+LmlgVVTbSVsnVRYdMOECHnUdLSnqJb6KX5t3Fmz0nktP2y
   Qqfd0PBgcXSMJLHccyIYl3TRjdepCvvedKl8uMSH4cGMndEQSfdwfAZXS
   Fh8tH0mittALP5qPQO8Kh2m1YHHCj3R2z4MIGJPXwVlsZAnF83q7T5rYO
   p3vYI54tJQuq1fncdQSh2BHjJSPJ//xdPygUMMgLTP55KEuOaVMDNuf02
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="312488237"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="312488237"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 02:43:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="592101868"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="592101868"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2022 02:43:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 02:43:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 02:43:05 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 02:43:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3Cmn+vbVS3vMLz0I0HEQdCrKpITb0X6t52xy27v5QjzHkq7LQYA2woSyWRkDXvYUo0lQc/cCKkZiyZJ4px40PqoBKJjfX29OjNxP//mz5DKmzc2Spd7/agH9kvUZeVZy00ufiT8XugE9m4cCrmd3p9J8bRZbtKj/usCDizGhRc1P2k7vDziTR2TMNIuzI41sHJcqyO0uGqX0Qpxl756Rcn4e2e7eJ0NKRaD/VebgWjCxAVxy+f5y5dLREoG9vpF4uMVglMWHMdwoNLK2IszNAHDg638SoRN59d0faEABrcIpYh/NHBnrig0BWHzZPtstbeFomcsMyiVJMOlqM052g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7RxhigFrl+k37JhQJq0oYJ08jabk87Z0Ckt+uYOToA=;
 b=eVQmeRd7fLjV2BloNicoYs0uUN37GEpD0uNmP2LBpcn51hEZUgXxab+wyJouKYXwroJshevQRTOqvsJEQFDGVnK+4FrMNigoL4Avo65MsmC7LzAZpD2DiNnBNnIV7M+dnCoICRN4a9HgYu495r3L4RXYtqr691WomwiB+C5XlkMEylN3cmf06sumd+49EKJ04TNTidunvWDBT0Zu90e43rDMPL3w3dIiAAdVyVGs1xgeuLdP/XMYdGW1arJyZWWlYKA9XaP+b33fO+TDU03DF1QdRZkrUowSRnntXTvsq8akfdks+2/Hdi2q7vDWHIRM5Rq8AgboWMx0EbdnQrTKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:43:03 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 10:43:03 +0000
Date:   Tue, 22 Nov 2022 11:42:57 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 1/3] selftests/xsk: print correct payload for packet
 dump
Message-ID: <Y3ynse0I7HgZ6rEX@boxer>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
 <20221115080538.18503-2-magnus.karlsson@gmail.com>
 <Y3OGJv2lym4u86C/@boxer>
 <CAJ8uoz3kLArrELgNi7gr_xx_9dPSD6QrwZvw9-2mzqHr9y_yTw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz3kLArrELgNi7gr_xx_9dPSD6QrwZvw9-2mzqHr9y_yTw@mail.gmail.com>
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: a434bf68-3662-4694-d6c1-08dacc76552d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfnG3XjKBdscGzAgYW985zptFkbuZktLe+8AejQhjpBf0rNOa8GVnKiszC2K/2oYeepe1Pn1g9KyphIxM4BjqJhcPJ7YVa2a1+25GPUf0UyNxFnAMkvshcD95JZvbdhygqGIJRh0w6X8VuSXJiacykrWjqlbbjJwwAzlROyq613HEzE6KltKAp1r2OSNJcIRN0zypNokOUNvcgcQqnZMVlVy+BuvICfP8nXQqJJv7t7voTehJvA9qofuBhiNP3Jn7WBHFXGO7RtQc458gZjLHhdd8U5CjyYqcuJZSx1SsMv6pXmMJcDX0XWX1TWAUnbHsDXldNrdd3+kPhJxGyiDygJY/LRePFKQ4suagFOaZDIwfnRcDEy3siyMC1O5RzLsshLsN9aLiHBh8eH9rbmbH6f3u5DxnJOKAo5reaehFHlF9a1cuDaHfhLTCX2e43tD5rJP22cF/JrWor3z6S4SzuWYu0nXQgsdtky5TItKHI1yud1utb9fM5ksXf4LjZwZE+jPL3bIQyeefPx+BkHqcbt2i9FKtvs8uVDFUObzn+wpvUjuTqAwe5Fbp0+QvzG3bBLFZUVIUfYMvWL3duozOClXq+OYbbHs7tJHV6VKPJ1OtDJwo133F8yytdeZG+f8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(41300700001)(4326008)(8676002)(66556008)(66476007)(66946007)(5660300002)(8936002)(478600001)(6916009)(316002)(6486002)(83380400001)(82960400001)(38100700002)(86362001)(26005)(6666004)(6506007)(53546011)(6512007)(186003)(9686003)(66899015)(33716001)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BvgXsYK9NmneRj6Y8KuT5E8RjdfB31V6Vqfc2Ry871dLCXhfAYoZMCaoNKzU?=
 =?us-ascii?Q?aB1fAxrEOwhA6Yb65rBbYjNy+mYaBEz9tCHHjzMkShwnEbFzLp9rk5F3FiaV?=
 =?us-ascii?Q?6/LrSpggBwzvcX3Xw6udea3X+SLQCtE/ANJxkFLbNSmElLlucpfFKYo+u7yl?=
 =?us-ascii?Q?zalXLZiFEqSOiT4rS4c9uetNZFbKBLdA5u1oVLJUg9Z3nBUYr8tvW9f+b42B?=
 =?us-ascii?Q?sMPzsNL743yKNOY1gPCc8aoYVsmtVO8pfVePkWbtTVVDAiGvcC3fyXlO07ct?=
 =?us-ascii?Q?gz0gDou0p+WJWKy2IR+TsZfaZz9wSz/DHSsG1NI8Nsz/eJYIJMs2H7eDaEre?=
 =?us-ascii?Q?JVwU4D81/7IJn07sSGDZCw341pnRRsf5CxtcHCZV4VC6OfEHtwQxXoPl8gjy?=
 =?us-ascii?Q?Pv9REHxkHBELwrI1uC0yQOx/DKF/o93t4m0sdsimrvXHIAZsZHxQbKb8B2Ny?=
 =?us-ascii?Q?DyGy5yTgp7h8+vHj+N8N0UaIWHIj5cTq4z9FdS1W1Ww6jeInzArgwDMdwfv/?=
 =?us-ascii?Q?ZmzrjTxrXQMFm/3LfsZaVIeD0BFONcNHo3oaZ/s9MZFOCYCnbL/gE2IlTQtS?=
 =?us-ascii?Q?T4QQcsrFeDVTh7HBxCDvvDrBGkt+wtCy1F9tm9+MO71jszRV4FL8x7Y/9HB+?=
 =?us-ascii?Q?lb3gXYNScKSVmd/IvXnz++1OqyOB3soM5EonlfjjNjzH+iSHMgvsBkA8+YQ3?=
 =?us-ascii?Q?W45hBatJhuON0GaKbQ7a/sXt4NpOIfERGDbI7r1L+HL05bsfyjkKUn5Ae3Bh?=
 =?us-ascii?Q?KliZ/sed0ugmjAl785hpGEpYdooyL95jfjMbGAbmaVsJ/leMHm5ATPJ5CY2+?=
 =?us-ascii?Q?/oVVXtCLXH1UOa5tlXeAX4N6Rs9pzdkoOXS3wB11eHKejjAHBx0BzGreerLW?=
 =?us-ascii?Q?erIpu2s1pvu2njmuYeclXId9bsboxGwUPfkAw3s6Bct5TwFKAqEf1Lpo0zAB?=
 =?us-ascii?Q?H8zf5dOLpCAXTro2tldgShlsoKrj24Gy6lG645EGhkP0DHpwJJ9xp43M2Ng+?=
 =?us-ascii?Q?8G6jVfycEMA7TpKvcUZT1W4oiV4qxROJr69B3G+522D7mWz09IqWeJSRJ4wU?=
 =?us-ascii?Q?eQdw3FWQpHcS3IvJKdSt/U2Nc8doP9uj7QyfiFgC+1ssm+K7WRo0YKNn6n9M?=
 =?us-ascii?Q?6OErVVbXfz9emH2TpFTegJPx99fvK4qDuFsDcEDG8/4eMsac0iD129RX6XvT?=
 =?us-ascii?Q?wpm3ga5nuhRmZcKtd7QqptvKt9W5S8IQPJxSNp7KY683kpS3SRSHqiVnl4Lf?=
 =?us-ascii?Q?Za8bfzDKf6BLpDC2GeX+uVrEsy2nxjUgidLmqWAfNDHqSokbQIg9CwppYX8K?=
 =?us-ascii?Q?o6OXIbotbraqlCCZhDHkwq9k2fX84LNCEj1Vgsb7Gb+bEXRUgfrABC3VR7fk?=
 =?us-ascii?Q?kh6UnMJmOEE89K0KirUvT9FmYeiNY3CFRKPJOTSnbgzZ1QIQH2zAI6sGNx0h?=
 =?us-ascii?Q?4q84ci28vEg9CO9d4EN6PhAQ+omS1imU0G/JWPUvcX1Jhsk1EMoQkvwg7xyN?=
 =?us-ascii?Q?VNuSz+CG8Zm8Q6J/kL6dNQ8h1hv5RtW/EJOkK7CTBdz6/O7ZAsHP1HTwxJAA?=
 =?us-ascii?Q?2VNs9AxAA3r1QUrUSPVlASu3uTvzRpCBm1GsEqXblKptduAdU/D8bpeEvwV8?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a434bf68-3662-4694-d6c1-08dacc76552d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:43:03.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nF9Bco3wPzESOaBGOWySa2fXqwp0vRM0NNEAu9Cull3s9ItROLqjFSgLk25/LP/m1Zdpm7GG/ljXCRSClSr0wjHAyCS4vS5kN6AMKWr8jLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 01:40:48PM +0100, Magnus Karlsson wrote:
> On Tue, Nov 15, 2022 at 1:29 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Tue, Nov 15, 2022 at 09:05:36AM +0100, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Print the correct payload when the packet dump option is selected. The
> > > network to host conversion was forgotten and the payload was
> > > erronously declared to be an int instead of an unsigned int. Changed
> > > the loop index i too, as it does not need to be an int and was
> > > declared on the same row.
> > >
> > > The printout looks something like this after the fix:
> > >
> > > DEBUG>> L2: dst mac: 000A569EEE62
> > > DEBUG>> L2: src mac: 000A569EEE61
> > > DEBUG>> L3: ip_hdr->ihl: 05
> > > DEBUG>> L3: ip_hdr->saddr: 192.168.100.161
> > > DEBUG>> L3: ip_hdr->daddr: 192.168.100.162
> > > DEBUG>> L4: udp_hdr->src: 2121
> > > DEBUG>> L4: udp_hdr->dst: 2020
> > > DEBUG>> L5: payload: 4
> > > ---------------------------------------
> >
> > Above would be helpful if previous output was included as well but not a
> > big deal i guess.
> 
> It would not bring any value IMHO. The only difference is that the
> "L5: payload" row is now showing the correct payload.

Ah okay then. I have already acked whole series, but just to make things
clear, I am okay with the current state of this patch:

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> > >
> > > Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > > index 681a5db80dae..51e693318b3f 100644
> > > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > > @@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
> > >       struct ethhdr *ethhdr;
> > >       struct udphdr *udphdr;
> > >       struct iphdr *iphdr;
> > > -     int payload, i;
> > > +     u32 payload, i;
> > >
> > >       ethhdr = pkt;
> > >       iphdr = pkt + sizeof(*ethhdr);
> > > @@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
> > >       fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
> > >       fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
> > >       /*extract L5 frame */
> > > -     payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
> > > +     payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
> > >
> > >       fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
> > >       fprintf(stdout, "---------------------------------------\n");
> > > --
> > > 2.34.1
> > >
