Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC0124BD8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLRPhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:37:46 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44473 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfLRPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:37:45 -0500
Received: by mail-lj1-f196.google.com with SMTP id u71so2627093lje.11;
        Wed, 18 Dec 2019 07:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V1pv88vY1+c95Jz3a5FVx/PZ15Axli8rimr1CN4blrM=;
        b=gE7CYz+JSD09CXD7SVzajNg18yqQ4Q9b+EYidoEv88a2xAIw8hKAhIKZJI2X/nXjPu
         2rYEakuHcDDWj6CtXwNJIlErh9GN5cWdc20H3cpdmMKHo0MeEfH2PyupwcsE6nCPksa3
         JmZXCOZRr7gmAyBlNaBtnoi2falyqqeHMAIRTLNAS3hWhQyjx0bfy4LnHH2czoTvMgDA
         I1mCP4215aFytv+QQxqm5FuS9hIAHRJmmjyhK4cBWLxtjHi2fs3r8qyN2VcfMhD+zTpI
         o7Ek+l5p2RjQWAw8FjVs3FxiPeswNTxsqUxXPI6Ux5SR9rYiRC50a3JB34nEWLZtE8yq
         EC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V1pv88vY1+c95Jz3a5FVx/PZ15Axli8rimr1CN4blrM=;
        b=p6CTDduSlLoAwyU4BMl3JNSLRb1Zb+5k3TiqGNjHMMKbvGY8NCgyoEoyhPi0K7vnhm
         CfKiD8q7fGbZXV0TG0ELT8qLJEswXQKCBgJ3NBsrVephzhu65KGaW09lDDl4+RywBmrQ
         NDPcQCu/Z/Gdj4EneXFLMH8U0mtqJJpiHmQfok+MyFDfDb8/w2nXMrry7PdPp6dY8ATf
         1X4AAXjM7m9BEPcrOybekiKsrFtnH8RX23Kkve9X0hmbxp0mI07rS6v3HWuQ3qL0ak0p
         oUnUCfaaiNillJ0s5YJ+9OsfWdiUdxeY5cZ0e4EF7+jIkYqHWUwWSajotQ7cgSZeabw/
         eP7w==
X-Gm-Message-State: APjAAAUhE+kBGHNBkVKcjOC70Po3vMFXUhfGtE2ASPbgAodKQc2eY7Vp
        nYpVE8o4dR40tNGn0j5n5hccJFgGsDhXF2DgAes=
X-Google-Smtp-Source: APXvYqxIJ++8dRL9ZfsRJcNFRJQSeVd9jbMFdU5IPmtGdaYeZotYsE/8ANSYO9PeMCX2UotpO3fCe7uc62biwNds5s0=
X-Received: by 2002:a2e:8e8d:: with SMTP id z13mr2253817ljk.10.1576683463773;
 Wed, 18 Dec 2019 07:37:43 -0800 (PST)
MIME-Version: 1.0
References: <20191218112840.871338-1-toke@redhat.com>
In-Reply-To: <20191218112840.871338-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Dec 2019 07:37:31 -0800
Message-ID: <CAADnVQKP3-ebzctUi+7t9YcHkJWt-Y+BToksnhTBgbe2VseUCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Use PRIu64 when printing ulimit value
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 3:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Naresh pointed out that libbpf builds fail on 32-bit architectures becaus=
e
> rlimit.rlim_cur is defined as 'unsigned long long' on those architectures=
.
> Fix this by using the PRIu64 definition in printf.
>
> Fixes: dc3a2d254782 ("libbpf: Print hint about ulimit when getting permis=
sion denied error")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3fe42d6b0c2f..ba31083998ce 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -117,7 +117,7 @@ static void pr_perm_msg(int err)
>                 return;
>
>         if (limit.rlim_cur < 1024)
> -               snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
> +               snprintf(buf, sizeof(buf), "%"PRIu64" bytes", limit.rlim_=
cur);

please use %zu and (size_t) cast like the rest of libbpf.
Thanks!
