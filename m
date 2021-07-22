Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52113D277C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhGVPl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:41:57 -0400
Received: from verein.lst.de ([213.95.11.211]:34894 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGVPl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:41:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B75EC67373; Thu, 22 Jul 2021 18:22:28 +0200 (CEST)
Date:   Thu, 22 Jul 2021 18:22:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/6] compat: make linux/compat.h available
 everywhere
Message-ID: <20210722162228.GA9882@lst.de>
References: <20210722142903.213084-1-arnd@kernel.org> <20210722142903.213084-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722142903.213084-2-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 04:28:58PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Parts of linux/compat.h are under an #ifdef, but we end up
> using more of those over time, moving things around bit by
> bit.
> 
> To get it over with once and for all, make all of this file
> uncondititonal now so it can be accessed everywhere. There
> are only a few types left that are in asm/compat.h but not
> yet in the asm-generic version, so add those in the process.
> 
> This requires providing a few more types in asm-generic/compat.h
> that were not already there. The only tricky one is
> compat_sigset_t, which needs a little help on 32-bit architectures
> and for x86.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
