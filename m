Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57BB29EB31
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJ2MCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:02:50 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34979 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgJ2MCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:02:50 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ed5be1d0;
        Thu, 29 Oct 2020 12:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to
        :content-type; s=mail; bh=UWei3Dja6hmoCFMeKlYb7qUdCuc=; b=wjucsa
        1UUmENTJ4WFke7zVHvQDNlZ67IRa7Pr1o66yL+z4Z/hyqcxcVZXFhQ+qXQamcGXE
        FmcV49QUWjx0hPXHKCfBZzQWEMRTWgz7Jl6/QIiKJMyqsN+pGGWETd48JXBdgiIy
        aBULLFK1kNbR1tRsKqhI1KsZ0M0xJek3tsf0JEr/hcqZPvIjL/TGB4Z1gm7de0DL
        G6Z4pn/6eqzhrjx1BVBczRfe231Q1avHFyupr5SVx40LQK423UbOwh7augg787jn
        iY9ebzIy39nuiSrW0/tlX9ABxfxllnMi/+/xVBB0EgF+yOCz961drt6fbDpVciL0
        8LuB4bhh/2g+y3Cg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6b9afe77 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 29 Oct 2020 12:01:26 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id f6so1966295ybr.0;
        Thu, 29 Oct 2020 05:02:48 -0700 (PDT)
X-Gm-Message-State: AOAM532cakGi/IZlVWmJT3/88uR3uv9Uz6aZxf4H3nOFO8fhLRHLeyjR
        vlXB7ZieMBy+OK8RtyRfQEsk7oQcFm0DG8Tym04=
X-Google-Smtp-Source: ABdhPJydtCA7yNokEssotSDE1p/MWWWFiuS8KTDtiI3b5tTpq5vbldI2DbdK/zzuil3AWJwEdJTJKwRBWXbRkRfaAy4=
X-Received: by 2002:a25:6089:: with SMTP id u131mr5629352ybb.456.1603972968557;
 Thu, 29 Oct 2020 05:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201029025606.3523771-1-Jason@zx2c4.com> <20201029025606.3523771-3-Jason@zx2c4.com>
 <CAHmME9ohyPOwQryPMzk7oNGaBeKSJoFmSQkemRoUYKhjqgQ7ag@mail.gmail.com>
In-Reply-To: <CAHmME9ohyPOwQryPMzk7oNGaBeKSJoFmSQkemRoUYKhjqgQ7ag@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 29 Oct 2020 13:02:37 +0100
X-Gmail-Original-Message-ID: <CAHmME9r+n7B8cdGHYJvztOp2z7ghBYQA0VRZ4y2VZZroQubBAQ@mail.gmail.com>
Message-ID: <CAHmME9r+n7B8cdGHYJvztOp2z7ghBYQA0VRZ4y2VZZroQubBAQ@mail.gmail.com>
Subject: Re: [PATCH nf 2/2] netfilter: use actual socket sk rather than skb sk
 when routing harder
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 1:01 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> As a historical note, this code goes all the way back to Rusty in
> 2.3.14, where it looked like this:

Grrr, typo. 2.3.15.
