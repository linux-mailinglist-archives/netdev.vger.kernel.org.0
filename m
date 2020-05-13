Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B293C1D20DE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgEMVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgEMVXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:23:05 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3FC061A0C;
        Wed, 13 May 2020 14:23:05 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c24so1127306qtw.7;
        Wed, 13 May 2020 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ubrHZSYEKKou4e53nbg3nlnbTpsWG3KUDEhqp3CKwJ8=;
        b=AiGWdZkvOLCNvWgLAlLldXk23HjiyczO+Uu/qsfgh2QJTack2vesUlgUetN2rYmzek
         +yAeRhsvYItbnPnE2771mTesZVYJtKZoTRMoDxUtlMr4/wFgYZquM3QpruVS5FLCPoiH
         OV+2fSfFu+9KNqVd8zqFE+Ots78zAhlSMpSCM3Y4mR10/QPW3QU9JCqJTBoTXbxoFePM
         /KMYKONFU3z/B6HyUNDPaA2eiu4cfeJltSUScBf+qd9CsZ6PAyLi84FhYFmWTgW8Nw2M
         1WVMTpdxr7IH3jqfv08D+8kDa+0m7fgwhsogFYPnzfdnV5D6+dO9p61WrVMwScsmCKfV
         2tGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubrHZSYEKKou4e53nbg3nlnbTpsWG3KUDEhqp3CKwJ8=;
        b=nuulfjOxTl5Ar/yxynupjWXIytvURfBNn2fzE1m8yAOeEd2yJHmZnAwZuiEndLw/ie
         hw7d/epSd83v02VNdHFi6dZtLQy3YYkh5+6eC8U8Es6BRlkT59GFuZ2aNKC/K3/hp1xX
         BcYbV7GXY/EoGp9p1Sh2VWPDME0pfwdZNURFtGyxbVnxuG47vFiJNekBoeybUbzKibtp
         gcm19H0Dgqp6e15qMf6AI/Pkqt7kw7gxLfn7sB8e7cJ3NknIv6jP45vZ4oS1jengADRP
         XHcwhMklxJvh21EOUOgnpCV9cx4ugxax3oV7/aiEmKrM7BWeja7MwLh4LgtGez/MvX2N
         ynYA==
X-Gm-Message-State: AOAM5319pZIz1wlV9FMKb3Z95X3BmeNKsVOOY7+OMX0iyHsJzB3mNh0H
        yTBPwzBSWsTYpkWM/kDYxXY=
X-Google-Smtp-Source: ABdhPJx0XygIfEwxbEwf4SdVOrnpRm0qDjT9w9ocMvT2e7ZKb+Ct5MJ9/3Eyo6/WjKxXeDE+hy1GQw==
X-Received: by 2002:ac8:7482:: with SMTP id v2mr1155989qtq.328.1589404984485;
        Wed, 13 May 2020 14:23:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3140:7ba:69e7:d3b1? ([2601:282:803:7700:3140:7ba:69e7:d3b1])
        by smtp.googlemail.com with ESMTPSA id l2sm881929qkd.57.2020.05.13.14.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 14:23:03 -0700 (PDT)
Subject: Re: "Forwarding" from TC classifier
To:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <51358f25-72c2-278d-55aa-f80d01d682f9@gmail.com>
Date:   Wed, 13 May 2020 15:23:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 10:40 AM, Lorenz Bauer wrote:
> Really, I'd like to get rid of step 1, and instead rely on the network
> stack to switch or route
> the packet for me. The bpf_fib_lookup helper is very close to what I need. I've
> hacked around a bit, and come up with the following replacement for step 1:
> 
>     switch (bpf_fib_lookup(skb, &fib, sizeof(fib), 0)) {
>     case BPF_FIB_LKUP_RET_SUCCESS:
>         /* There is a cached neighbour, bpf_redirect without going
> through the stack. */
>         return bpf_redirect(...);

BTW, as shown in samples/bpf/xdp_fwd_kern.c, you have a bit more work to
do for proper L3 forwarding:

        if (rc == BPF_FIB_LKUP_RET_SUCCESS) {
		...
                if (h_proto == htons(ETH_P_IP))
                        ip_decrease_ttl(iph);
                else if (h_proto == htons(ETH_P_IPV6))
                        ip6h->hop_limit--;

                memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
                memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
                return bpf_redirect_map(&xdp_tx_ports,
fib_params.ifindex, 0);

The ttl / hoplimit decrements assumed you checked it earlier to be > 1
