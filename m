Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15515376195
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhEGIAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:00:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48334 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhEGIAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:00:48 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2E376414B;
        Fri,  7 May 2021 09:59:02 +0200 (CEST)
Date:   Fri, 7 May 2021 09:59:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: avoid potential overflows
 on 32bit arches
Message-ID: <20210507075945.GB4320@salvia>
References: <20210506125350.3887306-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210506125350.3887306-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 05:53:50AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> User space could ask for very large hash tables, we need to make sure
> our size computations wont overflow.
> 
> nf_tables_newset() needs to double check the u64 size
> will fit into size_t field.

Also applied, thannks.
