Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9930F421D98
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 06:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhJEEm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 00:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEEmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 00:42:25 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFA8C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 21:40:35 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id t200so8744826vkt.0
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 21:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wgKtBiEn2wBDdqZRvUXXOrvUUpUPmrytJu6SFo88c9s=;
        b=prgdXdsH/lneLBPsoWmhuBdzAiwm73RkDEyiOViteu2+UF9CLsLVSz0n2cqGyNSOKh
         VmRB6G3IomM7pZZ9/ECDR88zMNw+Sz0HSKzMWl0DO39m7WJbbVEVrkGUsLtuM0hCql3b
         tlbrJi5cScVGbvr0l9ZjRZ7Y7TxbBeOYjEPQMzY5DoFD8YXMGDeDvxsgfrkpvMM+Ms1h
         YouW8JtoX3c6mW5jvlx+d/5vhDmc4MCw9XxkxYIakgCNNx3c9J4n9hPFF9h4WheHZ36q
         JvjyeRcmFXCgSJoNzRhJjhfCqX7qTABbgdQkMCrLwZk/FqNPCX+uVFQkeob6mQTQCDfm
         dKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgKtBiEn2wBDdqZRvUXXOrvUUpUPmrytJu6SFo88c9s=;
        b=SEsk8jcNlJHYTC5wmN670HFsJJ828VelFpFU+mzRgP7jai2/IkteQYWpnLMs6WS8Us
         AVGrI5Ni3+qGU6UfIIcyA7ZTXvxWZFoeCnGyzrb2ZVuFuhcEhKJ8Mq+bPgrG0GTODJbv
         C24CXO2Vmort+w0ljw+JYhF7s9/gqBA2khEbuGangWComydCWD+1EChDqhyln3kymvaT
         tuvhFfi/Mj6LjgsXKVEKeV9EWxe3JKQ+NCe3zBi2ij7Trbm8iCbOAaUoTBNbt6bwYagP
         wK0bj+TUUSQUb0qlAJTUjsfmapcsvpUts+kVP/hi5y8BWv1zPpBna+Q1vsVmRSwYvmVV
         m/dg==
X-Gm-Message-State: AOAM532mpVa3ANup+uBGbW329tfPoo4HBleCA7aPkKNmOj7T1fjVu3Dd
        SfxKtwa+0/beE/HGLQT4kW1isFjCYkl0fAXiTlKU3w==
X-Google-Smtp-Source: ABdhPJwc+zpVBB1whHmbw3RZzmFrz8UHwO3UIwLKXVwZ5K05MzYm9oB9WXGMBinanX6JHvaNQjqkw5YGjJjXq+t98fk=
X-Received: by 2002:a1f:9e11:: with SMTP id h17mr18670970vke.16.1633408834159;
 Mon, 04 Oct 2021 21:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211001161849.51b6deca@canb.auug.org.au> <20211001.144046.309542880703739165.davem@davemloft.net>
 <20211005121154.08641258@canb.auug.org.au>
In-Reply-To: <20211005121154.08641258@canb.auug.org.au>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 4 Oct 2021 21:40:23 -0700
Message-ID: <CAEA6p_DG+TBWFwmPNG+vZqUqAsL-EpJs2kUEqF1CV1J=-wc6Gg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 6:12 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Dave,
>
> On Fri, 01 Oct 2021 14:40:46 +0100 (BST) David Miller <davem@davemloft.net> wrote:
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 1 Oct 2021 16:18:49 +1000
> >
> > > Hi all,
> > >
> > > After merging the net-next tree, today's linux-next build (sparc64
> > > defconfig) failed like this:
> > >
> > > net/core/sock.c: In function 'sock_setsockopt':
> > > net/core/sock.c:1417:7: error: 'SO_RESERVE_MEM' undeclared (first use in this function); did you mean 'IORESOURCE_MEM'?
> > >   case SO_RESERVE_MEM:
> > >        ^~~~~~~~~~~~~~
> > >        IORESOURCE_MEM
> > > net/core/sock.c:1417:7: note: each undeclared identifier is reported only once for each function it appears in
> > > net/core/sock.c: In function 'sock_getsockopt':
> > > net/core/sock.c:1817:7: error: 'SO_RESERVE_MEM' undeclared (first use in this function); did you mean 'IORESOURCE_MEM'?
> > >   case SO_RESERVE_MEM:
> > >        ^~~~~~~~~~~~~~
> > >        IORESOURCE_MEM
> > >
> > > Caused by commit
> > >
> > >   2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
> > >
> > > arch/sparc/include/uapi/socket.h does not include uapi/asm/socket.h and
> > > some other architectures do not as well.
> > >
> > > I have added the following patch for today (I searched for SO_BUF_LOCK
> > > and, of these architectures, I have only compile tested sparc64 and
> > > sparc):
> >
> > I committed the sparc part into net-next today, thanks.
>
> Unfortunately, there is a typo in what you committed in bfaf03935f74
> ("sparc: add SO_RESERVE_MEM definition."), SO_RESEVE_MEM instead of
> SO_RESERVE_MEM ...
>

Thanks Stephen for the report and thanks a lot David for submitting
the fix. Let me know if I need to do the fix.


> --
> Cheers,
> Stephen Rothwell
