Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2645CE7002
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 11:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388384AbfJ1KyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 06:54:05 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52547 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfJ1KyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 06:54:05 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MGQzj-1iDGZ40mlR-00GoiK; Mon, 28 Oct 2019 11:54:03 +0100
Received: by mail-qt1-f174.google.com with SMTP id o49so13865309qta.7;
        Mon, 28 Oct 2019 03:54:02 -0700 (PDT)
X-Gm-Message-State: APjAAAXL3h0o0pKmhO/hWENCKxpLZ9BR7O7hMOXFq/6hRfFzEdIwgGIp
        MZ+fCuesngIfvtJZ77WlCi6+QYDsOWaYc4OY/Gw=
X-Google-Smtp-Source: APXvYqw3mSNDkUTcbQaHFAtUtdPZnsQPsyEJ9YfrEXX7tfIz55d/aoAmMt/lg1YLPJEWVjNWe1pYeNKu3immoZ5+7GU=
X-Received: by 2002:a0c:9083:: with SMTP id p3mr14884214qvp.210.1572260041982;
 Mon, 28 Oct 2019 03:54:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190731155057.23035-1-johannes@sipsolutions.net>
 <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com> <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
In-Reply-To: <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 28 Oct 2019 11:53:55 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
Message-ID: <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
Subject: Re: pull-request: mac80211-next 2019-07-31
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:VxUCY6c7TZ7XaW9WR+AUnyLhoOhpSDhmSnWroOX57CN38nnKWTv
 JPwswXuZRins167/wBhAHsWsu3xL+Up2ywWy+Ubk10Wvdi6WiatNd8Bwnan3gLFfbeCG3rr
 GUD5pkY6FRKgcxmIkEdH8G+EcnRQncDl7GPA34ETddWMMqbt7D+tJtNhw+ne/To67A7+eEm
 wYpz8fVXvoOQVmVECsnUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sH8N4E59CS8=:go6Fc7JtnbuNRkgLLqNli3
 j1jRxIGyNmKjVQMPMao+okTEPC0XpD7lRI8YdNwX0Ij1ODwbFgRKVyhBj0aqOorKbWnj3/oOM
 Xc3MfILrQkjSMGKK+QSFBI/iP6VkOvkoOM9eMHuQpoDZxNxc+FOeVM0tXbN0ThNACndoswrp+
 60pfhKsohnUqsCyIQdKTrU1Cv1KsemE2ym2Vj/7V0BybEql2hs9ie6//3ETrp9UalDlXDpzHo
 I559SS4qB0+c6tA+zbeq6PWnxGz6YNCR4JYXqLDAcajQEHVVMSlWzNKFFkDfXH1x9iA2p1nh+
 m3Qbkcojo+QkXoIsIQ5/AS4JHvgf7Y0giJJVKlDTdq8A0aC3GmSM0i6jJRwQ3OfffKM9OAXZh
 YEz1IKOaJVMHNkuAnH9SYzYwIx2a0FI6uLi3j/U+bvDIqCIKphy5HyxmW04f8zCtttLVFEcLR
 v4X2AcrqGtk3aTiGryVJKwkw4gmLf3PuY3xVKxHXYUYbIH+vggqD1vxdnJX1uNoLs3n6Hm6/j
 E6fDA8UkwwzNL13bUg9hUP88/K13R+oYV+obOXvk4z65ZJcNzsVHs+dYESDVp5x8MNuZVNTVH
 9RH98+n05SfCtFSggQc2DSmqO0wk6mzzuo/b/NU9JjbkiKPUvIb3Aaw2IDs98W4JA7jk6ltU1
 C0zwiSBmFDt+wkMZvqGqwpz5c1XqwIiHlT+alcctiBh4N5f8+whpy62GH0hZT+n1VWr5ItBRS
 hbwo5NHN/er/3i4wlHmKLoY/OBOFMU7NWJMbO4Rk19QHB6m9oUspVFSHqh4oEJIdAPOJLt0mz
 IBwTYtuid6FpDGxH+N8gOiiXgStMtzzRBHvMVcauBZuHjP1rPnXURySkcG78q0UYNh/433hck
 5xsDoZ8Kmqu0BzQ6MHiQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 10:52 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> > It looks like one of the last additions pushed the stack usage over
> > the 1024 byte limit
> > for 32-bit architectures:
> >
> > net/mac80211/mlme.c:4063:6: error: stack frame size of 1032 bytes in
> > function 'ieee80211_sta_rx_queued_mgmt' [-Werror,-Wframe-larger-than=]
> >
> > struct ieee802_11_elems is fairly large, and just grew another two pointers.
> > When ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success()
> > are inlined into ieee80211_sta_rx_queued_mgmt(), there are three copies
> > of this structure, which is slightly too much.
>
> Hmm. I guess that means the compiler isn't smart enough to make the
> copies from the inlined sub-functions alias each other? I mean, if I
> have
>
> fn1(...) { struct ... elems1; ... }
> fn2(...) { struct ... elems2; ... }
>
> fn(...)
> {
>   fn1();
>   fn2();
> }
>
> then it could reasonably use the same stack memory for elems1 and
> elems2, at least theoretically, but you're saying it doesn't do that I
> guess?

No, that's not the problem here (it can happen if the compiler is
unable to prove
the object lifetimes are non-overlapping).

What we have here are multiple functions that are in the same call chain:

fn1()
{
     struct ieee802_11_elems e ;
}

fn2()
{
   struct ieee802_11_elems e;
  ...
   fn1();
}

fn3()
{
   struct ieee802_11_elems e;
  ...
   fn2();
}

Here, the object lifetimes actually do overlap, so the compiler cannot easily
optimize that away.

> I don't think dynamic allocation would be nice - but we could manually
> do this by passing the elems pointer into the
> ieee80211_rx_mgmt_assoc_resp() and ieee80211_assoc_success() functions.

Ah, so you mean we can reuse the objects manually? I think that would
be great. I could not tell if that's possible when reading the source, but
if you can show that this works, that would be an easy solution.

> Why do you say 32-bit btw, it should be *bigger* on 64-bit, but I didn't
> see this ... hmm.

That is correct. For historic reasons, both the total amount of stack space
per thread and the warning limit on 64 bit are twice the amount that we
have on 32-bit kernels, so even though the problem is more serious on
64-bit architectures, we do not see a warning about it because we remain
well under the warning limit.

      Arnd
