Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92A845F771
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbhK0A0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:26:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34030 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343818AbhK0AYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:24:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C21623BA;
        Sat, 27 Nov 2021 00:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B09C004E1;
        Sat, 27 Nov 2021 00:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637972446;
        bh=79on01tyiwdUsmsUayuMLAkiaUJy72JpDMyxzGraM8s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=troLlDMXVWWOkld07K1TrPQ2uWv9jZpZSmgota8dgQR2Hd5umaOGuguZ9m9Jr4wYZ
         GAIf6BvL95Bz0r0AWWR1OeXopDeby8n1g9WgtX+eGBI4VCiiMNQRByrNHI8g6ss3a7
         bd1RSxF2Ck/uBrGQAtrczjPq2r13216waidvaUBLN64Um5w6DtlimNuA3q2eNm3mmO
         SYqwlFu9hJRSC+X/2eG1Ti007klROryFWPknx/i9bJjra2LnG7EL4OnYD+1FlyyaEO
         Gw6yGCcnAPH58H7ldT2dUZDwg9KkHU/RsNXAOcsN4oxiLTZE5I8mt7nnRQKew4Edu7
         kzUkTCN9ctw0Q==
Received: by mail-yb1-f180.google.com with SMTP id v64so24134759ybi.5;
        Fri, 26 Nov 2021 16:20:46 -0800 (PST)
X-Gm-Message-State: AOAM533C5TAkE6e5QIeDfgZwqJnoYKhNtPK/VP7mHRKJLsFjKheInJwm
        0UPq/v+TICqMxkD9vQO2LhSA+oWn55rwasT69qs=
X-Google-Smtp-Source: ABdhPJz7GBIoMXCz3NprIwDC3XS0OXt5ARgMqxD+jNhSCsWbEEt8xF31Bj9TRw1nZyuWv0IXg0UjK+gefWGaZVELmbg=
X-Received: by 2002:a25:af82:: with SMTP id g2mr19656674ybh.509.1637972445285;
 Fri, 26 Nov 2021 16:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 16:20:34 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
Message-ID: <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
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

On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> a section mapping for it in libbpf.
>
> Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

The patch looks good to me. But seems the selftests are OK without this. So,
do we really need this?

Thanks,
Song
