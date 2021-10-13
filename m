Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFECE42CB22
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhJMUfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJMUfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EF13610CE;
        Wed, 13 Oct 2021 20:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157212;
        bh=JUi6Yrt6b3RrzaP0GICRbOBRuJGs4INzI/hs1Pv1ynA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SourJ8TlnOofBWndt0Z4Ov7zJeXmPKK9QVPLhT0bssGWje0ZQeexHPnzQKnfRe20G
         Et06r+zv79HlJn9pahoeu0mQQEvzBCOsMq6wSt/RAOyiBdj9t5eFqZGbOKPVsPlNrh
         Uena4duOKbT1zt4511C45BmlHC4cg3Tf/isiq7COiQNWqOCd1lmjAGuuNpApID921j
         RUdLd+8PJ9TW9pIkAW0iXym+eC69E6Dyfd63gjEtJxMyc22yCQBIVCacnXIvo29FkV
         tIDTmp5ZaUm44LQU+4uIfISb1y9wyrJ3LGIh5DggEmob0XAxjra7jfsa7SLAAsarOl
         Md98WOalFav3w==
Date:   Wed, 13 Oct 2021 13:33:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kyungrok Chung <acadx0@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next] net: bridge: make use of helper
 netif_is_bridge_master()
Message-ID: <20211013133331.0b846cd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012141810.30661-1-acadx0@gmail.com>
References: <20211012141810.30661-1-acadx0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 23:18:09 +0900 Kyungrok Chung wrote:
> Make use of netdev helper functions to improve code readability.
> Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).
> 
> Signed-off-by: Kyungrok Chung <acadx0@gmail.com>

Why leave these out?

net/batman-adv/multicast.c:     } while (upper && !(upper->priv_flags & IFF_EBRIDGE));
net/core/rtnetlink.c:                               !(dev->priv_flags & IFF_EBRIDGE))
