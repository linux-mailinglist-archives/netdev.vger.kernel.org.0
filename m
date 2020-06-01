Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3A21EAF9A
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgFATd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:33:59 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59045 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgFATd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 15:33:59 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ca825d88
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=NoX9YXx2p0iCAh+yBLjqXFviZZM=; b=f+ymc8
        GoNjKhbuNZLTTm7yc2waGYa+k7wf9nZXOd8StT3K/2gWBWOYtUCwF7MeSNYnq03Z
        ER7nVn5uNTpIeM/p082Hdv7OWeT0J8QFGOiavzZOP+sn9YKw9UPsb5aSylqxTiKn
        4goqjXy38/t5J0uBAkapzv48LvUfHZSasbmjOhVrsafyXOUV0q+Xyp9gvpslhY9P
        heDiHmiCRwmAh6QatQVyBY1QdDNGH90LDiA4R4zL0ggw1vM3EEQlICYiHm/HKbMi
        bE56CSCt6jr606Kn1RF+sQPuFyH7KgPInxcPgExCUtpePHL67accShHDBPingcrp
        eG8ILMeeEZXjcnPw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f5845ec6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 19:17:53 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id b5so4368331iln.5
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 12:33:58 -0700 (PDT)
X-Gm-Message-State: AOAM532j6iwUJbRISlXbQphCxvUAU7hk0Wj2qHbtJvilY7LUKo0ufUKt
        V1MPS/ddxqhsxxQiskBY0AEpW1Deo5j9JFC55rw=
X-Google-Smtp-Source: ABdhPJw1hT+MN0G+Oi3SPmMsOpvW2HaJiBp9cM3i2vLViFT1xu7uj5bQiL2DysCTIX/laA2h9rApUGuGIzmOq5iIPOc=
X-Received: by 2002:a92:af15:: with SMTP id n21mr16267397ili.64.1591040037549;
 Mon, 01 Jun 2020 12:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200601062946.160954-1-Jason@zx2c4.com> <20200601.110044.945252928135960732.davem@davemloft.net>
In-Reply-To: <20200601.110044.945252928135960732.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 1 Jun 2020 13:33:46 -0600
X-Gmail-Original-Message-ID: <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
Message-ID: <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of cycle
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On Mon, Jun 1, 2020 at 12:00 PM David Miller <davem@davemloft.net> wrote:
> This is going to make nearly every -stable backport not apply cleanly,
> which is a severe burdon for everyone having to maintain stable trees.

This possibility had occurred to me too, which is why I mentioned the
project being sufficiently young that this can work out. It's not
actually in any LTS yet, which means at the worst, this will apply
temporarily for 5.6, and only then on the off chance that a patch is
near code that this touches. Alternatively, it'd be easy enough to add
a Fixes: to this, just in case. I'll be sad but will understand if you
decide to n'ack this in the end, but please do consider first that
practically speaking this won't be nearly as bad as this kind of thing
normally is.

Jason
