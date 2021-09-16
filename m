Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB3640EBDE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbhIPUug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhIPUuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:50:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDE8C061574;
        Thu, 16 Sep 2021 13:49:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso8424153pjh.5;
        Thu, 16 Sep 2021 13:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=61Bc1rsBPkDe/85GVqDSyMoQYLRk+Ove9fLFxyWK6gY=;
        b=eX8SuK7TgvfmHN8uTrrTZbUECiUZDmpepcCDOXqq1SnaxfAcKia2ZV1ecltTL8bqhR
         f5XVMAf3CMpKQXKrmYBwBf5GStknmnAXuastin9VpphBNaJjWLQcf37pKwTd6rIMzDc7
         QFKaY43IJF8zEO2PrsOGE2VHcGuz5nVrmtIUDQFPDbEla2Q/SOqVYgNkW2ACPOCtZr3+
         EABBZBH+7aQ9KlrpAfqJtQ4xZFnJQRGag1mGK9xX+5oR+R39SxiUnTMCoT4oEDw6uNa3
         zJ4nQMf5fIhLCnZ4kpYslh6A38DVznBr1cwEVen5iU+VwhLmS69axPUIvrUXp7/WiamH
         TWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=61Bc1rsBPkDe/85GVqDSyMoQYLRk+Ove9fLFxyWK6gY=;
        b=7vcyCt4XGRAdEQGqu0l/jj4+FqsB1iMqsiMOm6DGhPg9aYIB0g5/gFwq+lmtO3NmgV
         oRrvlgoII8eaGTp7tfrSOdVM+pGNBJR3mJcX2Hq1CmVid4YGyazncohAJdg0FMtObO92
         hPD6dz2H7ef2ZMqv3KECVMliwyngIcvpqbP560pYvAzYn4sa1Kb3Cn1AZK9InUT8ojwu
         2CO55dqhw0LQNmvFcpK8UDUPwZKUAiXPYGU2fy5v0z5RdUeN8eM7V6FwA5BVrRghcj7d
         oU4+WfVTC+CeZvcsYbpcewaeqK54M4/DNUpbPxNLb932N/A0ouqs4NAp9Dn5xkzLj/O8
         VDvg==
X-Gm-Message-State: AOAM530kPkOPTv4/2D0/I9/G8ACg9b4WQYelgdVYpnGbI2LWO7JfpDps
        cFeo688VwJnl8aoojT+8xjfDdgqAUfPt1TD6YXs=
X-Google-Smtp-Source: ABdhPJyjk9NAvuXZyJZn7EkFkOibIh2nqWHKbRtcq9FvEW6/L8RxC6zUx0hgz+2j889BYKBwoRa/3jjmDpzf/cO3HNU=
X-Received: by 2002:a17:903:32c6:b0:13b:9cd4:908d with SMTP id
 i6-20020a17090332c600b0013b9cd4908dmr6553678plr.20.1631825353890; Thu, 16 Sep
 2021 13:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com> <87bl4s7bgw.fsf@meer.lwn.net>
In-Reply-To: <87bl4s7bgw.fsf@meer.lwn.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Sep 2021 13:49:02 -0700
Message-ID: <CAADnVQ+y5hmCmxM6jKY=TqpM0cGE-uSO=mObZ=LDxiVd9YUzuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 9:05 AM Jonathan Corbet <corbet@lwn.net> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Document and clarify BPF licensing.
>
> Two trivial things that have nothing to do with the actual content...
>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> > Acked-by: Joe Stringer <joe@cilium.io>
> > Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> > Acked-by: Dave Thaler <dthaler@microsoft.com>
> > ---
> >  Documentation/bpf/bpf_licensing.rst | 91 +++++++++++++++++++++++++++++
> >  1 file changed, 91 insertions(+)
> >  create mode 100644 Documentation/bpf/bpf_licensing.rst
>
> When you add a new file you need to put it into index.rst as well so it
> gets pulled into the docs build.

ok.

> > +under these rules:
> > +https://www.kernel.org/doc/html/latest/process/license-rules.html#id1
>
> I would just write this as Documentation/process/license-rules.rst.  The
> HTML docs build will link it automatically, and readers of the plain-text
> file will know where to go.

Good point. Will fix.
