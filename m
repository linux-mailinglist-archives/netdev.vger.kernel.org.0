Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2071396A6D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhFAAtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhFAAty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:49:54 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB31C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:48:13 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c10so9017879qtx.10
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZlUjDCgsuFWhxvYifxTNKmVsvLWaULGbLRVxGxQoSM=;
        b=JWFQUzLZ7DOB7kAIScftoxqju3Z4p+Or6uJXs9XrGZGqH6t9nOVHX89/ljGzxerpwf
         /RU6l94a6knLlW0z4QmurHjKeBy0VDazHIkc7remepSMBUF8zaeiRga1q/X4AK10WNHw
         fnXsoYAZJz/f14OECkGioGqo/GU8m0+JrDNc86ti6EMZd0xpTm+rWog8BgUQ2RNO0rs3
         ZOQj6DGjpSPT2DPgl1/kAsIR0DWyJ3X1Igf98dYxeYgKYOEjXgFez3IslbQUb97Ug5SI
         Qs7gxf3C0t0c5tU9nWizEcaDVi77W6e4/lDDR+T6sn/3SQ7VRNFzo0CQD/bnU0vQQwou
         4PlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZlUjDCgsuFWhxvYifxTNKmVsvLWaULGbLRVxGxQoSM=;
        b=jr9A5bzomO7dyXWsTF9BOdMl//uA64caGiTZ3mGzY5rphAW11zbd56CzvH9qSZWcBO
         8HlF7G7tnm1Zd7vcGvaVxO7HYiwAftwTH3XgPj75ffy+96E3+tCJI0GhWQORrW2L+MlM
         a0TIqa65tYP10ozy7XSKEjx+gzO+swKdSDEZkZ0TTSVPkJHRiSdHi4mO/t/F3eJxyruj
         5ADpKuR8CI1TAkIQxQWxI6XtUim0cuCaUW/oCDqjMzE29MMpbVbrF/h1twOn/QJ08xaY
         IxVuHYDMPnDGynoNL2Aj0azDcNEwCp7ntWGSOn2qaIrDs0AV+oJjW3KFKwTnyfPB+LHT
         awwQ==
X-Gm-Message-State: AOAM531ffGWaYtMj+o/SfCC2jIpdu+Ltjhz0XgRQzRrFh7gEtDLj31Jc
        QvywHU12ENeTkdE2jTrY08lRaTQpLRuvDnD5Eofv8UN5ZLn5BQ==
X-Google-Smtp-Source: ABdhPJxzJBTKk6VjVfWZVlNuDmaF4bfTo4cRHTkv6Yn2tJvxoMZOP8XGalAK0tjSq/RVWpWD1MyDsUVee2/TsiSmeS0=
X-Received: by 2002:ac8:4ccb:: with SMTP id l11mr12314288qtv.127.1622508492351;
 Mon, 31 May 2021 17:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210525121507.6602-1-liuhangbin@gmail.com> <CAHmME9rYp0iO_=c_+UxvU9+UpHnnGkQVJYoikyjwav04UwZwBQ@mail.gmail.com>
In-Reply-To: <CAHmME9rYp0iO_=c_+UxvU9+UpHnnGkQVJYoikyjwav04UwZwBQ@mail.gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Tue, 1 Jun 2021 08:48:01 +0800
Message-ID: <CAPwn2JTgovNOOWcPTkDgZxRFcmk5MciHMEgGio2iJajjtrpfKw@mail.gmail.com>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 8:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > +n1 sysctl -w net.ipv4.conf.vethc.rp_filter=0
>
> The VM does not ship with sysctl, and you'll notice that other changes
> go through /proc directly. Since it's a trivial change, I'll rewrite
> your commit.

Sorry to make this trouble. I saw other selftests also using sysctl, so I didn't
realize some VM may not have sysctl installed.

Thanks for your fix.

Hangbin
