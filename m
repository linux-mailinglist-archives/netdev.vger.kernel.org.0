Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945C3F315
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 11:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfD3JeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 05:34:24 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42743 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfD3JeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 05:34:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so4515010wrb.9
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WgeJtIaVk2LjqwSgc2L1QBSn7MOThACp1yk5NcAoAik=;
        b=i2IJj0wNGRy4xTHMRfdNsjUEdx1lRAgJyA11hdM4I/j3rk6knydIAEH3RRMm9+0wne
         mPZNf6Jjvj1+Uhj42BeIfuLGwv8LXHr1cLBCA4g9139MDeDB8OHQKWcb7cxEnTPPTysd
         JYFP+nBit9hHNXjoPzM3E1l/E8gJm2Axc1SAqPnmI8qRSpb2q5/2j1Z99FPVigRJ+0Hc
         o1gCcx5jAjdtkDcDxy0CNXA0IQHgR2bdmKyn1DUPAHIzz/ceIBP+Ud/MgU0OGRIaqV/u
         KUMPYGcfRGIT3d4I5j4yhE0Kdu20BgcFkezSw6FdyJpOR1NSxxuV7bwMgYD9JNJ6lwT/
         bskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WgeJtIaVk2LjqwSgc2L1QBSn7MOThACp1yk5NcAoAik=;
        b=rWjv7gILVL6xCw1qTNihsXuiBBu0Olk/5z2rul6lOjVd5hHOQNg5+kGYYx4DfS9caQ
         MYytIkbIxiHJ89XbosVcrnEjGLbCy0aM+eUfR9P4wB00gtlyhprgKAjRQu80lcRSKfvB
         ZeyKv1DAOAWtBDqSt62Ed8gy1+kZ9VccQofsKWL5KchHbsNbFKQ1vUGP68gZGGUynY6B
         D3m3+y96aRJHMGgEZ/CUyRAzySdyvtz8p0YJKXmrnjxtBMeg7U5ubZkbvtgcQn9nzing
         MH0t09VXeJxCYxBu3ueh+n+352ipW5EZeZDn29kKwTxOeZPiKl/TKtManBxfxhJP1h06
         Qxbg==
X-Gm-Message-State: APjAAAWgsjdjuT/SrJEpFha9j0QVMPfRRMkmWiKL1flKSdN/HPUWvIvr
        PZ4KyyQRwSYzEWg7xcsLlls3BQ==
X-Google-Smtp-Source: APXvYqwgccHJSG+cYk7+C2F0UUHVL3LdLvbbu7hXo1Rh5d38y19YJgdeb4kOyOz2peZCJvBjbN+toA==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr17750328wrq.211.1556616862742;
        Tue, 30 Apr 2019 02:34:22 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.187.71])
        by smtp.gmail.com with ESMTPSA id p67sm2111596wmp.22.2019.04.30.02.34.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 02:34:21 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/6] tools: bpftool: add --log-libbpf option to
 get debug info from libbpf
To:     Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
 <20190429095227.9745-2-quentin.monnet@netronome.com>
 <CAH3MdRUQn=ycpcDLbLxGAZwGhnVMoD-avPPcSCopAtwof4czNw@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <d4f761c3-d133-4f89-44c2-a96c7f917571@netronome.com>
Date:   Tue, 30 Apr 2019 10:34:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAH3MdRUQn=ycpcDLbLxGAZwGhnVMoD-avPPcSCopAtwof4czNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,

2019-04-29 16:32 UTC-0700 ~ Y Song <ys114321@gmail.com>
> On Mon, Apr 29, 2019 at 2:53 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> libbpf has three levels of priority for output: warn, info, debug. By
>> default, debug output is not printed to stderr.
>>
>> Add a new "--log-libbpf LOG_LEVEL" option to bpftool to provide more
>> flexibility on the log level for libbpf. LOG_LEVEL is a comma-separated
>> list of levels of log to print ("warn", "info", "debug"). The value
>> corresponding to the default behaviour would be "warn,info".
> 
> Do you think option like "warn,debug" will be useful for bpftool users?
> Maybe at bpftool level, we could allow user only to supply minimum level
> for log output, e.g., "info" will output "warn,info"?
I've been pondering this, too. Since we allow to combine all levels for 
the verifier logs it feels a bit odd to be less flexible for libbpf. And 
we could imagine a user who wants verifier logs (so libbpf "debug") but 
prefers to limit libbpf output (so no "info")... Although I admit this 
might be a bit far-fetched.

I can resend a version with the option taking only the minimal log 
level, as you describe, if you think this is best.

Quentin

> 
>>
>> Internally, we simply use the function provided by libbpf to replace the
>> default printing function by one that prints logs for all required
>> levels.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
