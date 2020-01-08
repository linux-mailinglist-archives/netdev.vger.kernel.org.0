Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C92134F04
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgAHVlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:41:07 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:33973 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAHVlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:41:06 -0500
Received: from mail-qv1-f48.google.com ([209.85.219.48]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MAfMc-1j0Kca3xkm-00B43N; Wed, 08 Jan 2020 22:41:05 +0100
Received: by mail-qv1-f48.google.com with SMTP id u1so2078948qvk.13;
        Wed, 08 Jan 2020 13:41:04 -0800 (PST)
X-Gm-Message-State: APjAAAWClsuphvDAz4hu53kr+Gu6dBQ3kxRHv3ghSBjK0XP8Z5pTYRyE
        8b7YxrK/+b7KrCzeBOBKe8HSDPXrlJuUbHuL4GY=
X-Google-Smtp-Source: APXvYqzEwETrf49DN9MgcBhXFQ7+alVc9IqPbg1rtUPHKn/j2r8+VsNhWqPPwM0LF8+Bwslt+yfMiZ5t4wQnjd1dec8=
X-Received: by 2002:a0c:d788:: with SMTP id z8mr5759631qvi.211.1578519663758;
 Wed, 08 Jan 2020 13:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20200107213609.520236-1-arnd@arndb.de> <20200108.132701.1531822898576247637.davem@davemloft.net>
In-Reply-To: <20200108.132701.1531822898576247637.davem@davemloft.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Jan 2020 22:40:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3_4aXaUc-wtk-6Tm++mhWyB7uWbTUN7-a0mBHw1Y8KwA@mail.gmail.com>
Message-ID: <CAK8P3a3_4aXaUc-wtk-6Tm++mhWyB7uWbTUN7-a0mBHw1Y8KwA@mail.gmail.com>
Subject: Re: [PATCH] [net-next] socket: fix unused-function warning
To:     David Miller <davem@davemloft.net>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>, Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, pctammela@gmail.com,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2WOJdDRq2ssQujLdhk18ZNTW+JT7u4DoriBhVC5xJ6eRf4EC/+L
 mq3Y4LmOYS9ikRp6GDqKRFUKIb4de/34IFTy2/YVdbvniYb3syorsdNhvVONk3ttGDBW+T1
 UjSVFUCvSITtT5aa2MSKAt622qPcbe/J8CkSte9jrRKBhv5HR2NVM0/x/sC474my7iyhxxR
 xBep3yuzrlS89c48ESMKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nKr4gj5w16Y=:mCyRN1QWlVSVe5/+yCiOI0
 R/E57P5fbTC3ldMankmpzkc2pjbPbAL78ZdDUqSf0IwqTGEXB3qx1W2OA88/187O2NBrt2eV6
 4z0x/7bIH6jpzh7wYHvUVdeqpFUTCr36md7KQO1tyC2gGZyhvasKokOX7poZ/1VaakOIOK6kj
 uvlmHRQ+oHS/ByuiRWqrnS+ctJZfp7DZTphU4qUOwQBAHVDdQ5AzA3cIGZc9Av1HqSCKfN/Mf
 2lE+J7Tr0b+ayAMIXM8eRoXTxC76Ikr1ZhqRf/IrLXFGIaCLOYsIMFgoKu67uZNAsdBKIS2FY
 T/oWk5eWrICXXI1UZlHwWgt5hizJQ56TN/l4vuTmfkgEt85oguJ6x48v7qwhSXMGcgCqQhinw
 FFAad/3y68KtmyVOO0N3RvlDW6aXSDn/JsjU1kJtDXCOOPngoXf4WIAyWiTMFrlO4n1tgbnPg
 gp4FkLk/9btpIiZV/r57SFHMK1eyJhg5Lu/F+zlhy8KfrYx05xQPofettY4l/bMAI4zJAOzVZ
 W7S/3JwWBm5tOPDkmtXyIgFf+/B0nqIooGThScOiu/fyfG8RSjwqwU2dPtpYPtcN049vDn7cy
 n+XLR/DAMAnk8NcN7hENsXGbWLlHlZAvCGAuUWjWVJs3kle2f+YQNR+5SlypYIHYTMmZ9XIPh
 3VMVzPs3FdMl0l2yKVo+qm5peD5vPwkuTBb345Li3bpRNzytyz+RO2e5yNZgYHHlJoQHkpmeR
 hKqRzPYoaVpWlWVHplDef2FIV6izbPYGP7FzVOxCI51KlxKzf8K5g4ZTj35W3gVikAkuUgYLu
 ATbeMAG3yw7+90WJSR1fO+WqEHQvy+ojKNVPBW7dFauAA6dP+8T9ipSZmLiP8TFUfgczi3lLv
 ZxLF0kVZwuqJaNaET4fg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 10:27 PM David Miller <davem@davemloft.net> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue,  7 Jan 2020 22:35:59 +0100
>
> > When procfs is disabled, the fdinfo code causes a harmless
> > warning:
> >
> > net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
> >  static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> >
> > Change the preprocessor conditional to a compiler conditional
> > to avoid the warning and let the compiler throw away the
> > function itself.
> >
> > Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This isn't the prettiest thing I've ever seen.
>
> I really think it's nicer to just explicitly put ifdef's around the
> forward declaration and the implementation of sock_show_fdinfo().
>
> Alternatively, move the implementation up to the location of the
> forward declaration and then you just need one new ifdef guard.

My first version just had a __maybe_unused tag on the declaration, but
I was hoping this would be nicer as it avoids the #ifdef.

I'll send the version Al suggested instead, unless you prefer the
__maybe_unused.

      Arnd
