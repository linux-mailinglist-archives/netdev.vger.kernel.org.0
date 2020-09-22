Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447EB273BAE
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgIVHYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:24:01 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49235 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729735AbgIVHX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:23:59 -0400
Received: from mail-qv1-f46.google.com ([209.85.219.46]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MgzWP-1kwjIH0sNp-00hNUS; Tue, 22 Sep 2020 09:23:56 +0200
Received: by mail-qv1-f46.google.com with SMTP id cy2so9001474qvb.0;
        Tue, 22 Sep 2020 00:23:54 -0700 (PDT)
X-Gm-Message-State: AOAM530Ji4p6SqJlsqlAIhXa/mehEohMOm/qYFKdMQf1jU7KsXMjThoF
        zhEaydElHAkD1HY8suM9/IFXSKaiuthCjdj0j8g=
X-Google-Smtp-Source: ABdhPJx2+lYoTA/KUzOktg9GCEROrxWzhLaiei0nYKlXvAWkeVBXqnjogbknJct+KWfdqdHtsSEC4gKbjbjELvczheY=
X-Received: by 2002:ad4:4594:: with SMTP id x20mr4471122qvu.4.1600759433835;
 Tue, 22 Sep 2020 00:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
 <D0791499-1190-4C3F-A984-0A313ECA81C7@amacapital.net> <563138b5-7073-74bc-f0c5-b2bad6277e87@gmail.com>
 <486c92d0-0f2e-bd61-1ab8-302524af5e08@gmail.com> <CALCETrW3rwGsgfLNnu_0JAcL5jvrPVTLTWM3JpbB5P9Hye6Fdw@mail.gmail.com>
 <d5c6736a-2cb4-4e22-78da-a667bda5c05a@gmail.com> <CALCETrUEC81va8-fuUXG1uA5rbKxnKDYsDOXC70_HtKD4LAeAg@mail.gmail.com>
 <e0a1b4d1-ff47-18d1-d535-c62812cb3105@gmail.com>
In-Reply-To: <e0a1b4d1-ff47-18d1-d535-c62812cb3105@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 22 Sep 2020 09:23:37 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2-6JNS38EbZcLrk=cTT526oP=Rf0aoqWNSJ-k4XTYehQ@mail.gmail.com>
Message-ID: <CAK8P3a2-6JNS38EbZcLrk=cTT526oP=Rf0aoqWNSJ-k4XTYehQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:AjHYUanKdOfbecE9w+B9Z4N6BZ2b/6C3GC/ZT1GJo80TVMT1TiT
 B7v2YHekGwErZe59Y8I5SN6nA+wzRAtAzQV1alKD4cIBzMUtp+uCtDl7yXziqEx66eHXl+8
 5YaL/7KLJywdo7o6ruzdrm03FhbTCMOpxp+6Gjsv8I+DI1w9YYa5HKbByc2HjGMgB5rmpQw
 GI2KocTAr9puH1Zbmwgvw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9U7HyB6Ug10=:7VkgnZRSuXPXxCph3JiICU
 vGLCkcH/ucwoA0af9e3nwxzDrSU4qHHl5LbVNZE9fwRlf3BxRnIxChhoUWY/pbGK9kbUMnPn6
 iOxC7987sYhrLc/wR5FOOl9AmSFlJBCSkq0ECTVJJpJ1zAxFuSujqohHO71ms6fcLmkaP+68S
 a0y2dx03p+yQJTxCFfxZOllLfzHK80WYos1HroZHejUrF2/VDsLfCxxtFN6y520PH/aUVeNvX
 l/r1mWP7DXSVu7yUeClrfFvYtyE6idWsIDiC+H5wv241L9aUyE9A1wYt26cS3oRTT1aDX3vMZ
 lF5PgAd9+uS16D5p+mk7jnRYYYSNrgwHLffuwCYE2JUBFqA2ujr4MluvOT2GRH9b6unq2dzUt
 517RcTi/d6VNGTxLnkFU+xqDBgZ1yVXhchRfVaiepT1jCj8BgkHRkV9OoGDBdyP1nmyz0sll2
 VQ2xFLSS96OSw2POSPIhQsLbgTDcNO1bJhekhO3rGilcenA0dj9a+7SWVb/8O+ZUaB/SmF73C
 H3ua4oRbYBwYWG4ccj0SutXeHYh6UzX5exeOaMAbrFEBOHq90MPJxZr9OpBKopwpfZg7TSiRi
 zSapc09tG64gvk/y30gK+i9n1y1+Z0hVsj881DVR15Z8IRzOaiwsXHPRYtDWn/5Id1OXfXYUM
 GQLtid6DrtgYOV0t1yQLdUOtxCEHIcKjbkyzeUWon4rvW/O2PJ+LPGuX+cT3Y0mJX/3TaOO54
 m56BSGeq93F8uHja3JT2cGnNBOb+bVlrVofywZOAznpqgdVcbwKfyV9CySRC23EhkF1Ux3+P4
 ZUOrZnEIgtbSpmA2VFcNm2AcUo/kCY3kPrBkDXiWyRHUmv7uuCFJ1dmKR0zxr3hNe7SRSUTeV
 e6nWK/ehurPAIaliTaLQ6/+QvEa//1a77RtpYjE1Mq+j6mZVIEO8F7N+t+EVsiOGMFjG5zlvk
 7US7In7QKaLgmPwktYFz4b9g/6ZdT94cvaUrc7hXk0N9in6iyc/wh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 8:32 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 22/09/2020 03:58, Andy Lutomirski wrote:
> > On Mon, Sep 21, 2020 at 5:24 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > I may be looking at a different kernel than you, but aren't you
> > preventing creating an io_uring regardless of whether SQPOLL is
> > requested?
>
> I diffed a not-saved file on a sleepy head, thanks for noticing.
> As you said, there should be an SQPOLL check.
>
> ...
> if (ctx->compat && (p->flags & IORING_SETUP_SQPOLL))
>         goto err;

Wouldn't that mean that now 32-bit containers behave differently
between compat and native execution?

I think if you want to prevent 32-bit applications from using SQPOLL,
it needs to be done the same way on both to be consistent:

   if ((!IS_ENABLED(CONFIG_64BIT) || ctx->compat) &&
        (p->flags & IORING_SETUP_SQPOLL))
            goto err;

I don't really see how taking away SQPOLL from 32-bit tasks is
any better than just preventing access to the known-broken files
as Al suggested, or adding the hack to make it work as in
Christoph's original patch.

Can we expect all existing and future user space to have a sane
fallback when IORING_SETUP_SQPOLL fails?

      Arnd
