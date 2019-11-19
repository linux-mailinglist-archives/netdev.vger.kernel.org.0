Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1C2102831
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfKSPhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:37:38 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39934 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfKSPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:37:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id p18so23856299ljc.6;
        Tue, 19 Nov 2019 07:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAyUdfmJiJi4RpgjaU0REjjASDaV/bWU7/WG+YER0uc=;
        b=fS5ID8C8Ou3hctvXS249gt3CgzjMHu6QOznB0d4VTxqRkdLzJoQc4Juz7F0SjgYoDM
         /rhuxUNH7ktJpyqkCV0DVsvKMeh9GTQZrD4JyHWuxdewlgEgvBlguPaE7RK9rvO5XRfH
         sdk3uRQBula1q2w5uvVf2fXq2AdbNDg8s41w7CN3LLW2r1pAGNyDkQElIX7/b6uZrekV
         /z8c73jF5ZfMT5LncrJBsGihL99X3+tjCMa4cgWhiz+0IOe4CibvLD4yzXC2OYkM3crB
         jk3EoJOETFTzJMzi9pseRuqH2jeo/stYJugWSweN9pDMetK2Y8oyYs72BGOqUV2CEOLr
         DQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xAyUdfmJiJi4RpgjaU0REjjASDaV/bWU7/WG+YER0uc=;
        b=J1fIAKzpwWIc4P2Cvf+SnBOlV1YRYNqjGnPGhMahpAGG9XwnMKOhFiVJd9h57dTegt
         B2tdx22faIk2vy+oYttQu5EeC/fmusq9zcJs4RU93RdPnCV88c4kNBkT8VrbC0DEyTD3
         2cU5NVNLrqrrzvQYXLf0VnuFO+w6VKeZebX3YzaBKQe51HiGUfenDgDqVL7+uNHnthLP
         PVQqeXSxmAgowCqLD+0tQGqPBHNpnuE3S8IZuo4FJL3jJs5VRjIRRH+N5C/ZspPFOoYb
         Qol49O71MXCf1k+UUucFHr4lJX/XIpyn32z9b7iRN6vPplXiG+AIffgbQRVMTz9BNRKZ
         Qodg==
X-Gm-Message-State: APjAAAX9TuFYj07OK3xMhbAaAR3fJugFCAesbM2Y+JnPjTTckSV53jzM
        +73rDmO+wb6TpsILXgNtHCcBiiygUIC937Nk/0o=
X-Google-Smtp-Source: APXvYqwM5CuCM0cMaXsnBmFFYQh73bBkZRAdGfG3BteYMFXCaRaY935y4lBJiyme/ufuVZgdkox3YAKYAYngH5QeuYI=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr4614470lji.142.1574177855313;
 Tue, 19 Nov 2019 07:37:35 -0800 (PST)
MIME-Version: 1.0
References: <20191114194636.811109457@goodmis.org> <20191114194738.938540273@goodmis.org>
 <20191115215125.mbqv7taqnx376yed@ast-mbp.dhcp.thefacebook.com>
 <20191117171835.35af6c0e@gandalf.local.home> <CAADnVQ+OzTikM9EhrfsC7NFsVYhATW1SVHxK64w3xn9qpk81pg@mail.gmail.com>
 <20191119091304.2c775b35@gandalf.local.home>
In-Reply-To: <20191119091304.2c775b35@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Nov 2019 07:37:23 -0800
Message-ID: <CAADnVQJ7ymcPRCw4iWBuec-tYLXSH-62r96WNAVNwQTLA+DGsg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ftrace: Add modify_ftrace_direct()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 6:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 18 Nov 2019 22:04:28 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > I took your for-next without the extra patch and used it from bpf trampoline.
> > It's looking good so far. Passed basic testing. Will add more stress tests.
> >
> > Do you mind doing:
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 73eb2e93593f..6ddb203ca550 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -256,16 +256,16 @@ struct ftrace_direct_func
> > *ftrace_find_direct_func(unsigned long addr);
> >  # define ftrace_direct_func_count 0
> >  static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
> >  {
> > -       return -ENODEV;
> > +       return -ENOTSUPP;
> >  }
> >  static inline int unregister_ftrace_direct(unsigned long ip, unsigned
> > long addr)
> >  {
> > -       return -ENODEV;
> > +       return -ENOTSUPP;
> >  }
> >  static inline int modify_ftrace_direct(unsigned long ip,
> >                                        unsigned long old_addr,
> > unsigned long new_addr)
> >  {
> > -       return -ENODEV;
> > +       return -ENOTSUPP;
> >  }
> >
> > otherwise ENODEV is a valid error when ip is incorrect which is
> > indistinguishable from ftrace not compiled in.
>
> Sure I can add this. Want to add a Signed-off-by to it, and I'll just
> pull it in directly? I can write up the change log.

Whichever way is easier for you.
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Thanks!

> -- Steve
