Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600A732E47
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfFCLL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:11:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40474 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfFCLL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 07:11:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so8766196qtn.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 04:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c/siBasV5xKDQ0Pt7FXs8i5Kuj/WBz+vq2c5nV1pNQw=;
        b=DszPtQiaao3Qn0KZgdDLHuaEbrmYkq76HBnBZ0ujtfN96ztAeFsrwXX+tazDgtq4P0
         +LLHTRmXF/i7eJo2QgAlt+MqdxVOfY5tiXg+iw0h6zqFwjdgUGmsqKuAw1EOZBwjVHI0
         gTnoFKrQVHbxl8MOEEiRgpup3c039yOiJTh4xr+IHwETf1B/F/ziWL/kEq6jMfVwEPBl
         kA+4BgEGyarlV99ffywl054NaKvACjGrl2RdkQt/SeLgLzWxfPeSc5cWLmr4gfNl+Qzu
         fq/8BCgFVJto2YDlQBn56eiGrbNBw5SHj63//Pl/JfEogX0KUUhbdz80ByRcPB3MFric
         KRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c/siBasV5xKDQ0Pt7FXs8i5Kuj/WBz+vq2c5nV1pNQw=;
        b=Hz8OmwKwH5brWhrHASLUCOTSUoZd6Y1crn0/5rpt64IAB7kIejIb0udCJ1GsxMSZOa
         10BVN4UQUp7y/zYzjfSp3TvBYs+OlCKuRZtyQazt6Vtum1/D/GtbdP1fTeGh7Chq/11T
         0MaBe2rRi6B7jdZJFEvYcUijzZl7PqQuI9JrBYCOoUeXbOGuUu8ny+sYz9nyIAkNFAHJ
         iv9VnNgD8QBQlqwnc3LmyPzr+9BGIGyCn1BSqx69U/Ci3h3L74RD7UUEpfWhzV85hM49
         b3TW96O31VNZTOsHVs5/3GwQkmdpWNdAciV9CkdI6PIJCq8SrNn0UWm/O7JJS6kf4s/S
         11KQ==
X-Gm-Message-State: APjAAAWLb/uBJXGQTLFUzFh86ZHFOC0VkJ3Ev0zQPVQ83apBYJyCnS0f
        lMm/3uUpM/nQv0/pLB/3/1S5eqHMxpDKxbMTMZ8=
X-Google-Smtp-Source: APXvYqyFNZdFT8IccLckrSLXJpxw0rsfcxVyvm/PCf9u9b3fV34tZXunW62jS2cGyQylfEjzPSSJk05NZ5xSEM59hrA=
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr5008328qtj.46.1559560285821;
 Mon, 03 Jun 2019 04:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
 <20190531185705.2629959-3-jonathan.lemon@gmail.com> <02CA9EF5-1380-4FE0-9479-C619C1792C2E@fb.com>
 <A2F3C0B9-FFA2-4EB3-8A20-A0D5D89A8C63@gmail.com>
In-Reply-To: <A2F3C0B9-FFA2-4EB3-8A20-A0D5D89A8C63@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Jun 2019 13:11:14 +0200
Message-ID: <CAJ+HfNjfpjUOEHdu3pJg5h8bqwtQqNRob6zcYWX+pY7r0uL9fg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better support
 external bpf programs.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Jun 2019 at 06:19, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
