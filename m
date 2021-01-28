Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8493730688F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhA1AVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhA1AT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C95D64DD4;
        Thu, 28 Jan 2021 00:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611793157;
        bh=RqM3c6egRsVNE68AdmtxrLLispYDJ5/JiNlf4EnT1Tw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ff84jhMK3PqKcNSALAtbkHR8QLbN3sHSx++lnEvAALDsiG2q/nX9tXYprDr/VwhPg
         17E1Kfkm9bLJr38cjUy80O5RT0/ZLpdcUUdFSJtFTfpMp7V8Vlz9DJVV11Nlq07bsh
         Bbq+YqraT+LsMB/iqtCu4mxYOO5MeedfoZDBtpDd1dXzZwevVevqdNnWxHUMceBxvg
         yP8+cKBO4VXFAJrTbO9od12h+1qp3wge+lNFTFQrHy/IpTr5X+7yul8B1jUBetXGeo
         izeEEZzEVxqcp25XnJgaAQg0X52wQos0q0sHmH9I6lLiGTCu+3iMJnduLrENio0iDb
         CNWcJaELmJW/g==
Date:   Wed, 27 Jan 2021 16:19:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariharan Ananthakrishnan <hari@netflix.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Subject: Re: [PATCH 0/1] net: tracepoint: exposing sk_family in
 tcp:tracepoints
Message-ID: <20210127161916.7d31e7ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126212530.6510-1-hari@netflix.com>
References: <20210126212530.6510-1-hari@netflix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 21:25:29 +0000 Hariharan Ananthakrishnan wrote:
> Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
> distinguish AF_INET and AF_INET6 families.
> 
> The following tcp tracepoints are updated:
> tcp:tcp_destroy_sock
> tcp:tcp_rcv_space_adjust
> tcp:tcp_retransmit_skb
> tcp:tcp_send_reset
> tcp:tcp_receive_reset
> tcp:tcp_retransmit_synack
> tcp:tcp_probe

There is no need for a cover letter with a single patch.

Please put this description directly in the commit message.

The patch does not apply to net-next, please rebase.
