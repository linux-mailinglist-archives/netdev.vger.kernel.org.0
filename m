Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9790375528
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhEFNw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 09:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhEFNwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 09:52:55 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DBCC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 06:51:56 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id k25so5550136oic.4
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 06:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UHHIARiiVkQxrvbNSoIYCZpXh4T217tw1wLMkCsDwc0=;
        b=uKvl3gXigzFpQwwAPVBXLP+OIoQlf0HmcZk7s+6ahpnkOkSYX3GdNJGttKljpifsp7
         LIKp6UhYQKsvgTwGzsswDssaqBc+57NXCPW3ucoBIElA1Ih5RL3doS8M+FOggyOkirww
         EWbNImzrgC/a7pHOtCeT3MZ9MnbkId72xHN5NLEIAWYQJiMJFSQc8jpDVQ8PWBdHaOwb
         mbklxHUy6cMCqa3qmcp63ZcYhsmRkNcIVKXu/hFQqAlvFeUlY5SvrlDzPEybucqbI4qN
         iTrZXlMNgi5ZUNLTVMNLrAmFlzPCTtUExHZLytaeBoPGKhN2fuzdxLh3vSGfNwOH3mnF
         OzBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UHHIARiiVkQxrvbNSoIYCZpXh4T217tw1wLMkCsDwc0=;
        b=qQOxH596ygiOvN4OWPFV8zcEOzHg6C5J3d9MWQLJ25Vdk6RFisS99gZbDthSfCZ/5I
         spiocQ6Tza6Xs8yJlqPmbjzc+9dhLvgfZ3L1q76ndRGrSnuEniUKabBGNAh/NSRw2hVV
         gf11KjWayRzQSJgeucP/oJ9CxMycUf4SqGR1IuHakgrwZKH6lvqz3/fYoEUlX4hDftuQ
         RMrEbjFdTZ0yDolNCpxT5e1OFq4ntVExx1wiNLKbN0VOob3Ff41N11P5QaBF6NSH4H6u
         GHOjX+BHLBRixYxDiLopacF8QsjBMmw4RSGaknYx37neTF6JnY7YWQTCJJwDP1PAgfq3
         N+Kg==
X-Gm-Message-State: AOAM533ewPpFpIqUyny0t51arZKmwfhbONyMXS8QHyqdOcdm5WHuaZDV
        HHeXFVEAxf+VZbS9pukDPqet+42MazKMaImXn0s=
X-Google-Smtp-Source: ABdhPJzde/r0pMboI2UOenujUIIVAgXSqwTPF+J4wVmqzi0RTcexx6lVPNmDZ/NwXWpXxjAhnJTdj2s0P5TN/OR9+u8=
X-Received: by 2002:aca:c685:: with SMTP id w127mr10683142oif.89.1620309115809;
 Thu, 06 May 2021 06:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210506231158.250926-1-yanjun.zhu@intel.com> <CAJ8uoz2gd8xKd46Fq8numxS25Q68Gv-jtLqbWywLaztFCf=_jg@mail.gmail.com>
In-Reply-To: <CAJ8uoz2gd8xKd46Fq8numxS25Q68Gv-jtLqbWywLaztFCf=_jg@mail.gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 6 May 2021 21:51:44 +0800
Message-ID: <CAD=hENdVrb18vxnUrSZvgMnFo5EoJAJdSKSm4Q2kFLHHSoUbpQ@mail.gmail.com>
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

On Thu, May 6, 2021 at 8:54 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Thu, May 6, 2021 at 8:47 AM Zhu Yanjun <yanjun.zhu@intel.com> wrote:
> >
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > When compiling, the following error will appear.
> >
> > "
> > samples/bpf//xdpsock_user.c:27:10: fatal error: sys/capability.h:
> >  No such file or directory
> > "
>
> On my system, I get a compilation error if I include
> linux/capability.h as it does not have capget().

Thanks. Can you run "rpm -qf /xxx/xxx/sys/capability.h" to check which
software provides sys/capability.h?
Now I am on CentOS Linux release 8.3.2011.

Thanks a lot.
Zhu Yanjun


>
> NAME
>        capget, capset - set/get capabilities of thread(s)
>
> SYNOPSIS
>        #include <sys/capability.h>
>
>        int capget(cap_user_header_t hdrp, cap_user_data_t datap);
>
> Have you installed libcap? It contains the sys/capability.h header
> file that you need.
>
> > Now capability.h is in linux directory.
> >
> > Fixes: 3627d9702d78 ("samples/bpf: Sample application for eBPF load and socket creation split")
> > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > ---
> >  samples/bpf/xdpsock_user.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > index aa696854be78..44200aa694cb 100644
> > --- a/samples/bpf/xdpsock_user.c
> > +++ b/samples/bpf/xdpsock_user.c
> > @@ -24,7 +24,7 @@
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > -#include <sys/capability.h>
> > +#include <linux/capability.h>
> >  #include <sys/mman.h>
> >  #include <sys/resource.h>
> >  #include <sys/socket.h>
> > --
> > 2.27.0
> >
