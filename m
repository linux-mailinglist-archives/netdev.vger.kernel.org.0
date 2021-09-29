Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3BE41C38C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245713AbhI2Lii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:38:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42466 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245664AbhI2Lif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:38:35 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632915413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AT26+u/1euIQC1wufR5pbz980hdl9VvdaICKoRtaerg=;
        b=a7HnL+BqCz8C5zKJkQKAqQLTWHmHTLv6f3ggbGnH/LPb3ymePLJQwLRDliLSEbX4QiD7ka
        FoV1QaSiDg9AdkyrLqMB272mf25KLc7Zl77Eyq/ip8acdtXCk+Forhv2EOQ1UABBnByPw3
        gw2uVaf/lfwDWe+FdbCms7j18M/0sFbw9K1GOo630wPFjM4VaQl2VZjK21pzrKQ660kmMY
        rKEbjttOS7o5UuJaK4r0ite3+UlucsLLDAE0WTxp1EDViWD99BpLT3IYWeTJTD+uNjCfqb
        WI/U2gBFVGe6JFXCeOjsteQeUgouC2OThR3lf85Bjl35niGBoXPE828mAeRVAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632915413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AT26+u/1euIQC1wufR5pbz980hdl9VvdaICKoRtaerg=;
        b=Kf7FSw84Jq5Zse+HJngWsG3Dxn0vmk0IB/T7DxOEZnpHT1iabkk4YCvn5neXnxDLBvklbn
        Lj/17CE3rDtvGWBA==
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] net: introduce and use lock_sock_fast_nested()
In-Reply-To: <59164fda628b5169d2dac9ecf7e85d3d6f9690f5.1632909427.git.pabeni@redhat.com>
References: <59164fda628b5169d2dac9ecf7e85d3d6f9690f5.1632909427.git.pabeni@redhat.com>
Date:   Wed, 29 Sep 2021 13:36:53 +0200
Message-ID: <87tui38vfu.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29 2021 at 11:59, Paolo Abeni wrote:
>
> Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
> Fixes: 2dcb96bacce3 ("net: core: Correct the sock::sk_lock.owned lockdep annotations")
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Reported-and-tested-by: syzbot+1dd53f7a89b299d59eaf@syzkaller.appspotmail.com
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
