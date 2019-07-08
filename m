Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C724E61C1A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfGHJKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:10:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35770 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfGHJKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:10:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so7543858wrm.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nApOmxa/nTZssl96687LobLLtQEE95aAXmDznI6KUpI=;
        b=xSR/Vz6cpt09stA0c41KLhwvu1dUG3Eehg75wMim4sj7gB3nMys+y1Qja7XSqbHhgk
         O/CbnBSurvylqlPt7+GG6VNcOuBE1Ghna/u6CuhLgr9FKqcWjCDxpFw/cwaPOFY84ZMo
         WvzBoVLKgqsV3S3HlbrRkAitVCSfINQ0Odlw8bfS76PkzhUNJTe5Nw6Zgk+BUUHeW7BT
         XsCv2C5qRf3xo1JhSuA8Yxmu9yXF621yo8fuTu2KQQQefj0dSqoZzWikK4z1JeeK+R0O
         OeeVtOMTWKq4vqPoJfbx1FnE6KVwxZ70NcoB0rHLMXITVV6e6fPcrwmsa45sS6fkwbF+
         wdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nApOmxa/nTZssl96687LobLLtQEE95aAXmDznI6KUpI=;
        b=ILoQeol519unaCCJO1kkJNVhqBhjR+x/ij/gp+HNunydw7venw9n/RKAGc3CoZuuuS
         J6ObNhgdxOkdZT7o4PfOWJ6/1vx3oTuRHNE3GBTQN8x/fzLf/xMlHqsoSlhz+tOCMlMF
         +OOh0ph9xWP8BuNrGwfta7r5q6Hi/ZGlZAmN7WpxHOwxPNTFJIAeU10ey6yEtRmozna8
         5UYwS+6/BBJhmnstDknLT8CEysGfuaya77iiRRAmgme7Ytr55yTi0ViX/enLOSWo+rr4
         foz8GPiEiBWAUmDLsnLe8e6ugl+K0cllVdPoL7mUTFMY8SBshshVS4Tajx7oNwmtomxI
         Q7Sw==
X-Gm-Message-State: APjAAAVTgSsj88ml3YgFgOFC2nNyqAZ9mK5WuvNNi4Nxoo+8WVHxZBLF
        UI9rdXCluMpAsLww7+UozHMrxQ==
X-Google-Smtp-Source: APXvYqyjS32Qxfrpd1TCGrSwfuupNPwNIOg3TDdhDzJVSXyqQXBXOhCNkI8VK+ycY0C/+eb/1Fkkiw==
X-Received: by 2002:a5d:6908:: with SMTP id t8mr18561323wru.147.1562577002107;
        Mon, 08 Jul 2019 02:10:02 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.187.142])
        by smtp.gmail.com with ESMTPSA id t6sm18065447wmb.29.2019.07.08.02.10.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 02:10:01 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 6/6] tools: Add definitions for devmap_hash
 map type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
 <156240283611.10171.18010849007723279211.stgit@alrua-x1>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <767cade7-4cc4-b47d-a8ca-a30c01e0ba47@netronome.com>
Date:   Mon, 8 Jul 2019 10:10:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156240283611.10171.18010849007723279211.stgit@alrua-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-06 10:47 UTC+0200 ~ Toke Høiland-Jørgensen <toke@redhat.com>
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This adds a selftest, syncs the tools/ uapi header and adds the
> devmap_hash name to bpftool for the new devmap_hash map type.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tools/bpf/bpftool/map.c                 |    1 +
>  tools/include/uapi/linux/bpf.h          |    1 +
>  tools/testing/selftests/bpf/test_maps.c |   16 ++++++++++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 5da5a7311f13..c345f819b840 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -37,6 +37,7 @@ const char * const map_type_name[] = {
>  	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
>  	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
>  	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
> +	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
>  	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
>  	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
>  	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index cecf42c871d4..8afaa0a19c67 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -134,6 +134,7 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_QUEUE,
>  	BPF_MAP_TYPE_STACK,
>  	BPF_MAP_TYPE_SK_STORAGE,
> +	BPF_MAP_TYPE_DEVMAP_HASH,
>  };
>  
>  /* Note that tracing related programs such as

Hi Toke, thanks for the bpftool update!

Could you please also complete the documentation and bash completion for
the map type? We probably want to add the new name to the "bpftool map
help" message [0], to the manual page [1], and to the bash completion
file [2].

Thanks,
Quentin

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/bpf/bpftool/map.c?h=v5.2-rc6#n1271
[1]
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/bpf/bpftool/Documentation/bpftool-map.rst?h=v5.2-rc6#n46
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/bpf/bpftool/bash-completion/bpftool?h=v5.2-rc6#n449
