Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD22A189A
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgJaPi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgJaPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:38:59 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED684C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:38:58 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g7so9143593ilr.12
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vb9ATrbKmpbplTY+dVhgxJJXuILmrawR7JtdeoqVPFY=;
        b=m7mpPBDZGxhfAW41w5N1zi3BV1yTRZU6sfkKme7Juu/lMXSF9wcdWpjgeyrXIx9aPJ
         kHOWjOnxvicdzrK1OeWwlHgk7XUTAlMS2dN+UiCkJwyVfvGAuLbVT6qxv+Y/Uh5zPvU6
         /HnuEX5QzTtfyC7buy7g70Y0OKbqx2xd1KdYg32HnBSf3UQX5tY4/VujnyzWMUSRnrpY
         qWDNCZbBJVnicsx+zWc7EnyahJJQnMGpNShwL9eQ0y7XuyIpM3IkU7KcAzBd+lMu9+Gv
         FrJXkOPqkrbmhXoo+PSO5MksBmJNNOWrHrYnW2/ZPUBQBRyEw21z6c6pr/9q9DR3FCV3
         wW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vb9ATrbKmpbplTY+dVhgxJJXuILmrawR7JtdeoqVPFY=;
        b=NaIfPQnCaN910vvYWXbO2SzqW9fTeiHPngW9dZfAL6xmnwROrT43DnwlombGyL+stg
         uUymKEM1bjgCoTyBZOl9f0cLJxawrEzISRTCk2XXgIJ5feF43NZOarK43DEPIt9ZKvJd
         6nd99WSgum/mMgQTnGMja/VbYj/g+61fa/VgUzvDm70axozOpe/w5oIlRhYe33UbRzpv
         jXU+svw7bPj/REd9qAkgP/zmc2ewPTfIvJI0mlQT/U+e/quYgKybep/4Eqr+eM0vBLLn
         U2ShC/+uJorpTdqBuXIy7vfi3pSjyMstAoxPoVkf/nyGDRo08HsE8BJZFsRK4xzobXqB
         Xz+g==
X-Gm-Message-State: AOAM531XBeBaXicT1d20ddeFpVvpbJNbJbkOOcXwkz0Fg6CpayS4woDW
        4/R1/uMR2zhuaaROLtc3cts=
X-Google-Smtp-Source: ABdhPJyzQ4qNIhHiJjg9i1eKAalAEB3oyBMUGwgdpS4937cro4wVW5cVZvbwWyAkS5tKgd/NvuR85g==
X-Received: by 2002:a92:8e51:: with SMTP id k17mr5324079ilh.270.1604158738463;
        Sat, 31 Oct 2020 08:38:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:10cc:b439:52ba:687f])
        by smtp.googlemail.com with ESMTPSA id c66sm8193118ilg.46.2020.10.31.08.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:38:57 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
Date:   Sat, 31 Oct 2020 09:38:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 6:29 AM, Petr Machata wrote:
> diff --git a/include/utils.h b/include/utils.h
> index bd62cdcd7122..e3cdb098834a 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -328,5 +328,6 @@ int do_batch(const char *name, bool force,
>  int parse_one_of(const char *msg, const char *realval, const char * const *list,
>  		 size_t len, int *p_err);
>  int parse_on_off(const char *msg, const char *realval, int *p_err);
> +void print_on_off_bool(FILE *fp, const char *flag, bool val);
>  
>  #endif /* __UTILS_H__ */
> diff --git a/lib/utils.c b/lib/utils.c
> index 930877ae0f0d..8deec86ecbcd 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
>  
>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
>  }
> +
> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
> +{
> +	if (is_json_context())
> +		print_bool(PRINT_JSON, flag, NULL, val);
> +	else
> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
> +}
> 

I think print_on_off should be fine and aligns with parse_on_off once it
returns a bool.


