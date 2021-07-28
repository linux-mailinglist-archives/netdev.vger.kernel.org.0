Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B402B3D8771
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhG1FtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhG1Fs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 01:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E4BA60F00;
        Wed, 28 Jul 2021 05:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627451334;
        bh=JbVsyLEsyV0K95tq78eYFj+nbQBWex8TPUG2O5qezhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoC9EgXWUIVE6yfgEZosITUtLaP51IYAc4EF8BMu6yXcuHArSq3YpSLR0z9QW9PkB
         rOHss0A4SNXP4+opIRM5+O+mGIbwTTaMd/SSh7hXGIKc3F31yUanRxa81+9XqFAzLR
         gpTe0njI/NP4taNwLMzklkg1vAwgKq5naQqJEoXw=
Date:   Wed, 28 Jul 2021 07:48:52 +0200
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
Subject: Re: [PATCH 49/64] cm4000_cs: Use struct_group() to zero struct
 cm4000_dev region
Message-ID: <YQDvxAofJlI1JoGZ@kroah.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-50-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-50-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:40PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark region of struct cm4000_dev that should be
> initialized to zero.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/char/pcmcia/cm4000_cs.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
