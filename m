Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65962AE4D7
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgKKAUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbgKKAUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:20:35 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA78C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:20:34 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v22so380715edt.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB4Q2zA/liTOBi8sKOky9SbCmo/lw5wG2KFwiLLJnbA=;
        b=INTUc06LT0NQTxuR70DHnZVXxi6NfdvJzmJHbtl0YlOqdAMIz/wGK3/YMikJi8zXlu
         7rJC03Kt4w939jqArCebcFbVR5AeUFt/y690KFy3tqZuidytLdVIClDVjk04hnlBGjm2
         ZLCdDRjZ1lwzB8W+hAAiPVk0DkXM4XUnN0p95sMnKuiSotD7F2QdO824OKaBYHMkzbPC
         mrMeRt3YSy5Sb7DsxWrPAbIaLM9JLNrTmtUFFmsXlxz0VkWMefrnFPl4Gwu3wD2McL6w
         PmhSiS1aEnAmnRuCGQErqLOincg6GLnukZLKO8WIfPJ9HxubtGt5K0uez8v7be8evq1v
         ZI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB4Q2zA/liTOBi8sKOky9SbCmo/lw5wG2KFwiLLJnbA=;
        b=B6QDN/9A3QTXMpXrHYwYakCT5caRmDlHCANEqo40HoPjKU1po69iUCPiWHBvLYp1YH
         tr25TwfbDlx7lzy3l8h2higVGYFx66CIQTPt4lf3QfnEngRkBWB7yeDkvXTPsBRB39KR
         ciGm2WIGw65Mt99zIyd/hbNv5aesa4guuuu0F3xPAT6gfwO0ObZngMhmBfkuFQ4ChdJd
         4LkbKAcOb19uMVHmmNMpQCToro9G76kv3iHgWtUTHRf7db6p0DRel1UdOwOOgUbVG6nb
         6sExeh+9Cujk7x+0FAk4HgnpIAta147634hsRJi8iipfaXbsiGF0RKlRAbxreYe5eQRU
         yVGg==
X-Gm-Message-State: AOAM533trWKscZ9f3BOsoVQ0IOxK/XFq1P3No23+PAkAZ2hbGNtkpnas
        +x7CepvLQnEcW3ZzuuGDoCkfeCqcQyeMfuQT5m72NqMBLCfcCcKU
X-Google-Smtp-Source: ABdhPJzRXt3Ta0Tm9P8ZTwyB3k4xe7WeiCpa1td9ZytBtn8slNlLEzpd2bXVR5lR6JIdxzXw44ZeL0LUyuiJxqwEOh0=
X-Received: by 2002:aa7:c4c2:: with SMTP id p2mr2158819edr.371.1605054033046;
 Tue, 10 Nov 2020 16:20:33 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
 <20201111000902.zs4zcxlq5ija7swe@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201111000902.zs4zcxlq5ija7swe@bsd-mbp.dhcp.thefacebook.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 11 Nov 2020 00:20:22 +0000
Message-ID: <CAM1kxwh9+fu1O=rG9=HuEnp8c0E2_xvyZpTq=ehX+r5pmNiMLg@mail.gmail.com>
Subject: Re: MSG_ZEROCOPY_FIXED
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 12:09 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Sun, Nov 08, 2020 at 05:04:41PM +0000, Victor Stewart wrote:
> > hi all,
> >
> > i'm seeking input / comment on the idea of implementing full fledged
> > zerocopy UDP networking that uses persistent buffers allocated in
> > userspace... before I go off on a solo tangent with my first patches
> > lol.
> >
> > i'm sure there's been lots of thought/discussion on this before. of
> > course Willem added MSG_ZEROCOPY on the send path (pin buffers on
> > demand / per send). and something similar to what I speak of exists
> > with TCP_ZEROCOPY_RECEIVE.
> >
> > i envision something like a new flag like MSG_ZEROCOPY_FIXED that
> > "does the right thing" in the send vs recv paths.
>
> See the netgpu patches that I posted earlier; these will handle
> protocol independent zerocopy sends/receives.  I do have a working
> UDP receive implementation which will be posted with an updated
> patchset.

amazing i'll check it out. thanks.

does your udp zerocopy receive use mmap-ed buffers then vm_insert_pfn
/ remap_pfn_range to remap the physical pages of the received payload
into the memory submitted by recvmsg for reception?

https://lore.kernel.org/io-uring/acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com/T/#t

^^ and check the thread from today on the io_uring mailing list going
into the mechanics of zerocopy sendmsg i have in mind.

(TLDR; i think it should be io_uring "only" so that we can collapse it
into a single completion event, aka when the NIC ACKs the
transmission. and exploiting the asynchrony of io_uring is the only
way to do this? so you'd submit your sendmsg operation to io_uring and
instead of receiving a completion event when the send gets enqueued,
you'd only get it upon failure or NIC ACK).

> --
> Jonathan
