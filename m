Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC66691DF0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHSHf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:35:29 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43780 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSHf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:35:29 -0400
Received: by mail-ot1-f67.google.com with SMTP id e12so798534otp.10;
        Mon, 19 Aug 2019 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+IuCGkRqjP1DuhBDRVeyJhcF6TvuOGvCmgoo6Ex3X8=;
        b=QN5rSw7ODTDZYcsG9NCGXqnpAUBncmIc5qWdcU9MlBEpyWXPnBqVlDZhnLMt/FnYwO
         ZR8hJo81iiSQnLYVWySWEiq4NTCrdUKB/sATRKnWLknXjcg+nrxLoTP9kxxsqehtaO70
         ML21fg8b1gKLGLDSqWeEwVctSiynn+aCPs+pB/GaX24z+YDDdlopORgKx/rmVj6TIcd2
         yk+Z/7+I03b1Qtjk00U8ODdKEaNd8co+eIGGypp/6u1YCMTUZOP5I0dvyEvFNeVS0LG+
         dS36Ak/Iag1FeiZIxC3DbsQ7MKmDMl8ULylsmoPJqJzVblRoPviLYrBOKdrorVky7VzX
         HQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+IuCGkRqjP1DuhBDRVeyJhcF6TvuOGvCmgoo6Ex3X8=;
        b=MIf7cRWN1az5Dh1YbL027fdT7ZorXk78DUt19mU3h0jvTT6RF4DFzzvb/JELVQlaWS
         qZ3x1CJv65rsEOkZCT3in+/6MLJGl1hR9spL/QpCCAWHmolmIsCQ6SKB10K6YRXVmqmc
         YbCVAgXS2qp9FEKSXJUL37NJg2i2HVjRJaD6KSXeNu9n9y48e8m5GovI7tbGzjHQkVqc
         ICeJ3zSokCyUrPBDfKuNW/dOd27oiDtQri1xmAxNd1/CbJuo2Oi13RD50SBhS17pNCPH
         f6zVkDrQ+1K2Zznz+7MmSfQjVV4iYWWnF8GUhyNAMg6kuGV9kh04uqtvY1DbYB1cgOmk
         /ClA==
X-Gm-Message-State: APjAAAWWB5zGV/guW8diDlXhsZPK81tQMe4JsBdjLguAynoo5tWfIYFW
        wQdm5Ri6h5UwZsoXtRifp6pLmrY7WOeiGUpIyKU=
X-Google-Smtp-Source: APXvYqxcyKIVNXawss9JTb8ZXJSTgahm9Y9QOEf9abmuW+X7Jfybat23G6/x7iqSBjH7apozGCqFh6Iy1TCNlpADPWw=
X-Received: by 2002:a05:6830:11cf:: with SMTP id v15mr18313149otq.30.1566200128669;
 Mon, 19 Aug 2019 00:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
 <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com> <2B143E7F-EE34-4298-B628-E2F669F89896@gmail.com>
 <CAJ8uoz1hY0P+xypkJYYi775SeSXnrrPSM5v0yTf3G+d2a3OhJg@mail.gmail.com> <f88c052e-bc75-9e70-6e94-3dc581baf5f4@mellanox.com>
In-Reply-To: <f88c052e-bc75-9e70-6e94-3dc581baf5f4@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 19 Aug 2019 09:35:17 +0200
Message-ID: <CAJ8uoz1qhaHwebmjOOS9xfJe93Eq0v=SXhQUnjHv7imVL3ONsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: remove zc variable as it is not used
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 8:47 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> On 2019-08-19 09:35, Magnus Karlsson wrote:
> > On Sat, Aug 17, 2019 at 12:02 AM Jonathan Lemon
> > <jonathan.lemon@gmail.com> wrote:
> >>
> >>
> >>
> >> On 16 Aug 2019, at 8:37, Yonghong Song wrote:
> >>
> >>> On 8/16/19 3:26 AM, Magnus Karlsson wrote:
> >>>> The zc is not used in the xsk part of libbpf, so let us remove it.
> >>>> Not
> >>>> good to have dead code lying around.
> >>>>
> >>>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >>>> Reported-by: Yonghong Song <yhs@fb.com> > ---
> >>>>    tools/lib/bpf/xsk.c | 3 ---
> >>>>    1 file changed, 3 deletions(-)
> >>>>
> >>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >>>> index 680e630..9687da9 100644
> >>>> --- a/tools/lib/bpf/xsk.c
> >>>> +++ b/tools/lib/bpf/xsk.c
> >>>> @@ -65,7 +65,6 @@ struct xsk_socket {
> >>>>       int xsks_map_fd;
> >>>>       __u32 queue_id;
> >>>>       char ifname[IFNAMSIZ];
> >>>> -    bool zc;
> >>>>    };
> >>>>
> >>>>    struct xsk_nl_info {
> >>>> @@ -608,8 +607,6 @@ int xsk_socket__create(struct xsk_socket
> >>>> **xsk_ptr, const char *ifname,
> >>>>               goto out_mmap_tx;
> >>>>       }
> >>>>
> >>>> -    xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
> >>>
> >>> Since opts.flags usage is removed. Do you think it makes sense to
> >>> remove
> >>>           optlen = sizeof(opts);
> >>>           err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts,
> >>> &optlen);
> >>>           if (err) {
> >>>                   err = -errno;
> >>>                   goto out_mmap_tx;
> >>>           }
> >>> as well since nobody then uses opts?
> >>
> >> IIRC, this was added specifically in
> >> 2761ed4b6e192820760d5ba913834b2ba05fd08c
> >> so that userland code could know whether the socket was operating in
> >> zero-copy
> >> mode or not.
> >
> > Thanks for reminding me Jonathan.
> >
> > Roping in Maxim here since he wrote the patch. Was this something you
> > planned on using but the functionality that needed it was removed? The
> > patch set did go through a number of changes in the libbpf area, if I
> > remember correctly.
> >
> > There are two options: either we remove it, or we add an interface in
> > xsk.h so that people can use it. I vote for the latter since I think
> > it could be useful. The sample app could use it at least :-).
>
> +1, let's expose it and make xdpsock read and print it. I added this
> flag to libbpf when I added the ability to query it from the kernel, but
> I didn't pay attention that struct xsk_socket was private to libbpf, and
> xsk->zc couldn't be accessed externally.

Good. I will then add it.

Please discard this patch. I will add this interface in a new patch.

/Magnus

> > /Magnus
> >
> >> --
> >> Jonathan
>
