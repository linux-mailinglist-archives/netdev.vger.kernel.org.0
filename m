Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E93F277963
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgIXTcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:32:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:24657 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgIXTcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 15:32:25 -0400
IronPort-SDR: XnQslgfioWbLlkJO5tr/dIipgsPnndZvf/oThS5526YhbNEDDa5PeLv8zbZYc5J/0/BjeLJtKu
 t44th3rcMKIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="141333506"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="141333506"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:32:25 -0700
IronPort-SDR: 1pfq+OAgEiSwB4AeF3hmaszVBhe2sxt5b0Ts5MPJpMAViOE+gvoRXZ6TwG1gy/Fq5C6r20EAOd
 dBvbA9Qy4O+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="291356077"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 24 Sep 2020 12:32:23 -0700
Date:   Thu, 24 Sep 2020 21:25:08 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 5/6] bpf, selftests: use bpf_tail_call_static
 where appropriate
Message-ID: <20200924192508.GA34764@ranger.igk.intel.com>
References: <cover.1600967205.git.daniel@iogearbox.net>
 <0c8a5df84b2f174412c252ad32734d3545947b31.1600967205.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c8a5df84b2f174412c252ad32734d3545947b31.1600967205.git.daniel@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 08:21:26PM +0200, Daniel Borkmann wrote:
> For those locations where we use an immediate tail call map index use the
> newly added bpf_tail_call_static() helper.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/testing/selftests/bpf/progs/bpf_flow.c  | 12 ++++----
>  tools/testing/selftests/bpf/progs/tailcall1.c | 28 +++++++++----------
>  tools/testing/selftests/bpf/progs/tailcall2.c | 14 +++++-----
>  tools/testing/selftests/bpf/progs/tailcall3.c |  4 +--
>  .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |  4 +--
>  .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  6 ++--
>  .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |  6 ++--
>  .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  6 ++--
>  8 files changed, 40 insertions(+), 40 deletions(-)

One nit, while you're at it, maybe it would be good to also address the
samples/bpf/sockex3_kern.c that is also using the immediate map index?

[...]
