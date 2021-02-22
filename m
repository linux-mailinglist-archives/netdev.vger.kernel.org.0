Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F269F32125A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBVIwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhBVIws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:52:48 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62CBC061786
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 00:52:02 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n10so13580462wmq.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 00:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HF95ndbA7nNPDRh4S+2W0IHRdkwjz+dgoM5gTSFUR/k=;
        b=cN6+Xxd+3QOT0mU3bzZH0snj8lTWrwz+u48GEKD9es587bph7N9cFCaCQMn6O7luGM
         hv9/o8gTqmE1jI2VRva2Nj8v3A53/CPvQO56v/DUaqumpBQaOtwzBqAZ6Gl+Jky/t0kr
         qimhd6AsGmSxkf9jV767ZdvnYxQcKYRWZpWcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HF95ndbA7nNPDRh4S+2W0IHRdkwjz+dgoM5gTSFUR/k=;
        b=IpUdRZz7jNBW/0pAxIDBchPJUrcxShGU01annbmrkDU55sQ5Jr54phtXEA6l+z7IfL
         vU5r4O88W1wqV/8+IDY6rqMMb7ZoMzGsQjqJ1nxOgJ/i+9qA4G6ErPXqgau+zf+Aj07u
         0akvQyiKLVuQxjUltmo/rawnezntDYJjsF6SgQjh1CEjffG6P4BpdzMEIq9JjgOi/5sr
         kHcxC0gqPZ9fKryBPdvtongFEr9jKnsKoUTgysTnYBOxHwpCL+2s5badsTT5gKyDzSnt
         BdzZL0p9HSR3thU3chZ/56SIOi/1Yj0pFy5fuu7IeSucqhAEGrRnTnI6KU1A/HoO8HQH
         m6Vw==
X-Gm-Message-State: AOAM532j0gMFXlWZ/VsksN3OepMZj6fAOf47Z1pOJn1bX9viSsBkfh5a
        ube21jFsOjnOWNw5t3Ehi10MOQ==
X-Google-Smtp-Source: ABdhPJwBJbXCMnh3ExP5xAF5iwSCCczkYxIZ6o0asK+I6HfOdBNyFk2bs+eGvUkKnrG7ZH9ICmg0Zg==
X-Received: by 2002:a1c:7e4e:: with SMTP id z75mr19355059wmc.168.1613983921204;
        Mon, 22 Feb 2021 00:52:01 -0800 (PST)
Received: from cloudflare.com ([83.31.182.249])
        by smtp.gmail.com with ESMTPSA id w11sm5560165wru.3.2021.02.22.00.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 00:52:00 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-2-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v6 1/8] bpf: clean up sockmap related Kconfigs
In-reply-to: <20210220052924.106599-2-xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 09:51:59 +0100
Message-ID: <87ft1o4h8w.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> As suggested by John, clean up sockmap related Kconfigs:
>
> Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
> parser, to reflect its name.
>
> Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL
> and CONFIG_INET, the latter is still needed at this point because
> of TCP/UDP proto update. And leave CONFIG_NET_SOCK_MSG untouched,
> as it is used by non-sockmap cases.
>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Couple comments:

1. sk_psock_done_strp() could be static to skmsg.c, as mentioned
   earlier.

2. udp_bpf.c is built when CONFIG_BPF_SYSCALL is enabled, while its API
   declarations in udp.h are guarded on CONFIG_NET_SOCK_MSG.

   This works because BPF_SYSCALL now selects NET_SOCK_MSG if INET, and
   INET has to be enabled when using udp, but seems confusing to me.

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
