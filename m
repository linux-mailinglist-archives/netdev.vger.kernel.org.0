Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2AC4A4CE3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380840AbiAaRP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380790AbiAaRPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:15:09 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA97C061714;
        Mon, 31 Jan 2022 09:14:25 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p63so16928637iod.11;
        Mon, 31 Jan 2022 09:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X0IWdTk14kpZVd2y+qp2xWpWZVnD0EfRlgxdTrCRYhg=;
        b=bHXT/M4O15NAtGC0zYd3q3eplcv6pt79zL3tFG7hUOP1HOk5lUfDiqPDWs1EPm2rFS
         dUC7+310VVJGrjB+qvt5VtgUrrmY8lzPaAg87PA1sb4ty1QpSKF3WygjbK237roR5J0M
         u++R7TJN4x1wlJWTmm5NAjZrxyqL9pz+o1FmbafUVhWThp07Wh7UQNYF0PSTZQfS5VQ7
         9F0/hhLmPr8V8i2ITugcNEuaszZvlmO6aoGIWn1J21VJmYjXgvGzmwxd7D6tBjOHFVVG
         hkz2LjXiifc8V31WkUBEdF59M9ric7+RT/Z4PAeiwefEUrBbFggoyXC+EV7VSSH0jOR+
         qI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X0IWdTk14kpZVd2y+qp2xWpWZVnD0EfRlgxdTrCRYhg=;
        b=rn5UNUb5D0GVMGUctUwn4H+TyjHdYYqhvQ3jpzzGbucIAXaIY34N18Z4Oi5W1CnfPa
         xCIPAWt3KY0x8heDREzM9K0xZMBccQzZqfIvh+9gSEYqUNmgbYePy/mEBVwQDEgHyryp
         qYKwUWgisc9rdpKr6rwUi3P4IYInS2uyC+S8O9/iH+1oZtIk5Bq0FMFgQXLrWbDg1zkB
         u+pVC/ak1zQNCGEZ8FebZ1kcTw3PDMnwNUAgZCcmRBYpABckJQLHvARC7mdyUNOZPBQn
         VOjKEIDsxWlhCJaQOejJBQC6Bj9UjruzJwR1p+Bhvi3Mx+f5d/wEqLIb75UBu1fKlc0m
         EIbw==
X-Gm-Message-State: AOAM531Uv/hJMpl4ym/SOYc81XRevLHhsn2v5EVoYJisxBOd7IE2lnk0
        E+kdIuT2SBcNpwXFP2K8iR0=
X-Google-Smtp-Source: ABdhPJwxxeNkjPEYu/NfBwwGwKpPtiqFHSdpucHrxP+39C6ooTaal6Q9sWXf3sk6LeJLyKLebuyfhg==
X-Received: by 2002:a05:6638:1396:: with SMTP id w22mr3519069jad.11.1643649264654;
        Mon, 31 Jan 2022 09:14:24 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id u26sm13024591ior.52.2022.01.31.09.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:14:24 -0800 (PST)
Message-ID: <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
Date:   Mon, 31 Jan 2022 10:14:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-2-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Add document for following existing drop reasons:
> 
> SKB_DROP_REASON_NOT_SPECIFIED
> SKB_DROP_REASON_NO_SOCKET
> SKB_DROP_REASON_PKT_TOO_SMALL
> SKB_DROP_REASON_TCP_CSUM
> SKB_DROP_REASON_SOCKET_FILTER
> SKB_DROP_REASON_UDP_CSUM
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


