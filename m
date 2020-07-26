Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB55922DB0A
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 03:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgGZBBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 21:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgGZBBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 21:01:16 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59CC08C5C0;
        Sat, 25 Jul 2020 18:01:15 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b25so13623557ljp.6;
        Sat, 25 Jul 2020 18:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRZ6k+2EudeHcZ1b0jIuHOrby+BxTb2SO0kPldgSHGM=;
        b=VjrhvCM8b3FWo+/TIjekn4QFnPxqkpMJCmtYhSeNOjB5ric/d+Z8hkrquF9ISxcupt
         qMzNsVZXAenccTbWWgh7rr7Dt9B5SlQLj/sv/AwB+ELvX6nMcAguBcy9iTfOfXP9xq7P
         cOKAI3nz/hzJGBzEMeW5o6iDzEkMbDAjzP20z0Sa23EMKDPlxC8MSac4uljKj5cx2v4c
         NTqklFJqxC341WhihVYbDSJEUPQdT1JeAvpWoF2Rpa70crpKLftobre8zlx7M//kGiT+
         Bdjs3eMgBpZDJc6NCTrAE2h3N+iD0Kuuf37SV3l6Ab/yQ8E3nUj17KYorAzr4rFnWHA1
         EQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRZ6k+2EudeHcZ1b0jIuHOrby+BxTb2SO0kPldgSHGM=;
        b=aYEOm4XM3rQzzvbph+xIHxrvb10KQSpKyvt5NKQMyZ4aIboOExVQqEoh//a/WLe6B4
         GGaI24K1znX13o4jHEtV+/vykRW8xuvhftxPdgjvz8qwBO2hGICzGWguQpFlOFZwjelH
         jU8ZeGwiab47waFMixMHL/AaqjNfBJg2IO3vTR9js/oUHj9nOAbObRfkZhwKVgX9LwT8
         O6yih6OSp9v4ccdZIuXY8wvg+zPNtwZCVrgUYJs7dQVRIH8Ytk0SL2rReSwp80fuSG22
         LtkIZeMtd4figfidQkSpsRpJDOygNEutGg8sLtL/z7uqSVIkYkvhtfoai08PEEs53OYw
         eIDA==
X-Gm-Message-State: AOAM533xHNg7eUwAEvNYfdHhxxibs6bJZ+79w2frln330U4If3C7Ho0e
        KWqCjj8Qf3NKiU21Jg6Y3eTxS1Y1f4UB+kNkTmI=
X-Google-Smtp-Source: ABdhPJxztEx9LxUx2VCXP8Lb3AxeJujIxpEjuQTtRRKuD9r2U+RvhSUBRP/iHQR9IaqoqIm8Tblx05kje6uVTpnZRVs=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr6688105ljh.290.1595725274305;
 Sat, 25 Jul 2020 18:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200725025457.1004164-1-willemdebruijn.kernel@gmail.com> <20200725105841.19507-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200725105841.19507-1-kuniyu@amazon.co.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 25 Jul 2020 18:01:03 -0700
Message-ID: <CAADnVQLbQuWGOUO-hN56WzRrVHoNaOhKOeuxZih9K-4b2C97Zw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] udp: reduce merge conflict on udp[46]_lib_lookup2
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 3:58 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date:   Fri, 24 Jul 2020 22:54:57 -0400
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Commit efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> >
> > in net conflicts with
> >
> > Commit 72f7e9440e9b ("udp: Run SK_LOOKUP BPF program on socket lookup")
> >
> > in bpf-next.
> >
> > Commit 4a0e87bb1836 ("udp: Don't discard reuseport selection when group
> > has connections")
> >
> > also in bpf-next reduces the conflict.
> >
> > Further simplify by applying the main change of the first commit to
> > bpf-next. After this a conflict remains, but the bpf-next side can be
> > taken as is.
> >
> > Now unused variable reuseport_result added in net must also be
> > removed. That applies without a conflict, so is harder to spot.
> >
> > Link: http://patchwork.ozlabs.org/project/netdev/patch/20200722165227.51046-1-kuniyu@amazon.co.jp/
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> Thank you for the follow up patch!
>
> Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

net is being merged into net-next. I think this one is no longer necessary.
