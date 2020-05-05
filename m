Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D947E1C5D5A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgEEQVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgEEQVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:21:19 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B537C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:21:19 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id t3so2914558qkg.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OhY6T2+oI+ia1B+xr+YNleF/AfPXm2IqHaD/tj9TVV0=;
        b=Cp8yrExq2LrEulHGuQ+tC8QAgWlA7rZghg2IyYLbYsW+A+s5ALB35LUizqdY8hrLO3
         CSjUhP5NTxMDmh2utMR7iG0lZI83u0ICyPeFJS+HilhFaLbKPMHi7DkJcp4NZIntXvm/
         LOavkHSsYJu36/bJgieLND7ML721iNCEwRyWx1iE7Q1b/3vYofDtLXCY9Vl1fFok9gTg
         bfSxQsgrPpWrDcDEayLSzIu+a2QRrLp2YXP2Z/0GE4QdB0NItUGSWxRRG/gGm1q2tJex
         ZgmHyC/QQip0PBDuniDF/cR93HN1JixHjUkaGsuFy4oBMX+4f1eHN9VFGQsdDkwJmmxC
         B5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OhY6T2+oI+ia1B+xr+YNleF/AfPXm2IqHaD/tj9TVV0=;
        b=d7f5ntvLtHI8STo+w+4STClcJiWzSscbM7GUMwiJ1ap4nrkdCX4NdoIYgB3BV2iV2y
         2AzHIPPykfp5zCn7b1ZYyZZxJ8NKL69FxV3rj694VgV9dLQLjfwYm1TOYxhIsqcwQleF
         N5kJbCQdJVuqZdqSOixF9g5Gjg+bB+uVI1naS/7MPDodbRu5979sT3nFQpl8m2x4UFA/
         uSGuK/oNodgMnFu12c5K4F8GKh8SjqudZ0Kh2ClnfaipN+a+dc5fgB0ZqpBMTIg9a6Pe
         XsJkIRBEX/n2EfeZRrAMtEwVpzhLQulFzxK7YrIgf7VISDrlXCymNqCTeXxuxMhBPo+T
         l4KA==
X-Gm-Message-State: AGi0PuYLDxTbqCIFT8jsc2lK1IQnddgkJLZoDdNOxnMh01dUVu/rI99x
        AojoQ4LRjiT4xqzkFESTKcI=
X-Google-Smtp-Source: APiQypL63PNgZWMJwMe6W0nDaUcb50xpMCB0bpLwJ1IMzwVsp6NUYbnpMI0K6Yt+fjlN+kDtDzQYyQ==
X-Received: by 2002:a37:5846:: with SMTP id m67mr3967594qkb.78.1588695678583;
        Tue, 05 May 2020 09:21:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id c63sm2129268qkf.131.2020.05.05.09.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:21:17 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] tc: full JSON support for 'bpf' filter
To:     Davide Caratti <dcaratti@redhat.com>, aclaudi@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, jhs@mojatatu.com
References: <0f53a3a2bf42de2ff399c8396c3d0bc76c8344ea.1588269623.git.dcaratti@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ed429cab-db8b-f46f-d766-d29d4ad43ec8@gmail.com>
Date:   Tue, 5 May 2020 10:21:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0f53a3a2bf42de2ff399c8396c3d0bc76c8344ea.1588269623.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 12:03 PM, Davide Caratti wrote:
> example using eBPF:
> 
>  # tc filter add dev dummy0 ingress bpf \
>  > direct-action obj ./bpf/filter.o sec tc-ingress
>  # tc  -j filter show dev dummy0 ingress | jq
>  [
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0
>    },
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0,
>      "options": {
>        "handle": "0x1",
>        "bpf_name": "filter.o:[tc-ingress]",
>        "direct-action": true,
>        "not_in_hw": true,
>        "prog": {
>          "id": 101,
>          "tag": "a04f5eef06a7f555",
>          "jited": 1
>        }
>      }
>    }
>  ]
> 
> v2:
>  - use print_nl(), thanks to Andrea Claudi
>  - use print_0xhex() for filter handle, thanks to Stephen Hemminger
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  tc/f_bpf.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
>

applied to iproute2-next. Thanks,

