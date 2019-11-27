Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC29610AE31
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK0Kte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:49:34 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:41637 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfK0Kte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 05:49:34 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f4a941b4;
        Wed, 27 Nov 2019 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=eRC4IefZaq2pDwmil7AkwYOB+x4=; b=apEnIqc
        hNhcp7PJoYCnlztSmO7hU35bnQku8sxzwt1fW8+esarEmV01sBUE2BQEGhNWxXE8
        I2q2j1gBzd0sjNNA9TGQddNz6gFlSozY/c4Gj3iymlk6n+wQuhsrqW8KN/ivJI5v
        BNCCm+d4ePkfYGyaMxzmLeYm7/SK8RkTljIhUtAElmPpeaFoIB2n+3ughhPsQbq2
        VDDxiHP+jZ0P77Fiym39B4h+Lh2SVAtU8ipMse5WxWj4lTB4vjO2STnTP3BUobxn
        oIqk3/PV8ttdTa1XejhNrrmvfApxp3fSNEolkmv0UXwr2RhbvKShz43T9HyGelkf
        vF0EwPKqVdHxSTA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 96238084 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 27 Nov 2019 09:55:42 +0000 (UTC)
Date:   Wed, 27 Nov 2019 11:49:30 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
Message-ID: <20191127104930.GA367657@zx2c4.com>
References: <20191120203538.199367-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191120203538.199367-1-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 09:35:38PM +0100, Jason A. Donenfeld wrote:
> RFC Note:
>   This is a RFC for folks who want to play with this early, because
>   Herbert's cryptodev-2.6 tree hasn't yet made it into net-next. I'll
>   repost this as a v1 (possibly with feedback incorporated) once the
>   various trees are in the right place. This compiles on top of the
>   Frankenzinc patchset from Ard, though it hasn't yet received suitable
>   testing there for me to call it v1 just yet. Preliminary testing with
>   the usual netns.sh test suite on x86 indicates it's at least mostly
>   functional, but I'll be giving things further scrutiny in the days to
>   come.
> 
> WireGuard is a layer 3 secure networking tunnel made specifically for
> [...]

FYI, as the various merges happen between crypto-2.6.git and net*.git,
I'll be keeping this tag up to date with the latest WireGuard patch:

https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/patch/?id=734bd9ed21b0b0057bd2a131c9129a50cd910f6c
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/commit/?h=wireguard
