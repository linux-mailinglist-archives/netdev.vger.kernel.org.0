Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6753C2BA73C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKTKUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:20:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:2583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTKUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 05:20:09 -0500
IronPort-SDR: qAd9Y4jY3p0s6fUTkdaCkBvlRsug3v4qPBa9h/Q8pAsrZxR0L1uorsqmmBM4aPNyB2Zws1EH+l
 zqxSLhPV+R4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="170669444"
X-IronPort-AV: E=Sophos;i="5.78,356,1599548400"; 
   d="scan'208";a="170669444"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 02:20:09 -0800
IronPort-SDR: wmc0JH8A7o1ERwpw4MsSCZ5YZBzwpK2CGxwjAJk6lkbSCf5qUeJJA8JSeiv2S+AasTeqLfLvwU
 3eW9LBYnDlhA==
X-IronPort-AV: E=Sophos;i="5.78,356,1599548400"; 
   d="scan'208";a="477175051"
Received: from schuenem-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.37.132])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 02:20:06 -0800
Subject: Re: [PATCH net-next V3] MAINTAINERS: Update XDP and AF_XDP entries
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>, joe@perches.com
References: <160586238944.2808432.4401269290440394008.stgit@firesoul>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c40b7ae2-78e5-a507-79df-4968924a0cfb@intel.com>
Date:   Fri, 20 Nov 2020 11:20:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <160586238944.2808432.4401269290440394008.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 09:53, Jesper Dangaard Brouer wrote:
> Getting too many false positive matches with current use
> of the content regex K: and file regex N: patterns.
> 
> This patch drops file match N: and makes K: more restricted.
> Some more normal F: file wildcards are added.
> 
> Notice that AF_XDP forgot to some F: files that is also
> updated in this patch.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks Jesper!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   MAINTAINERS |   12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index af9f6a3ab100..f827f504251b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19105,12 +19105,17 @@ L:	netdev@vger.kernel.org
>   L:	bpf@vger.kernel.org
>   S:	Supported
>   F:	include/net/xdp.h
> +F:	include/net/xdp_priv.h
>   F:	include/trace/events/xdp.h
>   F:	kernel/bpf/cpumap.c
>   F:	kernel/bpf/devmap.c
>   F:	net/core/xdp.c
> -N:	xdp
> -K:	xdp
> +F:	samples/bpf/xdp*
> +F:	tools/testing/selftests/bpf/*xdp*
> +F:	tools/testing/selftests/bpf/*/*xdp*
> +F:	drivers/net/ethernet/*/*/*/*/*xdp*
> +F:	drivers/net/ethernet/*/*/*xdp*
> +K:	(?:\b|_)xdp(?:\b|_)
>   
>   XDP SOCKETS (AF_XDP)
>   M:	Björn Töpel <bjorn.topel@intel.com>
> @@ -19119,9 +19124,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
>   L:	netdev@vger.kernel.org
>   L:	bpf@vger.kernel.org
>   S:	Maintained
> +F:	Documentation/networking/af_xdp.rst
>   F:	include/net/xdp_sock*
>   F:	include/net/xsk_buff_pool.h
>   F:	include/uapi/linux/if_xdp.h
> +F:	include/uapi/linux/xdp_diag.h
> +F:	include/net/netns/xdp.h
>   F:	net/xdp/
>   F:	samples/bpf/xdpsock*
>   F:	tools/lib/bpf/xsk*
> 
> 
