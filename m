Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA9D47EB89
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 06:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbhLXFTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 00:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhLXFTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 00:19:01 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5630DC061401;
        Thu, 23 Dec 2021 21:19:00 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id u6so6370755uaq.0;
        Thu, 23 Dec 2021 21:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=A4j7ZbwCysaFys8KHWOf03uVJMHgRAD5iL/gr3YSOIo=;
        b=dzzyoqMlVNdbL83xOHBD8mkbdKjYgZdIBBD4c30v84g0OObj7wxsWElyY9XaQSSVbG
         FqouWGgrj2ydOgvlWZxnH8eIKsS40Dr0+ZfLNsNAO8n6fpdw/CIX0VukDi4c1Q2IzzV1
         EH/Elu5wgaPgMG1WSqggJRzoY+8e4tBF/lqUjdF4RAwrLy8XJwdQFm36Gvuo/YkB4bUJ
         531iPL/RgzAQqSMkYAqvC0OkUSQnXYm7w7LYobR96JoX3FvA5bkOG8ubLCbO3jA26u/Q
         Xkiek6MHEieOPgdvYsZTZdRWLr+cPAdNh+sCIAz7kgYvm1Xra0XR8G02A90MHmY5kjth
         yexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=A4j7ZbwCysaFys8KHWOf03uVJMHgRAD5iL/gr3YSOIo=;
        b=qez4//jmdgyHcyGyL3C5wFUQ3ygA0PnXp+1ot6WM7I/iTD9BBB/Az1omrv13rvFRM5
         yZKZincDPR9oHphrK7GuSt1Z1ZT2bvqM1QjY0fXmmKZyRoeleCVm3UKDBHMgDIynRN8b
         N23inTyEmT3k3n1UpI+kOO2haVizZFGWP39T3fz6B7Tn5QPa8nov6hEvjDhwLDeGZdgO
         Gwdy+C+owp2k4AMY9C/vcFnajHZNLpOE0+DcKZxnfB8QK1tTQiC6IM6jZr0lr2HhrNiq
         X1SqHJuJgz+kt+YjrRoaBtwwC7V2XgK+Mv2TzUaLWocPiuiP3ExoBJcPAldMSnVp/V6S
         nFiw==
X-Gm-Message-State: AOAM532EVlTtq99E92iyH3mDdho1IA/VsxhZZVTDJErHbJ9gn3T8njHh
        65L0TFRO7PSiqOpWlZVG4WQXg+jxceZ+d54t81GCbD66r2k=
X-Google-Smtp-Source: ABdhPJwtCNzmy/xCUBT3v+fUC+dzkvRxot2Azxsu+3b04uWjs52qx9+CzqOtx0RZC1qZXVtkwCnVQImkgWE6xmVn8oA=
X-Received: by 2002:a05:6102:558b:: with SMTP id dc11mr1587075vsb.23.1640323139414;
 Thu, 23 Dec 2021 21:18:59 -0800 (PST)
MIME-Version: 1.0
References: <20210419212525.12894-1-ljp@linux.ibm.com> <161887560929.13803.2397044457894925895.git-patchwork-notify@kernel.org>
In-Reply-To: <161887560929.13803.2397044457894925895.git-patchwork-notify@kernel.org>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 23 Dec 2021 23:18:48 -0600
Message-ID: <CAOhMmr7MSQvHkFucvF-5fvNsm7PCJt_UVEjhuTvSnjHOypvh1g@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: update
To:     Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 6:40 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (refs/heads/master):
>
> On Mon, 19 Apr 2021 16:25:25 -0500 you wrote:
> > I am making this change again since I received the following instructio=
n.
> >
> > "As an IBM employee, you are not allowed to use your gmail account to w=
ork
> > in any way on VNIC. You are not allowed to use your personal email acco=
unt
> > as a "hobby". You are an IBM employee 100% of the time.
> > Please remove yourself completely from the maintainers file.
> > I grant you a 1 time exception on contributions to VNIC to make this
> > change."
> >
> > [...]
>
> Here is the summary with links:
>   - [net] MAINTAINERS: update
>     https://git.kernel.org/netdev/net/c/4acd47644ef1


In the past 8 months I have received many emails from you, asking me
about my current status. I am sorry that I did not have a chance to
answer all of them.

The most questions being asked were =E2=80=9CAre you still with IBM? Did th=
ey
restore you to the previous job?=E2=80=9D. I think I can answer these
questions now. I am not with IBM anymore. I was terminated this month.
I wasn=E2=80=99t able to work on ibmvnic since June, even as a hobby, which
you can figure out from the mailing list traffic. The last 8 months
was tough for me. But I am very thankful to all of you for your
kindness and support.

I will be celebrating the holiday with my family for the rest of the
year. I would be happy to find something worth my time (vs. arguing
about the open source way of doing things with an entity). I would
rather just have a break and relax myself than do something completely
mundane for another company. Thank you in advance for any connections,
advice or opportunities that you can offer.

I have been working on open source projects for 10 years. And I
believe that an entity who truly embraces open source, directs the
engineering work in the open source way, but not just takes open
source as a marketing strategy, will at the end greatly benefit from
the open source community, either in attracting top talent or in
delivering high quality code.

Merry Christmas to You and Your Family!
Lijun
