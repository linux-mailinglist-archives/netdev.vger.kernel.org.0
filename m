Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF11D250FF9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgHYD1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbgHYD1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 23:27:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDBC061574;
        Mon, 24 Aug 2020 20:27:41 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id w14so12102368ljj.4;
        Mon, 24 Aug 2020 20:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ISkKwpf1NKEfistWSxUgd367ieHCmBZuSqVZcUfedQ=;
        b=opGYwbvyYRgk6oN6QyfAJ+tyFRMEooh6BTTZdcbl6X5up1m9KwAW7wW7MicSB9vqA+
         BUQd9lNNGa2ov58hsXHBsfItnGK/Vtz5B04twulawQ2EHGYIZSYISj8MFxyN05j25krP
         3rQU1elXYMygrDUdTl1Oj8ptUyWwwiyNDUGQeOWgdHY0TP3OuQ2Yl2qxwQwcivdtBq7d
         YjmMs+Dpf93XbVwYL6ht+tMEXByLg0See8V/Iu4De/LETcnqlHmrFU45u+qSbBL5ZYSI
         Oz6yV8Zo7uvve3hX6vu4RGW2xkqvxmB05+g4ne4r3wdDcyHowXVBy/3gS75av7ZzF0Ci
         aJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ISkKwpf1NKEfistWSxUgd367ieHCmBZuSqVZcUfedQ=;
        b=OU1zGS+IWxnZAZyWK3jpc3fTPj6FFawAt6pL9A+VgDu81rh19a7Of2N7XKqoj1viOv
         ygqpWcCuGS2fjZ+t/xu/uhEruB+KpJQA4f1zSjjOvp8PSBFxlzFcGA3wLyUzJYtAfNDZ
         FHr41/tGljinQI+zkNDlbTnJw6V3+D+skZ5nWhpvMQ6GUwGiYQYPNbeLCFQ2cjFjS9No
         +0mRvgJmb0mFxwsUDDQb/hqJFxY1FNXBfEdHG59tMVFEIPxbl2Rfjxn39B1uJ6bdC+v5
         jE19NQSx2+bf3ymknFsl68vcKqlcvyWJqZsrwCpn5Ka52nKQy5qrhqF9OjisBeoGu4Bf
         bKeA==
X-Gm-Message-State: AOAM531h2l1auJkHU5+Fr+v2kJPJpqDXDTg7tnPZpHTZ0gI2COzq3iMZ
        v6eicHoZSgzp8J3LxkBjMgbvMfRPtDMvCRMljk3H2mgEwAQ=
X-Google-Smtp-Source: ABdhPJx929t7WmM1kzR4eLUL/43eA/hSVvqhj/hqPW/OCoF4qHfzdgBbNUA2ey4rGUquHSFICqAmnSHuTTAwhAi/qag=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr4037385ljb.283.1598326059940;
 Mon, 24 Aug 2020 20:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200821111111.6c04acd6@canb.auug.org.au> <20200825112020.43ce26bb@canb.auug.org.au>
 <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com> <20200825130445.655885f8@canb.auug.org.au>
In-Reply-To: <20200825130445.655885f8@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 20:27:28 -0700
Message-ID: <CAADnVQKGf7o8gJ60m_zjh+QcmRTNH+y1ha_B2q-1ixcCSAoHaw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 8:04 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Alexei,
>
> On Mon, 24 Aug 2020 18:25:44 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Aug 24, 2020 at 6:20 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > On Fri, 21 Aug 2020 11:11:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >
> > > > After merging the bpf-next tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >
> > > > Auto-detecting system features:
> > > > ...                        libelf: [  [31mOFF [m ]
> > > > ...                          zlib: [  [31mOFF [m ]
> > > > ...                           bpf: [  [32mon [m  ]
> > > >
> > > > No libelf found
> > > > make[5]: *** [Makefile:284: elfdep] Error 1
> > > >
> > > > Caused by commit
> > > >
> > > >   d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
> > > >
> > > > [For a start, can we please *not* add this verbose feature detection
> > > > output to the nrormal build?]
> > > >
> > > > This is a PowerPC hosted cross build.
> > > >
> > > > I have marked BPF_PRELOAD as BROKEN for now.
> > >
> > > Still getting this failure ...
> >
> > I don't have powerpc with crosscompiler to x86 to reproduce.
> > What exactly the error?
>
> Just as above.

I didn't receive the first email you've replied to.
The build error is:
"
No libelf found
make[5]: *** [Makefile:284: elfdep] Error 1
"
and build process stops because libelf is not found, right?
That is expected and necessary.
bpf_preload needs libbpf that depends on libelf.
The only 'fix' is to turn off bpf_preload.
It's off by default.
allmodconfig cannot build bpf_preload umd if there is no libelf.
There is CC_CAN_LINK that does feature detection.
We can extend scripts/cc-can-link.sh or add another script that
will do CC_CAN_LINK_LIBELF, but such approach doesn't scale.
imo it's cleaner to rely on feature detection by libbpf Makefile with
an error above instead of adding such knobs to top Kconfig.
Does it make sense?
