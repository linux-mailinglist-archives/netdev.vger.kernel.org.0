Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18C3699ED
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbhDWSmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWSmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C9061139;
        Fri, 23 Apr 2021 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619203330;
        bh=qIaVUyzdhjBUU7tl3VOejcO6+StJQjKYlePJddUmi7E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aWSmmAHDhWfWLE27J7QqAexykU5n2y1GB/omH7zwDOAleNlcEqvO2r1rMfIBOL2q7
         Lat+X4UwmhBUzghwYL1bKCHRq97nz9BIxbw15E69e7LN1imyo834aKxbQU2BOZKLG7
         CVyzo1lcmj88d9r6farXjOhA1Rm8GL8AnHsRC8WFMbZJMpPY7B9Lb2pGosTLA2m2+Y
         5hD67MSNjpt5Ga27/Rf1fRdnUh4QwM/XkMrGxJbCtqqFTEORU7D5sq1QWsLr3YhrpA
         0+DeEnj573ny/o1tQZWsJCqSMxo1EYPj1CfYZLrcQJi1p9zO9VbWKG1PLpMe59Egvp
         C5Pgpz85CJBvg==
Received: by mail-ed1-f51.google.com with SMTP id g17so57822888edm.6;
        Fri, 23 Apr 2021 11:42:09 -0700 (PDT)
X-Gm-Message-State: AOAM533dM28BrDcP/pun+4d78kpUgHchAi4Z5zwXS20RVhAa0ChHQU6G
        hQTudVdZFVr8Hb+LSJlyZz35M0FMW+fxtHwpWQ==
X-Google-Smtp-Source: ABdhPJxRxWR99r32kKOjtbYRcF+R9SoFCUGOziFQxhTRy7/ub7acC9s4XzQRvki8x3jvmUqBtR/g+HPM9RbFw1VUkOs=
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr6219150edc.194.1619203328426;
 Fri, 23 Apr 2021 11:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210420024222.101615-1-ilya.lipnitskiy@gmail.com>
 <20210421220302.GA1637795@robh.at.kernel.org> <CALCv0x2oSXBT-6LteYtr9J5XmmDuer_=sbCgB5CBXWe_cKk2sA@mail.gmail.com>
In-Reply-To: <CALCv0x2oSXBT-6LteYtr9J5XmmDuer_=sbCgB5CBXWe_cKk2sA@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 23 Apr 2021 13:41:56 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+Zhgn53wGdMbZKMjxk2gPQQFpjSsudVso+keonDCd+oQ@mail.gmail.com>
Message-ID: <CAL_Jsq+Zhgn53wGdMbZKMjxk2gPQQFpjSsudVso+keonDCd+oQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: mediatek/ralink: remove unused bindings
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 5:05 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> Hi Rob,
>
> On Wed, Apr 21, 2021 at 3:03 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Mon, Apr 19, 2021 at 07:42:22PM -0700, Ilya Lipnitskiy wrote:
> > > Revert commit 663148e48a66 ("Documentation: DT: net: add docs for
> > > ralink/mediatek SoC ethernet binding")
> > >
> > > No in-tree drivers use the compatible strings present in these bindings,
> > > and some have been superseded by DSA-capable mtk_eth_soc driver, so
> > > remove these obsolete bindings.
> >
> > Looks like maybe OpenWRT folks are using these. If so, you can't revert
> > them.
> Indeed, there are out of tree drivers for some of these. I wasn't sure
> what the dt-binding policy was for such use cases - can you point me
> to a definitive reference?

Perhaps we should write that down more explicitly, but I think it is
pretty rare actually. And really, I'd like to require we have at least
1 dts user. Though, then we'd just have dead dts files. More
generally, other projects use the bindings and dts files. The bindings
and dts files live in the kernel tree for convenience and the simple
fact that is where the vast majority of both developers and hardware
support are. There are exceptions of course such as h/w that doesn't
run Linux.

I'm all for removing this if no one cares (please try to find out) or
if the existing binding is just bad (doesn't match the h/w or is
incomplete in an incompatible way). I would have expected in the 5
years since it was added, a user (either dts file or driver) would
have appeared.

Rob
