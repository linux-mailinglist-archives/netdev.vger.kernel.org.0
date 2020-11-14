Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D772B2B00
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKNDYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKNDYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:24:47 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8059EC0613D1;
        Fri, 13 Nov 2020 19:24:47 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id s24so11794756ioj.13;
        Fri, 13 Nov 2020 19:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yu9gcwue9CxPD4yXxmsqiMTjRC3fuaEWKdsADqqHy6s=;
        b=iDWWLB87H2RyOGxxii8EV1z87lf2Nx+WC6hJd8fbVYmFwgIUrWygiEURNJga7KzWRs
         z1aP4UugTMYyFFhkz6EWQR7Gq8NdaVU9VohF/TJckp/MHdgK44bKmfaBFeflST1BrKte
         UPinXv+s8s7ie/wHKNThc0su7MFlqBvc0WmJoUxfBWVgcjeA0jsfLngeTJ2PdDqDC4q4
         XWt+QYVZRpdCz47tuigGxnDp/v1blJm1z/satfz/GSzZDvT2Fu/Q/cp/dlhEtARyOIww
         oaarrc1PPcu2DiT2FGX7tdfJse9OhAPsbO5liM2SZiIUwHt5XcSn3q/oFH/5YdaBbnxn
         bt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yu9gcwue9CxPD4yXxmsqiMTjRC3fuaEWKdsADqqHy6s=;
        b=Xw344waCP+EedkX+H5Y0U6wdyF1XtQawbZYolkLAJ1zaRpcg9lLayS4IFfBXXqpkLE
         uxCIcddgjSHzAmeecmCTUQd5HrP4+l4Wp/fFYrWzHqmqysZNHif9yWJKP12NXssiASg5
         8gDZx79G9WVtK1m8+gvYNU6JtCjyN4Ay4fZqMukNr8u79UyQh7Eavz84EzMarDXRE9Va
         ZlEGwfTGUzW2e1S1Dt+xnQyg+j5a4MIUU/TJOjwLsl/AjLdebzsSokc6K1KNl+Q69uV8
         43JuaAfuTczJcEc8tNALd++vA4ne54qkevm/sYrNX7bDwbEQtw1Si42n4V87sL0fJhu9
         deCA==
X-Gm-Message-State: AOAM5304kQIZq8DmnbNg/XWn1/tdFtyw6l5dzrkaH8A5ggHV5/AZVuvN
        RtvJpM7OZkqr1A0skx7sDSwbv44hxgk7Zw==
X-Google-Smtp-Source: ABdhPJwulySKIzWPp/lSFlmm0qDmcc612wjv8fCnAZMX7wCHPbwqO3KD9Gg+2JBLLaWMUL1ZXrn0CQ==
X-Received: by 2002:a05:6602:21c2:: with SMTP id c2mr2173733ioc.184.1605324286916;
        Fri, 13 Nov 2020 19:24:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id b1sm5646948iog.14.2020.11.13.19.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 19:24:45 -0800 (PST)
Subject: Re: [PATCHv4 iproute2-next 2/5] lib: rename bpf.c to bpf_legacy.c
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
 <20201109070802.3638167-3-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a42a6a91-53fa-5b31-4bba-273847ee8986@gmail.com>
Date:   Fri, 13 Nov 2020 20:24:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201109070802.3638167-3-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 12:07 AM, Hangbin Liu wrote:
> diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
> new file mode 100644
> index 00000000..7626a893
> --- /dev/null
> +++ b/lib/bpf_glue.c

...

> +
> +int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
> +		     size_t size_insns, const char *license, char *log,
> +		     size_t size_log)
> +{
> +#ifdef HAVE_LIBBPF
> +	return bpf_load_program(type, insns, size_insns, license, 0, log, size_log);
> +#else
> +	return bpf_load_load_dev(type, insns, size_insns, license, 0, log, size_log);
> +#endif
> +}
> +

Fails to compile:

$ LIBBPF_FORCE=off ./configure
$ make
...
/usr/bin/ld: ../lib/libutil.a(bpf_glue.o): in function `bpf_program_load':
bpf_glue.c:(.text+0x13): undefined reference to `bpf_load_load_dev'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:27: ip] Error 1
make: *** [Makefile:64: all] Error 2

