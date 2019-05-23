Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 269322821C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbfEWQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:05:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44087 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfEWQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:05:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id w25so4107909qkj.11;
        Thu, 23 May 2019 09:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bJMTypIkfNvf8ijNb6UrSxgs9aUjdLuxJ5xA2anY/E8=;
        b=L3JzgTaBCHbEinTmlt6tKNxxCgYZwz3YlwLYyRoGrkaN1CA/aOK3KzG9Bc95KsRBkp
         bLurWmML6uoL9WlOUUC1htC1+r5zqRi1WGlOAcONKyY/wqeTo4umTN2kEhIHYUVNyMoy
         50hDPUIy7f8YDEBcHSaoAmcpv70zqNBbGTpJLZpBsA62iZ31tlFvJv6TZdm6o8JpQWEq
         MYgjdA+CbKZHVCVQ9mXLng6dzGi9U2rlDT6nqv8Kh0mkGjNnZan9lZd8euxf0i0BdcTL
         f3OS+vA8gXsAkmmuYlVqjBeMiPOxgqFCzHtVuj1F6Le5SZalkKu6cfqDuJ92F10lRq4z
         mdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bJMTypIkfNvf8ijNb6UrSxgs9aUjdLuxJ5xA2anY/E8=;
        b=pDs4Fa17hHNFLoqsiq/EELIpuwPhyfCCynQ84VpNCFgwSoSXPkjx5Vj0vAKe/oM1to
         Sl8JVw/ZCQeD0bCGPfyEUYARmwr8c9o4alPvjs4ItGiI+/NG/BThY680gwRZOBKMr1nE
         klcxIZ1wXHm93SUB5UYa635oQa/AUNU+0+M0kxXt6HqJXlc+mBMFRBEV1Cm2Z9yWrVLO
         Cze3XDuCqZ/WvWFO5HUkd01/qYVPFZHZ+orGypixSVRr1yZSnGi27lgN4xJnTEsmWssv
         za/Tc3kjkjl2j+6PxRSpdktlwh/MDaKDqiHf1wQetpFqzECu0mOU6qQuFUiCh5j2N9NT
         QEaA==
X-Gm-Message-State: APjAAAWy1NurSWmthC3b4FcPxysosI4Al9t2Z6KxL6uW5F+YvY2/V6fj
        gpjw4o2KEHYMdqlSiXl2PRExki/g3vuJNLUgC9k=
X-Google-Smtp-Source: APXvYqzNsdDxOMaeF12dSZcLO08T0wKYfMdf3DbF7ahaBJCIMptOe+5jdO93c85koOWVl2vpyZXGhkJSb/Chjc30XNE=
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr62328133qkl.81.1558627534024;
 Thu, 23 May 2019 09:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190522092323.17435-1-bjorn.topel@gmail.com> <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
 <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com>
 <CAH3MdRX6gocSFJCkuMuhko+0eheWqKq4Y4X-Tb3q=hzMW5buyw@mail.gmail.com>
 <c1f90672-d2ce-0ac9-10d1-08208575f193@iogearbox.net> <3ED3A4F8-CC01-4179-9154-6FC5338E83B5@netronome.com>
In-Reply-To: <3ED3A4F8-CC01-4179-9154-6FC5338E83B5@netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 23 May 2019 18:05:22 +0200
Message-ID: <CAJ+HfNj_ZBqdwoWh7w4M3mUm_vPUwJ2QBWpyKCSSvk7e8xKz6w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Y Song <ys114321@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 at 16:31, Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> > On 23 May 2019, at 15:02, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 05/23/2019 08:38 AM, Y Song wrote:
> >> On Wed, May 22, 2019 at 1:46 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gma=
il.com> wrote:
> >>> On Wed, 22 May 2019 at 20:13, Y Song <ys114321@gmail.com> wrote:
> >>>> On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@g=
mail.com> wrote:
> >>>>>
> >>>>> Add three tests to test_verifier/basic_instr that make sure that th=
e
> >>>>> high 32-bits of the destination register is cleared after an ALU32
> >>>>> and/or/xor.
> >>>>>
> >>>>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> >>>>
> >>>> I think the patch intends for bpf-next, right? The patch itself look=
s
> >>>> good to me.
> >>>> Acked-by: Yonghong Song <yhs@fb.com>
> >>>
> >>> Thank you. Actually, it was intended for the bpf tree, as a test
> >>> follow up for this [1] fix.
> >> Then maybe you want to add a Fixes tag and resubmit?
> >
> > Why would the test case need a fixes tag? It's common practice that we =
have
> > BPF fixes that we queue to bpf tree along with kselftest test cases rel=
ated
> > to them. Therefore, applied as well, thanks for following up!
> >
> > Bj=C3=B6rn, in my email from the fix, I mentioned we should have test s=
nippets
> > ideally for all of the alu32 insns to not miss something falling throug=
h the
> > cracks when JITs get added or changed. If you have some cycles to add t=
he
> > remaining missing ones, that would be much appreciated.
>
> Bj=C3=B6rn,
>
>   If you don=E2=80=99t have time, I can take this alu32 test case follow =
up as well.
>

Jiong, that would be great. Thank you. I'd guess it would take much
longer for me to do it (gmail.com time vs intel.com time ;-)).


Bj=C3=B6rn

> Regards,
> Jiong
>
> >
> > Thanks,
> > Daniel
>
