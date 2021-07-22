Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361743D278C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhGVPqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:46:18 -0400
Received: from verein.lst.de ([213.95.11.211]:34927 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhGVPqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:46:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E66D67373; Thu, 22 Jul 2021 18:26:51 +0200 (CEST)
Date:   Thu, 22 Jul 2021 18:26:50 +0200
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
Subject: Re: [PATCH net-next v6 6/6] net: socket: rework
 compat_ifreq_ioctl()
Message-ID: <20210722162650.GD9882@lst.de>
References: <20210722142903.213084-1-arnd@kernel.org> <20210722142903.213084-7-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722142903.213084-7-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
