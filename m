Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622A42A7639
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbgKEDtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732874AbgKEDtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:49:14 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE82C0613CF;
        Wed,  4 Nov 2020 19:49:13 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id c27so78294qko.10;
        Wed, 04 Nov 2020 19:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nHcpnXTIrUuiigmJngR6wPSO4iJWR81p9EyJouHF74A=;
        b=ukaeKAE9sSb1zGqDB9vk/BGcwIqtsyoIDure2+bQ0F/CF1r6JK3HjP0aLCADoToT69
         1rDjqJZgUIuyFAwJkiDd0FodvN2ZcolRzA5fbOjSjOZydZ9hlHv9OUQJRSdC4fvO8WW6
         hTz9y+PCP+u8Zae31G3lw400wigkymkuCk+27GtKUdil+JRrQG/r5YnsovMjPALkrlYw
         fMXcf4KFuLGyEu2rE9+VeUxYwoqlktsKSSN3Sw4S71VX9qHFFsPMooYP1Vcul3D2O+mx
         U/XAGhLMmv8ynqOUMvQkvCSctUFBUD42+uFN2VTDEjtEWmjhSFVIQs0rYtfIUH4YchSm
         D8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nHcpnXTIrUuiigmJngR6wPSO4iJWR81p9EyJouHF74A=;
        b=BuTmU+az9WcE5iUrPR4MlAVMZsdDOH8U2EmqfD+e16A8JmYeoDoxQZcrd4o77WcXvc
         rnIc3GxU2RbUFl65qEbBPAO/cZbCk9d4A7XuHQYOCT3Q7qseEOetlq1RaRBVZUEIDm5e
         CAluCoEksuTPHaOlU+gmEcz1mhEG2e/ut9eRahdD43EhQjfIrEwPGfP5/L4EYT3cHRBX
         S1ucHqbgzneXjWYHt+fics/Pb5sWZOvX+WG5CMedil1c8c+uMzids74tAe+RJVBYRT4b
         n6Ot/BvbvUX59LhTJClRsPaoz0rUNokrqqtc+aiA5a8dyEWtbct4vtx6HD108jNRYSqi
         7f6Q==
X-Gm-Message-State: AOAM531nChaV4n+Ot0zy2dNOeMBoyHusk+Ghzj0P+y1+80u1PjnrZcSu
        Dr3M/maW4oKj174Zw7ovDiM=
X-Google-Smtp-Source: ABdhPJzzAi/1/TEksK+4RSUwNGfZ6kNc3RKv3T8yFu36vcDIIfAHDNDAzW9ZydDqM6LZmnaF3hP1xA==
X-Received: by 2002:a05:620a:24ce:: with SMTP id m14mr398550qkn.399.1604548153046;
        Wed, 04 Nov 2020 19:49:13 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.74])
        by smtp.gmail.com with ESMTPSA id u5sm143265qtg.57.2020.11.04.19.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 19:49:12 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DAD41C639F; Thu,  5 Nov 2020 00:49:09 -0300 (-03)
Date:   Thu, 5 Nov 2020 00:49:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] sctp: bring inet(6)_skb_parm back to
 sctp_input_cb
Message-ID: <20201105034909.GJ11030@localhost.localdomain>
References: <136c1a7a419341487c504be6d1996928d9d16e02.1604472932.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <136c1a7a419341487c504be6d1996928d9d16e02.1604472932.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 02:55:32PM +0800, Xin Long wrote:
> inet(6)_skb_parm was removed from sctp_input_cb by Commit a1dd2cf2f1ae
> ("sctp: allow changing transport encap_port by peer packets"), as it
> thought sctp_input_cb->header is not used any more in SCTP.
> 
> syzbot reported a crash:
> 
>   [ ] BUG: KASAN: use-after-free in decode_session6+0xe7c/0x1580
>   [ ]
>   [ ] Call Trace:
>   [ ]  <IRQ>
>   [ ]  dump_stack+0x107/0x163
>   [ ]  kasan_report.cold+0x1f/0x37
>   [ ]  decode_session6+0xe7c/0x1580
>   [ ]  __xfrm_policy_check+0x2fa/0x2850
>   [ ]  sctp_rcv+0x12b0/0x2e30
>   [ ]  sctp6_rcv+0x22/0x40
>   [ ]  ip6_protocol_deliver_rcu+0x2e8/0x1680
>   [ ]  ip6_input_finish+0x7f/0x160
>   [ ]  ip6_input+0x9c/0xd0
>   [ ]  ipv6_rcv+0x28e/0x3c0
> 
> It was caused by sctp_input_cb->header/IP6CB(skb) still used in sctp rx
> path decode_session6() but some members overwritten by sctp6_rcv().
> 
> This patch is to fix it by bring inet(6)_skb_parm back to sctp_input_cb
> and not overwriting it in sctp4/6_rcv() and sctp_udp_rcv().
> 
> Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com
> Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Xin.
