Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD863B9A49
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhGBA7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:59:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbhGBA7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:59:22 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6A7CC60705;
        Fri,  2 Jul 2021 02:56:43 +0200 (CEST)
Date:   Fri, 2 Jul 2021 02:56:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Message-ID: <20210702005648.GC29227@salvia>
References: <20210624195718.170796-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624195718.170796-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 08:57:18PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where chain->flags & NFT_CHAIN_HW_OFFLOAD is false then
> nft_flow_rule_create is not called and flow is NULL. The subsequent
> error handling execution via label err_destroy_flow_rule will lead
> to a null pointer dereference on flow when calling nft_flow_rule_destroy.
> Since the error path to err_destroy_flow_rule has to cater for null
> and non-null flows, only call nft_flow_rule_destroy if flow is non-null
> to fix this issue.

Applied, thanks.
