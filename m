Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF75122F7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEBUFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:05:13 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35805 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBUFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:05:13 -0400
Received: by mail-yw1-f68.google.com with SMTP id n188so2564665ywe.2;
        Thu, 02 May 2019 13:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TJNAk0Lvfagj8fRo6Jl6RQONptd5xU+ZB1fw7sgph30=;
        b=eAs4GRXJ5Bl7vzQy7WcntFmTXgCjyDkydNz11hqgpIygMgpRlH/Rni8x07UN5Ov8zt
         gfpHNxfO8oboQIBwIOqXOsYiv/atbjnio1nni0LLOUDECgVkoTDRInzrtLFajrFsT5Mm
         d1UVXabCg+Bbkgg2ORLc13O9X5JPMtKzV2eeUdBoOZGGiAtPQzUh0gDMNJKbSpkHgcF2
         t2/k8uPGHkV7T9KVSbk1OyavlIxlgVNpJBuQPs3T+vCKO8eni7gZ/xYsNKTP9PPFGqb4
         W+17lnLJcakRSgPAarG+aE6zHDjV79GYj/GgpIALFpD8U4++cdrv+l4TbXmFmrEYjHyY
         nCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJNAk0Lvfagj8fRo6Jl6RQONptd5xU+ZB1fw7sgph30=;
        b=uR9vFK9NwoncqXyqyVqCLGKjU3z3K0fDbIiWbK+T3+lWflnDCLkAS8kTFVVQUa/B9A
         3xr6KrRalTUdXzC2Gv4Kv62z6hmp240DibmU/5RmJ9K2uvWcnDV59QuCTW56fOXyM7gM
         ALnZpFYOT5aarxt7OKJI37AYnPYr8XK2VtWMkQdlfhMY/oK9eT8WLSOXtAL4E2SfT3hs
         3pcHuCDE1R4PlXt9I1OF57g8RJXqLk6aLvO7AY9QGUSM128p8xXpoH94fc9hPeeVFuta
         QEBFwk/kfuBzgp9pRg5+PuTKKpiR4rch2yg8beQySaW9b3lTHNuw9JNYEk5MWDZM+5ff
         FDBA==
X-Gm-Message-State: APjAAAWbSAms6n8hg3eTBPyXNq7de4XpSg7mO/GylOrkwJmz/13ex9nC
        pj+n9RhRD4TTVFEsZdw6mArJQlwP/5/lmg==
X-Google-Smtp-Source: APXvYqwciAe4nEria44nc6rzApTMdY1iD2aS5mcwajyy/cffGlk4sZyRqLkM4cV6eKKiDXJ+Cv9ZYg==
X-Received: by 2002:a81:110c:: with SMTP id 12mr4887289ywr.188.1556827512026;
        Thu, 02 May 2019 13:05:12 -0700 (PDT)
Received: from [172.20.28.132] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id m1sm6100ywi.89.2019.05.02.13.05.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:05:10 -0700 (PDT)
Subject: Re: [bpf-next PATCH v3 0/4] sockmap/ktls fixes
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
From:   John Fastabend <john.fastabend@gmail.com>
Message-ID: <c6621617-9edf-bd4a-7738-63de6e910eb4@gmail.com>
Date:   Thu, 2 May 2019 13:05:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 7:06 PM, John Fastabend wrote:
> Series of fixes for sockmap and ktls, see patches for descriptions.
> 
> v2: fix build issue for CONFIG_TLS_DEVICE and fixup couple comments
>     from Jakub
> 
> v3: fix issue where release could call unhash resulting in a use after
>     free. Now we detach the ulp pointer before calling into destroy
>     or unhash. This way if we get a callback into unhash from destroy
>     path there is no ulp to access. The fallout is we must pass the
>     ctx into the functions rather than use the sk lookup in each
>     routine. This is probably better anyways.
> 
>     @Jakub, I did not fix the hw device case it seems the ulp ptr is
>     needed for the hardware teardown but this is buggy for sure. Its
>     not clear to me how to resolve the hw issue at the moment so fix
>     the sw path why we discuss it.
> 
Unfortunately, this is still failing with hardware offload (thanks
Jakub) so will need a v4 to actually fix this.


Thanks,
John

> ---
> 
> John Fastabend (4):
>       bpf: tls, implement unhash to avoid transition out of ESTABLISHED
>       bpf: sockmap remove duplicate queue free
>       bpf: sockmap fix msg->sg.size account on ingress skb
>       bpf: sockmap, only stop/flush strp if it was enabled at some point
> 
> 
>  include/net/tls.h    |   24 ++++++++++++---
>  net/core/skmsg.c     |    7 +++-
>  net/ipv4/tcp_bpf.c   |    2 -
>  net/tls/tls_device.c |    6 ++--
>  net/tls/tls_main.c   |   78 +++++++++++++++++++++++++++++++++-----------------
>  net/tls/tls_sw.c     |   51 ++++++++++++++++-----------------
>  6 files changed, 103 insertions(+), 65 deletions(-)
> 
> --
> Signature
> 

