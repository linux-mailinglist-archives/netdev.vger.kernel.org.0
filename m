Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D88D3B9C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfJKIt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:49:56 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42465 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfJKItz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:49:55 -0400
Received: by mail-lf1-f65.google.com with SMTP id c195so6447034lfg.9
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZcGygTCwpeNMQnDZaCGXMswzs4Pr+XRxJbo6OSQ+isc=;
        b=nb0Zcb4RKQs4XAJskwL04LDvLPrFFtP6zspQ09KQsXlbet2m8FFqEIGvVo0SwccZyy
         mhOYR5vQVYBEnLD6RM5JJYdFpkwi4P/roo3DzdWh4Tt+5LNM0WDagm4/kDoVzpgHYDbN
         ShoO2ppVI9uOOEsH2pbVHRKrUlUm9l2AwcfSN3dqfV9PJ+CRBkLryyJ/l1qe8STGrCI6
         044bOXEGsLgy6pOjkjdaN7Pd4GMs6yZqU5pqWrltzqcaOI5FvWPO0hw2yqGYBpDPurLm
         FkxGJTH4701MBBnYA36jG/vaiEs7u8VPtf997ggd+nQV/WGLM5MSTJN/xsM3pAYJjtxX
         kROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZcGygTCwpeNMQnDZaCGXMswzs4Pr+XRxJbo6OSQ+isc=;
        b=mrPDLd5cEPCIAVVcR8hQVvPHu2CYS93CdldewYrtAOXeH22vnZm6hKVUK6EZsPZq/n
         tMxofWb/mOYUvJ1r65PUWdnLStNCg4UTOydXRdRKCmIuZ5Lv+phYw+MZoCr8CLw3H2o0
         Bn25ge/C3x5DomDNyXGIjPOqSAGViky5dhXN35STsrm8Q2EoAzMq47WdH2qKfXkk1Ukn
         gZqbubJn5y1AXzRaqxwtRcgcipRJngVcoAL0eI6hakK01kxVwV8LVFPWrjoctiOAPSPt
         zQuoz+tKgKNWH6PgTRkeYt7yPRqsNF6Rys/Yv4mNq3lEa0ImtLWoZ+12R530OqN6Fn1W
         E33g==
X-Gm-Message-State: APjAAAVbL52dqVml3p9Bm0Sa1Y69Ip1fRq21GUAbOBM8rklUTJeey+q7
        M0CuIcJoO4h8k/qdfbVMC0ZxGg==
X-Google-Smtp-Source: APXvYqztfz/Zby4n3sMo4oPARCaeMlUEm5fXgfozoP48jy0PPYbpLqM6rlUBu2PLYt6kNEFjCMgWRg==
X-Received: by 2002:ac2:4830:: with SMTP id 16mr8261983lft.2.1570783793946;
        Fri, 11 Oct 2019 01:49:53 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:86c:2e5e:9033:59d0:e194:cd55? ([2a00:1fa0:86c:2e5e:9033:59d0:e194:cd55])
        by smtp.gmail.com with ESMTPSA id k28sm1901704lfj.33.2019.10.11.01.49.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 01:49:53 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 09/15] samples/bpf: use own flags but not
 HOSTCFLAGS
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-10-ivan.khoronzhuk@linaro.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <99f76e2f-ed76-77e0-a470-36ae07567111@cogentembedded.com>
Date:   Fri, 11 Oct 2019 11:49:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011002808.28206-10-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    More grammar nitpicking...

On 11.10.2019 3:28, Ivan Khoronzhuk wrote:

> While compiling natively, the host's cflags and ldflags are equal to
> ones used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it
> should have own, used for target arch. While verification, for arm,

    While verifying.

> arm64 and x86_64 the following flags were used always:
> 
> -Wall -O2
> -fomit-frame-pointer
> -Wmissing-prototypes
> -Wstrict-prototypes
> 
> So, add them as they were verified and used before adding
> Makefile.target and lets omit "-fomit-frame-pointer" as were proposed
> while review, as no sense in such optimization for samples.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
[...]

MBR, Sergei
