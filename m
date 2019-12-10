Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7184118F04
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfLJR3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:29:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41938 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfLJR3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:29:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so21053086wrw.8
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aDmC92jBqiL+/WoMc+0FY9tr4/vQFb7jJJbUuvUOxgk=;
        b=GNnaibblkhsIakHJW7Pcm0KSdPkdDEu/YacNWKldOTxAtoBmpNF1qRUTT58RICahb3
         myNMq41VY2pHmYgZPbYDYGE7ZfzKN+ZzWVBDTy/FuZZVKpXMBlcoybwe2ZVSvr0DqcCq
         8Dv+pDqw6hr3x4H8mbhnLY5T50Q1N7q2GnT4OhHL0K3uuptI1zMihaPCHD7Wj0n/84HF
         rz1GbxjdUKAbKGL4USg2rVYAb4G3hkzXTXKXC9JL2endyRGOiQXcv6bMcJIDO5pWbc8v
         Ss1K696T7dweWmGRZYw0AknAA1/7eDQGmWVPVAbxvFHCy8/ryn/7ILV58csSzUyFyMRo
         824A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aDmC92jBqiL+/WoMc+0FY9tr4/vQFb7jJJbUuvUOxgk=;
        b=BIH+hWbbXdrT7qG41YUAUp9Tym9BZ+bTxvtms+g89MJyZOpNSqciTLihqqMRRgLP76
         9FKvt4AdIYzmkdL3WAtQheHbgdV6zHzj2wj9o5nmFFJ4rMBx2ZbQ2QaEAtZkxkbbPVXm
         AliL+ZzA1espAuY/SFQGsYnHbZWpMkjHr0cuPipBS8iM6QytGvXy/FmTneWtKtL2WZ92
         WSxvdphIHw1rpQ2OzM2IIUHmDWkhRrU2J3iBc+vLJOvhnkQdpT7Q4gwdWF4T0Yd2rq37
         rEYQ0rscquvnk/hDuaOojDpZ+8jDuGguDH1ONyfulrAU6M/yUNK50/gUAwspbiE03KoX
         zFrw==
X-Gm-Message-State: APjAAAVG6WI9wHeNAI3HC3p/R7hfPxfeWkYRhu6jaymbBfr398PAQlEI
        YpM3ttEiTswXoMSl8lX87HvYGQ==
X-Google-Smtp-Source: APXvYqzZ32OZ43XiDmnL0tZ+0N4vglz77WKkPK0994O0BNNY3gZaGRbpeBkXnQ1BWAJeSTojSEDqVw==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr4536101wrl.190.1575998991273;
        Tue, 10 Dec 2019 09:29:51 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id z11sm3684519wrt.82.2019.12.10.09.29.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:29:50 -0800 (PST)
To:     Paul Chaignon <paul.chaignon@orange.com>, bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <06aad9217a37b0582407cab11469125e645f5084.1575991886.git.paul.chaignon@orange.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 3/3] bpftool: match maps by name
Message-ID: <61747303-6cd5-e2e7-749f-13068085ed9c@netronome.com>
Date:   Tue, 10 Dec 2019 17:29:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <06aad9217a37b0582407cab11469125e645f5084.1575991886.git.paul.chaignon@orange.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-12-10 17:06 UTC+0100 ~ Paul Chaignon <paul.chaignon@orange.com>
> This patch implements lookup by name for maps and changes the behavior of
> lookups by tag to be consistent with prog subcommands.  Similarly to
> program subcommands, the show and dump commands will return all maps with
> the given name (or tag), whereas other commands will error out if several
> maps have the same name (resp. tag).
> 
> When a map has BTF info, it is dumped in JSON with available BTF info.
> This patch requires that all matched maps have BTF info before switching
> the output format to JSON.
> 
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> ---
>  .../bpf/bpftool/Documentation/bpftool-map.rst |  10 +-
>  tools/bpf/bpftool/bash-completion/bpftool     | 131 ++++++-
>  tools/bpf/bpftool/main.h                      |   2 +-
>  tools/bpf/bpftool/map.c                       | 366 +++++++++++++++---
>  4 files changed, 432 insertions(+), 77 deletions(-)
> 

> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 05b5be4a6ef9..21c676a1eeb1 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool

Nice work on the completion, thanks!

> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index de61d73b9030..f0e0be08ba21 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c

[...]

> @@ -654,14 +771,42 @@ static int do_show(int argc, char **argv)
>  		build_pinned_obj_table(&map_table, BPF_OBJ_MAP);
>  
>  	if (argc == 2) {
> -		fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
> -		if (fd < 0)
> +		fds = malloc(sizeof(int));
> +		if (!fds) {
> +			p_err("mem alloc failed");
>  			return -1;
> +		}
> +		nb_fds = map_parse_fds(&argc, &argv, fds);
> +		if (nb_fds < 1)
> +			goto err_free;
> +
> +		if (json_output && nb_fds > 1)
> +			jsonw_start_array(json_wtr);	/* root array */
> +		for (i = 0; i < nb_fds; i++) {
> +			err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
> +			if (err) {
> +				p_err("can't get map info: %s",
> +				      strerror(errno));
> +				for (; i < nb_fds; i++)
> +					close(fds[i]);
> +				goto err_free;

Same remarks as on patch 1, we may want to keep listing the maps even if
we get a failure for one of them?

> +			}
>  
> -		if (json_output)
> -			return show_map_close_json(fd, &info);
> -		else
> -			return show_map_close_plain(fd, &info);
> +			if (json_output)
> +				show_map_close_json(fds[i], &info);
> +			else
> +				show_map_close_plain(fds[i], &info);
> +
> +			close(fds[i]);
> +		}
> +		if (json_output && nb_fds > 1)
> +			jsonw_end_array(json_wtr);	/* root array */
> +
> +		return 0;
> +
> +err_free:
> +		free(fds);
> +		return -1;
>  	}
>  
>  	if (argc)

The rest of the code looks good to me, thanks a lot for working on this!
Quentin
