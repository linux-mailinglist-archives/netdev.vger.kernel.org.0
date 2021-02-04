Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB25730F9A3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhBDR1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238588AbhBDR1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61CBE64DD6;
        Thu,  4 Feb 2021 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612459582;
        bh=gsCBX5P1w60pZhbTrn4HbhnCeNM2BzuTVKxM5k2M42o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gn0lJ+tL/z4skILfSx32p/UEI2OlF08BOsxvuLuZXJdZc4xkW9KbUjkPhZjFLfNrB
         fBj36qeHpbFM1gzXQqG837Dk1f5hkj4yW0L7Ph0hhSv8H37cIaavbqD2PAp3SLL4PZ
         ww/kcN+bxL1gO8xHD77cknVojBESeHZbJLNYXtHeztiN7+fS2aeGqVBrSLr0jiNzze
         TK3kA1Fy/NFAXSHeLaQGbqTZVW8cWgnswhX+CBhXrHywkuatunU2tfrXf4ynkZK2HP
         dFpMRkZ19k3ytIjqRht+c4ivh0oGIqpcCuSSzECHAVmrWjyIWEPLdGnr0XbF0ul7lE
         MsRPXFoP2KMsw==
Date:   Thu, 4 Feb 2021 09:26:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariharan Ananthakrishnan <hari@netflix.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all
 tcp:tracepoints
Message-ID: <20210204092621.48275fcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

Fixed up white space and applied, thanks!
