Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DACA1452CB
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAVKmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:42:11 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:37811 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgAVKmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:42:11 -0500
Received: by mail-wm1-f49.google.com with SMTP id f129so6626074wmf.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 02:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AIjdbnwnNK2/SCQ9Jb0UeLy/gm1BfTK32TagA23gRBM=;
        b=q3mavHJKJ9U+zmc0DpEm++y+hxVFsvaTdPdXAHeWd3O4ptBF+6BkQNsiCWJPFT7tdc
         99LEpYdoq+xIzCNvxBd40p1q1zonbazDD///GcSRLfsSWpwoToHoMmVftp6tDRQTKHh5
         kONMu3/8Vocho77+gLZB0V7NTwuiEOt2uVxCz1WBuYNJZDQ4QUDOiyLKs4P9pmoNAH3Q
         QG83HP5VKToINsrNqN5nydDeQpanrZsFUwHYgEXVAfXsfBO30NRBMIQuazgMJGlim0Se
         wjAunA0SqSVu+Skbz4KnSsalG4tcRU9sr/84Pj8zqBEui6F19Ai4tA6pjuq/0hXMCKnb
         JpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AIjdbnwnNK2/SCQ9Jb0UeLy/gm1BfTK32TagA23gRBM=;
        b=Bq8AIJ7CXgQQsZikChHmCcsnTTyYDTPdIipQhlpjdCkX3h0BEWOkcfjBnGVCwifE2R
         7ZYErwNydIR1EpvJ9tSW0kneP0BMF/hWWuKzOQv5lV4cMPOPXxE9JWt7wn6xuuUlJl6d
         MXD4UOc3oKPygAWBo17Prpff8UZbyv9SKFLow+xFMHSQs3MouEXbt+CURKm/e7xVB+a0
         YluOrmNj6TqBCYMJ43WVa8lqaE2iIJvQbY32ZOS68liBMsRrWgxVukryqBmx2JTaEidf
         XddEMmq5AWoyFJyhc3l7TQf2qBiOumQ+xTP0b2IWTI8lG99M4kqvIlYqvH3hRlJeX7Ic
         Rpcw==
X-Gm-Message-State: APjAAAUmKOy8Bi+FalBznwJzO6I8PXY1wocRuDIY0ynMZhLX+2sxBMd3
        dcDFUBtCKUtspPX29rPv+mZ1CA==
X-Google-Smtp-Source: APXvYqyj9ZPe/lVtcUydlXbf8ydHeHX8xKFtEv9XvXQ+CUdOs/fjn3apPMz/aRI5DbdG2VpLcUOGUg==
X-Received: by 2002:a05:600c:108a:: with SMTP id e10mr2264954wmd.38.1579689728763;
        Wed, 22 Jan 2020 02:42:08 -0800 (PST)
Received: from apalos.home (ppp-94-66-201-28.home.otenet.gr. [94.66.201.28])
        by smtp.gmail.com with ESMTPSA id x16sm3355695wmk.35.2020.01.22.02.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:42:08 -0800 (PST)
Date:   Wed, 22 Jan 2020 12:42:05 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Created benchmarks modules for page_pool
Message-ID: <20200122104205.GA569175@apalos.home>
References: <20200121170945.41e58f32@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121170945.41e58f32@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, 

On Tue, Jan 21, 2020 at 05:09:45PM +0100, Jesper Dangaard Brouer wrote:
> Hi Ilias and Lorenzo, (Cc others + netdev)
> 
> I've created two benchmarks modules for page_pool.
> 
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> 
> I think we/you could actually use this as part of your presentation[3]?

I think we can mention this as part of the improvements we can offer, alongside
with native SKB recycling.

> 
> The first benchmark[1] illustrate/measure what happen when page_pool
> alloc and free/return happens on the same CPU.  Here there are 3 modes
> of operations with different performance characteristic.
> 
> Fast_path NAPI recycle (XDP_DROP use-case)
>  - cost per elem: 15 cycles(tsc) 4.437 ns
> 
> Recycle via ptr_ring
>  - cost per elem: 48 cycles(tsc) 13.439 ns
> 
> Failed recycle, return to page-allocator
>  - cost per elem: 256 cycles(tsc) 71.169 ns
> 
> 
> The second benchmark[2] measures what happens cross-CPU.  It is
> primarily the concurrent return-path that I want to capture. As this
> is page_pool's weak spot, that we/I need to improve performance of.
> Hint when SKBs use page_pool return this will happen more often.
> It is a little more tricky to get proper measurement as we want to
> observe the case, where return-path isn't stalling/waiting on pages to
> return.
> 
> - 1 CPU returning  , cost per elem: 110 cycles(tsc)   30.709 ns
> - 2 concurrent CPUs, cost per elem: 989 cycles(tsc)  274.861 ns
> - 3 concurrent CPUs, cost per elem: 2089 cycles(tsc) 580.530 ns
> - 4 concurrent CPUs, cost per elem: 2339 cycles(tsc) 649.984 ns

Interesting, i'll try having a look at the code and maybe run then on my armv8
board.

Thanks!
/Ilias
> 
> [3] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
