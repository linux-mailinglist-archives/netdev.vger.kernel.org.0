Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9D22F6E5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgG0RmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbgG0RmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:42:23 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA81C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:42:23 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a15so9164855ybs.8
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=draconx-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=8eTEImJlgOllN2N0LVMVlZdkUWAqoKd8wMgN/KPPGyw=;
        b=PcQmdoobad+ns7LDo62SRtHFW8CqQRB4OfyM2CsoZ5l2gfI3wUdbpc9Yj4KvkWQZ7N
         8XdUhqrCIftgytbRI9vziHsjeNts5Uh0BVZAoJRfgAg4KwEgh3NrzyaHezhLeYBHPm4k
         F9FpyLz33eEJtNjfTrmzoHAu2Kt0lmU+UvpqYdD4nGUjCxAAcNsx/Uutbvv9pyJ6WklG
         I/dm5avZl3GKTeDD1o7/dnoIBjePWFod0UvfipQJZ89CLhFLxYeAAcmFe7sD77C2yuuo
         MoF5iah1OaPspUQibfWciLZeqwnZ8uDhkv8mEi6YPGVvRsqjNTvmQael1e32eCGsndnj
         y85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=8eTEImJlgOllN2N0LVMVlZdkUWAqoKd8wMgN/KPPGyw=;
        b=mr7Rqdfnt1DmsiHZzX1kWBW2fGCMJ0lx8eCLMhPGouUWASZNi4TyKzg6oeEn1K3j65
         dhnIkLhhTaNGD1PTcmPt9TwCz6nLfMifSpL4W8qWtgsDRfQQBkA6Xb55+43dcGcHwOvK
         NZuEUNZjGpPM6FpDS/biQl8myWrFIeh6MYLixqF0RRHP8m3sx7jZfJqOmk+rIBzFP0My
         HcjJYJ3cxF+W4sP7Ky2w1lRqWEy2kiZdA+QCNHbIbxxz1ahP2BEUiPuo2N0HOlwn2bY5
         3SHXcdxNcKY6TuMbe86vFYpQNCExBomeVjAAiq+gIyB91tzkMh0Y37wHf9KgRmJFT0WQ
         Rl3Q==
X-Gm-Message-State: AOAM532THBi4ioEENpVnPX3+MNDYrsEUc1KnNjRURoFbTUWGZ/DAuq3v
        cH0HjAN3kVNx8FFfelccS4bgKh70ixLZzhv5+jYAyTFuEc0=
X-Google-Smtp-Source: ABdhPJyhgSDpr2FdTbpW7mQoCX8b9rF1eP3wUiwp1GHuEIFPNp42c9HwMG5miSAbYBtkAYUJUXiKKPD+jHA9yuLX72s=
X-Received: by 2002:a25:b446:: with SMTP id c6mr36564613ybg.279.1595871743002;
 Mon, 27 Jul 2020 10:42:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a25:807:0:0:0:0:0 with HTTP; Mon, 27 Jul 2020 10:42:22 -0700 (PDT)
X-Originating-IP: [24.53.240.163]
In-Reply-To: <20200727161319.GH794331@ZenIV.linux.org.uk>
References: <20200723155101.pnezpo574ot4qkzx@atlas.draconx.ca>
 <20200727160554.GG794331@ZenIV.linux.org.uk> <20200727161319.GH794331@ZenIV.linux.org.uk>
From:   Nick Bowler <nbowler@draconx.ca>
Date:   Mon, 27 Jul 2020 13:42:22 -0400
Message-ID: <CADyTPEx_dppsUK_SdPKfn-1ZgEzYubbe4tBmXSKBBXTFT5cbWA@mail.gmail.com>
Subject: Re: [PATCH] Re: PROBLEM: cryptsetup fails to unlock drive in 5.8-rc6 (regression)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-27, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jul 27, 2020 at 05:05:54PM +0100, Al Viro wrote:
>> On Thu, Jul 23, 2020 at 11:51:01AM -0400, Nick Bowler wrote:
>> > After installing Linux 5.8-rc6, it seems cryptsetup can no longer
>> > open LUKS volumes.  Regardless of the entered passphrase (correct
>> > or otherwise), the result is a very unhelpful "Keyslot open failed."
>> > message.
[...]
> Oh, fuck...  Please see if the following fixes your reproducer; the braino
> is, of course, that instead of fetching ucmsg->cmsg_len into ucmlen we read
> the entire thing into cmsg.  Other uses of ucmlen had been replaced with
> cmsg.cmsg_len; this one was missed.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/net/compat.c b/net/compat.c
> index 5e3041a2c37d..434838bef5f8 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -202,7 +202,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr
> *kmsg, struct sock *sk,
>
>  		/* Advance. */
>  		kcmsg = (struct cmsghdr *)((char *)kcmsg + tmp);
> -		ucmsg = cmsg_compat_nxthdr(kmsg, ucmsg, ucmlen);
> +		ucmsg = cmsg_compat_nxthdr(kmsg, ucmsg, cmsg.cmsg_len);
>  	}
>
>  	/*

This patch appears to resolve the problem when applied on top of 5.8-rc7.

Thanks,
  Nick
