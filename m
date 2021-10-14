Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD2A42E306
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 23:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhJNVDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 17:03:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47108 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhJNVD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 17:03:29 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 344EF63F1F;
        Thu, 14 Oct 2021 22:59:46 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:01:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH nf-next v6 0/4] Netfilter egress hook
Message-ID: <YWianzD4donIclhQ@salvia>
References: <cover.1633693519.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1633693519.git.lukas@wunner.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 10:06:00PM +0200, Lukas Wunner wrote:
> Netfilter egress hook, 6th iteration
> 
> Changes:
> 
> * Perform netfilter egress classifying before tc egress classifying
>   to achieve reverse order vis-a-vis ingress datapath.
> 
> * Avoid layering violations by way of new skb->nf_skip_egress flag.
> 
> * Add egress support to new nfnetlink_hook.c.
> 
> 
> Link to previous version v5 (posted by Pablo):
> https://lore.kernel.org/netdev/20210928095538.114207-1-pablo@netfilter.org/
> 
> Link to previous version v4:
> https://lore.kernel.org/netdev/cover.1611304190.git.lukas@wunner.de/

Applied to nf-next, thanks.
