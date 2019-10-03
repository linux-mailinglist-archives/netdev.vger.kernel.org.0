Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E60CAAF7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbfJCRQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:16:18 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:40394 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389996AbfJCQYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:24:33 -0400
Received: by mail-qt1-f174.google.com with SMTP id f7so4416785qtq.7
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 09:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IvL+ss5T/k+nRhw+VVeKHbu6m5dVP+TtYYrk2WT58Ys=;
        b=CUfiqqy8+I5a30W+hCyIRDSjjuYsB5Fbez36xVmF3/kyiYOUNtTNC6Gm/+uJeYtHON
         dFv3aueBXFsmvcDh8F6C7BGM6PvVueamQ0KuNBIPxdA+t3GhmLbU7BPMTj8qLd/PGjFk
         I+rt5GXZR8kbWYRJXS0Sz5rgTPg1FWtyxS7LBuMBbY8T1mcjOTkqf9WHOci2DcKP8MU3
         hDcrY+Zk8k1u1FzRnzV03tq3qiYNsxgLeWLN5N6nM269g+wFJC8rCt07jTvnf/1f4cqy
         CBc9FQ3UWt94tCWgT8l4al35zSCnVyn7p4OmM/xuJwiPZAH3HKOs6jqQ61q307X9cqxI
         BK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IvL+ss5T/k+nRhw+VVeKHbu6m5dVP+TtYYrk2WT58Ys=;
        b=J/mtnyAmVbpjb1dK2ILLq4m49NoAKmZm9n2NVM4eXEUPDYFCP+QErPi5ayQ02ysWsp
         e9WFzD5GknaG5TwdQ3RpkJazflnoSWoSeF1guJ2cB2r0pFdx19bmDqlJeboUuhpfrhpK
         0c7PdhLiFltZc5/U/mGlnfbmSIKqLsAPQOV8z8IQ3V3vF8OKQcyY2EAc57uL6HhDc5Hh
         T+osxt1MHCdiG6WooHNuz5O73ZHBjgnTi6lWo09u1odipwsJk6b+pDrCn5bj5/BXh2Ub
         Vfgha4QySzShpVtHzDJtRkezXfNt0Vdmokwis2nLrlO7pzK3HGE5mCLlqNH5pQlncO6t
         b4Xw==
X-Gm-Message-State: APjAAAWxekmY217hvaxAcaKhBylW3LgwA2CJ30poNeVO7xTkpt+ZuEqo
        KDy5gfz9H93h7UXdf1m6lItxo/ldVX4hxIgt02s=
X-Google-Smtp-Source: APXvYqygh5EyHf7jU6Y9qtnoOy/vcbTDDBfxZ8UevgY1feegHuB0lkgs0XLTXvYC0JE3XsH8BisZctYGY3B/Y/V+rp8=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr10640455qtq.141.1570119872231;
 Thu, 03 Oct 2019 09:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
 <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com> <8B38D651-7F77-485F-A054-0519AF3A9243@fb.com>
 <20191003111029.GC23291@krava>
In-Reply-To: <20191003111029.GC23291@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 09:24:21 -0700
Message-ID: <CAEf4BzamREOTYvspbg5yp1igg8pY_0MQu93Y34w1t_WT9VJXNg@mail.gmail.com>
Subject: Re: libbpf distro packaging
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Julia Kartseva <hex@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 4:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 03, 2019 at 12:50:08AM +0000, Julia Kartseva wrote:
> > Hi Jiri,
> >
> > v0.0.5 is out: [1] which brings questions regarding further maintenance
> > of rpm.
> > Who'll maintain the most recent version of rpm up-to-date?
>
> I will do that on fedora/rhel side now
>
> > Are you looking into making the procedure automated and do you need any
> > help from the side of libbpf devs if so? In particular, we can have the=
 *.spec file
> > in GH mirror synchronized with the most recent tag so you can take it f=
rom the
> > mirror along with tarball.
>
> some notification of new tag/sync would be great

Hey Jiri! You can watch Github repo for new releases, see
https://help.github.com/en/articles/watching-and-unwatching-releases-for-a-=
repository.

>
> the spec file update is not a big deal because I need to do its
> changelog update anyway.. but I can put the fedora rpm spec in
> GH repo for reference, I will do a pull request for that
>
> jirka
>
> > Thanks!
> >
> > [1] https://github.com/libbpf/libbpf/releases/tag/v0.0.5
> >
> > =EF=BB=BFOn 9/30/19, 11:18 AM, "Julia Kartseva" <hex@fb.com> wrote:
> >
> > > Thank you Jiri, that's great news.
> > >
> > > > On 9/30/19, 4:13 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> > > >
> > > > heya,
> > > > FYI we got it through.. there's libbpf-0.0.3 available on fedora 30=
/31/32
> > > > I'll update to 0.0.5 version as soon as there's the v0.0.5 tag avai=
lable
> >
> >
> >
