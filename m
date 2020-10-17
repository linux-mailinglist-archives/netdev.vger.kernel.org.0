Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436A6290F73
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411858AbgJQFiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:38:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:41860 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392570AbgJQFiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 01:38:22 -0400
IronPort-SDR: llpWoGz3ausfJPWoqr7tZ4XMH0a1k5v+bEwN/q8WZ4Ub2/TF81OlWBI+NUAZFKTuqGvVvGG0I0
 SBVMf5Vu0Z8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="153636519"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="153636519"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:35:01 -0700
IronPort-SDR: Q4TUQpLRhrUKKVN5Spl62aIu9r1QZwd83TmEaFRVHdUW+Ja41cU/hoXpVKtP6uRHym8QOrAuOa
 xVzPAwQgHS5Q==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="331325349"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:35:00 -0700
Date:   Fri, 16 Oct 2020 17:34:58 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Toke =?ISO-8859-1?Q?H=F8ila?= =?ISO-8859-1?Q?nd-J=F8rgensen\?=" 
        <toke@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Cassen <acassen@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tools/include: Update if_link.h and netlink.h
Message-ID: <20201016173458.00000597@intel.com>
In-Reply-To: <20201016143201.0c12c03b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201015223119.1712121-1-irogers@google.com>
        <20201016142348.0000452b@intel.com>
        <20201016143201.0c12c03b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> On Fri, 16 Oct 2020 14:23:48 -0700 Jesse Brandeburg wrote:
> > > These are tested to be the latest as part of the tools/lib/bpf build.  
> > 
> > But you didn't mention why you're making these changes, and you're
> > removing a lot of comments without explaining why/where there might be
> > a replacement or why the comments are useless. I now see that you're
> > adding actual kdoc which is good, except for the part where
> > you don't put kdoc on all the structures.
> 
> Note that he's just syncing the uAPI headers to tools/
> 
> The source of the change is here:
> 
> 78a3ea555713 ("net: remove comments on struct rtnl_link_stats")
> 0db0c34cfbc9 ("net: tighten the definition of interface statistics")


Thanks Kuba, I'm not trying to be a hard ass, but the commit message
didn't say why he's making the change, and if I bisect back to this
and see "sync" as the commit message, I think I'd be stuck chasing
"sync to what?"

I guess that his changelog could just say what you said?

Proposed:
Sync the uAPI headers so that userspace and the kernel match. These
changes match the updates to the files in the tools directory that were
already updated by commits:
78a3ea555713 ("net: remove comments on struct rtnl_link_stats")
0db0c34cfbc9 ("net: tighten the definition of interface statistics")
