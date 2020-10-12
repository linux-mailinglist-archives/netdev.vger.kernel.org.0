Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4728AB54
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgJLBKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgJLBKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:10:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602465003;
        bh=rYvZ9IAzJ3Sn5z3L1WcrrApyRRAeQVOlEeYd+UNfyf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ji6vwVlCTOaTK6362bYKuVlkKhbv10Rf63bflhw0pFiZvynFlQvggr6EA82FWJu+n
         cXRVpjiBiEQYNbSPEktdSZ6YZ39JxFMfm3PzvIcnUKbQG7oZAkM9HgqKPprdoavbwt
         BlzY9tCYgLSixazkcdFNV9wYTS82flLg19LSyBEA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next PATCH v2 0/6] sockmap/sk_skb program memory acct fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160246500365.4244.11580231205636613123.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Oct 2020 01:10:03 +0000
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 09 Oct 2020 11:35:53 -0700 you wrote:
> Users of sockmap and skmsg trying to build proxys and other tools
> have pointed out to me the error handling can be problematic. If
> the proxy is under-provisioned and/or the BPF admin does not have
> the ability to update/modify memory provisions on the sockets
> its possible data may be dropped. For some things we have retries
> so everything works out OK, but for most things this is likely
> not great. And things go bad.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/6] bpf, sockmap: skb verdict SK_PASS to self already checked rmem limits
    https://git.kernel.org/bpf/bpf-next/c/cfea28f890cf
  - [bpf-next,v3,2/6] bpf, sockmap: On receive programs try to fast track SK_PASS ingress
    https://git.kernel.org/bpf/bpf-next/c/9ecbfb06a078
  - [bpf-next,v3,3/6] bpf, sockmap: remove skb_set_owner_w wmem will be taken later from sendpage
    https://git.kernel.org/bpf/bpf-next/c/29545f4977cf
  - [bpf-next,v3,4/6] bpf, sockmap: remove dropped data on errors in redirect case
    https://git.kernel.org/bpf/bpf-next/c/9047f19e7ccb
  - [bpf-next,v3,5/6] bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
    https://git.kernel.org/bpf/bpf-next/c/10d58d006356
  - [bpf-next,v3,6/6] bpf, sockmap: Add memory accounting so skbs on ingress lists are visible
    https://git.kernel.org/bpf/bpf-next/c/0b17ad25d8d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


