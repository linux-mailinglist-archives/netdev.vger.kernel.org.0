Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CAA1CB430
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgEHP5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:57:55 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8540C061A0C;
        Fri,  8 May 2020 08:57:55 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b18so1862387ilf.2;
        Fri, 08 May 2020 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+zs5D709Kcq02wF+wQySn8tSW4QeeIBgzdWz3Xh4pgA=;
        b=S+uaB25lMCKKzFoTbl6GIjt09lJvzZEWVG68w0Kr8cp1altO76iccX+eOaoOYR+wTH
         yEGp5yssYnDDLOPBbqfR2NLFd+iPafHsdKIxIeW5w6OFXKjSlndNE5QqtC/YQRTDT4mg
         00LARhWyRdFm9PU3YOhYmN5fM39zEufngLf3srYNPntjH/RWvZj7jCay4PUwYXYPfAr7
         nnOg2Q4mOakwA24IB9p0w1yvQo1hSpEIeEYvcpLVTw/rb37Il8GdqRxFAPNaRadGoUex
         YW2omROLt8USuNH4mRM7BtDZXmhtiDuUylFQthcpDLngf731MKsZK2JkgFjYQplNpeDx
         oAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+zs5D709Kcq02wF+wQySn8tSW4QeeIBgzdWz3Xh4pgA=;
        b=pg1MZsSaoCAqZPaU6BE12hKHrtTbceKRKzF7X2MzEWftew3Cq29tSi+vdLvv4QCoZb
         jP6CUGIVS76s78wSXr9+EsQYSjX6zmY6+9TNinjwByStuTLmQXZWsX9HvYKIzDPbyUu2
         LmRQTVAh/2JxIXuKpr9562vY4KyZ6TJzdC065Y0xaBA9CzSSXSrxe6OlXOuoGS2AoIfy
         xkqQpOgb4vZ5gQAAyz16UlXqZ8heG84gmE8PMzVN20B/wWD3XUKQ7s+zHlLmR44gUN/m
         Ywg93WiZs1fn5ptj0Frpj/YmvkR+1pYKma+r4ptu7jOydH1Umw8HVMji1tuvVo04qazy
         8cuQ==
X-Gm-Message-State: AGi0PuavPCiWaQkNTnxpEtDiIxHZ4PneiklR2mvM2YPZEqxVl1vMNs9S
        VKBwjI8Yj5E6HlHoIVonlds=
X-Google-Smtp-Source: APiQypJUoHtmWb13Y6e0Yv8sjQLE7cXPzhv2atgih5xjZQKmVGIiHq8kl/9jJUBzF6Kj7TGjObn6Hw==
X-Received: by 2002:a92:aa0f:: with SMTP id j15mr3526097ili.211.1588953474755;
        Fri, 08 May 2020 08:57:54 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u203sm809842iod.54.2020.05.08.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:57:53 -0700 (PDT)
Date:   Fri, 08 May 2020 08:57:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5eb5817b12a3b_2a992ad50b5cc5b4b7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200508070548.2358701-3-andriin@fb.com>
References: <20200508070548.2358701-1-andriin@fb.com>
 <20200508070548.2358701-3-andriin@fb.com>
Subject: RE: [PATCH bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add fmod_ret BPF program to existing test_overhead selftest. Also re-im=
plement
> user-space benchmarking part into benchmark runner to compare results. =
 Results
> with ./bench are consistently somewhat lower than test_overhead's, but =
relative
> performance of various types of BPF programs stay consisten (e.g., kret=
probe is
> noticeably slower).
> =

> To test with ./bench, the following command was used:
> =

> for i in base kprobe kretprobe rawtp fentry fexit fmodret; \
> do \
>     summary=3D$(sudo ./bench -w2 -d5 -a rename-$i | \
>               tail -n1 | cut -d'(' -f1 | cut -d' ' -f3-) && \
>     printf "%-10s: %s\n" $i "$summary"; \
> done

might be nice to have a script ./bench_tracing_overhead.sh when its in it=
s
own directory ./bench. Otherwise I'll have to look this up every single
time I'm sure.

> =

> This gives the following numbers:
> =

>   base      :    3.975 =C2=B1 0.065M/s
>   kprobe    :    3.268 =C2=B1 0.095M/s
>   kretprobe :    2.496 =C2=B1 0.040M/s
>   rawtp     :    3.899 =C2=B1 0.078M/s
>   fentry    :    3.836 =C2=B1 0.049M/s
>   fexit     :    3.660 =C2=B1 0.082M/s
>   fmodret   :    3.776 =C2=B1 0.033M/s
> =

> While running test_overhead gives:
> =

>   task_rename base        4457K events per sec
>   task_rename kprobe      3849K events per sec
>   task_rename kretprobe   2729K events per sec
>   task_rename raw_tp      4506K events per sec
>   task_rename fentry      4381K events per sec
>   task_rename fexit       4349K events per sec
>   task_rename fmod_ret    4130K events per sec
> =

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>=
