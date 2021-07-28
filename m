Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1871D3D881D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhG1GlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232798AbhG1GlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 02:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA8B16023E;
        Wed, 28 Jul 2021 06:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627454479;
        bh=56P83WlclwichTl6Z38luZ2iMK3+gEOYgDjb65V+lIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RyFulSv1DKr+WMQoNMSADu/bvEL2Nt9m/j8r5jvKSLh5jGBe0pgTIj4j2kHvRaqiq
         cqa3qzmYXurTLeQgm/jDQEpxNsvH/ufI5US3zham8t8FNmVEui6kSE+H9CKeuNpq36
         x4opoXtu0wbNZ69pe/1t1danjGs4IfYhvpwS+YHI=
Date:   Wed, 28 Jul 2021 08:41:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 19/64] ip: Use struct_group() for memcpy() regions
Message-ID: <YQD8DcOeivPzLMkL@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-20-keescook@chromium.org>
 <YQDxaYrHu0PeBIuX@kroah.com>
 <baead202-569f-775f-348c-aa64e69f03ed@embeddedor.com>
 <YQD2/CA7zJU7MW6M@kroah.com>
 <e3193698-86d5-d529-e095-e09b4d52927b@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3193698-86d5-d529-e095-e09b4d52927b@embeddedor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 01:31:16AM -0500, Gustavo A. R. Silva wrote:
> > Why not use a local version of the macro like was done in the DRM header
> > file, to make it always work the same and more obvious what is
> > happening?  If I were a userspace developer and saw the above, I would
> > think that the kernel developers have lost it :)
> 
> Then don't take a look at this[1]. :p
> 
> --
> Gustavo
> 
> [1] https://git.kernel.org/linus/c0a744dcaa29e9537e8607ae9c965ad936124a4d

That one at least looks a "little" different so maybe it could be seen
as semi-reasonable :)
