Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70E548FF3C
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbiAPVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiAPVkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 16:40:19 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28892C061574;
        Sun, 16 Jan 2022 13:40:19 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id 2so2363753uax.10;
        Sun, 16 Jan 2022 13:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gROzuvikK/ATevyfDAedkxS79wFmYsKPnU3R6nd8i+I=;
        b=BXcT789/tu+tczHDLdb5Blg5wGUleoD63VXRwpeK8lXkexvxLVXgJ5nTLBqLiP1oF/
         zvq7mNbpnfllyyC1iA5WmwvJuoM0C4RRkW9jzTGpJ2tOrPqBUcET7LpUlAf+IrOjkAK1
         u1BA/50FPNueazKNYQ1OG1/nh5ARYSbftU2bf59UYotJDhVf8IGSizIMrGVn+ZEfiGuv
         iTJYbYsRxX4CcKwUuAhghckmkTsOtYJsvHgd8mep55GbhTsCk2JpekFJR64j4Huhl5TC
         s3pk+llKXWcAsPH189LxijCTL7HZglzjROcyQnkWuKNRoA+rMvJyd2KkbDlrXo9If9JC
         i5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gROzuvikK/ATevyfDAedkxS79wFmYsKPnU3R6nd8i+I=;
        b=e7abSES3bH7iOpEHNceWO5CoGAfJHArL2ZzxXvv+idASFYCEyXMFdn0AxHYGlJ5M/+
         ri+M/SA9HzPRPnC3GdEBzt7H9BFs45Q3/dtNFJm7P5Nr+QcYkwO0tg3R/2vxThizX7Og
         1TBkUCcSRbPievzkElUPREUrV95k4tMqwJhHyocGjegOrbsdX2nYPr7jGArZSGE/bk84
         n1x1oNw9GHjQMZZBKs2gj9hAucunzNLqy/jhOf72fKfmJ3dyn2+ArxxzOaGDMHHRErb2
         Bc9rSfhUiYbv8sP4LC/96MBbzt/+Ffx4KZwt/Y/Ke0ilakRbDRR7v715E2lFhG7NyWQB
         ONsA==
X-Gm-Message-State: AOAM531VwrO1h6PZ+JzIf13jBOd9k3wfFp+ePJoRmWqPVRMSJG7WlemT
        /huIDopQT6aEeQqva69DgkaTfpoOfW0h2xCVNxEt1uWRx5M=
X-Google-Smtp-Source: ABdhPJxa15rUV4bT1t1aGIRE+kfsOmxmT1MgdJUAtCHwT44yTHf025+0RYwnZMRunF+WB1eP/8koPfHKNOT3n6Vs8+4=
X-Received: by 2002:a67:d51b:: with SMTP id l27mr6164960vsj.23.1642369218144;
 Sun, 16 Jan 2022 13:40:18 -0800 (PST)
MIME-Version: 1.0
References: <20210419212525.12894-1-ljp@linux.ibm.com> <161887560929.13803.2397044457894925895.git-patchwork-notify@kernel.org>
 <CAOhMmr7MSQvHkFucvF-5fvNsm7PCJt_UVEjhuTvSnjHOypvh1g@mail.gmail.com> <CA+pv=HMqeEUnCs3waDKitgmRn=xXX-_AFAOY2ve1zVqQtX0sag@mail.gmail.com>
