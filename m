Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3897B37555F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhEFOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhEFOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:05:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6625C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:04:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s20so3432413plr.13
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Q/jAIUUETZ32rVCOA5mR3xBrCuSgTX/aYv4ZeRDb0w=;
        b=R0Ww9Ai4OYysA4ls9utTA4PoFHUeNR0J15J53BB3yiUqXDUFn5tKqtxRqNUwxBoe08
         uQhbC6hii3WV4BKsqu1wGQhG0PdlbqxSviK3AH6gwNFn5Xgp5SBXw3He06l+MXMAJ05H
         QO1/SRStttr7XIlD6QwNiw/cSfQxJZ5ufthh5uU0s/ZvNSMI5/rkjcm94YRs+QGT1v0t
         7RXOvCgqGJ0G+ckCW8WgxQOuk0Z1ENJcsbzsZdN+FMRVpPShS6R9WR1akuw1JJgszMUI
         9/PpiK4S/L0x70Gnp0X2HbUqOlsvycn1431kn5KyUXOq4aWX5rxilW+at3j5vsq99Bve
         S2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Q/jAIUUETZ32rVCOA5mR3xBrCuSgTX/aYv4ZeRDb0w=;
        b=nAB7hTSjkFeEuyoqwy9B2/pAPgGVSXkmvcmBfHD3XKGe4ALPZJzYbQ4B1uj16hgRWY
         6bLLnC7vwwMyQhYDAqMypWSMsj69Qd/L/3sGWoBgs9KTHi7900tqShgEDfvQSSRnxdzl
         gbCenEn76/g57acW3sUfqfu06wcY6+y5ZeIojR7LX5qBDTMyy22ODcUVLEW6/6AX9JqE
         x8Plk9JvZmPraMAg5lAQWRR3Msp4syDXKgqGSQ7Ec3B11loZGHV6wroXI43ZGg0HWUxa
         60uHsc5hELr3/TrWFBOK5F1L7gppGkbuHG7rMKL1F64EvEnWq+83RaHtXYvFlSFC7X/s
         BG+w==
X-Gm-Message-State: AOAM531u0+Ost8E2b9IPm+kkLKBZLtmCKveNGSk0lxHrdBLcsKswboEH
        wLbyIPEtBejrFgYAwuYN4qcup5Pbv25HbHTLpPE=
X-Google-Smtp-Source: ABdhPJwaOPdCHa9QooT+dWqBlHYZlqjje+CE5T3SrjFX0Kt5rYssslrN+0llf4xu6kq3oMJ5Pu5nc9LShDaP6QTa6s0=
X-Received: by 2002:a17:902:8d98:b029:eb:43c2:d294 with SMTP id
 v24-20020a1709028d98b02900eb43c2d294mr4569992plo.49.1620309867453; Thu, 06
 May 2021 07:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210506231158.250926-1-yanjun.zhu@intel.com> <CAJ8uoz2gd8xKd46Fq8numxS25Q68Gv-jtLqbWywLaztFCf=_jg@mail.gmail.com>
 <CAD=hENdVrb18vxnUrSZvgMnFo5EoJAJdSKSm4Q2kFLHHSoUbpQ@mail.gmail.com>
In-Reply-To: <CAD=hENdVrb18vxnUrSZvgMnFo5EoJAJdSKSm4Q2kFLHHSoUbpQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 6 May 2021 16:04:16 +0200
Message-ID: <CAJ8uoz3f+GqGoVnmYh2Y0fBG44CgES+4MXGCuCDriVx5QYsMJA@mail.gmail.com>
Subject: Re: [PATCH 1/1] samples: bpf: fix the compiling error
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
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

On Thu, May 6, 2021 at 3:51 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> On Thu, May 6, 2021 at 8:54 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Thu, May 6, 2021 at 8:47 AM Zhu Yanjun <yanjun.zhu@intel.com> wrote:
> > >
> > > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> > >
> > > When compiling, the following error will appear.
> > >
> > > "
> > > samples/bpf//xdpsock_user.c:27:10: fatal error: sys/capability.h:
> > >  No such file or directory
> > > "
> >
> > On my system, I get a compilation error if I include
> > linux/capability.h as it does not have capget().
>
> Thanks. Can you run "rpm -qf /xxx/xxx/sys/capability.h" to check which
> software provides sys/capability.h?
> Now I am on CentOS Linux release 8.3.2011.

I do not have CentOS, but it is likely called libcap-dev or
libcap-devel. If that does not work, Google/Baidu it.

> Thanks a lot.
> Zhu Yanjun
>
>
> >
> > NAME
> >        capget, capset - set/get capabilities of thread(s)
> >
> > SYNOPSIS
> >        #include <sys/capability.h>
> >
> >        int capget(cap_user_header_t hdrp, cap_user_data_t datap);
> >
> > Have you installed libcap? It contains the sys/capability.h header
> > file that you need.
> >
> > > Now capability.h is in linux directory.
> > >
> > > Fixes: 3627d9702d78 ("samples/bpf: Sample application for eBPF load and socket creation split")
> > > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > > ---
> > >  samples/bpf/xdpsock_user.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > > index aa696854be78..44200aa694cb 100644
> > > --- a/samples/bpf/xdpsock_user.c
> > > +++ b/samples/bpf/xdpsock_user.c
> > > @@ -24,7 +24,7 @@
> > >  #include <stdio.h>
> > >  #include <stdlib.h>
> > >  #include <string.h>
> > > -#include <sys/capability.h>
> > > +#include <linux/capability.h>
> > >  #include <sys/mman.h>
> > >  #include <sys/resource.h>
> > >  #include <sys/socket.h>
> > > --
> > > 2.27.0
> > >
