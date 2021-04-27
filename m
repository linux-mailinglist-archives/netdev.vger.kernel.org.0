Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D2436CC62
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhD0UgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:36:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54170 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbhD0UgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:36:14 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 12F3763E81;
        Tue, 27 Apr 2021 22:34:50 +0200 (CEST)
Date:   Tue, 27 Apr 2021 22:35:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] netfilter: nft_socket: fix an unused variable warning
Message-ID: <20210427203525.GA14154@salvia>
References: <20210427194528.2325108-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427194528.2325108-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 09:45:18PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The variable is only used in an #ifdef, causing a harmless warning:
> 
> net/netfilter/nft_socket.c: In function 'nft_socket_init':
> net/netfilter/nft_socket.c:137:27: error: unused variable 'level' [-Werror=unused-variable]
>   137 |         unsigned int len, level;
>       |                           ^~~~~
> 
> Move it into the same #ifdef block.

Applied, thanks Arnd.
