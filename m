Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62513D7EB6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhG0TzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:55:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0TzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:55:06 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 794496411D;
        Tue, 27 Jul 2021 21:54:34 +0200 (CEST)
Date:   Tue, 27 Jul 2021 21:54:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kyle Bowman <kbowman@cloudflare.com>
Cc:     kernel-team@cloudflare.com, Alex Forster <aforster@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
Message-ID: <20210727195459.GA15181@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210727190001.914-1-kbowman@cloudflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 27, 2021 at 02:00:00PM -0500, Kyle Bowman wrote:
> From: Alex Forster <aforster@cloudflare.com>
> 
> nftables defines NF_LOG_PREFIXLEN as 128 characters, while iptables
> limits the NFLOG prefix to 64 characters. In order to eventually make
> the two consistent [...]

Why do you need to make the two consistent? iptables NFLOG prefix
length is a subset of nftables log action, this is sufficient for the
iptables-nft layer. I might be missing the use-case on your side,
could you please elaborate?
