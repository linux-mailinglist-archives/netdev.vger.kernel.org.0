Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6681328CBB
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbhCAS5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbhCASz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:55:28 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C8CC0617A7;
        Mon,  1 Mar 2021 10:54:48 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k2so13465602ioh.5;
        Mon, 01 Mar 2021 10:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3WuD5KJwVIICV/S1qElOXfxsVldAv6ahO2BGQBm1n6g=;
        b=MeLteGoni5CryvdK4U5PkRm00k4NUHjEDs7sdDGqcq5QQscBB3psBZIIBaqh3+NOtr
         /snexHZoMx5OZ4EvxKRJEx97+37+gQzsKY430TdMvWwtEw44ZaduJVRtFuYgPAcvzE0n
         DScwERBmSPxm9wc4CSUZOom57L3kibY7LfjZNbzk0A7qCESyct1UJYE1UOG2KZVxwdUh
         IF3Dx3IsrkJTD9ZeTNzHFwFESwV4x5fhmdLozsadugftzRb5cU7XP3rgGjnNYpQbOzVW
         MAq9SNU/hGyI+rEXRR1WNhCROQSxvv/RkqMIe68by14jzD16qt3g20q0Vq8IaNc6ZmBw
         VAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3WuD5KJwVIICV/S1qElOXfxsVldAv6ahO2BGQBm1n6g=;
        b=UFGOJsRcgZ2aHFi9ncsTL/vnplfpHhtGeWE6S39JbKY18jiZSbZiXDzVM5zrLQqCTE
         0FDZr5Uuq26+24Gziq67rn9rZDh4tpqQGo3weAzeQxJB23OAPbT2pUuHXocoCHdzVayo
         +k4/qHe3JlcAOOqWlayedBIpz0UYuyIS3Ywq8fnq4HrPnEvmO7Wg6kxlz6dtAR4pzaSj
         onPkaK1kF8FStl+IvJ5EPFCfyGtombHDSJmcbzrVfY4R5WPdyf3hsOn9chXVbybk7GlO
         a5lbwSx9+HDkJVjG3A6TzxPtQOb0CENwpYYZ7ocdYAKaZ31uzEiNmshhGku6xWiR/tRh
         kUew==
X-Gm-Message-State: AOAM5315J6hOuUWCuSZCwZFjE1sRJ6+Yu4J5BmdDi3qwvEGT3Negnn8t
        PtIieTV3Re9htZN7LXEoHde5o4T+WhIedw==
X-Google-Smtp-Source: ABdhPJwp2xHI0sax2w27zMgXDJjzBnq0PpWxJswtBwPu0Ydi/Fji91zssN54qzF5PXtqdKmQRA4wcg==
X-Received: by 2002:a05:6602:737:: with SMTP id g23mr3164697iox.130.1614624887613;
        Mon, 01 Mar 2021 10:54:47 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id s16sm484813ioe.44.2021.03.01.10.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:54:47 -0800 (PST)
Date:   Mon, 01 Mar 2021 10:54:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <603d386fcb3e8_20893c208c5@john-XPS-13-9370.notmuch>
In-Reply-To: <20210301184805.8174-1-xiyou.wangcong@gmail.com>
References: <20210301184805.8174-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] skmsg: add function doc for skb->_sk_redir
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This should fix the following warning:
> 
> include/linux/skbuff.h:932: warning: Function parameter or member
> '_sk_redir' not described in 'sk_buff'
> 
> Reported-by: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skbuff.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index bd84f799c952..0503c917d773 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -656,6 +656,7 @@ typedef unsigned char *sk_buff_data_t;
>   *	@protocol: Packet protocol from driver
>   *	@destructor: Destruct function
>   *	@tcp_tsorted_anchor: list structure for TCP (tp->tsorted_sent_queue)
> + *	@_sk_redir: socket redirection information for skmsg
>   *	@_nfct: Associated connection, if any (with nfctinfo bits)
>   *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
>   *	@skb_iif: ifindex of device we arrived on
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
