Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF753DCB11
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhHAKPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:15:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47736 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhHAKPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:15:50 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id D6CA060033;
        Sun,  1 Aug 2021 12:15:07 +0200 (CEST)
Date:   Sun, 1 Aug 2021 12:15:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nf_conntrack_bridge: Fix memory leak when
 error
Message-ID: <20210801101537.GA20629@salvia>
References: <20210729082021.14407-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210729082021.14407-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 04:20:21PM +0800, Yajun Deng wrote:
> It should be added kfree_skb_list() when err is not equal to zero
> in nf_br_ip_fragment().

Applied, thanks.
