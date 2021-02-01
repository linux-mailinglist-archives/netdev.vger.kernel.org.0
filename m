Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEA130B28E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBAWHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230523AbhBAWG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 17:06:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5933A64D92;
        Mon,  1 Feb 2021 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612217175;
        bh=vFB0PVO42hGcXxmxZOk3TF4woos7hzB49k5OXM54BTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D30lx/8uJcow0JSMC1gSqyNV+uy54UegBxLl+D3OvPSRDeXlc1KoZpbVEwy12DqGN
         ERmHQVnHJmxv1EeOEFK3lBYxirdFIlwXtRw4jkMjiwGMONVxDBfeUOL3QNtt20LCgX
         GKGTzAms6r9Ijju3c4nWTDjB0N28vCbuG3DSAoOKz7nj0XkiDflL8rCN9ShyhSTIKT
         NHE/nQ3+0dwZNFVUzj1GLZYK93d9C91Cjo7teg9IkxJTFLp+ubBTsg/Xuzbo0LQFeQ
         e5r//RXIfO+cb41pvT0Ek+xLrRDp03lJWVVaU6SXJjzQF3IX5fenHzWi1TKty11aZk
         B7jj2BOPtQuPA==
Date:   Mon, 1 Feb 2021 14:06:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Hariharan Ananthakrishnan <hari@netflix.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all
 tcp:tracepoints
Message-ID: <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129001210.344438-1-hari@netflix.com>
References: <20210129001210.344438-1-hari@netflix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 00:12:10 +0000 Hariharan Ananthakrishnan wrote:
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
> 
> Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
> Signed-off-by: Brendan Gregg <bgregg@netflix.com>

Eric, any thoughts?