>
>
> On 1 Jun 2019, at 16:05, Song Liu wrote:
>
> >> On May 31, 2019, at 11:57 AM, Jonathan Lemon
> >> <jonathan.lemon@gmail.com> wrote:
> >>
> >> Use the recent change to XSKMAP bpf_map_lookup_elem() to test if
> >> there is a xsk present in the map instead of duplicating the work
> >> with qidconf.
> >>
> >> Fix things so callers using XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD
> >> bypass any internal bpf maps, so xsk_socket__{create|delete} works
> >> properly.
> >>
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >> ---
> >> tools/lib/bpf/xsk.c | 79
> >> +++++++++------------------------------------
> >> 1 file changed, 16 insertions(+), 63 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> index 38667b62f1fe..7ce7494b5b50 100644
> >> --- a/tools/lib/bpf/xsk.c
> >> +++ b/tools/lib/bpf/xsk.c
> >> @@ -60,10 +60,8 @@ struct xsk_socket {
> >>      struct xsk_umem *umem;
> >>      struct xsk_socket_config config;
> >>      int fd;
> >> -    int xsks_map;
> >>      int ifindex;
> >>      int prog_fd;
> >> -    int qidconf_map_fd;
> >>      int xsks_map_fd;
> >>      __u32 queue_id;
> >>      char ifname[IFNAMSIZ];
> >> @@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket
> >> *xsk)
> >>      /* This is the C-program:
> >>       * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> >>       * {
> >> -     *     int *qidconf, index =3D ctx->rx_queue_index;
> >> +     *     int index =3D ctx->rx_queue_index;
> >>       *
> >>       *     // A set entry here means that the correspnding queue_id
> >>       *     // has an active AF_XDP socket bound to it.
> >> -     *     qidconf =3D bpf_map_lookup_elem(&qidconf_map, &index);
> >> -     *     if (!qidconf)
> >> -     *         return XDP_ABORTED;
> >> -     *
> >> -     *     if (*qidconf)
> >> +     *     if (bpf_map_lookup_elem(&xsks_map, &index))
> >>       *         return bpf_redirect_map(&xsks_map, index, 0);
> >>       *
> >>       *     return XDP_PASS;
> >> @@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket
> >> *xsk)
> >>              BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
> >>              BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> >>              BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
> >> -            BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
> >> +            BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
> >>              BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> >>              BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> >> -            BPF_MOV32_IMM(BPF_REG_0, 0),
> >> -            /* if r1 =3D=3D 0 goto +8 */
> >> -            BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
> >>              BPF_MOV32_IMM(BPF_REG_0, 2),
> >> -            /* r1 =3D *(u32 *)(r1 + 0) */
> >> -            BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> >>              /* if r1 =3D=3D 0 goto +5 */
> >>              BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
> >>              /* r2 =3D *(u32 *)(r10 - 4) */
> >> @@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct
> >> xsk_socket *xsk)
> >>      if (max_queues < 0)
> >>              return max_queues;
> >>
> >> -    fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
> >> +    fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
> >>                               sizeof(int), sizeof(int), max_queues, 0)=
;
> >>      if (fd < 0)
> >>              return fd;
> >> -    xsk->qidconf_map_fd =3D fd;
> >>
> >> -    fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
> >> -                             sizeof(int), sizeof(int), max_queues, 0)=
;
> >> -    if (fd < 0) {
> >> -            close(xsk->qidconf_map_fd);
> >> -            return fd;
> >> -    }
> >>      xsk->xsks_map_fd =3D fd;
> >>
> >>      return 0;
> >> @@ -385,10 +367,8 @@ static int xsk_create_bpf_maps(struct xsk_socket
> >> *xsk)
> >>
> >> static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
> >> {
> >> -    close(xsk->qidconf_map_fd);
> >> +    bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> >>      close(xsk->xsks_map_fd);
> >> -    xsk->qidconf_map_fd =3D -1;
> >> -    xsk->xsks_map_fd =3D -1;
> >> }
> >>
> >> static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
> >> @@ -417,10 +397,9 @@ static int xsk_lookup_bpf_maps(struct xsk_socket
> >> *xsk)
> >>      if (err)
> >>              goto out_map_ids;
> >>
> >> -    for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> >> -            if (xsk->qidconf_map_fd !=3D -1 && xsk->xsks_map_fd !=3D =
-1)
> >> -                    break;
> >> +    xsk->xsks_map_fd =3D -1;
> >>
> >> +    for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> >>              fd =3D bpf_map_get_fd_by_id(map_ids[i]);
> >>              if (fd < 0)
> >>                      continue;
> >> @@ -431,11 +410,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket
> >> *xsk)
> >>                      continue;
> >>              }
> >>
> >> -            if (!strcmp(map_info.name, "qidconf_map")) {
> >> -                    xsk->qidconf_map_fd =3D fd;
> >> -                    continue;
> >> -            }
> >> -
> >>              if (!strcmp(map_info.name, "xsks_map")) {
> >>                      xsk->xsks_map_fd =3D fd;
> >>                      continue;
> >> @@ -445,40 +419,18 @@ static int xsk_lookup_bpf_maps(struct
> >> xsk_socket *xsk)
> >>      }
> >>
> >>      err =3D 0;
> >> -    if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
> >> +    if (xsk->xsks_map_fd =3D=3D -1)
> >>              err =3D -ENOENT;
> >> -            xsk_delete_bpf_maps(xsk);
> >> -    }
> >>
> >> out_map_ids:
> >>      free(map_ids);
> >>      return err;
> >> }
> >>
> >> -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> >> -{
> >> -    int qid =3D false;
> >> -
> >> -    bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0)=
;
> >> -    bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> >> -}
> >> -
> >> static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> >> {
> >> -    int qid =3D true, fd =3D xsk->fd, err;
> >> -
> >> -    err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id,
> >> &qid, 0);
> >> -    if (err)
> >> -            goto out;
> >> -
> >> -    err =3D bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd=
,
> >> 0);
> >> -    if (err)
> >> -            goto out;
> >> -
> >> -    return 0;
> >> -out:
> >> -    xsk_clear_bpf_maps(xsk);
> >> -    return err;
> >> +    return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
> >> +                               &xsk->fd, 0);
> >> }
> >>
> >> static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> >> @@ -514,6 +466,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket
> >> *xsk)
> >>
> >> out_load:
> >>      close(xsk->prog_fd);
> >> +    xsk->prog_fd =3D -1;
> >
> > I found xsk->prog_fd confusing. Why do we need to set it here?
>
> I suppose this one isn't strictly required - I set it as a guard out of
> habit.
> xsk is (currently) immediately freed by the caller, so it can be
> removed.
>
>
> The main logic is:
>
>          xsk->prog_fd =3D -1;
>          if (!(xsk->config.libbpf_flags &
> XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
>                  err =3D xsk_setup_xdp_prog(xsk);
>
> The user may pass INHIBIT_PROG_LOAD, which bypasses setting up the xdp
> program
> (and any maps associated with the program), allowing installation of a
> custom
> program.  The cleanup behavior is then gated on prog_fd being -1,
>
> >
> > I think we don't need to call xsk_delete_bpf_maps() in out_load path?
>
> Hmm, there's two out_load paths, but only one needs the delete maps
> call.  Let
> me redo the error handling so it's a bit more explicit.
>

You're going for a V4?

I took this series for a spin:
Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Very nice cleanup, Jonathan!


Bj=C3=B6rn


>
> >
> >> out_maps:
> >>      xsk_delete_bpf_maps(xsk);
> >>      return err;
> >> @@ -643,9 +596,7 @@ int xsk_socket__create(struct xsk_socket
> >> **xsk_ptr, const char *ifname,
> >>              goto out_mmap_tx;
> >>      }
> >>
> >> -    xsk->qidconf_map_fd =3D -1;
> >> -    xsk->xsks_map_fd =3D -1;
> >> -
> >> +    xsk->prog_fd =3D -1;
> >>      if (!(xsk->config.libbpf_flags &
> >> XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> >>              err =3D xsk_setup_xdp_prog(xsk);
> >>              if (err)
> >> @@ -708,8 +659,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >>      if (!xsk)
> >>              return;
> >>
> >> -    xsk_clear_bpf_maps(xsk);
> >> -    xsk_delete_bpf_maps(xsk);
> >> +    if (xsk->prog_fd !=3D -1) {
> >> +            xsk_delete_bpf_maps(xsk);
> >> +            close(xsk->prog_fd);
> >
> > Here, we use prog_fd !=3D -1 to gate xsk_delete_bpf_maps(), which is
> > confusing. I looked at the code for quite sometime, but still cannot
> > confirm it is correct.
>
> See above reasoning - with INHIBIT_PROG_LOAD, there is no
> library-provided
> program or maps, so cleanup actions are skipped.
> --
> Jonathan
