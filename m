Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6601A8E9D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391997AbgDNWai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391879AbgDNWaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 18:30:30 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7EC92072D;
        Tue, 14 Apr 2020 22:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586903430;
        bh=vG8FDRwCHd5tylyNu5Cye5AQVB8T/XkGgBRurtv/Z9k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yzUjr/x3vmA6qJpT9YNj78uDWMIOEB4KjvnuYKzOOimYMdK89bkxIbvXIhrnnzu7q
         ENcVqFIpheSQXYeMHEPlzyMbPWQdwqTy5Qt45wmabmZnkwR6gmqJ+BIfoX4S7/AGdM
         lyWrdNyx80HsXuYcidqqPmZBps4KMvlYnSw2ZGMo=
Received: by mail-lj1-f169.google.com with SMTP id v9so1520522ljk.12;
        Tue, 14 Apr 2020 15:30:29 -0700 (PDT)
X-Gm-Message-State: AGi0PuaRIrotRll8srLNhsIJvOAjvQfS/15ljo7I9v0Mdm8LzXkyjy2l
        9ICLhMpWz9P4M2N3L7znPFRnSP19IJkduwcnbgY=
X-Google-Smtp-Source: APiQypLXJSM+Z2nv7xY8Bt8+Ocf0ju5yHdrGYojLi9dKlCxBxr+EdIWzPa5utfYoe/Qrwtja5VTBa9gvsyxSsFxJG7I=
X-Received: by 2002:a2e:720e:: with SMTP id n14mr1359284ljc.64.1586903428092;
 Tue, 14 Apr 2020 15:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200414145025.182163-1-toke@redhat.com> <20200414145025.182163-2-toke@redhat.com>
In-Reply-To: <20200414145025.182163-2-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 14 Apr 2020 15:30:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW49m8Ke+kiuCvfPKdEefnON8_vb1bO6rfX5a7_ke=FSiw@mail.gmail.com>
Message-ID: <CAPhsuW49m8Ke+kiuCvfPKdEefnON8_vb1bO6rfX5a7_ke=FSiw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Check for correct program
 attach/detach in xdp_attach test
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
> David Ahern noticed that there was a bug in the EXPECTED_FD code so
> programs did not get detached properly when that parameter was supplied.
> This case was not included in the xdp_attach tests; so let's add it to be
> sure that such a bug does not sneak back in down.
>
> Fixes: 87854a0b57b3 ("selftests/bpf: Add tests for attaching XDP programs=
")
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
