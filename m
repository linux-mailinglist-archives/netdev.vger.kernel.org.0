Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF7D7414D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfGXWP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:15:57 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36445 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfGXWP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:15:57 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so46033965ljj.3;
        Wed, 24 Jul 2019 15:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBF6bNBt/PemNw217in5S9v8lFOv59SFC9xNcgdoU6Y=;
        b=s+uv8qpFxE+t54WGQJxNv5PYL7LjIriR64oc1BJyj1009oNYg6lzg+rMYzQQOCEQ/4
         QMO4FRyZCOuroPUbx/6MBgHUdMdnEQwtfxh2xCc2q4kRbiUdpUyvMegZrChhGGNgJUAy
         Avf8nJfUygtP6hrUCLBQbNyAPWmEHblYOzgfDrxZOYT4sb7wUIbwDdogK+r6+C7bntd1
         +4WqbjfwD6gUnOOpW6Dx9tKsZJRXETh89NSOLtFpz6P4uu6xdSRhH1vM8s0lTRrSfEjw
         GorBm5VsmBWs/7Jx2ZCSLyDT5+kidDNLZJ2dWq9ruL3lc9uDai+Qh4U0qR+mrnSPTidp
         qRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBF6bNBt/PemNw217in5S9v8lFOv59SFC9xNcgdoU6Y=;
        b=fUGyCmD8sMc7BsJPqMr1azO6Hv/2CBZ0CGdOKUeys9APJZBHraNOk1H5mWgFieXks9
         M9O8YAaS0WtjcoZISEEKTKHLd3dPAFF+M+Csq+/9w03roWcJeaOoJkRaGExL5aM+nGo8
         J2RgQR+UWcuNre9PAoFPLZKZPoayfKc/qYnVEDJD5wdjCqyt404IFz+Zrn38E1SJ3Ilj
         gLafZRl4rwCIizadG/5PabG7gs5ex1okVSZqjcl15up/9IjjaAPSvlw20ghgYQaQyx4r
         yZFX7iQb24eDwlC9hKrRdk6L7Ay+jrlh4B/GqfAR5P6FL/Sfio9OWRCE3Vojw5TJ0gDT
         6IIA==
X-Gm-Message-State: APjAAAXPaesB7+s8PpzShWpa6Xr4H84lwzIKA8DoQJRLeqop+Vv4Xr9/
        2yepAZmDetNvoW49A/X5K9/L8HnN+tUIBKnSJRs=
X-Google-Smtp-Source: APXvYqwM9LPq8IoQDhPWPLNNHxpyCL3AuIe6TPRs7D3NajHezX5f401oHxVeqFYuSFlyCQnR0SrW8LZ2qREKv7Tmk+o=
X-Received: by 2002:a2e:9a82:: with SMTP id p2mr45445949lji.64.1564006555385;
 Wed, 24 Jul 2019 15:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <CAPhsuW7PU1PP91e8vD2diwhBAwGJHWu6wAKOoBThT86f4r5OJw@mail.gmail.com>
In-Reply-To: <CAPhsuW7PU1PP91e8vD2diwhBAwGJHWu6wAKOoBThT86f4r5OJw@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 15:15:44 -0700
Message-ID: <CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:20 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 10:09 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > This introduces a new command to retrieve multiple number of entries
> > from a bpf map.
> >
> > This new command can be executed from the existing BPF syscall as
> > follows:
> >
> > err =  bpf(BPF_MAP_DUMP, union bpf_attr *attr, u32 size)
> > using attr->dump.map_fd, attr->dump.prev_key, attr->dump.buf,
> > attr->dump.buf_len
> > returns zero or negative error, and populates buf and buf_len on
> > succees
> >
> > This implementation is wrapping the existing bpf methods:
> > map_get_next_key and map_lookup_elem
> >
> > Note that this implementation can be extended later to do dump and
> > delete by extending map_lookup_and_delete_elem (currently it only works
> > for bpf queue/stack maps) and either use a new flag in map_dump or a new
> > command map_dump_and_delete.
> >
> > Results show that even with a 1-elem_size buffer, it runs ~40 faster
>
> Why is the new command 40% faster with 1-elem_size buffer?

The test is using a really simple map structure: uint64_t key,val.
Which makes the lookup_elem logic faster since it doesn't spend too
much time copying the value. My conclusion with the 40% was that this
new implementation only needs 1 syscall per elem compare to the 2
syscalls that we needed with previous implementation so in this
particular case the number of ops that we are doing is almost halved.
I did one experiment increasing the value_size (448*64B) and it was
only 14% faster with 1-elem_size buffer.

> > than the current implementation, improvements of ~85% are reported when
> > the buffer size is increased, although, after the buffer size is around
> > 5% of the total number of entries there's no huge difference in
> > increasing it.
> >
> > Tested:
> > Tried different size buffers to handle case where the bulk is bigger, or
> > the elements to retrieve are less than the existing ones, all runs read
> > a map of 100K entries. Below are the results(in ns) from the different
> > runs:
> >
> > buf_len_1:       69038725 entry-by-entry: 112384424 improvement
> > 38.569134
> > buf_len_2:       40897447 entry-by-entry: 111030546 improvement
> > 63.165590
> > buf_len_230:     13652714 entry-by-entry: 111694058 improvement
> > 87.776687
> > buf_len_5000:    13576271 entry-by-entry: 111101169 improvement
> > 87.780263
> > buf_len_73000:   14694343 entry-by-entry: 111740162 improvement
> > 86.849542
> > buf_len_100000:  13745969 entry-by-entry: 114151991 improvement
> > 87.958187
> > buf_len_234567:  14329834 entry-by-entry: 114427589 improvement
> > 87.476941
>
> It took me a while to figure out the meaning of 87.476941. It is probably
> a good idea to say 87.5% instead.

right, will change it in next version.
