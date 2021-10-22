Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1BE437B71
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhJVRHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhJVRHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:07:37 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4188C061226;
        Fri, 22 Oct 2021 10:05:15 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h196so6297198iof.2;
        Fri, 22 Oct 2021 10:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=aOicbiME2BnKBlw3Dk0BrMP0wVjcmRzulWqjlzLwSCQ=;
        b=cdW6TAzqKQ5AUhN3093+i/BliSPkrf2o+V+QAW3FBdW47e2E6kop2Ff3OKG8KXHACJ
         jhNg4twWG9yzzsSDKQE0NMGX7CCqqkkI6KeuZI/xeXHtr17eMdMqiB/2XsjHYwnJTJg4
         HbkLpX/7S8u5q8BJHWDHk9Zi4C2pYJX376VHh8WWXTfU0jHgBRmg+191MYAUpmdDB1ZG
         lH+az8h0UAMFK6R+qyL6mY1oI0iayDAcS84CvZmwCrjZ99TZfY86/WyEsRqmZZZB/bCm
         XjscpIOFmmsKbP2Z6sVcfxsKKxJFRihPXvsrGZkfqpdFliZ1VDYCIP8jRUfOcxwQVSGf
         7VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=aOicbiME2BnKBlw3Dk0BrMP0wVjcmRzulWqjlzLwSCQ=;
        b=Y0bVIRLbRYNmnSSdRri+Zt3cGWOd0x2MOhvTLoAhoL5/IuUdWLgpaViJ3XyxSSM76x
         LS0YIiAiI0GwW9Xm+zqaFexpratP0mpO9Y7eg6yh1jUZXc2VRC8kQ8qcKlY5zeqg8O71
         WJ3pC8Z66Cox/3ouOhmhhWWSDiiQPtwLQ3phtEzD7u+Cyw4IZMay4VIxlfM7c8BkYBTU
         Lr1C8jOFKIRj4vjwRDiuZha5ba1ea2hbkdWgCBGIWLQwe+6lgqTj6AG+o3e0FT8ox34Y
         rLyl46x2YyCnMnCz5SGO+ICdzOwtmRjncsfAqnqx7BTidn9I+vf/JC0zxfRu6zFa69Gb
         OtrA==
X-Gm-Message-State: AOAM530dKR/3vMmV5Zjgku7IKsusk1NQZ1kBRHdJfeLi4yK2WeD1rkGE
        VAt/uPKC0ZxB7k3z7srrHiI=
X-Google-Smtp-Source: ABdhPJxMx2NhdH5diZ2QHqNazQmaVAp2wti9qiQPkutzsRaFumXXUnshVy2VWy8JFKVV8Dm60GM9gw==
X-Received: by 2002:a02:ce82:: with SMTP id y2mr675819jaq.121.1634922315117;
        Fri, 22 Oct 2021 10:05:15 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r9sm4699655ilb.28.2021.10.22.10.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:05:14 -0700 (PDT)
Date:   Fri, 22 Oct 2021 10:05:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch>
In-Reply-To: <20211011155636.2666408-2-sdf@google.com>
References: <20211011155636.2666408-1-sdf@google.com>
 <20211011155636.2666408-2-sdf@google.com>
Subject: RE: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/main.c |  4 ++++
>  tools/bpf/bpftool/prog.c | 15 +--------------
>  2 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 02eaaf065f65..8223bac1e401 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -409,6 +409,10 @@ int main(int argc, char **argv)
>  	block_mount = false;
>  	bin_name = argv[0];
>  
> +	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> +	if (ret)
> +		p_err("failed to enable libbpf strict mode: %d", ret);
> +

Would it better to just warn? Seems like this shouldn't be fatal from
bpftool side?

Also this is a potentially breaking change correct? Programs that _did_
work in the unstrict might suddently fail in the strict mode? If this
is the case whats the versioning plan? We don't want to leak these
type of changes across multiple versions, idealy we have a hard
break and bump the version.

I didn't catch a cover letter on the series. A small
note about versioning and upgrading bpftool would be helpful.


>  	hash_init(prog_table.table);
>  	hash_init(map_table.table);
>  	hash_init(link_table.table);
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 277d51c4c5d9..17505dc1243e 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  
>  	while (argc) {
>  		if (is_prefix(*argv, "type")) {
> -			char *type;
> -
>  			NEXT_ARG();
>  
>  			if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  			if (!REQ_ARGS(1))
>  				goto err_free_reuse_maps;
>  
> -			/* Put a '/' at the end of type to appease libbpf */
> -			type = malloc(strlen(*argv) + 2);
> -			if (!type) {
> -				p_err("mem alloc failed");
> -				goto err_free_reuse_maps;
> -			}
> -			*type = 0;
> -			strcat(type, *argv);
> -			strcat(type, "/");
> -
> -			err = get_prog_type_by_name(type, &common_prog_type,
> +			err = get_prog_type_by_name(*argv, &common_prog_type,
>  						    &expected_attach_type);
> -			free(type);
>  			if (err < 0)
>  				goto err_free_reuse_maps;

This wont potentially break existing programs correct? It looks like
just adding a '/' should be fine.

Thanks,
John
