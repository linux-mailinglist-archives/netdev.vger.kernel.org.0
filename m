Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF69CE04B
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfJGLZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:25:37 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36448 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbfJGLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:25:36 -0400
Received: by mail-yb1-f194.google.com with SMTP id r2so4533068ybg.3;
        Mon, 07 Oct 2019 04:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSSn9nuGJFkNmV3Ad6esk8BPxn8MDrtoN+nrwnmUgNU=;
        b=gRO/DLYuewD23kmazS+h++Ca7bm5EWCpxujdJg8AICBmBXxi5QrDk5QZOCe12YWGqo
         oVYfic2caqcbTaXCnx+t8kGkhTF3DJYNDkB1PhOqkGQJlnbuUKmsShTYfSJ8F9K0y8v8
         /rlp6R9T8/ggWPdYzdis61NWClP4tnMjCxzKBOB0iSrUsJPlNrv3zuz0jCtu6V13dJO7
         7nPiCZgb6aae5ZfcHkFf+CT86dAfX6l1Lds6gEiQkpD7lLvVbVMRovPA/QuahdYBCJOL
         mgWsUT0azOjgXfohhIsFjaQonYD/5OA4eKEtugq+/W7QqRdZuUK5LecnmC2gHmD7uqDu
         qFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSSn9nuGJFkNmV3Ad6esk8BPxn8MDrtoN+nrwnmUgNU=;
        b=KcDVPts1QSI58mfIlX+uM3vrgCegA466V9Ntb42RrvJJmV9e+UKbXkrg8poZa0k9s+
         +JS0f62oW8mBPaBTZxZqAPQSh4aM5p6IUI9HbYj0ADQ4yk5Cqp4hbXIFEfnpg74vDL9Z
         DfAxx+0wM9XIE9TFbBFbYTSqwtGGU6NsSx9afn6rMz/s1NODN0BN7/zr5bZ/1vxqso2b
         yzmoRuj9KWm9LAcrRdSJWqh44wQJpB6tQ5uQAM9gYX6mAVgd9/dyD85gQuVCKK/Rb8Kx
         ChhsvEwRLXJzAJvgHZzBtjXIkiW+eYYutPfVNqhBhiJtKRpjfhTR151aq/r40XdTTFLy
         Pl6Q==
X-Gm-Message-State: APjAAAVN/fHbMamifyhIPXL2jX6jQ08b7n4HOMVDbbUH9YBCM0jwfHGN
        xHmkDs5DlMevFLnJ56X5sGr2tNMGkERh1+wEGg==
X-Google-Smtp-Source: APXvYqyktAxb03gDnJck5sTDTlWkVN9ZbfFJmrP1ZuNId2ucjo/jC8lV+13UrtvNwIfexC/bqKUAZsFr32eI72G18Sk=
X-Received: by 2002:a25:c009:: with SMTP id c9mr10930458ybf.164.1570447535633;
 Mon, 07 Oct 2019 04:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191006115815.10292-1-danieltimlee@gmail.com> <CAEf4BzaUMRkbJLm98ZBu7uutcdukxUb2XyzX60ODcuBXGdQ3Vg@mail.gmail.com>
