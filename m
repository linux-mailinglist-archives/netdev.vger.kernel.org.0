Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53342118EFF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfLJR3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:29:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35212 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfLJR3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:29:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id c20so4141473wmb.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHgpwLrNeuOuBJWJ9xSmyd82zmrlT84LiK7U7bQGaIk=;
        b=vQegrrz1v7ISzbZoNbwq/XjGpzrc8KRF/ol4dkPLohqzkKKjhpOZPB8MPw4yOQ9oX4
         I4b8VGiBqgf1FokSJk+gBL0PGbZy26uXU/Hzx3u0vcxnzZWyFo8WMvB1G4AQlc28YV4r
         0qhDD2sECm5L052o3sCkCQFvUSeCLTWsqvX8kbxCRLVFK0sfFIhC5mlUp8nde5dVuRMI
         mD/0VLtbbiHC9g48bDYiQDgW9MM8slqeMXb1BLfMUrZHEIORUkMXr2QtkYCkbP9WG3m7
         4eB7uHXS2GRs8dN9DXT53YXumf88jo9aJdOpL4Yw3hbBkAKPP2YNYdIGROA/achQetWG
         9OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IHgpwLrNeuOuBJWJ9xSmyd82zmrlT84LiK7U7bQGaIk=;
        b=CjV5lmuHP2p628KDVpTDeijBsTZqGcRGm0deSlll30tdqcliOk1dndJ2rhRcLqjAWg
         K4aYwnpfGRRwZP5UcyeCzXwaI3wx3TwCoMOePphHiOxC8haoBQDKfJky0NrV+ItlBZ0n
         HTPzfIRImoZNQ95Rd1gql/oxdyKlDTayFo1WVtEObgZE1q9PxV1CgAZT0nRC7bihM6eZ
         haVZc6yS7QR0flfDEXdv3ZTF3HZIf9r4PFlE9ZdPHRKbh9eXQisq63rp8DZQxmZQ4vqh
         WlTcbW+sTKf254qhOiQ1uVOMAYFDF8R1t4sNAu9CpaZcsfyH2XDwaEHK8DdbuyhvKAK1
         lEKw==
X-Gm-Message-State: APjAAAXGV4Q5Ffq35N3urB3D4pZ5mbXFdA0Ilh6h22IDCEg0ify7k5/j
        gdfEcu79XeDxZR8exExv6byGzg==
X-Google-Smtp-Source: APXvYqwCJJFAZR6mB/jlnbIjmfv00hJEWtpBH4RF4JL5RApevSNapWQT49128Cz5FieaOsekKd10xQ==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr6218069wml.141.1575998960524;
        Tue, 10 Dec 2019 09:29:20 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r6sm3865728wrq.92.2019.12.10.09.29.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:29:19 -0800 (PST)
To:     Paul Chaignon <paul.chaignon@orange.com>, bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <4db34d127179faafd6eca408792222c922969904.1575991886.git.paul.chaignon@orange.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 1/3] bpftool: match several programs with same
 tag
Message-ID: <99f35770-9a3f-2135-a9a6-34d931b1ae1e@netronome.com>
Date:   Tue, 10 Dec 2019 17:29:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <4db34d127179faafd6eca408792222c922969904.1575991886.git.paul.chaignon@orange.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

2019-12-10 17:06 UTC+0100 ~ Paul Chaignon <paul.chaignon@orange.com>
> When several BPF programs have the same tag, bpftool matches only the
> first (in ID order).  This patch changes that behavior such that dump and
> show commands return all matched programs.  Commands that require a single
> program (e.g., pin and attach) will error out if given a tag that matches
> several.  bpftool prog dump will also error out if file or visual are
> given and several programs have the given tag.
> 
> In the case of the dump command, a program header is added before each
> dump only if the tag matches several programs; this patch doesn't change
> the output if a single program matches.
> 
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> ---
>  .../bpftool/Documentation/bpftool-prog.rst    |  16 +-
>  tools/bpf/bpftool/prog.c                      | 371 ++++++++++++------
>  2 files changed, 272 insertions(+), 115 deletions(-)
> 

> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 4535c863d2cd..ca4278269e73 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -25,6 +25,11 @@
>  #include "main.h"
>  #include "xlated_dumper.h"
>  
> +enum dump_mode {
> +	DUMP_JITED,
> +	DUMP_XLATED,
> +};
> +
>  static const char * const attach_type_strings[] = {
>  	[BPF_SK_SKB_STREAM_PARSER] = "stream_parser",
>  	[BPF_SK_SKB_STREAM_VERDICT] = "stream_verdict",
> @@ -77,11 +82,13 @@ static void print_boot_time(__u64 nsecs, char *buf, unsigned int size)
>  		strftime(buf, size, "%FT%T%z", &load_tm);
>  }
>  
> -static int prog_fd_by_tag(unsigned char *tag)
> +static int
> +prog_fd_by_tag(unsigned char *tag, int *fds)

Nit: No line break necessary if it fits on one line.
(Sorry for misleading you on that in an earlier discussion :/)

>  {
>  	unsigned int id = 0;
> +	int fd, nb_fds = 0;
> +	void *tmp;
>  	int err;
> -	int fd;
>  
>  	while (true) {
>  		struct bpf_prog_info info = {};

[...]

> @@ -351,21 +421,43 @@ static int show_prog(int fd)
>  
>  static int do_show(int argc, char **argv)
>  {
> +	int fd, nb_fds, i;
> +	int *fds = NULL;
>  	__u32 id = 0;
>  	int err;
> -	int fd;
>  
>  	if (show_pinned)
>  		build_pinned_obj_table(&prog_table, BPF_OBJ_PROG);
>  
>  	if (argc == 2) {
> -		fd = prog_parse_fd(&argc, &argv);
> -		if (fd < 0)
> +		fds = malloc(sizeof(int));
> +		if (!fds) {
> +			p_err("mem alloc failed");
>  			return -1;
> +		}
> +		nb_fds = prog_parse_fds(&argc, &argv, fds);
> +		if (nb_fds < 1)
> +			goto err_free;
>  
> -		err = show_prog(fd);
> -		close(fd);
> -		return err;
> +		if (json_output && nb_fds > 1)
> +			jsonw_start_array(json_wtr);	/* root array */
> +		for (i = 0; i < nb_fds; i++) {
> +			err = show_prog(fds[i]);
> +			close(fds[i]);
> +			if (err) {
> +				for (i++; i < nb_fds; i++)
> +					close(fds[i]);
> +				goto err_free;

Alternatively, we could keep trying to list the remaining programs. For
example, if the system has a long list of BPF programs running and one
of them is removed while printing the list, we would still have the rest
of the list.

If we went this way, maybe just set err to non-zero if no program at all
could be printed?

> +			}
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
