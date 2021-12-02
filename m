Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69660465D38
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345185AbhLBEEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344960AbhLBEEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 23:04:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25FAC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 20:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1926CE2151
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 04:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E017EC53FCD;
        Thu,  2 Dec 2021 04:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638417672;
        bh=0JmrUxC1brkG33sPzmnb5m+fEpbpDoNqzokppUh15mM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZjJwJBJiwZWuGi2whtA6aMYejzSq3RWO2mxz2tFZDLTHj3xgtI3925gRhFxdB8irJ
         1uppSO2DLlCbGbGtiB5X/YWQynzP6IXKM+QqwVDliFh5A1ZDyOcBsWYHQAPwVY2lTT
         oIrqgZJKnFh0YmreB95WvwrbvuAl5lH/ZlSug1q2bHkSRByNYezT3yN/FqPQ/djeAP
         tURiDipUZDApq9jc0Hbca9TubBW9aR4tFPMl2R+YUSJ3+b8nU3R+60pbwHhveTZQYD
         J1Q5cRFEVZ2LtA3Mwuhcd2yUP2idywX8wSwIy7lRLjwdqwdb9FPb4yO8u0zMzbkS6Y
         uSGbrUodrA0BQ==
Date:   Wed, 1 Dec 2021 20:01:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: avoid uninit-value from tcp_conn_request
Message-ID: <20211201200110.7d664790@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130182939.2584764-1-eric.dumazet@gmail.com>
References: <20211130182939.2584764-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 10:29:39 -0800 Eric Dumazet wrote:
> +static inline void sk_rx_queue_update(struct sock *sk, const struct sk_buff *skb)
> +{
> +	__sk_rx_queue_set(sk, skb, false);
> +}
> +
> +

I assumed this double new line was unintentional so fixed that up and
applied, thanks!
