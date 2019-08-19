Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3D191D34
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 08:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSGf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 02:35:26 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35577 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfHSGfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 02:35:25 -0400
Received: by mail-ot1-f65.google.com with SMTP id g17so685820otl.2;
        Sun, 18 Aug 2019 23:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hehynR5oMc0ygrLfxgtV2LBMgj/0/3USx04Fi55/N18=;
        b=BqWb4oAF5EmHxqNMEkZ+gZT+JcDLLnz0XU9HRjN0B2I4FS/61qK4wt2ZtvUGFoei8g
         ZWJCaUh0TMbTF/cN6PII/9t1ebsCS77u8Og/uMeYojffXAQEsounkP6nhUaIiRxLsmTh
         WwSlnzyCl+uwRv/BwB106rGTgq8o/K3mK6mb1AWy0vSMGXwgGCId760ZnGSzJdnNdGnO
         QTBREfJ8UxrZoMdr1gnuodlCoatRC0qzAXP+VdfE20TZ4eYhNGt34Bm582mR52Uui35C
         48W0uXhaUZF9Z4W4js/7DY6dYv6j7DuhZtGElAXTEBIUY52EbrhhKowuksR/iROLQnEL
         +sYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hehynR5oMc0ygrLfxgtV2LBMgj/0/3USx04Fi55/N18=;
        b=nFwFaHewk1Z5kohYViGfUirAE8iy7Y9Hq8yKWyjdxL1aYvB9nygR8gUPR1baKGDwWG
         vIQsC20OIGqOZDhAu1dpU5N6N8WeIB0sQqTTHWKizrY4NAjEUZDjZMq8FlgWuvSQpC2P
         CyXbOzcXH92GcZRe1RbxJJ9FnvoKHtsRsdUqmxFZsyu5f7PPwdEN+1rmQmjh5lc7rw9d
         kZYTuTTEaiW7AXx/Ql6dVOZFZjPK/UTMOlbGnyOwSaLfNVx0FPaNdT2uGfttakb9zbii
         XGq0Pd+yCWbD/SZQHmCXdh+89YrtNX68Ou6sGcMhARjEwNfP3/ra3r/zPuedfowC0kAV
         QjVg==
X-Gm-Message-State: APjAAAUxxVoEwqwB0v1SB1519kMiWj4PwbeA6kpW0RxpIgIE0MpNnDJT
        uuLOE3xqTi6syVDnskHHEhwlGQFIEwtfrHTl46Q=
X-Google-Smtp-Source: APXvYqzWetXyg+zssDPoektkY2F3mYhPVSAYE/uwaNM/FFoHYpl9cGOm5nWniMRcJ8f0c8s+tjYglzEdpvdjJ0iGUVE=
X-Received: by 2002:a9d:5e19:: with SMTP id d25mr17527065oti.192.1566196524573;
 Sun, 18 Aug 2019 23:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
 <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com> <2B143E7F-EE34-4298-B628-E2F669F89896@gmail.com>
In-Reply-To: <2B143E7F-EE34-4298-B628-E2F669F89896@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 19 Aug 2019 08:35:13 +0200
Message-ID: <CAJ8uoz1hY0P+xypkJYYi775SeSXnrrPSM5v0yTf3G+d2a3OhJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: remove zc variable as it is not used
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Yonghong Song <yhs@fb.com>,
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

On Sat, Aug 17, 2019 at 12:02 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
>
>
> On 16 Aug 2019, at 8:37, Yonghong Song wrote:
>
> > On 8/16/19 3:26 AM, Magnus Karlsson wrote:
> >> The zc is not used in the xsk part of libbpf, so let us remove it.
> >> Not
> >> good to have dead code lying around.
> >>
> >> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >> Reported-by: Yonghong Song <yhs@fb.com> > ---
> >>   tools/lib/bpf/xsk.c | 3 ---
> >>   1 file changed, 3 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> index 680e630..9687da9 100644
> >> --- a/tools/lib/bpf/xsk.c
> >> +++ b/tools/lib/bpf/xsk.c
> >> @@ -65,7 +65,6 @@ struct xsk_socket {
> >>      int xsks_map_fd;
> >>      __u32 queue_id;
> >>      char ifname[IFNAMSIZ];
> >> -    bool zc;
> >>   };
> >>
> >>   struct xsk_nl_info {
> >> @@ -608,8 +607,6 @@ int xsk_socket__create(struct xsk_socket
> >> **xsk_ptr, const char *ifname,
> >>              goto out_mmap_tx;
> >>      }
> >>
> >> -    xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
> >
> > Since opts.flags usage is removed. Do you think it makes sense to
> > remove
> >          optlen = sizeof(opts);
> >          err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts,
> > &optlen);
> >          if (err) {
> >                  err = -errno;
> >                  goto out_mmap_tx;
> >          }
> > as well since nobody then uses opts?
>
> IIRC, this was added specifically in
> 2761ed4b6e192820760d5ba913834b2ba05fd08c
> so that userland code could know whether the socket was operating in
> zero-copy
> mode or not.

Thanks for reminding me Jonathan.

Roping in Maxim here since he wrote the patch. Was this something you
planned on using but the functionality that needed it was removed? The
patch set did go through a number of changes in the libbpf area, if I
remember correctly.

There are two options: either we remove it, or we add an interface in
xsk.h so that people can use it. I vote for the latter since I think
it could be useful. The sample app could use it at least :-).

/Magnus

> --
> Jonathan
