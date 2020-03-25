Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674B8193238
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCYU40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:56:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54718 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYU4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:56:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so4193483wmd.4;
        Wed, 25 Mar 2020 13:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=guf04qcrEdBtRuF9SYoOu8Wy++qyg5NjSOd4++zMt3w=;
        b=FkdW08p5U01xuUKRNj2Kc2MjlKQEt8pkODn2r3dnsRUUtRWbYXOyLh82VXo06AIVPj
         U1SsacRQ8EcAonpqzeIX0DkaZk95vUsM2N/UQTtfV4pBorSGVoeuv07tcrLvXOVFsU2A
         dAe7e4JQr5hnDgHCOKkGl7QztbS6QcMbg4EXgaCmki/etzOVmZYBEt3kxgYxCk9GnR7y
         xVUsLE4vPYAjUbRg9gfdw1e0ir5hKtJIWwt0D4MlxD+Y89MHPTZIHNjVMWtdozOiQMVs
         WZXE4l+X8Zde4gq0f7bI3++an9zX188EeD5aIooEaPIKKYRkLs3JUsO5eeipCUpmbkvi
         hbHw==
X-Gm-Message-State: ANhLgQ0tGE1dDS1Z4PEBUyEd3yiKPAPukVsbyQnr/aSfZ8uiMaocIRZq
        kgqTO0bEtgGQBEgVFZjLPcISA1pzcgaEEkDqz80=
X-Google-Smtp-Source: ADFU+vsuklc/U39/jTWLAg3YOMhHl/913hCJxpZdrFmhPp2wnNDcEG4716gE0gaM7qkGx7wcU+7IS1lLPwgrpVXCweo=
X-Received: by 2002:a1c:2842:: with SMTP id o63mr5329530wmo.73.1585169782681;
 Wed, 25 Mar 2020 13:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CACAyw9-jJiAAci8dNsGGH7gf6QQCsybC2RAaSq18qsQDgaR4CQ@mail.gmail.com>
In-Reply-To: <CACAyw9-jJiAAci8dNsGGH7gf6QQCsybC2RAaSq18qsQDgaR4CQ@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 13:55:59 -0700
Message-ID: <CAOftzPiDk0C+fCo9L5CWPvVR3RRLeLykQSMKAO4mOc=n8UNYpA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 3:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> >
> > From: Lorenz Bauer <lmb@cloudflare.com>
> >
> > Attach a tc direct-action classifier to lo in a fresh network
> > namespace, and rewrite all connection attempts to localhost:4321
> > to localhost:1234 (for port tests) and connections to unreachable
> > IPv4/IPv6 IPs to the local socket (for address tests).
>
> Can you extend this to cover UDP as well?

I'm working on a follow-up series for UDP, we need this too.
