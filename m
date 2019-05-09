Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F49193D1
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfEIUwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:52:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44420 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIUwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:52:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id n134so2542713lfn.11;
        Thu, 09 May 2019 13:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8izfY7QaATSiteV+jgAASzN3KHkaEiuR2IercyuoomA=;
        b=onL47UGdbdYp6jBL7dw86aJtJ9+XHCblfj1S2UF8L/0l3M1HoE5EjfEZB+8ncJeQes
         CDq5hzA3ZEaeJgjsNmL5afpuLujvbJ9AZg//GUXdDGZXNKg2qKFPZl0Nonmyig/rXyhM
         4KJCtrxJYPhjcgpCenoPS2oNj0FSsh9AmdxSww3hqpHCC0RAt91ex0HsmooyKMhrNBP7
         qcjLhwYf1WeT6N4kSKxq8vRbbkbjWTkFtDhgHs2bgzqpJiZbNT6iwE1AgIv0hQa9apvY
         Z1YBewW/UToX3mwziHunEM9TDkS1f5ybpDHj9kbzaGXGI7liVus8VKLd6MTttJd9HqMS
         KFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8izfY7QaATSiteV+jgAASzN3KHkaEiuR2IercyuoomA=;
        b=FuuCa2wVun9clu7QQgVbVdLhCGAvCLgYgAkBermclrX5kPxsC506S7Z/cGXr1zpNJ1
         EApTEUy7OCzzwiHuPTTgf2zsskYVNjQU2qkLsElZf/hx+nDBsIFJsMXBCjlX0JYlmETy
         dL8UWzMra3JtYBgA9s9YKlvcjE8cYf7xYAFpaluFsp0yiIM4jwp5AU/IGUcHW2reEMP9
         hKOE3a2LxqkZeb5N2rQAam+dpzzhUh2BzCioA02HDKJnzompXGBRJSo93srmr+GOBS3g
         a6DB7nUI/D/nqSGxAeayfEfLyQdPNdXwrfn7kov2x6wCyDmeSa1z0i33fWRbDpWP6Ez/
         rtYA==
X-Gm-Message-State: APjAAAXh81rT/bSYUMMOJJ5kdcFZqIyyELLqIJ5kZEYJ740F9YYEnACf
        HVVPYfdrt4yzJY1l3AsXkSMfXp4XzkQyZAmmtiw=
X-Google-Smtp-Source: APXvYqyNz7VRs76mnyUSutong8ogRBnUo1HREZ8RuBuXFpYB8nt0XjI4isUzAAUFh8CyIYznJaoqycgB5KRFCJL7Kmc=
X-Received: by 2002:ac2:5606:: with SMTP id v6mr3318657lfd.129.1557435125608;
 Thu, 09 May 2019 13:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190507231224.GA3787@ip-172-31-29-54.us-west-2.compute.internal>
In-Reply-To: <20190507231224.GA3787@ip-172-31-29-54.us-west-2.compute.internal>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 May 2019 13:51:54 -0700
Message-ID: <CAADnVQ+e6TW9cH6yDmRSG5pRHXJiZajcx_q9SoPQi1keDROh-g@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Fix compile warning in bpf selftest
To:     Alakesh Haloi <alakesh.haloi@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 4:12 PM Alakesh Haloi <alakesh.haloi@gmail.com> wrot=
e:
>
> This fixes the following compile time warning
>
> flow_dissector_load.c: In function =E2=80=98detach_program=E2=80=99:
> flow_dissector_load.c:55:19: warning: format not a string literal and no =
format arguments [-Wformat-security]
>    error(1, errno, command);
>                    ^~~~~~~
> Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
> ---
>  tools/testing/selftests/bpf/flow_dissector_load.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/te=
sting/selftests/bpf/flow_dissector_load.c
> index 77cafa66d048..7136ab9ffa73 100644
> --- a/tools/testing/selftests/bpf/flow_dissector_load.c
> +++ b/tools/testing/selftests/bpf/flow_dissector_load.c
> @@ -52,7 +52,7 @@ static void detach_program(void)
>         sprintf(command, "rm -r %s", cfg_pin_path);
>         ret =3D system(command);
>         if (ret)
> -               error(1, errno, command);
> +               error(1, errno, "%s", command);
>  }

it was fixed month ago.
