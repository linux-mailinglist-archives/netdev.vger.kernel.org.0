Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4388E32A3E4
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577721AbhCBJwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577606AbhCBJph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:45:37 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811FAC061788
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 01:44:45 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 2so18583600ljr.5
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHrxfmV9VqctHmCnIbkXHn8qNGwiob8Qpm1HTJJTCzE=;
        b=juSybNDJO3bTlTow3bGeK0gH+W3PCiBmXGPi96XzJp3+b6j9B13FTZeHyKlAi9NmEg
         BgFqCJ3kayWsop47Bo/5QSNqOZGUp0aDjFeI2qqaTy+11uYpk7+V47GtNvF21Rsm4DCs
         mgE6nOel0fKUZRc1j1VrR8liZO9ZpPsd9O5aU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHrxfmV9VqctHmCnIbkXHn8qNGwiob8Qpm1HTJJTCzE=;
        b=USU8kJ8HBzEnJvYG7w/v/Dtnc5PuXlfQsCxjRi7tEU3xwUzBoTA8fFUyQ2OFFU6sgm
         7itEJCAXO9Qq6bW1E1ZlJf47FNVAVPo66obR42d/rw2kUFgyyGPhwg40LLmq16ejbmpZ
         1z6PgJxUQjKkcMB/E7cCco96LmrBnXH6hZgXaWUubmTKRkhWoURmbkOU/l7ktZ5iHR+i
         MVFnmH0jIDeSWMk3tjd4hbAX8zxrmtnoCYcyV9ImJXEv7n91zIR0cmj3K6t69tgwL50z
         BogAzWkTYdMdDwDgRNx2S5Gfl20vLCdxJa1byUA0Bt+YXb/N0LnjMS1NmhYId6kSGh23
         kUhg==
X-Gm-Message-State: AOAM530qzCoF9bO2FgRR/YbBClHPS6YqA6Q04wetsOuqpKKYpKPw5xM0
        98AIcyFBaZ120rKCbY9QXHo3MoxxOZRLkDLb+lK0JQ==
X-Google-Smtp-Source: ABdhPJzTqebHkKvN0lljkDSYm953QyV+cMWBqCHz3J49dRqBnAtGo6LTTp0CACJMhLIp5MHuTi0pBc9WhsOO1Z0Lwy4=
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr11833762lja.426.1614678283978;
 Tue, 02 Mar 2021 01:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20210301184805.8174-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210301184805.8174-1-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Mar 2021 09:44:33 +0000
Message-ID: <CACAyw9-sas9U_KKsRjtQUdd=iiBmLmWYup4KFGEmB470H-b4Xw@mail.gmail.com>
Subject: Re: [Patch bpf-next] skmsg: add function doc for skb->_sk_redir
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 at 18:48, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This should fix the following warning:
>
> include/linux/skbuff.h:932: warning: Function parameter or member
> '_sk_redir' not described in 'sk_buff'

Thanks!

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
