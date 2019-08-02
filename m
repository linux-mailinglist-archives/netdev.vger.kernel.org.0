Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6106C7EF9A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404475AbfHBItl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:49:41 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37457 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404471AbfHBItl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:49:41 -0400
Received: by mail-yb1-f194.google.com with SMTP id i1so19302850ybo.4
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 01:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nk1SJaan0tEHhbPDSvs6oXzzX5gtFgjAQpe/kJQVAdc=;
        b=IXp4VsiIRAtXq5ZjZWAdNy1r4CCzDHzg+VOihBJyr49sPUmCzautJA7E8LSahpLwcP
         hy9w2T8Blr8XWFMQ6HogKNBUZmFOPts7Ce6a6ZFykynDiExHEX+CWtqKZlhN0ce+7Dim
         bTLJyT2x9+2uBQyEae5kwZEQlkl11krBC2VgMBcX0D5Cc+xoh6/td0oJqj2sgH7cd+PU
         7EGsShNNpZtEwm17ySo5276hSz7Dwg3KiI7U0GtWes2Mkd384gNlwBEsLH08czfgY+N5
         uYaOP6R+1wXS93xIV3cxCXVGFO2VpmwDpK6qlRzdxBMsbKcQSVFLilP9peUjIFylpksF
         Islg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nk1SJaan0tEHhbPDSvs6oXzzX5gtFgjAQpe/kJQVAdc=;
        b=GDR9dQUXnjF3S6VdfNKpXIwWdPc54AiVPgP+9tOvYoEZ+e26mDbzfQAzmhxA2+POU0
         nd6wx+HI8X/BRNi3PDIG3nI4sYvO70ibDcOhUvaRsQocU7UJwRxwxhs1tSfBBdwWwGxX
         628FUy5TlM4KqLuEq04yfcpwZnyqVs/iSql8roblbL9KPX7/1Gzh/6Ki4jCvf7BrRaem
         lAid9qTqMOA4BvcgML5xI6DuUuCsrdvP3+J3JiTOSNCgbeZ1BtQRCh9Tx+93lTzOKoEB
         ++U/C4twETjtUWA6cZ738TlV7lNLhkIS0VCDjCO7nNEjMSywjtdXTANKHl8yWfHSrxrj
         JR7Q==
X-Gm-Message-State: APjAAAXfdyHXzB9ZLeRjIyB1sFpLSVUTNqaxwRDgcjzuWzQHj/iVWkhP
        3UKxlGLWJs2Q79Yge+q3w3WI1qLj8HYWAD7/aw==
X-Google-Smtp-Source: APXvYqxPNvAKPD32ibcH37EiDDCC8aPesvLbxNIBoM2k72+Kkwg7g4FGhRony4lWXqDrkHPdwz8waPTswBJqE/yio/s=
X-Received: by 2002:a25:4ed5:: with SMTP id c204mr39227874ybb.333.1564735780391;
 Fri, 02 Aug 2019 01:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com>
 <20190801081133.13200-2-danieltimlee@gmail.com> <CAH3MdRXkr5oD=yTr8qevFMLBuLyv1v-E7BLme8n2FA8+uPe6sg@mail.gmail.com>
