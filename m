Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE81BD50E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgD2Gts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD2Gtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:49:47 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D014C03C1AD;
        Tue, 28 Apr 2020 23:49:47 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e25so1411637ljg.5;
        Tue, 28 Apr 2020 23:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLyfO06YNkQrkt/n+lUtmzpV34pmsSWhvd7/cIhlh/g=;
        b=I4quxXiaiQUC1Ng6Z2pOf12iiNiizYQGURpAnYPORfqBe9vP7o9PGfk49I73Vyb4h7
         av6sFkb/PQ7QG7Io0Tc6wX17s34U+Nfqax+IhdUAU4nYHjLN+RdD0txcq2iXemt0adtu
         fOzcAbd0Y4As9E7UYm/7ulwSl43AaQ2NinyQW+gPyb7txTw692Tplx+y3cLFQGixOY+V
         oFDzj2JEo702fTnInqiebIM8PvYYiHE+f5SZLkEqHqmDgqTWz0VgZIOb9U+B2fjmzoYr
         fapg17F492QVaP7WGmd+Xwco16MaIT/MfISUYHPzi7V1vrw4vpXEb/YOvttqE2GsQsCI
         LCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLyfO06YNkQrkt/n+lUtmzpV34pmsSWhvd7/cIhlh/g=;
        b=GWMHJi8q9wLaMeRSbYUPcHslddKeEFDqJUPiOSSQg5wXK+Sqk/InV9J2GBpemyGOgk
         R94DsCMiU0YcLQ0Z62TktteISVzaMcDaWn0BhHfINwX6lDTtLJleoZkwQv3ba5yM9OmL
         iDQdnsBs8qOTr9/2s3CPwZq+ISsGCboYr/oVPWhOVbxER5g5cYR9cavSVUAcnBokz6aR
         fD0bzJYEm04a4Zu3r8BMImIk0HEfpcH7oteKTke2Qu0E7nFA3QLaSwLIpd4hbVU8hGhv
         FIInbkr9fMdtjPxMyiM6O6b0dv1fxZikMk/vjByXjmmsxzvUf/QjF7glZkDR5WCP/Upq
         wyqQ==
X-Gm-Message-State: AGi0PuYi2AWXEcqzxhz+7gy2DpXKxkixkfz6SNQV+q8TYpk+sQK/nKts
        JrStsND6WQO+BPsdqGZ2HvducZU+dZvQ8/BM7ls=
X-Google-Smtp-Source: APiQypIYG6NfrVcu1OrpUzo+vOPCq37mbJmawsD3bcdngP1b3YCDUzxh3Bb8gdc9vmhHFrKSZ1H/GIIWWSEa07ubMa0=
X-Received: by 2002:a2e:990f:: with SMTP id v15mr19483327lji.7.1588142985478;
 Tue, 28 Apr 2020 23:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200429164507.35ac444b@canb.auug.org.au> <20200429064702.GA31928@lst.de>
In-Reply-To: <20200429064702.GA31928@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Apr 2020 23:49:34 -0700
Message-ID: <CAADnVQJWLPpt6tEGo=KkLBaHLpwZFLBfZX7UB4Z6+hMf6g220w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
To:     Christoph Hellwig <hch@lst.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:47 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Apr 29, 2020 at 04:45:07PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >
> > Today's linux-next merge of the akpm-current tree got a conflict in:
> >
> >   kernel/sysctl.c
> >
> > between commit:
> >
> >   f461d2dcd511 ("sysctl: avoid forward declarations")
> >
> > from the bpf-next tree and commits:
>
> Hmm, the above should have gone in through Al..

Al pushed them into vfs tree and we pulled that tag into bpf-next.
