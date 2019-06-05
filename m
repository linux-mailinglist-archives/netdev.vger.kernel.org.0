Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9805D3593D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFEJD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:03:58 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40024 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEJD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 05:03:58 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so2600160qtn.7;
        Wed, 05 Jun 2019 02:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8CSfDI3ilg7cS9jedAIbPBMKBAeGpTM8vhgFEc0r9qc=;
        b=ZD7iX2R9+JaUc18Hket6tYk/XWh2la6v0NCJfdMPg3dEWEaNMXI+snnxZmFfboJzfy
         7oMED9afeum0LT5cORNdr8/fJjlWw9oXO4fOzcQKNljlEbaHCp9kfuXaYuxQi2pLjhQu
         3BQC6D5Iq9hcy84/6+F86g7cxxGlPveHU79Ft0VzOpIFvOy8JFrlbx9GcL7bSBfghFZ+
         o0hZ1Ba8BppYvkaYJ0gd5QxanblzNtwNlRYhPW0XLHErjDHo5qdtkUgm+QsbIN9Pb6VC
         GQzivuC0QoGXw1N95KY9fQjQzE9mzfoOvkjpNFppU6PAhflij201Xf2blfNdl+FDxBEY
         nssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8CSfDI3ilg7cS9jedAIbPBMKBAeGpTM8vhgFEc0r9qc=;
        b=UqlrmVgSLihv66vmOkE4AjCEqUDtVdZlqTskaeaoKp5VVgAlY0F1iGig4kUwbEylXy
         KB1qaJ1Dm0yocmc4/5ajLgDg/kGdVJimG5qmpnY8oaXKu2GhwAV69+cgpA4gDupzvTuC
         ghFbf8bltQ4yODb+XDzCOFP07y7OAOi9n1y00mYqweMe1dMB+LpMyG3/xgSD9RlHcctu
         zG5SZXqzvr4bFrc9/GpEiNgnRNOoVx3lxX8Wa5IoZkSGOJL4A3r1lEE6P3k+w3RDpYAP
         pYLFFqsu18cpDXo4n/VcwlXosZKdgiiMGWk1Qu8R0boVuaYQarxQwFbOGvC+vPzeG5AI
         6WQA==
X-Gm-Message-State: APjAAAVL2dFs5/G/9j0HvH9oOvR7xrdB7bMt42wyBj9LIXdQgk9xhpKw
        TedtxVjEd5LbBKYTKPHNiIpCNrN6wbbD8qcjUNc=
X-Google-Smtp-Source: APXvYqyE7wEOcDGlclehYg1z18cYSvNh1uQ5UTDk4qXeNXAwb96b2BUyoTXa2yog8A1SB5KdShoreX58fls0ADltjys=
X-Received: by 2002:ac8:25b1:: with SMTP id e46mr13738972qte.36.1559725436835;
 Wed, 05 Jun 2019 02:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-4-maciej.fijalkowski@intel.com> <cf7cf390-39b4-7430-107e-97f068f9c3d9@intel.com>
 <20190604170657.000060ac@gmail.com>
In-Reply-To: <20190604170657.000060ac@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 5 Jun 2019 11:03:44 +0200
Message-ID: <CAJ+HfNiOh+2_tLmjhbbGC2H3gMhfr57uhCYho5OcfVwty0TWvg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] libbpf: move xdp program removal to libbpf
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 17:07, Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Tue, 4 Jun 2019 10:07:25 +0200
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:
>
> >
> > On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > > Since xsk support in libbpf loads the xdp program interface, make it
> > > also responsible for its removal. Store the prog id in xsk_socket_con=
fig
> > > so when removing the program we are still able to compare the current
> > > program id with the id from the attachment time and make a decision
> > > onward.
> > >
> > > While at it, remove the socket/umem in xdpsock's error path.
> > >
> >
> > We're loading a new, or reusing an existing XDP program at socket
> > creation, but tearing it down at *socket delete* is explicitly left to
> > the application.
>
> Are you describing here the old behavior?
>
> >
> > For a per-queue XDP program (tied to the socket), this kind cleanup wou=
ld
> > make sense.
> >
> > The intention with the libbpf AF_XDP support was to leave the XDP
> > handling to whatever XDP orchestration process availble. It's not part
> > of libbpf. For convenience, *loading/lookup of the XDP program* was
> > added even though this was an asymmetry.
>
> Hmmm ok and I tried to make it symmetric :p
>

Thought a bit more about this, and I think you're right here. It
should be symmetric! Please continue this work! (But keep in mind that
it might go away if/once per-queue programs appear. :-P)

> >
> > For the sample application, this makes sense, but for larger/real
> > applications?
> >
>
> Tough questions on those real apps!
>

:-D

>
> > OTOH I like the idea of a scoped cleanup "when all sockets are gone",
> > the XDP program + maps are removed.
>
> That's happening with patch 4 included from this set (in case it gets fix=
ed :))
>

Ok!

Bj=C3=B6rn

