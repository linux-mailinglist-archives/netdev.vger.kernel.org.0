Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579092B866E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgKRVQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKRVQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:16:09 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D936FC0613D4;
        Wed, 18 Nov 2020 13:16:07 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id o11so3602678ioo.11;
        Wed, 18 Nov 2020 13:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ID5JOLIfQntBjfE9mqw+s+lif9h6mnkwx9+Qn6RbCxw=;
        b=nqZkdYzb+MDYbxVrAvw2ZvsUdFvuI7FI5a4GUFn3iCvRSBd7f3ycN21FxabIT8ysxQ
         rrCkMTE2HjHFjz8z5NU4w0ft5FY7jhWW/3jPm4+qDBZZAFyhHHNtbfcOjKYY0jYeXCpq
         WPiX/W0U4MRwpq02rtfxbGFRExlO/9jI3AEQM5EsutRrE2uQJJk6+hOKyhDJ22zVmkjc
         iIIVk+MfXucIJfDAjUR4OhUx1P5JKZbcv3z7ysu9QevnP0+rLXtACWNQZ9n15JZhCcxP
         yPfYn4P8qlZwaUYGGtdA3tw6Kqa5tbKr2nGx1xK+vaRk1r7okJOIrzJrcaf5J26rhfE1
         7klQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ID5JOLIfQntBjfE9mqw+s+lif9h6mnkwx9+Qn6RbCxw=;
        b=F949+cFNOOBr6fMV7+EwbyvUqicJXC4zoIvQeqLshFa8tKzQ/n73YGO3zJavWHNurE
         1Q0+DoMB7OXav4YtNsMLUEdWb7t8rrgy1zDZy6FEP10T5RCNBDWhbo+ZuvDeZA3sBSXp
         V9+wq4t/iaEetHmSGxB05Lsugb4n7nwnNDa9gNcQIpkPSfbUgtMrnQhozms+aKLYLc6e
         UmUAWK+jEBduWnJcaD5gbkgES4DfigTnLaFA1xhhOCyjkN/ngi8MY/6fqNtHtOQ5m8uT
         GkibVoBhfQJkgAOVFCXhOUJZ64tezXuC0DU3JXDr1FmuNRJDGfSvoy5fuv1HXc2AlEml
         gx+w==
X-Gm-Message-State: AOAM531j8fA2iRUcR9N2KBcdWmXa0n6N/WMhR86zTJmX/75LFArfUr1j
        W4U8c8nvtJG2WWVQhmrEVmc=
X-Google-Smtp-Source: ABdhPJy57VPFR7FcFi891hjG3qDvsgxWPfi1BtcfuOADirEaAOm+gmU+0bzxoWbI5g71iiNhzBX3+g==
X-Received: by 2002:a5d:9d16:: with SMTP id j22mr17535889ioj.172.1605734167234;
        Wed, 18 Nov 2020 13:16:07 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id p24sm16653432ill.59.2020.11.18.13.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 13:16:06 -0800 (PST)
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_version() function to get
 library version at runtime
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        haliu@redhat.com, jbenc@redhat.com
References: <20201118170738.324226-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <754122eb-676f-0b5a-4deb-24658750eefb@gmail.com>
Date:   Wed, 18 Nov 2020 14:16:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118170738.324226-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 10:07 AM, Toke Høiland-Jørgensen wrote:
> As a response to patches adding libbpf support to iproute2, an extensive
> discussion ensued about libbpf version visibility and enforcement in tools
> using the library[0]. In particular, two problems came to light:
> 
> 1. If a tool is statically linked against libbpf, there is no way for a user
>    to discover which version of libbpf the tool is using, unless the tool
>    takes particular care to embed the library version at build time and print
>    it.
> 
> 2. If a tool is dynamically linked against libbpf, but doesn't use any
>    symbols from the latest library version, the library version used at
>    runtime can be older than the one used at compile time, and the
>    application has no way to verify the version at runtime.
> 
> To make progress on resolving this, let's add a libbpf_version() function that
> will simply return a version string which is embedded into the library at
> compile time. This makes it possible for applications to unambiguously get the
> library version at runtime, resolving (2.) above, and as an added bonus makes it
> easy for applications to print the library version, which should help with (1.).
> 
> [0] https://lore.kernel.org/bpf/20201109070802.3638167-1-haliu@redhat.com/T/#t
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/Makefile   |  1 +
>  tools/lib/bpf/libbpf.c   | 12 ++++++++++++
>  tools/lib/bpf/libbpf.h   |  1 +
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 15 insertions(+)
> 
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 5f9abed3e226..c9999e09a0c8 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -107,6 +107,7 @@ override CFLAGS += -Werror -Wall
>  override CFLAGS += $(INCLUDES)
>  override CFLAGS += -fvisibility=hidden
>  override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> +override CFLAGS += -DLIBBPF_VERSION="$(LIBBPF_VERSION)"
>  
>  # flags specific for shared library
>  SHLIB_FLAGS := -DSHARED -fPIC
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 313034117070..dc7bb3001fa6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -136,6 +136,18 @@ static void pr_perm_msg(int err)
>  
>  #define STRERR_BUFSIZE  128
>  
> +#ifndef LIBBPF_VERSION
> +#define LIBBPF_VERSION unset
> +#endif
> +#define __str(s) #s
> +#define _str(s) __str(s)
> +static const char *_libbpf_version = _str(LIBBPF_VERSION);
> +
> +const char *libbpf_version(void)
> +{
> +	return _libbpf_version;
> +}
> +
>  /* Copied from tools/perf/util/util.h */
>  #ifndef zfree
>  # define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6909ee81113a..d8256bc1e02e 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -45,6 +45,7 @@ enum libbpf_errno {
>  };
>  
>  LIBBPF_API int libbpf_strerror(int err, char *buf, size_t size);
> +LIBBPF_API const char *libbpf_version(void);
>  
>  enum libbpf_print_level {
>          LIBBPF_WARN,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 29ff4807b909..5f931bf1b5b0 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -345,4 +345,5 @@ LIBBPF_0.3.0 {
>  		btf__parse_split;
>  		btf__new_empty_split;
>  		btf__new_split;
> +                libbpf_version;
>  } LIBBPF_0.2.0;
> 

a good export for libraries in general to track not just the compiled
against version, but the run time version. It would be good to have the
option to add the git hash of the top commit to LIBBPF_VERSION as well
to make it easier to track dev builds.
