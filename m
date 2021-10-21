Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D4E435EF7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJUKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhJUKYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:24:10 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB0C06161C
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:21:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v127so117628wme.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wyoLOnjzrBHxn9a5W20RYF99EFISKK5JgvzJQ/EF86Y=;
        b=WKWdwPN/J9IdQP0mfy7pRIW1mHCJTjIhqJCjWclgf81DlTb+27hl3wXo19SYxQfcgm
         s7HkuNUWtH6WdaiAOb7M7v2toTfictyBLG+V/uBuJ1zmWVhTzSCl4tIkqOj3VfUn4/iD
         yZvQaUhWyXKCb6V/+2IFYGsFGWq0OfBzJtpk+7CjI+QbCO5Ts6v1ZFeGG6LGsPHQTAU3
         iRAysHqDYLHgPZTKC4t7r37OnHKqAm2xLA4tuZLmu9T3+ROnH5ff/hg/6vHeF4OGjraC
         ArR49bf9v3UzU9uGF2t4GmcY2J7dMUcsuBjibgzq1zS6JK2aAHwCJt/kaeWgyqwwq92N
         QD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wyoLOnjzrBHxn9a5W20RYF99EFISKK5JgvzJQ/EF86Y=;
        b=nKeTJTD5agV40sPpdhtzbX5R8mRW5hjTM/wbTjquEDXKwkJ2XbjF1w8joOAET9dqyM
         kiOa92xy72clZfe7/Bc7vRWWxszpzAvItulUzv90wqUgy8I44fxgiADMHCwiZYkmyBYy
         ZvE40L6yg11bcQ0yaVs1Rez7Xan1asZwToJvuhF3zJiAxlmZF7II9ZZ4bMJEcLYqyGpL
         BcM4uEJPuC688a2UfDCuWZfBIb1VWbIjhzi4G7S1KVaVuAwMY0JszTiYF0bUFQChgwpm
         HJDVThJ5yCiwZ83A8FnZ5Ilzsaj5zd2mbSK0iTFjDk9bjntEDw0327znAWgeF68VzYB0
         hHsQ==
X-Gm-Message-State: AOAM533JuznPQeHWgYhjzstLIbbjpAqCDzfoEd7EQH1R3sq8wtIw+Ma8
        IipfdkbaWdL+IYWwG0LtckrlIg==
X-Google-Smtp-Source: ABdhPJxp5kGgl7q3gATtxHuXKloj2QE9lt32JgEKKRx22VZsYX8ojjT6YokHilphTvZIN8L9YOk7dQ==
X-Received: by 2002:a05:600c:1d1a:: with SMTP id l26mr19953599wms.98.1634811712596;
        Thu, 21 Oct 2021 03:21:52 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.71.75])
        by smtp.gmail.com with ESMTPSA id v5sm1344224wru.85.2021.10.21.03.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 03:21:52 -0700 (PDT)
Message-ID: <39d1135f-1792-147a-558f-1e2314e34afe@isovalent.com>
Date:   Thu, 21 Oct 2021 11:21:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next v3 2/3] bpftool: don't append / to the progtype
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20211020225005.2986729-1-sdf@google.com>
 <20211020225005.2986729-3-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211020225005.2986729-3-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-20 15:50 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).

We've been trying to avoid breaking the command line arguments so far.
With your patch, there are several types that would need a '/' appended
to the command line argument. As far as I can tell, these are:

    kprobe
    kretprobe
    uprobe
    uretprobe
    tracepoint
    raw_tracepoint
    tp
    raw_tp
    xdp_devmap
    xdp_cpumap

(Libbpf requires a '/' for a few other types, but bpftool does not
support loading programs of such types at this time.)

And I find it a bit strange to pass the trailing slash on the command line:

    # bpftool prog load ret1.o /sys/fs/bpf/ret1 type kprobe/

Would it be possible to maintain the current syntax? Maybe by keeping a
list of types that need the trailing '/', or by making a second attempt
with the '/' when libbpf complains that it failed to guess the program type?

Quentin
