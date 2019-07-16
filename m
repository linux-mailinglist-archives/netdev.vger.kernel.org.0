Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BB16AD27
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbfGPQvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:51:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35838 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbfGPQvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:51:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so21748609wrm.2;
        Tue, 16 Jul 2019 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Hy49on9pwwSGHNWYVhJzWErO9W6VcZ9NlKNWOV3BWc=;
        b=q38h3o5ZliUop4xBI7tENJvCxXWazWhs+64AnVfRjFzrwUEdpj+35+r7I72+EPiNQr
         dtbwcSWEixsIrauXfvcJJa2gJ03K3o4kExVvBSlx9S7t9cD8DkG3iKIVTCwrrEXNSR9J
         MzaZsx8y23s9+WW1xQ8iYKXQtAFAyD62F2XQVEth6Yf3YusJXHYg7urvCKFB6g8DBmRm
         yuZ/50Wnelzt7xDuiHcfY9CE7V1Puv5pwgQbeKdY5cVuNtZqLHey3FU/dB0Xwg2vDuX9
         RVIkIAb1QsBPzvAsLpNFGk1ot2y2BvjHDdfmFx+13bArzKlAs+KKj9eASXi4AFoCeM+Y
         5jCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Hy49on9pwwSGHNWYVhJzWErO9W6VcZ9NlKNWOV3BWc=;
        b=iin8t17sFHBLUYUdLmNyo4bfHa23IIycR3CunltLHuKTJT62Kp2AXapRl7gpJe4J0u
         UvAb5TvC13NBAN0v0sc5+gulGQ+Xjg60rozu43gRCbGfX8S5pssb+tO0Qgts0E/0lHof
         8y+z61XBZjjQVdyBx6J6CPp54zXh8d2Ex+TZPnGKEM3tfiFxzuQ9G/vi6Fy+HWaCVSZS
         i7jzxV4hsVsq0S1n/OPxDHsjL865IaJybXvtbYKya5SeJwMEVpqTz/cQ6CvCbBUV6fft
         XaCq1ZHLdgQ0noIVD8y5U/wTaAl9oYMNDr8DShgTZhEEfmtBf8nVETOKhBDkibiDjbVx
         Ap9g==
X-Gm-Message-State: APjAAAUVtaJa5zfG8vk07gjMKGSp95uFQpuX8hY9DWQe9U5LGsjmTugB
        dhEiq2EgozO0i97asdfJX7A=
X-Google-Smtp-Source: APXvYqyK1XrE0/ze/V6GKKt2PzEIT2vfmQcanfpKSRpagWW6mywvhrLN+NEpiBfWopzLIKvR0AgEFA==
X-Received: by 2002:adf:da4d:: with SMTP id r13mr3792996wrl.281.1563295898960;
        Tue, 16 Jul 2019 09:51:38 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id n9sm38090291wrp.54.2019.07.16.09.51.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 09:51:38 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:51:36 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Qian Cai <cai@lca.pw>
Cc:     davem@davemloft.net, willemb@google.com, joe@perches.com,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] skbuff: fix compilation warnings in skb_dump()
Message-ID: <20190716165136.GC37903@archlinux-threadripper>
References: <1563291785-6545-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563291785-6545-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:43:05AM -0400, Qian Cai wrote:
> The commit 6413139dfc64 ("skbuff: increase verbosity when dumping skb
> data") introduced a few compilation warnings.
> 
> net/core/skbuff.c:766:32: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
>                                              ^~~~~~~~~~~
> net/core/skbuff.c:766:45: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                        level, sk->sk_family, sk->sk_type,
> sk->sk_protocol);
> ^~~~~~~~~~~~~~~
> 
> Fix them by using the proper types.
> 
> Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
> Signed-off-by: Qian Cai <cai@lca.pw>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
