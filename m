Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D0375570
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhEFOOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbhEFOOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:14:43 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E52C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:13:44 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id i20-20020a4a8d940000b02901bc71746525so1280544ook.2
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1cqDzeI1snfFPIZd/YEXkNc/co5zes8QE8iPZ//qc8=;
        b=fNCJkZjFEQUvjqJoZANpns1oDhHCiqpAtqBStAOEnqrixfDn4nSdgZ8LZ6NTi7jfdS
         +2cm8rLkk+CbmlTJxq5GOY44etULO/CrrrsJybVw/BGoa+4e44Nisc0tLIvZk5R822+1
         3wgWxkBxVgjQB0YLF7AVFU+PBLYy4YVH5rdPnqVAJ79xfGNj3pNVuEKNQ964Scrtc6Ey
         P/QHGenyW0cFkDgpmzLPvmbKoJI3+xck8nAtjFzty5rIQl5+AdX4kdtLSLoMjG6Bs7Rb
         IegbDT+F7x4HS5YEpdbKdTvEUcBh25E7x4dCydUqO8joniDfMFsBQk5dV7dxpJGt466o
         yujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1cqDzeI1snfFPIZd/YEXkNc/co5zes8QE8iPZ//qc8=;
        b=l8XQNnQKr7BxVSYy7G0eRh9sMzGy7cZ9yiSGWLy7Un2sSye4ZtIUsnCIQKsR7zUd/X
         LYRvENsmYKpZ5r3y+ShcB4UXkK6QWHlfcWZXa72cJsHmX3QtCr0xUDpyfGT3DtyhuAqa
         Nxu7yXRdfWLvmLJn9BeOsBNwEGiXrWFH61NiQ2wTK71eP+mEHajMLnHvAhF6+N/Zsw6D
         4WkyhupIirinqrv+YzxbUykdlEAX3tO8URImhevg4661j4/BOvDGJoPEjlbXIYeUlQLt
         2GQVZrT5En71E2FTtPRHLwykV2SzjPncw9oC7xcJIQS7xH8/br3K89tE1sdEeWyfknx1
         lQSg==
X-Gm-Message-State: AOAM5315HRj2fBrJ1ODAoeLMTm0v/8DjamO0s/CrdvQo3ChoMkpHiyx8
        f4f3ik+bMiVOH+sHuIesxlgxhcnCzubqdJuBvUE=
X-Google-Smtp-Source: ABdhPJwA6dDXOPSo7O3LHIdCsuUZPUMtkFSGvp7aQlaFQh/ys51IEnozdA0XyZdxDDjhmkDv7bpIL3Pjdr6/OaCldWA=
X-Received: by 2002:a4a:107:: with SMTP id 7mr888955oor.49.1620310423795; Thu,
 06 May 2021 07:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210506231158.250926-1-yanjun.zhu@intel.com> <CAJ8uoz2gd8xKd46Fq8numxS25Q68Gv-jtLqbWywLaztFCf=_jg@mail.gmail.com>
 <CAD=hENdVrb18vxnUrSZvgMnFo5EoJAJdSKSm4Q2kFLHHSoUbpQ@mail.gmail.com> <CAJ8uoz3f+GqGoVnmYh2Y0fBG44CgES+4MXGCuCDriVx5QYsMJA@mail.gmail.com>
In-Reply-To: <CAJ8uoz3f+GqGoVnmYh2Y0fBG44CgES+4MXGCuCDriVx5QYsMJA@mail.gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 6 May 2021 22:13:32 +0800
Message-ID: <CAD=hENfr57bDReESv7Ogqi7kuqXXdB28HyhD4L2Ld=S8UDdQ5g@mail.gmail.com>
Subject: Re: [PATCH 1/1] samples: bpf: fix the compiling error
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>,
        Mariusz Dudek <mariuszx.dudek@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 10:04 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Thu, May 6, 2021 at 3:51 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> >
> > On Thu, May 6, 2021 at 8:54 PM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > On Thu, May 6, 2021 at 8:47 AM Zhu Yanjun <yanjun.zhu@intel.com> wrote:
> > > >
> > > > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> > > >
> > > > When compiling, the following error will appear.
> > > >
> > > > "
> > > > samples/bpf//xdpsock_user.c:27:10: fatal error: sys/capability.h:
> > > >  No such file or directory
> > > > "
> > >
> > > On my system, I get a compilation error if I include
> > > linux/capability.h as it does not have capget().
> >
> > Thanks. Can you run "rpm -qf /xxx/xxx/sys/capability.h" to check which
> > software provides sys/capability.h?
> > Now I am on CentOS Linux release 8.3.2011.
>
> I do not have CentOS, but it is likely called libcap-dev or
> libcap-devel. If that does not work, Google/Baidu it.

Thanks. On centos8.3, libcap-devel can be installed by "dnf install
libcap-devel".
Then this problem is fixed.

So please ignore this commit.

Zhu Yanjun

>
> > Thanks a lot.
> > Zhu Yanjun
> >
> >
> > >
> > > NAME
> > >        capget, capset - set/get capabilities of thread(s)
> > >
> > > SYNOPSIS
> > >        #include <sys/capability.h>
> > >
> > >        int capget(cap_user_header_t hdrp, cap_user_data_t datap);
> > >
> > > Have you installed libcap? It contains the sys/capability.h header
> > > file that you need.
> > >
> > > > Now capability.h is in linux directory.
> > > >
> > > > Fixes: 3627d9702d78 ("samples/bpf: Sample application for eBPF load and socket creation split")
> > > > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > > > ---
> > > >  samples/bpf/xdpsock_user.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > > > index aa696854be78..44200aa694cb 100644
> > > > --- a/samples/bpf/xdpsock_user.c
> > > > +++ b/samples/bpf/xdpsock_user.c
> > > > @@ -24,7 +24,7 @@
> > > >  #include <stdio.h>
> > > >  #include <stdlib.h>
> > > >  #include <string.h>
> > > > -#include <sys/capability.h>
> > > > +#include <linux/capability.h>
> > > >  #include <sys/mman.h>
> > > >  #include <sys/resource.h>
> > > >  #include <sys/socket.h>
> > > > --
> > > > 2.27.0
> > > >
