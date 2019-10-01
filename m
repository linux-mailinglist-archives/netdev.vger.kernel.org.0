Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE0C40C0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfJATK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:10:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41961 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfJATK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:10:26 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so22372691ioj.8;
        Tue, 01 Oct 2019 12:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=JdM7k75IUpAdAhgdRlysrqDwZxM23pbxIW2rHhhMMAY=;
        b=Co/HVCfzToM6EhYCuoKERf1TaCLV0nUQ2H4a1ca/+//y7FkSdNvBgdcEzPXKHLRVf6
         FhXmqLAg0MQErB3iFAUp9lWhFZNzBj3WYls4R/P+vYcmq4O5LQhE/H35NNlw6Gb8ALpX
         AqYTM5FMlsImHPO5iyCG8wUZprLjctkTIOV1Nu2JMNzE9imlkAraXM9G47XouavXy8F3
         qG31h69cqrmUGpalp7dOSzJ3RsAnahjFA3gzGaQNxnYDGuvXgg5fVzW4zU8uZsTmfu3T
         Fr3arRivJKGz0kJTkd1FwXdaD7nGla8IM3JvARA2ELEu5UMLId0M+WrRpSvsSbIBM8zC
         ZxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=JdM7k75IUpAdAhgdRlysrqDwZxM23pbxIW2rHhhMMAY=;
        b=IiNR/cVkolBjH70zgGzLpjqB2/hnPSB7U84bqjWqdVLNBrCPH91iBivn2DOsNXi3c2
         i8WutACF1Nb2u0NBXaGcMAo4Pgd/+euQWQGnmj2fiufh0Zmb6WbAHLzFaR61BsINJCMo
         l7FPE0keAEKsjoE3dHXyeilKaqrKlv7CD6DCeVTO68MsqmLWJ0N+9cO2lUwnGk81Jzqe
         mqyowzoAvWGfrZuapcltGcLKpz154Cqx5DkpVzzZm7obNmYNslIX5acz15YCMczQj2zZ
         eHom14HGE0Vqu8aByS6D3GViIGdXJ22vgUE2THaCRWpnVa/ab9kK0ItznYQAPA3RpUll
         nrAA==
X-Gm-Message-State: APjAAAXdn0PTxgvNJbhKM3xzCXVFMTGtQpYuOvwr1VKgANENpvVX+Abj
        cQKl4+l6bVCcjwRTPb/9oVo=
X-Google-Smtp-Source: APXvYqzKX7Be/Pqe5RTEmcDjubzJf1IX+1HsFK+A0sRyoOdYO+ZglTYI7W1BLtYdIHV/s38O3wFEcA==
X-Received: by 2002:a6b:da1a:: with SMTP id x26mr4508318iob.63.1569957025849;
        Tue, 01 Oct 2019 12:10:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k66sm8266483iof.25.2019.10.01.12.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:10:25 -0700 (PDT)
Date:   Tue, 01 Oct 2019 12:10:20 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d93a49c2b41f_85b2b0fc76de5b468@john-XPS-13-9370.notmuch>
In-Reply-To: <20190930185855.4115372-2-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-2-andriin@fb.com>
Subject: RE: [PATCH bpf-next 1/6] selftests/bpf: undo GCC-specific
 bpf_helpers.h changes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Having GCC provide its own bpf-helper.h is not the right approach and is
> going to be changed. Undo bpf_helpers.h change before moving
> bpf_helpers.h into libbpf.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/bpf_helpers.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 54a50699bbfd..a1d9b97b8e15 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -13,8 +13,6 @@
>  			 ##__VA_ARGS__);		\
>  })
>  
> -#ifdef __clang__
> -
>  /* helper macro to place programs, maps, license in
>   * different sections in elf_bpf file. Section names
>   * are interpreted by elf_bpf loader
> @@ -258,12 +256,6 @@ struct bpf_map_def {
>  	unsigned int numa_node;
>  };
>  
> -#else
> -
> -#include <bpf-helpers.h>
> -
> -#endif
> -
>  #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
>  	struct ____btf_map_##name {				\
>  		type_key key;					\
> -- 
> 2.17.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