In-Reply-To: <CAEf4BzaUMRkbJLm98ZBu7uutcdukxUb2XyzX60ODcuBXGdQ3Vg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Mon, 7 Oct 2019 20:25:19 +0900
Message-ID: <CAEKGpzg_bOzsD_BmvOUTneFscdbEZhCcY5BBtsYZW=GmMGDb1g@mail.gmail.com>
Subject: Re: [bpf-next v5] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 12:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Oct 6, 2019 at 4:58 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, static global variable
> > 'max_pcktsz' is added.
> >
> > By updating new packet size from the user space, xdp_adjust_tail_kern.o
> > will use this value as a new max packet size.
> >
> > This static global variable can be accesible from .data section with
> > bpf_object__find_map* from user space, since it is considered as
> > internal map (accessible with .bss/.data/.rodata suffix).
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
> >
> > Changed the way to test prog_fd, map_fd from '!= 0' to '< 0',
> > since fd could be 0 when stdin is closed.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
>
> See nit below, but otherwise looks good.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> > Changes in v5:
> >     - Change pcktsz map to static global variable
> > Changes in v4:
> >     - make pckt_size no less than ICMP_TOOBIG_SIZE
> >     - Fix code style
> > Changes in v2:
> >     - Change the helper to fetch map from 'bpf_map__next' to
> >     'bpf_object__find_map_fd_by_name'.
> >
> >  samples/bpf/xdp_adjust_tail_kern.c |  7 +++++--
> >  samples/bpf/xdp_adjust_tail_user.c | 32 ++++++++++++++++++++++--------
> >  2 files changed, 29 insertions(+), 10 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..c616508befb9 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -25,6 +25,9 @@
> >  #define ICMP_TOOBIG_SIZE 98
> >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> >
> > +/* volatile to prevent compiler optimizations */
> > +static volatile __u32 max_pcktsz = MAX_PCKT_SIZE;
> > +
> >  struct bpf_map_def SEC("maps") icmpcnt = {
> >         .type = BPF_MAP_TYPE_ARRAY,
> >         .key_size = sizeof(__u32),
> > @@ -92,7 +95,7 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
> >         orig_iph = data + off;
> >         icmp_hdr->type = ICMP_DEST_UNREACH;
> >         icmp_hdr->code = ICMP_FRAG_NEEDED;
> > -       icmp_hdr->un.frag.mtu = htons(MAX_PCKT_SIZE-sizeof(struct ethhdr));
> > +       icmp_hdr->un.frag.mtu = htons(max_pcktsz - sizeof(struct ethhdr));
> >         icmp_hdr->checksum = 0;
> >         ipv4_csum(icmp_hdr, ICMP_TOOBIG_PAYLOAD_SIZE, &csum);
> >         icmp_hdr->checksum = csum;
> > @@ -121,7 +124,7 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
> >         int pckt_size = data_end - data;
> >         int offset;
> >
> > -       if (pckt_size > MAX_PCKT_SIZE) {
> > +       if (pckt_size > max(max_pcktsz, ICMP_TOOBIG_SIZE)) {
> >                 offset = pckt_size - ICMP_TOOBIG_SIZE;
> >                 if (bpf_xdp_adjust_tail(xdp, 0 - offset))
> >                         return XDP_PASS;
> > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > index a3596b617c4c..bcdebd3be83e 100644
> > --- a/samples/bpf/xdp_adjust_tail_user.c
> > +++ b/samples/bpf/xdp_adjust_tail_user.c
> > @@ -23,6 +23,7 @@
> >  #include "libbpf.h"
> >
> >  #define STATS_INTERVAL_S 2U
> > +#define MAX_PCKT_SIZE 600
> >
> >  static int ifindex = -1;
> >  static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > @@ -72,6 +73,7 @@ static void usage(const char *cmd)
> >         printf("Usage: %s [...]\n", cmd);
> >         printf("    -i <ifname|ifindex> Interface\n");
> >         printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> > +       printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);
> >         printf("    -S use skb-mode\n");
> >         printf("    -N enforce native mode\n");
> >         printf("    -F force loading prog\n");
> > @@ -85,13 +87,14 @@ int main(int argc, char **argv)
> >                 .prog_type      = BPF_PROG_TYPE_XDP,
> >         };
> >         unsigned char opt_flags[256] = {};
> > -       const char *optstr = "i:T:SNFh";
> > +       const char *optstr = "i:T:P:SNFh";
> >         struct bpf_prog_info info = {};
> >         __u32 info_len = sizeof(info);
> >         unsigned int kill_after_s = 0;
> >         int i, prog_fd, map_fd, opt;
> >         struct bpf_object *obj;
> > -       struct bpf_map *map;
> > +       __u32 max_pckt_size = 0;
> > +       __u32 key = 0;
> >         char filename[256];
> >         int err;
> >
> > @@ -110,6 +113,9 @@ int main(int argc, char **argv)
> >                 case 'T':
> >                         kill_after_s = atoi(optarg);
> >                         break;
> > +               case 'P':
> > +                       max_pckt_size = atoi(optarg);
> > +                       break;
> >                 case 'S':
> >                         xdp_flags |= XDP_FLAGS_SKB_MODE;
> >                         break;
> > @@ -150,15 +156,25 @@ int main(int argc, char **argv)
> >         if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> >                 return 1;
> >
> > -       map = bpf_map__next(NULL, obj);
> > -       if (!map) {
> > -               printf("finding a map in obj file failed\n");
> > +       if (prog_fd < 0) {
> > +               printf("load_bpf_file: %s\n", strerror(errno));
>
> program load error is checked above (bpf_prog_load_xattr check), not
> clear why check this again... Maybe just print helpful message there?
>

Oh, It won't be necessary since it gets error from 'bpf_prog_load_xattr'.
I'll resend the patch with this nit fixed.

Thanks for the review!

Thanks,
Daniel

> >                 return 1;
> >         }
> > -       map_fd = bpf_map__fd(map);
> >
> > -       if (!prog_fd) {
> > -               printf("load_bpf_file: %s\n", strerror(errno));
> > +       /* static global var 'max_pcktsz' is accessible from .data section */
> > +       if (max_pckt_size) {
> > +               map_fd = bpf_object__find_map_fd_by_name(obj, "xdp_adju.data");
> > +               if (map_fd < 0) {
> > +                       printf("finding a max_pcktsz map in obj file failed\n");
> > +                       return 1;
> > +               }
> > +               bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
> > +       }
> > +
> > +       /* fetch icmpcnt map */
> > +       map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
> > +       if (map_fd < 0) {
> > +               printf("finding a icmpcnt map in obj file failed\n");
> >                 return 1;
> >         }
> >
> > --
> > 2.20.1
> >
