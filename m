Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F3B1CDA32
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgEKMjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:39:42 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:53087 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgEKMjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:39:41 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N0o3X-1jD1w72qKz-00wj7v; Mon, 11 May 2020 14:39:38 +0200
Received: by mail-qv1-f52.google.com with SMTP id x13so2480304qvr.2;
        Mon, 11 May 2020 05:39:38 -0700 (PDT)
X-Gm-Message-State: AOAM532QioAGWDZuITaSW7oiOoIH4dW1cne4KwD3g3F6c3+GDsSZV6Vz
        c/X6sOoJENybWLcssGEjVjlbSk+ibPAYsSV+yZY=
X-Google-Smtp-Source: ABdhPJy3yFsBWp1nK1ImGF0MitXLs6M20wf6JJjlnmGirp/X0hBOy7mBcRbBLXQAjFiEonL+pzBlJFwyLyikux1+b14=
X-Received: by 2002:a05:6214:2f1:: with SMTP id h17mr2676901qvu.222.1589200777391;
 Mon, 11 May 2020 05:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200509120707.188595-1-arnd@arndb.de> <20200509120707.188595-2-arnd@arndb.de>
 <87v9l24qz6.fsf@kamboji.qca.qualcomm.com> <87r1vq4qev.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r1vq4qev.fsf@kamboji.qca.qualcomm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 May 2020 14:39:21 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2kRPcpv=xR6yYvFQ5bnFbOWAzyPyzzqufyzFmk2WW2fA@mail.gmail.com>
Message-ID: <CAK8P3a2kRPcpv=xR6yYvFQ5bnFbOWAzyPyzzqufyzFmk2WW2fA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] ath10k: fix ath10k_pci struct layout
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:4nh7np8KnWzZji1NSOLcEqFznUScdP31/SObguYzHTHKeLhM8dR
 vbBNs3lYuCnlSH4508vs4sSp0Heto3UeiEC/VJDIdjgjwRrexfHZ9OSx/KX6Xu+tYBEVn1Z
 c0KntIR4iBSjdsUWywTYTuiJ4Lgd9h+kkj/5tVZBhjL0x1vEQnv8v8s+PvESIUY9TfvI9ko
 MFDMQa5eyhCQ1FN2xrCOg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:N13znjD/Nx4=:nGpiXOL5OENPjtKIQ3VHnG
 KcdQ5d1Ha/yqDoZa7svXovW36CKkgCmGQnhNI46XwRAUCmyk2G5Dc23BBucE7VIfajLtuMTsp
 1kf3R/BJJgQWyMhqLD7vr1wblcu7x+NKGCPaoFDeqzqyEdF04OzJzE0Rlp9B6LGu071ptZoti
 HdMF50SshcnFgArlBIjdtJUIdDBah3vDekM4kV1VUARuL0xMm77bBNgkbVyXFPlIM1t45RYwy
 0GvY/IPnTnnrBLfZaA6dnZuDuYtW3FfvQRxDM6r2ArxgJ8WMOILktZl6eOKOOFfqhE0uqdBnz
 asveuBfSCX7D2sR2+LLuHTsbrLlk/ExoDLbHiEkDAf1GZchVUbiO0BFHtL/iV2ebUXAch0NfM
 Q/u1tAca8LnVwseS4gSXjPOboIiPxblYGRqAWmurCywHiQhZwVqR89g8yhLewciYQwD2XBUtq
 67GDSTk9oaAD4yr5X7D9dSTBJ6Qv2ib4IN5rqtLMFZn6CY5GN7XmPpi9uF/2ihy+g1DC4x9w+
 XPNYL9D9afKkCf18m3m93G9nLj+uD29htrCFlEvxmArgiW8NFr88O2LPBB9YMILgmjIzJhFzH
 Mp1Z7X5L6iYwWxA87hNrTBw7tntaZyG2c/Mhq1thblmAT5HJ57CrPpz/TmJOpgVA9aCZWnHLp
 UehbCNoUsg+s+N8gtAXTxJItV2azc0J50ZbTQR1ubPfBrPSLemIMpLhCn0P+ZfWT2CSXRqfSS
 Nl0aAYPTfpbj8jHURrV5MpsRhZYkEsK4THLMEgQyjDLlCYAkCviN3/ypJfkkIr3AKGY8kkhab
 AMXYzNbyZAKnPIH0Smlpqg9Y6rO1CZnxgPVm11sMUIH7M0oqtg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 2:17 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Kalle Valo <kvalo@codeaurora.org> writes:
> >>
> >> Change it to a flexible-array member and move it last again to
> >> make it work correctly, prevent the same thing from happening
> >> again (all compilers warn about flexible-array members in the
> >> middle of a struct) and get it to build without warnings.
> >
> > Very good find, thanks! This bug would cause all sort of strange memory
> > corruption issues.
>
> This motivated me to switch to using GCC 10.x and I noticed that you had
> already upgraded crosstool so it was a trivial thing to do, awesome :)
>
> https://mirrors.edge.kernel.org/pub/tools/crosstool/
>
> I use crosstool like this using GNUmakefile:
>
> CROSS_COMPILE=/opt/cross/gcc-10.1.0-nolibc/x86_64-linux/bin/x86_64-linux-
> include Makefile

Right, I have something similar (with many more additional things)
in a local makefile here.  I mainly use that to pick the correct cross
toolchain based on ${ARCH}, and to build multiple randconfig kernels
in parallel with 'make -j${NR_CPUS}' for better CPU utilization.

> I think it's handy trick and would be good to mention that in the
> crosstool main page. That way I could just point people to the crosstool
> main page when they are using ancient compilers and would need to
> upgrade.

I actually started working on a script that I'd like to include the kernel
sources to list the installed compilers, automatically pick on that
works for the current architecture, or download one for local installation.

      Arnd
