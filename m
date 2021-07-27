Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80CF3D81C6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhG0V1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:27:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36652 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhG0V1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:27:53 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6D41C642AC;
        Tue, 27 Jul 2021 23:27:06 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:27:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alex Forster <aforster@cloudflare.com>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
Message-ID: <20210727212730.GA20772@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 04:22:10PM -0500, Alex Forster wrote:
> > It should be possible to update iptables-nft to use nft_log from
> > userspace (instead of xt_LOG) which removes this limitation, there is
> > no need for a kernel upgrade.
> 
> We have been able to migrate some parts of this workload to the
> nftables subsystem by treating network namespaces sort of like VRFs.
> Unfortunately, we have not been able to use nftables to handle all
> traffic, since it does not have an equivalent for xt_bpf.

I'm not refering to nftables, I'm refering to iptables-nft.
