Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD50546C8A9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242799AbhLHA3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:29:50 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38906 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:29:50 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2DCF7605BA;
        Wed,  8 Dec 2021 01:23:56 +0100 (CET)
Date:   Wed, 8 Dec 2021 01:26:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH net] netfilter: conntrack: annotate data-races around
 ct->timeout
Message-ID: <Ya/7ppcKVGsokx7k@salvia>
References: <20211207180323.2505271-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207180323.2505271-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:03:23AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> (struct nf_conn)->timeout can be read/written locklessly,
> add READ_ONCE()/WRITE_ONCE() to prevent load/store tearing.

Applied to nf, thanks.