In-Reply-To: <CAH3MdRXkr5oD=yTr8qevFMLBuLyv1v-E7BLme8n2FA8+uPe6sg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 2 Aug 2019 17:49:29 +0900
Message-ID: <CAEKGpzhjx-H0ob-JsLXM2utgVEcAdjuqWoW+F=h-EwdxfzHpjQ@mail.gmail.com>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP on interface
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 3:23 PM Y Song <ys114321@gmail.com> wrote:
>
> On Thu, Aug 1, 2019 at 2:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > By this commit, using `bpftool net attach`, user can attach XDP prog on
> > interface. New type of enum 'net_attach_type' has been made, as stated at
> > cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> >
> > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >   - command 'load' changed to 'attach' for the consistency
> >   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'
> >
> >  tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 106 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 67e99c56bc88..f3b57660b303 100644
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
> > +       __MAX_NET_ATTACH_TYPE
> > +};
> > +
> > +static const char * const attach_type_strings[] = {
> > +       [NET_ATTACH_TYPE_XDP] = "xdp",
> > +       [NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
> > +       [NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
> > +       [NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
> > +       [__MAX_NET_ATTACH_TYPE] = NULL,
> > +};
> > +
> > +static enum net_attach_type parse_attach_type(const char *str)
> > +{
> > +       enum net_attach_type type;
> > +
> > +       for (type = 0; type < __MAX_NET_ATTACH_TYPE; type++) {
> > +               if (attach_type_strings[type] &&
> > +                  is_prefix(str, attach_type_strings[type]))
> > +                       return type;
> > +       }
> > +
> > +       return __MAX_NET_ATTACH_TYPE;
> > +}
> > +
> >  static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
> >  {
> >         struct bpf_netdev_t *netinfo = cookie;
> > @@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
> >         return 0;
> >  }
> >
> > +static int parse_attach_args(int argc, char **argv, int *progfd,
> > +                            enum net_attach_type *attach_type, int *ifindex)
> > +{
> > +       if (!REQ_ARGS(3))
> > +               return -EINVAL;
> > +
> > +       *progfd = prog_parse_fd(&argc, &argv);
> > +       if (*progfd < 0)
> > +               return *progfd;
> > +
> > +       *attach_type = parse_attach_type(*argv);
> > +       if (*attach_type == __MAX_NET_ATTACH_TYPE) {
> > +               p_err("invalid net attach/detach type");
> > +               return -EINVAL;
> > +       }
> > +
> > +       NEXT_ARG();
> > +       if (!REQ_ARGS(1))
> > +               return -EINVAL;
> > +
> > +       *ifindex = if_nametoindex(*argv);
> > +       if (!*ifindex) {
> > +               p_err("Invalid ifname");
>
> Do you want to use the full function name "invalid if_nametoindex" here?
>

No. I was trying to fix the message as "Invalid devname", since the
word "devanme"
is mentioned in 'bpftool net help'.

> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> > +                               int *ifindex)
>
> You can just use plain int as the argument type here.
>

I will change the parameter as pass by value.

> > +{
> > +       __u32 flags;
> > +       int err;
> > +
> > +       flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > +       if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> > +               flags |= XDP_FLAGS_SKB_MODE;
> > +       if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> > +               flags |= XDP_FLAGS_DRV_MODE;
> > +       if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> > +               flags |= XDP_FLAGS_HW_MODE;
> > +
> > +       err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> > +
> > +       return err;
>
> Just do "return bpf_set_link_xdp_fd(...)" and you do not need variable err.
>

Oh. I've misunderstood why variable err won't be needed.
I'll remove the variable err and update to it.

> > +}
> > +
> > +static int do_attach(int argc, char **argv)
> > +{
> > +       enum net_attach_type attach_type;
> > +       int err, progfd, ifindex;
> > +
> > +       err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> > +       if (err)
> > +               return err;
> > +
> > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > +               err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
> > +
> > +       if (err < 0) {
> > +               p_err("link set %s failed", attach_type_strings[attach_type]);
> > +               return -1;
> > +       }
>
> The above "if (err < 0)" can be true only under the above "if (is_prefix(..))"
> conditions. But compiler may optimize this. So I think current form is okay.
> But could you change the return value to "return err" instead of "return -1"?
>

Okay. I'll update the return value to "return err".

> > +
> > +       if (json_output)
> > +               jsonw_null(json_wtr);
> > +
> > +       return 0;
> > +}
> > +
> >  static int do_show(int argc, char **argv)
> >  {
> >         struct bpf_attach_info attach_info = {};
> > @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
> >
> >         fprintf(stderr,
> >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> > +               "       %s %s attach PROG LOAD_TYPE <devname>\n"
> >                 "       %s %s help\n"
> > +               "\n"
> > +               "       " HELP_SPEC_PROGRAM "\n"
> > +               "       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
> >                 "Note: Only xdp and tc attachments are supported now.\n"
> >                 "      For progs attached to cgroups, use \"bpftool cgroup\"\n"
> >                 "      to dump program attachments. For program types\n"
> >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> >                 "      consult iproute2.\n",
> > -               bin_name, argv[-2], bin_name, argv[-2]);
> > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> >
> >         return 0;
> >  }
> > @@ -319,6 +423,7 @@ static int do_help(int argc, char **argv)
> >  static const struct cmd cmds[] = {
> >         { "show",       do_show },
> >         { "list",       do_show },
> > +       { "attach",     do_attach },
> >         { "help",       do_help },
> >         { 0 }
> >  };
> > --
> > 2.20.1
> >

Thank you for the review :)
