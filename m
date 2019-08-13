Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71DD8ACC9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHMCmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:42:23 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44347 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfHMCmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:42:22 -0400
Received: by mail-yw1-f66.google.com with SMTP id l79so39341685ywe.11
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPUWVHthnvZ2Aa3gXm+SlWUUkEqb2RS+oSN06nGB0PM=;
        b=HqmJhntPxRImmUeccfUVRAjrIveNApPi+v1dGe0ANQ3OZj/IqaCFadusUaL6n4iiHc
         6Hri03pP+IrBJQHyUR6Xpj7HQNXzcXj5muRugLBsCFsVbaYlmr+WpiLziPZYBWXefGjx
         aoxpVCIdVxLWyxPQci43piYKvYlYMnK1Vdad6PyTpU+pqbr3ZXBxhWRa1Ld2vywzI/1F
         spqTphqCb/hoBHuFNTCxfY72wjuqn12wQti9KBZ0975LW+ZtJvgYjkYYDhufpxlYHsFo
         qBqdy+a6NtVI3Ch+iKIYbta9R6AKAKJBKCuk/YYpqktowPG2bErOXqI5zjeWX4UyZFfg
         YN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPUWVHthnvZ2Aa3gXm+SlWUUkEqb2RS+oSN06nGB0PM=;
        b=Zk1qAOFvWSrebEGBC2ss7OsUHWOKH6yCjQ8iAEVHT9j5oO/lgc7m8nWtYxuT/BGHM6
         x1v9mT/4ptWdMIlqUzdxNSai+PBeNckNLuL4aEiGjZXUHH/SAGLWNWn50SLq42d1CF7z
         DKG8qVl0Vt8Lm2sRdpQIQHHt7pSOxl0/Cby1VD99eKVj9GRaDkuwiwOaui80V5lHryQE
         RK3/Qhs6TMh3VnAQumTnz8cHct59M50w5AI2/4s9lM8dS2NbB926beGa2nv2YBNxSoco
         aNJ1YGWniOpSCC8hHATWqWekT/yRm4aUS9K8rBVjM7UDBzW7u2o+TEe7yMZhJ5EuyHmV
         gX+A==
X-Gm-Message-State: APjAAAWqMkaPjZ2bzHSwPZr3+kvzjQB3DPjd5mz4+YgaCAlfmWL6MTJ+
        IJRz8j+lRMFzdLWDNvS9NNycBEy+gSUp83UblHZ5KLxkNg==
X-Google-Smtp-Source: APXvYqxtk4CHuFVJ7LaNdyntWASH0VdNSr03HLxcofdnCth1/7iiZeX561j6NApgsBiVJBQuz88p0b5qiiR9IEbB7YU=
X-Received: by 2002:a81:de4e:: with SMTP id o14mr6788182ywl.369.1565664141479;
 Mon, 12 Aug 2019 19:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190809133248.19788-1-danieltimlee@gmail.com>
 <20190809133248.19788-2-danieltimlee@gmail.com> <CAH3MdRVJ5Z8FVF8XW8Ha-MwRAnO2mbmMDFb_s3cPswqq7MfsMQ@mail.gmail.com>
