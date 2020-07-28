Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F2230A60
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgG1Mi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:38:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:42016 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgG1Miz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 08:38:55 -0400
IronPort-SDR: oNVrUeLVHk6FcztJVFWrim2q/HfgLgajrWJiykyAgXTMod7JBsYiB/8fs7hNWU4hZZ6hf0MhsJ
 OLPG9xiy8YsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="138715804"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="138715804"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 05:38:54 -0700
IronPort-SDR: VWJkwtOzDp4FwvbZKd9uLQm5fepGPcAwZzSmCGCWRqfpGDmdUhT1P9ukakF5bt11tI3MIiHiDY
 70+3z/QHsEnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="320374771"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 28 Jul 2020 05:38:48 -0700
Date:   Tue, 28 Jul 2020 14:33:27 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sameehj@amazon.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, kuba@kernel.org,
        hawk@kernel.org, shayagr@amazon.com, lorenzo@kernel.org
Subject: Re: [PATCH RFC net-next 0/2] XDP multi buffer helpers
Message-ID: <20200728123327.GB25823@ranger.igk.intel.com>
References: <20200727125653.31238-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727125653.31238-1-sameehj@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:56:51PM +0000, sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This series is based on the series that Lorenzo sent [0].

What is your final design for multi buffer support in XDP?
Why don't you provide a single RFC that is fully functional but instead
you're sending a bunch of separate RFCs?

IMHO it's a weird strategy. Not sure what others think about.

> 
> This series simply adds new bpf helpers for xdp mb support as well as
> introduces a sample program that uses them.
> 
> [0] - [RFC net-next 00/22] Introduce mb bit in xdp_buff/xdp_frame

Direct link wouldn't hurt I guess :) Please also include all the previous
discussions that took place on mailing list around this topic. This will
make reviewers life easier I suppose. As I asked above, I'm not sure
what's your final design for this feature.

> 
> Sameeh Jubran (2):
>   xdp: helpers: add multibuffer support
>   samples/bpf: add bpf program that uses xdp mb helpers
> 
>  include/uapi/linux/bpf.h       |  13 +++
>  net/core/filter.c              |  60 ++++++++++++++
>  samples/bpf/Makefile           |   3 +
>  samples/bpf/xdp_mb_kern.c      |  66 ++++++++++++++++
>  samples/bpf/xdp_mb_user.c      | 174 +++++++++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  13 +++
>  6 files changed, 329 insertions(+)
>  create mode 100644 samples/bpf/xdp_mb_kern.c
>  create mode 100644 samples/bpf/xdp_mb_user.c
> 
> -- 
> 2.16.6
> 
