Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2673B4CB0
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhFZEsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhFZEsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:48:22 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65EDC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:45:59 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so11695839otl.3
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PCrnHAE06pPJBBHr1JnyaMXhocmvZY6w4Qs62INGwBo=;
        b=QCcjULXE/PTNmyRo+L5J4U+ngfDmRU1I4Rdh8dusEbcHxLRjt8vaIUezb+VsOcfq+M
         S/0EhuRuPcZjQK7Tj8H8pEfbelA9gprSKPOJLPRqAYjV/nJqLU+Ksz7NQagLj5eT9rp5
         AEakNxtosFTizPkv7WssTyqbmZFOc5d0+Iv6/HW5hiHpWQYelRp/67gxpq8sGMXy+ldM
         a8Zc9v28Nkzfn+kuZPuCps2E2wgMdA6lRGQCS5vBOVru8RAF8Kh1S8vxDufetBdq7qrL
         9cjwSSfK0+qApJc1JTWrIGhTRrMJ3pQcY9KGiz5f3nVsIWKOjBXzb2qQC8jhRx5JIAPv
         MBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PCrnHAE06pPJBBHr1JnyaMXhocmvZY6w4Qs62INGwBo=;
        b=rfpkJzNPLfQhzeA2nx45pTlsnTt+YJPOGRGtkGuoLNOZf6aiCe3DNAZJfcEc1Hl9lg
         OjxMS2eMhYM24EUK6yLFxbK8VG/L/VqVHrJWBP1NG9Qv9vSAjMOWxuLyzgsTguSXRvQz
         fx57extGUuPQVzZ8IBUyZcHbJgxotfe6o/kgmwlwUSCrkPZqxjmm8Ge2LNO5d8rw8kDA
         JmE6uJs60sAjaglzsTgXEPtEheLUsPWcINbbz9GFYA/QMUz9qIjqAhDRKU6Wp+Wlav6y
         +JAv2y0S3wjJ6WOVl8oWvuksgNFgEOnfXsomzxpEAGbHWcIKP3SQ5CkMkdNcU94kKfoU
         pumA==
X-Gm-Message-State: AOAM533cYPzzf86RmUzjWzHi4m3NwGYRFzrDvvl2I1aRXIhk/r8whiJI
        xwsba3FG9cCcZbco7IC5b44=
X-Google-Smtp-Source: ABdhPJzzkIASpnTPw2k2PqeKPs5GvncNo97IRpTl1tXPnvvgXC3qDsclKQYfc5DrYaZR08DFyB1k/A==
X-Received: by 2002:a05:6830:18c3:: with SMTP id v3mr12679300ote.41.1624682759077;
        Fri, 25 Jun 2021 21:45:59 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id j14sm1887076otn.18.2021.06.25.21.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 21:45:58 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 2/2] tc: pedit: add decrement operation
To:     =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
References: <20210618160635.703845-1-asbjorn@asbjorn.st>
 <20210618160635.703845-2-asbjorn@asbjorn.st>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c7be3044-dbaf-9274-e22d-d09672ca3ccd@gmail.com>
Date:   Fri, 25 Jun 2021 22:45:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618160635.703845-2-asbjorn@asbjorn.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/21 10:06 AM, Asbjørn Sloth Tønnesen wrote:
> Implement a decrement operation for ttl and hoplimit.
> 
> Since this is just syntactic sugar, it goes that:
> 
>   tc filter add ... action pedit ex munge ip ttl dec ...
>   tc filter add ... action pedit ex munge ip6 hoplimit dec ...
> 
> is just a more readable version of this:
> 
>   tc filter add ... action pedit ex munge ip ttl add 0xff ...
>   tc filter add ... action pedit ex munge ip6 hoplimit add 0xff ...
> 
> This feature was suggested by some pseudo tc examples in Mellanox's
> documentation[1], but wasn't present in neither their mlnx-iproute2
> nor iproute2.
> 
> Tested with skip_sw on Mellanox ConnectX-6 Dx.
> 
> [1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989
> 
> v3:
>    - Use dedicated flags argument in parse_cmd() (David Ahern)
>    - Minor rewording of the man page
> 
> v2:
>    - Fix whitespace issue (Stephen Hemminger)
>    - Add to usage info in explain()
> 
> Signed-off-by: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
> ---
>  man/man8/tc-pedit.8 |  8 +++++++-
>  tc/m_pedit.c        | 25 +++++++++++++++++++------
>  tc/m_pedit.h        |  4 ++++
>  tc/p_ip.c           |  2 +-
>  tc/p_ip6.c          |  2 +-
>  5 files changed, 32 insertions(+), 9 deletions(-)
> 

applied both to iproute2-next. Thanks,