In-Reply-To: <CA+pv=HMqeEUnCs3waDKitgmRn=xXX-_AFAOY2ve1zVqQtX0sag@mail.gmail.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Sun, 16 Jan 2022 15:40:07 -0600
Message-ID: <CAOhMmr7nR---CWzemaytXDb0jWLFembf5xWkjJsPLuCgkg=czA@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: update
To:     Slade Watkins <slade@sladewatkins.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 11:26 PM Slade Watkins <slade@sladewatkins.com> wro=
te:
>
> On Fri, Dec 24, 2021 at 12:19 AM Lijun Pan <lijunp213@gmail.com> wrote:
> >
> > On Mon, Apr 19, 2021 at 6:40 PM <patchwork-bot+netdevbpf@kernel.org> wr=
ote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net.git (refs/heads/master):
> > >
> > > On Mon, 19 Apr 2021 16:25:25 -0500 you wrote:
> > > > I am making this change again since I received the following instru=
ction.
> > > >
> > > > "As an IBM employee, you are not allowed to use your gmail account =
to work
> > > > in any way on VNIC. You are not allowed to use your personal email =
account
> > > > as a "hobby". You are an IBM employee 100% of the time.
> > > > Please remove yourself completely from the maintainers file.
> > > > I grant you a 1 time exception on contributions to VNIC to make thi=
s
> > > > change."
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [net] MAINTAINERS: update
> > >     https://git.kernel.org/netdev/net/c/4acd47644ef1
> >
> >
> > In the past 8 months I have received many emails from you, asking me
> > about my current status. I am sorry that I did not have a chance to
> > answer all of them.
> >
> > The most questions being asked were =E2=80=9CAre you still with IBM? Di=
d they
> > restore you to the previous job?=E2=80=9D. I think I can answer these
> > questions now. I am not with IBM anymore. I was terminated this month.
> > I wasn=E2=80=99t able to work on ibmvnic since June, even as a hobby, w=
hich
> > you can figure out from the mailing list traffic. The last 8 months
> > was tough for me. But I am very thankful to all of you for your
> > kindness and support.
>
> hi Lijun,
> just wanted to pop in for a sec.
>
> I am so sorry to hear about this and I sincerely hope that you are
> doing better now.
>
> >
> > I will be celebrating the holiday with my family for the rest of the
> > year. I would be happy to find something worth my time (vs. arguing
> > about the open source way of doing things with an entity). I would
> > rather just have a break and relax myself than do something completely
> > mundane for another company. Thank you in advance for any connections,
> > advice or opportunities that you can offer.
>
> please do! relax and don't burn yourself out. everything will be okay wit=
h time!
>
> Merry Christmas and happy holidays to you, and your family! :)
>
> best,
> slade

Thanks for so many of you supporting me and giving me advice during
the holiday season. I would like to share with you one piece of good
news, that is my unemployment benefits was approved by the Texas
Government. It was no easy job since I was fired. And usually a fired
worker does not get unemployment benefits. The reason for the decision
from the Texas Government is crystal clear =E2=80=9COur investigation found
that your employer fired you for a reason that was not misconduct
connected with the work.=E2=80=9D.[1] If it was not misconduct, what was th=
e
reason? You can figure it out.

This company plays the =E2=80=9Cat will=E2=80=9D game to the extreme extent=
.[2] By
firing me before Dec 15, it does not need to match my whole year=E2=80=99s =
6%
401K,[3] it does not need to pay for the rest 2 weeks of December,
when workers are usually laid back and enjoy the holidays. And of
course the company knows I have a 1-year-old child to support, lacking
unemployment benefits would be a disaster to my family. What a company
it is!

I hope, by sharing my own experience with you, it will help when you
pick an offer in the future.

Happy New Year to You and Your Family
Lijun


=E2=80=94
[1] https://drive.google.com/file/d/1JY8f1QLkvlOsQjgPQKDf_RSKEFt7h108

[2] US workers do not actually sign a contract. It is an =E2=80=9Cat will=
=E2=80=9D
offer. Employee and employer can fire/terminate each other at any time
with any reason. It looks fair to both sides, but in fact employees
are usually much weaker in front of employer, in terms of the
resources they own.

[3] https://www.ibm.com/us-en/employment/benefits/assets/2019_Benefits_and_=
HR_Programs.pdf
IBM matches 401K after one year of service, if you are on active
payroll on Dec 15. You may think you should get your first year=E2=80=99s 4=
01K
at the end of your first year. The fact is you don=E2=80=99t get it. For
example, I was hired in Jan 2019, I thought I would have 401K matched
in Dec 2019. But IBM actually started considering 401K matching from
Jan 2020. So in my case I only got Year 2020=E2=80=99s 401K matched at end =
of
Dec 2020. I was fired before Dec 15, 2021, so I did not get the money
for year 2021. Given the example above, you know exactly how good the
401K policy is.
