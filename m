Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CC26EA4B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRBIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIRBIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:08:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D39C06174A;
        Thu, 17 Sep 2020 18:08:15 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z25so4791029iol.10;
        Thu, 17 Sep 2020 18:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5w1jmkXLC7ZwZwnPVxI2ivN+2SEzDaz1fMdarp99Kwo=;
        b=WEUhEa7orWf6PhBUa1v74+0qpiq/4c9HRRr+wRAlV7FU7UarkdO6LbISTTjvpQ5Vuk
         Uys1J+l0Vl/EDAgseDjRa/swCgMx5CGLegC2NCbdQxc5APtGh+PjXomuxN5qrRr/B7U3
         IPgyFxwKWroYA9aFlctSU0rmFNQq9gXP/VqNaC2ZeGIOx7ksnSppt/3ZkxVBDbhdORZJ
         3jyYwsBDxModyirPNvxHOoKR6a9K/uxrQA1dLRB18eJGhA6PE27O58GWmj2QYrk37hfH
         qOf/jILVDVdUOSAs9OmcPlse1ckVkNeYkJA5ezuYe6DgOx81JW9TF5r+WO0QqyN9wpGl
         YjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5w1jmkXLC7ZwZwnPVxI2ivN+2SEzDaz1fMdarp99Kwo=;
        b=puUsTFapMgN9R7IZ1BTntjekA+sjrDl65YVtolHjbuW5C85pIixhnI+y2Nm9rsHOAY
         Qrq3WpzcyrI6sDj8mlgEqPeGroO7FEmm5eIw3ytNVqVSclUUSgNq+wH35b2MAjr1sr3n
         MEhTCfZNApmPHRyrfvqpD+CHZcnu3A06dVo0namGfd/nuVqoL1ZKQL88wniFLJO+wthE
         NRB7/EFRdFwmgPs3Ag2bNwlEslnwwKh/hk/wagyCclwqRC3kER5bYribKLHbLhufoVxe
         tvM+uG4kaw5jq6imIAnzOu0eqw2LVa4/Mvi3kOv4i+tmBPgJDcliMPVt86zIkW6bkTua
         ecfA==
X-Gm-Message-State: AOAM533OFfqJZK10UwLHEAIcANVePwz9uV2f4vq5G4GxW4LR/y3m8Mr9
        7y1vIwxinKsneXQoX1abVJB4lfZLnDYva06P7so=
X-Google-Smtp-Source: ABdhPJylCFqHxDlCTZWyHu0BaOy73iAIDqIuldCUzhR44fNPFG91gkwupqhxOT03KAsUXGBQxk2VdaOrNwNzTL3W6RA=
X-Received: by 2002:a02:ce8c:: with SMTP id y12mr29409632jaq.53.1600391294416;
 Thu, 17 Sep 2020 18:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
 <33dd4a10-9b2a-7315-7709-cd8e7c1cd030@isovalent.com> <CAPhsuW62F8CkQbrZpg-YEA+qyZ7=ra+aRwMaxEyU6zKBqZRCnQ@mail.gmail.com>
In-Reply-To: <CAPhsuW62F8CkQbrZpg-YEA+qyZ7=ra+aRwMaxEyU6zKBqZRCnQ@mail.gmail.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Thu, 17 Sep 2020 18:08:04 -0700
Message-ID: <CAPGftE9+xn4y6vY5LH3txVmMZ7k6C+QAdULv6CR5EWAJB54=cg@mail.gmail.com>
Subject: Re: [PATCH bpf v1] tools/bpftool: support passing BPFTOOL_VERSION to make
To:     Song Liu <song@kernel.org>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 at 16:27, Song Liu <song@kernel.org> wrote:
>
> On Thu, Sep 17, 2020 at 7:58 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > On 17/09/2020 12:58, Tony Ambardar wrote:
> > > This change facilitates out-of-tree builds, packaging, and versioning for
> > > test and debug purposes. Defining BPFTOOL_VERSION allows self-contained
> > > builds within the tools tree, since it avoids use of the 'kernelversion'
> > > target in the top-level makefile, which would otherwise pull in several
> > > other includes from outside the tools tree.
> > >
> > > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> >
> > Acked-by: Quentin Monnet <quentin@isovalent.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

I should clarify for those performing stand-alone builds that a few
items are still required from outside the tools/ tree:
kernel/bpf/disasm.[ch] and scripts/bpf_helpers_doc.py. Not sure that's
worth updating the commit description however.
