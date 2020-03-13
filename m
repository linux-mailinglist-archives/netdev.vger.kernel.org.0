Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED8E184C42
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCMQUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:20:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46317 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgCMQUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:20:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id n15so12825608wrw.13
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9yAuat/22fNvrLQHtVwJOuXJKdfyxNZNaC4y6TiV+Rc=;
        b=B7sB/m8QnCzsW/O5BFA6AjN8CaY3UzbWxEwN/khlowudBy/e7Jhtto+AE6YEiV8VdN
         WMBJdvfJdLw0/ydX6n6/OKFUivmhJYwT8GRm+xmE7Zd0Krt4rCGiaGG1sDegoUUpdczD
         L7DFoiVkSPIbhhZp78YPE/1yUzFaWLm1v9lGpZMYpwmN2smyhfX7dBeTnzICqQMNVuz+
         84+j445iQ6+s4j6jnnEvlaMxMSK5o5VP8+6TAuJlZsbN7OFfPkrg/iUPmeZMg05Sj5Xs
         wLmxO2PURtw2J2Z3Td3szH6avZEBAhUVPJ0Wh3Ifb05VipUFIxsK0JCAzKJ1Ouworuqs
         AjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9yAuat/22fNvrLQHtVwJOuXJKdfyxNZNaC4y6TiV+Rc=;
        b=Vf5zImcUbwY3roB/adg1sOmkXVccHTn0JIvaqAAJWgFmhaU0Zbm7Cvr/WmAcor4hN/
         Vgtt0rT4T+JMoB4bICtuGPCor5gz+wxVAPvJITemm1FMWf7HMGkIlCuzceJOS7KqV3DI
         9Snd9FyQUOeKgc+EkA4IYuiyKGnT8b1K+hLhMr62Kzy8V+11Im3pqMtQWZFMwdfYgUMf
         0zpyuIwFS7CUKV4dHBbm8x9RexKiSDUzLeO5HTROu8F+EA33pE5vwV/q1kQ7plc+6UCJ
         J1gCeG9wlR6MbIhd1PWOmmz4yjjqeQ8wtND4WugX5sEqEG5caE3nGxkOrqmvGerXqPz+
         rCZw==
X-Gm-Message-State: ANhLgQ31Cf/rmfKUzxYwZN6ZZxyWrQUTLhZbb036JzaJbv588x4YHX3E
        jUQW+QUtjMGrA8g7tZUL0ygH8Q==
X-Google-Smtp-Source: ADFU+vvW95OwsBswiJRiJS7hwm11qgjSosIqo5QDvCnw+u5d9QvIUy45j2V1wA/ZZj+Q3PmRIx//aw==
X-Received: by 2002:adf:f847:: with SMTP id d7mr17807816wrq.31.1584116404760;
        Fri, 13 Mar 2020 09:20:04 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.102])
        by smtp.gmail.com with ESMTPSA id n1sm35833275wrj.77.2020.03.13.09.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 09:20:04 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf_helpers_doc.py: Fix warning when compiling
 bpftool.
To:     Carlos Neira <cneirabustos@gmail.com>, netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org
References: <20200313154650.13366-1-cneirabustos@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <a71d42ca-662d-d057-6939-60ad2bc44e1d@isovalent.com>
Date:   Fri, 13 Mar 2020 16:20:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313154650.13366-1-cneirabustos@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-13 12:46 UTC-0300 ~ Carlos Neira <cneirabustos@gmail.com>
> 
> When compiling bpftool the following warning is found: 
> "declaration of 'struct bpf_pidns_info' will not be visible outside of this function."
> This patch adds struct bpf_pidns_info to type_fwds array to fix this.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  scripts/bpf_helpers_doc.py | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
> index c1e2b5410faa..f43d193aff3a 100755
> --- a/scripts/bpf_helpers_doc.py
> +++ b/scripts/bpf_helpers_doc.py
> @@ -400,6 +400,7 @@ class PrinterHelpers(Printer):
>              'struct bpf_fib_lookup',
>              'struct bpf_perf_event_data',
>              'struct bpf_perf_event_value',
> +            'struct bpf_pidns_info',
>              'struct bpf_sock',
>              'struct bpf_sock_addr',
>              'struct bpf_sock_ops',
> 

Note that the warning is not specific to bpftool (I just happened to
spot it when compiling this tool), it's for anything that uses libbpf,
or more generally, the generated header for helpers.

It is fixed by your patch, thank you!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
