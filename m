Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A74F3D8761
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhG1Fqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233485AbhG1Fqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB34560F00;
        Wed, 28 Jul 2021 05:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451190;
        bh=RkniVPw58x8HtXFNZtC6iw7u6agFRS3hIJcKdd+55ec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSebIApW9TVBAUK7OJ/Tb8IqORU/SGsPM3aWGnOEmtfhuKuwrzn0QtsCBUDuV6gqM
         yOHBji91agAgQERWWduJrLj9K/W8yyM7nH4QV70xYPcZBkujd6YERI4gwzXwo+otKh
         wLtgvqZimQZTA1U1liKqT622nMyjaIAZgegBMcNI=
Date:   Wed, 28 Jul 2021 07:46:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 09/64] staging: rtl8723bs: Avoid field-overflowing
 memcpy()
Message-ID: <YQDvM4r2KomO9p+J@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-10-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-10-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:00PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Adjust memcpy() destination to be the named structure itself, rather than
> the first member, allowing memcpy() to correctly reason about the size.
> 
> "objdump -d" shows no object code changes.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/rtl8723bs/core/rtw_mlme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

