Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598312ADA7F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731174AbgKJPgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:36:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:21153 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgKJPgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:36:36 -0500
IronPort-SDR: IVhKB9KSv94U2xOjHbOCWEUmJmhs6o91HgGE/gF1fPcq3e+Pzfb9EfPw71V9SrmcGa9+K59qny
 C5go1MF2LUYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="170150358"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="170150358"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 07:36:32 -0800
IronPort-SDR: qV9nGGu/OXsEWu9weOIelifOfq5ZJzlQMF8wk/exsZy322TiS+UNMD5c3HKjlHgIQhayhSEop5
 w8wnNasg7spw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="541364710"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2020 07:36:30 -0800
Date:   Tue, 10 Nov 2020 16:24:29 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next] samples/bpf: add xdp_redirect_map with xdp_prog
 support
Message-ID: <20201110152429.GA5283@ranger.igk.intel.com>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201110152510.2a7fa65c@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110152510.2a7fa65c@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 03:25:10PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 10 Nov 2020 20:46:39 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > This patch add running xdp program on egress interface support for
> > xdp_redirect_map sample. The new prog will change the IP ttl based
> > on egress ifindex.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  samples/bpf/xdp_redirect_map_kern.c | 74 ++++++++++++++++++++++++++++-
> >  samples/bpf/xdp_redirect_map_user.c | 21 ++++----
> 
> Hmmm... I don't think is it a good idea to modify xdp_redirect_map this way.
> 
> The xdp_redirect_map is used for comparative benchmarking and
> mentioned+used in scientific articles.  As far as I can see, this
> change will default slowdown xdp_redirect_map performance, right?

+1

User should be able to trigger attachment of this xdp egress prog by
himself. I don't like having it as a mandatory thing on this sample.

> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
