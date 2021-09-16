Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE940EB4A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhIPUGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhIPUGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:06:24 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C093C061574;
        Thu, 16 Sep 2021 13:05:03 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o124so7288900vsc.6;
        Thu, 16 Sep 2021 13:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqQVTE2PMRShuROB+jq/o3djQChpeXRaxOXavzg6lf4=;
        b=hSgVPKtEwsfx/U4A3f5s50Wpn0f45KZyL8lH06fZM7A2fHDAs42RosUD5dcQK0mwD/
         jLQKIoLYtgKx4pHPDFd9mQTKo+OchTiaPxwBL55ReX+FXAB9roei+Z8bVgaGqFtlAlN+
         sFHLTmWhrtSRpGApembZGfXGbJFQ7gnEfUPsrPwOHUN0naxMXKoO+hXG5y3+Oe45a6q+
         Ncq/rp0ZXs8enJI3GuTdF1Qii5TMcY7qTyHJq7HnEnvHh8o856ldrkp0vS9Jf8tQ3BLn
         yBeO54lock1fOC/xO4pjFhH1J0aa/vePeqy7Bkxrv85mlSZKrbf9qdyn3nAQb2GLewT1
         Yopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqQVTE2PMRShuROB+jq/o3djQChpeXRaxOXavzg6lf4=;
        b=wJ4jEo112ec4Y3cdXKvna/Dw8pqpibuLPkPiO9YXLPiCRxMtCiJdUh8VVABnb2EfIg
         FSbkdbG6RmKx0iDBYs4oOu/uTvS4BWZUmU49DJkDYHimK1ZK2x+Q5QdIXDtGYvxbtXGj
         Gtpky1JKHu4uIPqfUSEcHcJhtW+AR1H34ImVu1LNEd83xyzM7SU+J14Xuhiqa7y1U4g5
         CA4Zfq0TkmcuEKm4Zn4LSisKzpKfULCxP6F0t+JapduOK9p7j+eXatbLi5vPNrfx+I4/
         zxKrMOOu+21sGf2KU3Si8H57bXkPE/5jeAXvYlMvksR2w200nnPud99iRJKx4i0PJ2uN
         2aRQ==
X-Gm-Message-State: AOAM53067kyW27VAKzq/sdrb41irk8WONDM+c+pTge1QHosxPDQ2NNKx
        AtI1eDI90pcs7bu4Rgy91jNYzxKlD+PLIB45NzfSH/2+
X-Google-Smtp-Source: ABdhPJxBUU2X+ozv4+GD8aJqC55wGIdgwO2IreZ8dIJiSiHj2V0oO3jJ2R05zI6eZR2dLDF6+PYAA4OSKP5htXhfG9w=
X-Received: by 2002:a67:ca1c:: with SMTP id z28mr6172344vsk.40.1631822702570;
 Thu, 16 Sep 2021 13:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com> <20210916070632.2ee005e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916070632.2ee005e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Sep 2021 13:04:51 -0700
Message-ID: <CAADnVQL4y5xpGRH_mq4ntP+HLPrP47k6S6jv3H-wXMLJGJsDMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 7:06 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Sep 2021 20:21:04 -0700 Alexei Starovoitov wrote:
> > +In HW
> > +-----
> > +
> > +The HW can choose to execute eBPF instruction natively and provide eBPF runtime
> > +in HW or via the use of implementing firmware with a proprietary license.
>
> That seems like a step back, nfp parts are all BSD licensed:

Yeah. netronome is a great example of how firmware should be developed.

> > +Packaging BPF programs with user space applications
> > +====================================================
> > +
> > +Generally, proprietary-licensed applications and GPL licensed BPF programs
> > +written for the Linux kernel in the same package can co-exist because they are
> > +separate executable processes. This applies to both cBPF and eBPF programs.
>
> Interesting. BTW is there a definition of what "executable process" is?

That's how lawyers put it.
BPF in many ways is unique, so traditional computer science words and meanings
don't apply 100%. Like, bpf programs are analogous to kernel modules,
but they're very different at the same time as well.
The analogies are used to explain things.
Is bpf program an "executable process" on its own? Hard to say.
Is there a task_struct allocated for each bpf prog? Of course, not.
But it is certainly not executing in ring 3.
In the future we might have kthread or even user thread completely
occupied by bpf progs.
