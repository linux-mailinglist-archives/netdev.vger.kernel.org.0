Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A72C437686
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJVMMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:12:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36732 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhJVMMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:12:52 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BBF0963F45;
        Fri, 22 Oct 2021 14:08:50 +0200 (CEST)
Date:   Fri, 22 Oct 2021 14:10:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: autoload ipvs on genl access
Message-ID: <YXKqNos44XqQYXOi@salvia>
References: <20211021130255.4177-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021130255.4177-1-linux@weissschuh.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 03:02:55PM +0200, Thomas Weißschuh wrote:
> The kernel provides the functionality to automatically load modules
> providing genl families. Use this to remove the need for users to
> manually load the module.

Applied, thanks
