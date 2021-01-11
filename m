Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99842F1E3C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390266AbhAKSuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:50:32 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:61735 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbhAKSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:50:32 -0500
Received: (qmail 65343 invoked by uid 89); 11 Jan 2021 18:49:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 11 Jan 2021 18:49:50 -0000
Date:   Mon, 11 Jan 2021 10:49:45 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] skbuff: rename fields of struct
 napi_alloc_cache to be more intuitive
Message-ID: <20210111184945.e7y35uym73ujfif2@bsd-mbp>
References: <20210111182655.12159-1-alobakin@pm.me>
 <20210111182801.12609-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111182801.12609-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 06:28:21PM +0000, Alexander Lobakin wrote:
> skb_cache and skb_count fields are used to store skbuff_heads queued
> for freeing to flush them by bulks, and aren't related to allocation
> path. Give them more obvious names to improve code understanding and
> allow to expand this struct with more allocation-related elements.

I don't think prefixing these with flush_ is the correct approach;
flush is just an operation on the structure, not a property of the
structure itself.  It especially becomes confusing in the later 
patches when the cache is used on the allocation path.
-- 
Jonathan
