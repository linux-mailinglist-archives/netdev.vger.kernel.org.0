Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7CA31B740
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 11:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBOKgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 05:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhBOKf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 05:35:56 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A65AC061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 02:35:06 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id x1so7073043ljj.11
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 02:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2fJDaug/NaT07ZROmDa0hdWd6/FjaMaFHRUTepNMfY=;
        b=B8hFLR8Ba23yZJ7oN7bv8rrlCOB/B+trSlog+MAqjijptXxe+I/UsSZoCkU4O6Vsq0
         u6dX3FYCd3trGYaZmEBIV+jexzb/OLqBlHfC2pTy+fvN43XD5epeSzlYWvHnhuoOa02V
         ctWUlTScdd8v+CNFlAJ82yXVuYcM5zzsy8w+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2fJDaug/NaT07ZROmDa0hdWd6/FjaMaFHRUTepNMfY=;
        b=HDOMpFrbRug7aRa5qCEH44R2BBPQIkv3T+l/Gd0qOlkSfwFJ6DLUy0fwRCHZWJKgKc
         ZHqvTjAJvO9Oi8TSh+lm8Mm8OpaagyUD4mUHMHZ4sFQKwUqI/GgE6wdqplMHmrIVxxV8
         5X+pTqIMUvhQ3J1SwAwZElUE75jU4swOKDPV/zl3R52CiyQ0P2FH35tIICILvAGurRRK
         yrrBfvYhr7n4mFGIkqSZ0fTrTklgGzwMrLAFFn+H1oj2BvDmU9pMhMoUOYgWV8zBc6+e
         ZO9/JS+GGz9L4gOSp5mLWMi6k0VE/oV4JlJ+YSvNcK8NbMCcIw1LoV6W8yfbhHiRSHhb
         p2xA==
X-Gm-Message-State: AOAM533tAdo1bByANgkg1ekmL7FhWX6v0zUARXPQW9kY6zkWLJGvNuRF
        psVIsY8vPTAR1amMVVCF8afAAPJQfWuZb1V8dGpBKw==
X-Google-Smtp-Source: ABdhPJzOAWGFH/yS6fiaNSSYSCBu/QLhZBq/gIwIPJEwc5nnwUJMHgP/sw9aAh/toANseGBxa2G7bGQeukEScM81468=
X-Received: by 2002:a2e:9847:: with SMTP id e7mr56549ljj.376.1613385304873;
 Mon, 15 Feb 2021 02:35:04 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com> <20210213214421.226357-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20210213214421.226357-2-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 15 Feb 2021 10:34:53 +0000
Message-ID: <CACAyw9-EJdj8yTrZrym3U+nkBt0oG9P18NO3apZcxSE_jigdNA@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 1/5] bpf: clean up sockmap related Kconfigs
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Feb 2021 at 21:44, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> As suggested by John, clean up sockmap related Kconfigs:
>
> Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
> parser, to reflect its name.
>
> Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL.
> And leave CONFIG_NET_SOCK_MSG untouched, as it is used by
> non-sockmap cases.

For the series:

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

Jakub, John: can you please take another look at the assembly in patch 3?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
