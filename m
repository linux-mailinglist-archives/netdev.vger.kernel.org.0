Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1BBB69B2
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfIRRhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:37:53 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39055 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfIRRhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 13:37:53 -0400
Received: by mail-yw1-f66.google.com with SMTP id n11so247756ywn.6;
        Wed, 18 Sep 2019 10:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ns04xwbI6DY0reaiKnNYa1F6BIASN0MRHUd2Toki9A4=;
        b=Hv5y4AfyD+hTTK+IC+63wZyFOpKVddTYjfHR9IlXqr5a/YbpkEaM8t5wyuigvKYA/S
         aMTeeTfEIg3ozRcqcIhKkXlYwC9udxKRt1ZyyOGHZuyOVRk1EZG5TB9K3eK2hrUCe7Fl
         n4F//cr4Sd64YHb637cJpp2sW1j6YhYL5j+6Tj8nYsW3VZt/gZ8zHOVp1Yekzjqqw8Is
         gC4yHkpaky+nHq1MWYqM9gvhcqDTpYZmc05S+4mmCFLM823cGm9awL6iTNwPox73qhVG
         I2lksjy15hQmpK5jbC3/7pQvAKLkSA0J9slZcV01NPCDMWYkQ4pFmu3w4HgHqzmWYdYh
         eUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ns04xwbI6DY0reaiKnNYa1F6BIASN0MRHUd2Toki9A4=;
        b=TPE8RMuZqjs1kXVkNrHgglk2b9UvNQxzJ0AHhT2VscI8Vmu35I54mDmKMun5DUyHWc
         Z73SNxCfLtH9iJUyFWJiYvwkPqihWdufjPpTByxRzf7v1Jdme+gyuzX9p2/KOuP1Wrx/
         2grrY+m2Rt74RuviPsqTDfwMY9nb7V6OgG7GmWLJ0ek3XUApI+Gw0C6gZYINrXiqAiII
         vKVhNxtkmyxWuoj+BDYQsQfiUqWKYymUO/J+G3ScFP+kS406SB3/RaR9hQ0bt71tI4YU
         YKENEdns/1mybVRmxnyrKtqabArzQ135WZ8wyrUpRyKZTYm6hrM7U16myRulF/wU7mzh
         79IQ==
X-Gm-Message-State: APjAAAV1uJXj/sLCrwLaEPWbwsnfPNFHOCToIYWqLfLPO4KmjLfBxZjz
        dpI/vD7yybP1NIVBE+DLwD7DYLFJSoX7XZIyFw==
X-Google-Smtp-Source: APXvYqwKyrPKx2ykzSIASVtFZjJqQrAcJH64RxGEQnOuAfthsrbI3JRKTIqtsWnOvsSM2sHfIDmed3F0AhbTe8KGQtQ=
X-Received: by 2002:a81:8981:: with SMTP id z123mr4604427ywf.56.1568828272276;
 Wed, 18 Sep 2019 10:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com> <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 19 Sep 2019 02:37:36 +0900
Message-ID: <CAEKGpzjUu7Qr0PbU6Es=7J6KAsyr9K1qZvFoWxZ-dhPsD0_8Kg@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 1:04 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 11, 2019 at 2:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, a new map 'pcktsz' is added.
> >
> > By updating new packet size to this map from the userland,
> > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
> > Changes in v2:
> >     - Change the helper to fetch map from 'bpf_map__next' to
> >     'bpf_object__find_map_fd_by_name'.
> >
> >  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> >  samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> >  2 files changed, 41 insertions(+), 10 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..d6d84ffe6a7a 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -25,6 +25,13 @@
> >  #define ICMP_TOOBIG_SIZE 98
> >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> >
> > +struct bpf_map_def SEC("maps") pcktsz = {
> > +       .type = BPF_MAP_TYPE_ARRAY,
> > +       .key_size = sizeof(__u32),
> > +       .value_size = sizeof(__u32),
> > +       .max_entries = 1,
> > +};
> > +
>
> Hey Daniel,
>
> This looks like an ideal use case for global variables on BPF side. I
> think it's much cleaner and will make BPF side of things simpler.
> Would you mind giving global data a spin instead of adding this map?
>

Sure thing!
But, I'm not sure there is global variables for BPF?
AFAIK, there aren't any support for global variables yet in BPF
program (_kern.c).

    # when defining global variable at _kern.c
    libbpf: bpf: relocation: not yet supported relo for non-static
global '<var>' variable found in insns[39].code 0x18

By the way, thanks for the review.

Thanks,
Daniel


> >  struct bpf_map_def SEC("maps") icmpcnt = {
> >         .type = BPF_MAP_TYPE_ARRAY,
> >         .key_size = sizeof(__u32),
> > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> >         *csum = csum_fold_helper(*csum);
> >  }
> >
>
> [...]
