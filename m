Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09601E10C8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404093AbgEYOmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:42:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:36119 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404068AbgEYOmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 10:42:14 -0400
IronPort-SDR: dgT/YHtvCvbhb6DJqKB22y/obrccDhXNjQPsXrXMV358D2tGQHGePY2nLyc56+2t3XmBpUEn+/
 tKYeklgkbR2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 07:42:13 -0700
IronPort-SDR: m+ECazrk/RFy6x8os4mhKDVlQlSovraROTC+d9UpXtCAfP0yzrdDvoREiIZhb8VeFNlNvlYjXG
 teZy/peLXXrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,433,1583222400"; 
   d="scan'208";a="266165414"
Received: from bpawlows-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.40.57])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2020 07:42:10 -0700
Subject: Re: [PATCH] MAINTAINERS: adjust entry in XDP SOCKETS to actual file
 name
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        maciej.fijalkowski@intel.com, Alexei Starovoitov <ast@kernel.org>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200525141553.7035-1-lukas.bulwahn@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9d930e0e-5c77-11b8-6a8b-982fac711f6d@intel.com>
Date:   Mon, 25 May 2020 16:42:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525141553.7035-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-25 16:15, Lukas Bulwahn wrote:
> Commit 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API") added a
> new header file include/net/xsk_buff_pool.h, but commit 28bee21dc04b
> ("MAINTAINERS, xsk: Update AF_XDP section after moves/adds") added a file
> entry referring to include/net/xsk_buffer_pool.h.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:
> 
>    warning: no file matches  F:  include/net/xsk_buffer_pool.h
> 
> Adjust the entry in XDP SOCKETS to the actual file name.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Björn, please pick this minor non-urgent patch.
> 
> applies to next-20200525 on top of the commits mentioned above
>

Thanks Lukas!

Daniel/Alexei, this should go to the bpf-next tree.


Thanks!
Björn


>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a442b48f24b..895c5202fe9b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18667,7 +18667,7 @@ L:	netdev@vger.kernel.org
>   L:	bpf@vger.kernel.org
>   S:	Maintained
>   F:	include/net/xdp_sock*
> -F:	include/net/xsk_buffer_pool.h
> +F:	include/net/xsk_buff_pool.h
>   F:	include/uapi/linux/if_xdp.h
>   F:	net/xdp/
>   F:	samples/bpf/xdpsock*
> 
