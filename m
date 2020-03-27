Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80AC195DB8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0SeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:34:12 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:38471 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgC0SeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:34:11 -0400
Received: by mail-il1-f196.google.com with SMTP id n13so2368254ilm.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=09r2WOrp7wvjc0ckXYdVFEUESnByeqZbo2litgOdFvY=;
        b=kqg/UNU3JX9I2Xt9TkwnCldYTPJlu4P2jnJkAomKFHbwyLook3OZJsHQT7ycDMlzcN
         SCas29/91/kIbz5jggXrJSLJJZT+VjubA16+jtGz6w56P6OB1jXo/q7EJZ5wQFgucSo6
         hAfKPRlXgLp7QZOsTqF8uyhjsIAizhAn0sHy3iQP8TX55MWR71xnfhJ+1dwRbVeSACfG
         jQi1ltoJepQ4XKAeP7aFUNuGCOylMU3KLbVc9viMCvsw+kFAv3VkxDOSIBidkF1RSoAj
         6uvtY+LJ5yA2ug4fheR8pEEnGKOEsBp31avGed/f4VPo4G+GZVy6X30LhFH9vPJFXw8r
         5AlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09r2WOrp7wvjc0ckXYdVFEUESnByeqZbo2litgOdFvY=;
        b=CS2C/6wfop6mmdpdyXcnFoCZ7UjrWB49OK7DLoaBrvwjF1BLFWHB1HghPxeW9SEQN0
         9H3Yfhff+TrV8bSvChOzEU+ys4AqNdhNynrDr2Fn0RFuBzNsWh3CUYayqIzrsSZ971bs
         49bUPWY9BrCZRCpqRuLkQAk51jETkWBnjIE5KOslWWKpOV1hIH6sWIogGBk9GiKLTb4G
         my9yfbwEHm0ptNn4vqijUVgKlITIfW609Eum47hDDMw5zx4/bd5MbalFq1xDelRuJyB9
         3EfQr7Vtp78+fWZqdkWz04FoqCV5s+hXMDpejlDaFyt3nniwFveaTirGLV7QpyaTaeq5
         kljw==
X-Gm-Message-State: ANhLgQ1TfYRPjSrfAuz+6mQnuZTNaEQ2e/uo5lAPiy7+e+mHgDUwZ4hm
        NhXbhcDFBvtq7EkJy5s/1IWMkdePUoQ=
X-Google-Smtp-Source: ADFU+vtUBNtZi6++hllaaNBNCImnw+ZxgVcOvu3ukrmULjzYYI7SgMec9A5bFqkGFMYySqrxTpjOPg==
X-Received: by 2002:a92:8352:: with SMTP id f79mr482044ild.58.1585334050570;
        Fri, 27 Mar 2020 11:34:10 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id t24sm2111485ill.63.2020.03.27.11.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 11:34:09 -0700 (PDT)
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Roman Mashak <mrv@mojatatu.com>
References: <20200327042556.11560-1-joe@wand.net.nz>
 <9ee7da2e-3675-9bd2-e317-c86cfa284e85@mojatatu.com>
 <CAOftzPjWtL5a5j3GAJW5SOhWS1Jx43XWSwb7ksTaXC5-sAaw2w@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <52f33dc9-734c-d509-8da3-3e2cbdbaec45@mojatatu.com>
Date:   Fri, 27 Mar 2020 14:34:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOftzPjWtL5a5j3GAJW5SOhWS1Jx43XWSwb7ksTaXC5-sAaw2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-27 1:43 p.m., Joe Stringer wrote:
> On Fri, Mar 27, 2020 at 7:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>

[..]
>>
>> Trying to understand so if we can port our tc action (and upstream),
>> we would need to replicate:
>>
>>    bpf_sk_assign() - invoked everytime we succeed finding the sk
>>    bpf_sk_release() - invoked everytime we are done processing the sk
> 
> The skb->destructor = sock_pfree() is the balanced other half of
> bpf_sk_assign(), so you shouldn't need to explicitly call
> bpf_sk_release() to handle the refcounting of the assigned socket.
>

per other thread, I think once you factor out what those two functions
call into the kernel proper we will just call those same
things..

> The `bpf_sk_release()` pairs with BPF socket lookup, so if you already
> have other socket lookup code handling the core tproxy logic (looking
> up established, then looking up listen sockets with different tuple)
> then you're presumably already handling that to avoid leaking
> references.
> 

Yes, we have all that code already.

> I think that looking at the test_sk_assign.c BPF program in patch 4/5
> should give you a good sense for what you'd need in the TC action
> logic.

Seems like we are on track. Thanks again for working on this.

cheers,
jamal


