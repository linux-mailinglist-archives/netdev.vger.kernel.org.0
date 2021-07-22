Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61113D2785
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGVPoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:44:17 -0400
Received: from verein.lst.de ([213.95.11.211]:34907 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGVPoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:44:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A206567373; Thu, 22 Jul 2021 18:24:48 +0200 (CEST)
Date:   Thu, 22 Jul 2021 18:24:48 +0200
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
Subject: Re: [PATCH net-next v6 4/6] net: socket: remove register_gifconf
Message-ID: <20210722162448.GB9882@lst.de>
References: <20210722142903.213084-1-arnd@kernel.org> <20210722142903.213084-5-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722142903.213084-5-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 04:29:01PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Since dynamic registration of the gifconf() helper is only used for
> IPv4, and this can not be in a loadable module, this can be simplified
> noticeably by turning it into a direct function call as a preparation
> for cleaning up the compat handling.

I'd maybe mention that ipv4 must be built-in as that is the bit
required for all the above to make sense.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