> >
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >   samples/bpf/xdpsock_user.c | 33 ++++++++++-----------------------
> > >   tools/lib/bpf/xsk.c        | 32 ++++++++++++++++++++++++++++++++
> > >   tools/lib/bpf/xsk.h        |  1 +
> > >   3 files changed, 43 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > > index e9dceb09b6d1..123862b16dd4 100644
> > > --- a/samples/bpf/xdpsock_user.c
> > > +++ b/samples/bpf/xdpsock_user.c
> > > @@ -68,7 +68,6 @@ static int opt_queue;
> > >   static int opt_poll;
> > >   static int opt_interval =3D 1;
> > >   static u32 opt_xdp_bind_flags;
> > > -static __u32 prog_id;
> > >
> > >   struct xsk_umem_info {
> > >     struct xsk_ring_prod fq;
> > > @@ -170,22 +169,6 @@ static void *poller(void *arg)
> > >     return NULL;
> > >   }
> > >
> > > -static void remove_xdp_program(void)
> > > -{
> > > -   __u32 curr_prog_id =3D 0;
> > > -
> > > -   if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags=
)) {
> > > -           printf("bpf_get_link_xdp_id failed\n");
> > > -           exit(EXIT_FAILURE);
> > > -   }
> > > -   if (prog_id =3D=3D curr_prog_id)
> > > -           bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
> > > -   else if (!curr_prog_id)
> > > -           printf("couldn't find a prog id on a given interface\n");
> > > -   else
> > > -           printf("program on interface changed, not removing\n");
> > > -}
> > > -
> > >   static void int_exit(int sig)
> > >   {
> > >     struct xsk_umem *umem =3D xsks[0]->umem->umem;
> > > @@ -195,7 +178,6 @@ static void int_exit(int sig)
> > >     dump_stats();
> > >     xsk_socket__delete(xsks[0]->xsk);
> > >     (void)xsk_umem__delete(umem);
> > > -   remove_xdp_program();
> > >
> > >     exit(EXIT_SUCCESS);
> > >   }
> > > @@ -206,7 +188,16 @@ static void __exit_with_error(int error, const c=
har *file, const char *func,
> > >     fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
> > >             line, error, strerror(error));
> > >     dump_stats();
> > > -   remove_xdp_program();
> > > +
> > > +   if (xsks[0]->xsk)
> > > +           xsk_socket__delete(xsks[0]->xsk);
> > > +
> > > +   if (xsks[0]->umem) {
> > > +           struct xsk_umem *umem =3D xsks[0]->umem->umem;
> > > +
> > > +           (void)xsk_umem__delete(umem);
> > > +   }
> > > +
> > >     exit(EXIT_FAILURE);
> > >   }
> > >
> > > @@ -312,10 +303,6 @@ static struct xsk_socket_info *xsk_configure_soc=
ket(struct xsk_umem_info *umem)
> > >     if (ret)
> > >             exit_with_error(-ret);
> > >
> > > -   ret =3D bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags)=
;
> > > -   if (ret)
> > > -           exit_with_error(-ret);
> > > -
> > >     return xsk;
> > >   }
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index 514ab3fb06f4..e28bedb0b078 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -259,6 +259,8 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, =
void *umem_area, __u64 size,
> > >   static int xsk_load_xdp_prog(struct xsk_socket *xsk)
> > >   {
> > >     static const int log_buf_size =3D 16 * 1024;
> > > +   struct bpf_prog_info info =3D {};
> > > +   __u32 info_len =3D sizeof(info);
> > >     char log_buf[log_buf_size];
> > >     int err, prog_fd;
> > >
> > > @@ -321,6 +323,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *=
xsk)
> > >             return err;
> > >     }
> > >
> > > +   err =3D bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> > > +   if (err) {
> > > +           pr_warning("can't get prog info - %s\n", strerror(errno))=
;
> > > +           close(prog_fd);
> > > +           return err;
> > > +   }
> > > +   xsk->config.prog_id =3D info.id;
> > > +
> > >     xsk->prog_fd =3D prog_fd;
> > >     return 0;
> > >   }
> > > @@ -483,6 +493,25 @@ static int xsk_set_bpf_maps(struct xsk_socket *x=
sk)
> > >     return err;
> > >   }
> > >
> > > +static void xsk_remove_xdp_prog(struct xsk_socket *xsk)
> > > +{
> > > +   __u32 prog_id =3D xsk->config.prog_id;
> > > +   __u32 curr_prog_id =3D 0;
> > > +   int err;
> > > +
> > > +   err =3D bpf_get_link_xdp_id(xsk->ifindex, &curr_prog_id,
> > > +                             xsk->config.xdp_flags);
> > > +   if (err)
> > > +           return;
> > > +
> > > +   if (prog_id =3D=3D curr_prog_id)
> > > +           bpf_set_link_xdp_fd(xsk->ifindex, -1, xsk->config.xdp_fla=
gs);
> > > +   else if (!curr_prog_id)
> > > +           pr_warning("couldn't find a prog id on a given interface\=
n");
> > > +   else
> > > +           pr_warning("program on interface changed, not removing\n"=
);
> > > +}
> > > +
> > >   static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> > >   {
> > >     __u32 prog_id =3D 0;
> > > @@ -506,6 +535,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *=
xsk)
> > >             err =3D xsk_lookup_bpf_maps(xsk);
> > >             if (err)
> > >                     goto out_load;
> > > +           xsk->config.prog_id =3D prog_id;
> > >     }
> > >
> > >     err =3D xsk_set_bpf_maps(xsk);
> > > @@ -744,6 +774,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >
> > >     }
> > >
> > > +   xsk_remove_xdp_prog(xsk);
> > > +
> > >     xsk->umem->refcount--;
> > >     /* Do not close an fd that also has an associated umem connected
> > >      * to it.
> > > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > > index 82ea71a0f3ec..e1b23e9432c9 100644
> > > --- a/tools/lib/bpf/xsk.h
> > > +++ b/tools/lib/bpf/xsk.h
> > > @@ -186,6 +186,7 @@ struct xsk_socket_config {
> > >     __u32 tx_size;
> > >     __u32 libbpf_flags;
> > >     __u32 xdp_flags;
> > > +   __u32 prog_id;
> > >     __u16 bind_flags;
> > >   };
> > >
> > >
>
