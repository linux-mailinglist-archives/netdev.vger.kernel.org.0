Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6431A8E82
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391872AbgDNWYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391856AbgDNWYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 18:24:41 -0400
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1270D2076B;
        Tue, 14 Apr 2020 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586903081;
        bh=YaJVT/ye1FgBI4JEdpPpiFVU6B7Mpm3hjJhUg2CSA94=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JEBHN+5SgmCGJ2yWaSx36uCojxC+aC2BZy6wJlChdqzACq0/GAGcOuw364NP9vCHJ
         jrHQ4fYIwT4Ktma2GfhGDBGggSaKZTxZTbT1kGwXaXINs5i6zclUfXYoBjTsWc2UvK
         T13TyNzTVMnQCHu8zQZEvqcYIMJTVJUcPI1DV+2s=
Received: by mail-lj1-f175.google.com with SMTP id q22so1600628ljg.0;
        Tue, 14 Apr 2020 15:24:40 -0700 (PDT)
X-Gm-Message-State: AGi0PubcjDtEXCl4PdA6eBfNu6lJTS/67A9TbtduVWTtu5kIcCiN81Tz
        6+bCqTlmbTIQNDcqbinmvDGepVElk3ldh54bTZo=
X-Google-Smtp-Source: APiQypIAWSIXj7RT/pEoMXOrSMyKd56/mNs4ugtTYhIc9Jk9mRXSGpzm8BvLTnuM4herlwlx8vNNtowRPcFhxbI86Y0=
X-Received: by 2002:a05:651c:1a5:: with SMTP id c5mr1383150ljn.113.1586903079191;
 Tue, 14 Apr 2020 15:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200414145025.182163-1-toke@redhat.com>
In-Reply-To: <20200414145025.182163-1-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 14 Apr 2020 15:24:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7X00K9_QsGm8XhFw2QB03MQSEYRv2f6KupXnWHmH-puA@mail.gmail.com>
Message-ID: <CAPhsuW7X00K9_QsGm8XhFw2QB03MQSEYRv2f6KupXnWHmH-puA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] libbpf: Fix type of old_fd in bpf_xdp_set_link_opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 9:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The 'old_fd' parameter used for atomic replacement of XDP programs is
> supposed to be an FD, but was left as a u32 from an earlier iteration of
> the patch that added it. It was converted to an int when read, so things
> worked correctly even with negative values, but better change the
> definition to correctly reflect the intention.
>
> Fixes: bd5ca3ef93cd ("libbpf: Add function to set link XDP fd while speci=
fying old program")
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