In-Reply-To: <CAH3MdRVJ5Z8FVF8XW8Ha-MwRAnO2mbmMDFb_s3cPswqq7MfsMQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 13 Aug 2019 11:42:10 +0900
Message-ID: <CAEKGpzisX_AP=WULuLjvN1buHmjsut9nLghhfONFnnaDQeE5Fw@mail.gmail.com>
Subject: Re: [v4,1/4] tools: bpftool: add net attach command to attach XDP on interface
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 9:27 AM Y Song <ys114321@gmail.com> wrote:
>
> On Fri, Aug 9, 2019 at 6:35 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > By this commit, using `bpftool net attach`, user can attach XDP prog on
> > interface. New type of enum 'net_attach_type' has been made, as stated at
> > cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> >
> > With 'overwrite' option at argument, attached XDP program could be replaced.
> > Added new helper 'net_parse_dev' to parse the network device at argument.
> >
> > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  tools/bpf/bpftool/net.c | 136 +++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 129 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 67e99c56bc88..74cc346c36cd 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -55,6 +55,35 @@ struct bpf_attach_info {
> >         __u32 flow_dissector_id;
> >  };
> >
> > +enum net_attach_type {
> > +       NET_ATTACH_TYPE_XDP,
> > +       NET_ATTACH_TYPE_XDP_GENERIC,
> > +       NET_ATTACH_TYPE_XDP_DRIVER,
> > +       NET_ATTACH_TYPE_XDP_OFFLOAD,
> > +};
> > +
> > +static const char * const attach_type_strings[] = {
> > +       [NET_ATTACH_TYPE_XDP]           = "xdp",
> > +       [NET_ATTACH_TYPE_XDP_GENERIC]   = "xdpgeneric",
> > +       [NET_ATTACH_TYPE_XDP_DRIVER]    = "xdpdrv",
> > +       [NET_ATTACH_TYPE_XDP_OFFLOAD]   = "xdpoffload",
> > +};
> > +
> > +const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
> > +
> > +static enum net_attach_type parse_attach_type(const char *str)
> > +{
> > +       enum net_attach_type type;
> > +
> > +       for (type = 0; type < net_attach_type_size; type++) {
> > +               if (attach_type_strings[type] &&
> > +                   is_prefix(str, attach_type_strings[type]))
> > +                       return type;
> > +       }
> > +
> > +       return net_attach_type_size;
> > +}
> > +
> >  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
> >  {
> >         struct bpf_netdev_t *netinfo = cookie;
> > @@ -223,6 +252,97 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
> >         return 0;
> >  }
> >
> > +static int net_parse_dev(int *argc, char ***argv)
> > +{
> > +       int ifindex;
> > +
> > +       if (is_prefix(**argv, "dev")) {
> > +               NEXT_ARGP();
> > +
> > +               ifindex = if_nametoindex(**argv);
> > +               if (!ifindex)
> > +                       p_err("invalid devname %s", **argv);
> > +
> > +               NEXT_ARGP();
> > +       } else {
> > +               p_err("expected 'dev', got: '%s'?", **argv);
> > +               return -1;
> > +       }
> > +
> > +       return ifindex;
> > +}
> > +
> > +static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
> > +                               int ifindex, bool overwrite)
> > +{
> > +       __u32 flags = 0;
> > +
> > +       if (!overwrite)
> > +               flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > +       if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> > +               flags |= XDP_FLAGS_SKB_MODE;
> > +       if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> > +               flags |= XDP_FLAGS_DRV_MODE;
> > +       if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> > +               flags |= XDP_FLAGS_HW_MODE;
> > +
> > +       return bpf_set_link_xdp_fd(ifindex, progfd, flags);
> > +}
> > +
> > +static int do_attach(int argc, char **argv)
> > +{
> > +       enum net_attach_type attach_type;
> > +       int progfd, ifindex, err = 0;
> > +       bool overwrite = false;
> > +
> > +       /* parse attach args */
> > +       if (!REQ_ARGS(5))
> > +               return -EINVAL;
> > +
> > +       attach_type = parse_attach_type(*argv);
> > +       if (attach_type == net_attach_type_size) {
> > +               p_err("invalid net attach/detach type: %s", *argv);
> > +               return -EINVAL;
> > +       }
> > +       NEXT_ARG();
> > +
> > +       progfd = prog_parse_fd(&argc, &argv);
> > +       if (progfd < 0)
> > +               return -EINVAL;
> > +
> > +       ifindex = net_parse_dev(&argc, &argv);
> > +       if (ifindex < 1) {
> > +               close(progfd);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (argc) {
> > +               if (is_prefix(*argv, "overwrite")) {
> > +                       overwrite = true;
> > +               } else {
> > +                       p_err("expected 'overwrite', got: '%s'?", *argv);
> > +                       close(progfd);
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
> > +       /* attach xdp prog */
> > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > +               err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> > +                                          overwrite);
> > +
> > +       if (err < 0) {
> > +               p_err("interface %s attach failed: %s",
> > +                     attach_type_strings[attach_type], strerror(errno));
> > +               return err;
> > +       }
>
> I tried the below example,
>
> -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example
> dev v1
> -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
> Kernel error message: XDP program already attached
> Error: interface xdp attach failed: Success
> -bash-4.4$
>
> It printed out "Success" as errno here is 0.
> The errno is encoded in variable err. Function bpf_set_link_xdp_fd()
> uses netlink interface to do setting. The syscall may be find (errno = 0)
> but the netlink msg may contain error code, which is returned with err.
>
> So the above strerror(errno) should be strerror(-err).
> libbpf API libbpf_strerror_r() accepts positive or negative err code which
> you could use as well here.
>
> With this issue fixed. You can add:
> Acked-by: Yonghong Song <yhs@fb.com>
>

I didn't realize it would return 0 as 'errno'.
Thanks for letting me know.
I'll update to next patch.

Thank you for taking your time for the review.

> > +
> > +       if (json_output)
> > +               jsonw_null(json_wtr);
> > +
> > +       return 0;
> > +}
> > +
> [...]
