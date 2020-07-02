Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2BD212030
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGBJlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgGBJlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:41:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51662C08C5C1;
        Thu,  2 Jul 2020 02:41:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so28513599eje.1;
        Thu, 02 Jul 2020 02:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5uetk4l/MbHsFV0PVEK494J/oOl1v9zGOC4JF1Xwlo=;
        b=CnMaYX4ESBZzNTTNlk+O3QnFP8gEjYdxZ2X5fErELFo4pa2B67V71n1GjJpC6BNanv
         lkAf3b4Ugwf20ItQkL3IMb7dWbva/Rj2ItFncu7m6k0CfoRm31NydDLqKlbz9bkfoyCJ
         nSr4q+Kq0k7VmhBDF1yihUHUVudDN/W2d8qk7iclqDgW0UP8UXkdNTANfFVpME+6Rd+4
         9Q9JwlsvvHyIVyZJnIFrhbfGAn0NqgNlqAreYrxSDxPd7EiqFK6iDy/aUwSVCVYFtQxf
         xb8g83T05VlyOtYrloMwL3OM9bbKFZxtev/h93mAKxbn+KBYZxs5VfIpLqRKrAECGJDt
         C2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5uetk4l/MbHsFV0PVEK494J/oOl1v9zGOC4JF1Xwlo=;
        b=tvrAh5zkBpWnWfRnARyAfUqxIiR2I0DXTg65B7+8uA2H4AIZXnY6noL++t1ivcAVWH
         YsvQW9i8mU26YewUc7gWSa7H0UIwzkushhYgPt/knygq9EawfJdoumMuB8+BUf6hwgF4
         vOIGmyVIb2okNFQ7EpiOLrizXNqMQR7GIyjtHpvS11j9NeipfHEl7eZXpvf+/kr0S4+j
         RRUpfLqZ7Co+hf3S8Eekfjlp3ci+jGNYwR1Ex7xaLZzNzqg+OyNiLVX5lRhMhxNIi8H8
         0U/SWy9PMFnHygjHVIo0YuRCByoAeEtTa838jyN1YudZgCEGdmgUfJutb4acuxu2fSnt
         EQCA==
X-Gm-Message-State: AOAM530znVC8vObo1Ka8MafBPDOHTfWJnbM5xi0GcATNjFQAB4ul0u14
        2HeWlRY0cC+N8lWf4Ik8LOgEnCG35u9fCgh4nMph48Mb
X-Google-Smtp-Source: ABdhPJxSq5fW8ouB0Ff5UzExabRnPT2gN9SXVfYg5UOQJRwAFxm06wANAMGgWAVHgRsBNLT95oUmkfrNTL2XMdcoSK0=
X-Received: by 2002:a17:906:1117:: with SMTP id h23mr24492014eja.396.1593682910997;
 Thu, 02 Jul 2020 02:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200701213433.9217-1-michael@walle.cc> <20200701215310.GL1551@shell.armlinux.org.uk>
 <CA+h21hotHbN1xpZcnTMftXesgz7T6sEGCCPzFKdtG1NfMxguLg@mail.gmail.com> <20200702084128.GM1551@shell.armlinux.org.uk>
In-Reply-To: <20200702084128.GM1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 Jul 2020 12:41:39 +0300
Message-ID: <CA+h21hoD0HTtpeGtEFyALg-5b7Gs0qJycukgzhQOGy+xHra23A@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v3 0/3] net: enetc: remove bootloader dependency
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 at 11:41, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Jul 02, 2020 at 01:04:02AM +0300, Vladimir Oltean wrote:
> > On Thu, 2 Jul 2020 at 00:53, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > fixing up almost every driver the best I can with the exception of two -
> > > felix DSA and Mediatek.
> > >
> > > I'm not going to wait for Felix or Mediatek.  As I say, I've given
> > > plenty of warning, and it's only a _suspicion_ of breakage on my
> > > side.
> > >
> >
> > What do you mean "I'm not going to wait for Felix"?
> > https://patchwork.ozlabs.org/project/netdev/patch/20200625152331.3784018-5-olteanv@gmail.com/
> > We left it at:
> >
> > > I'm not going to review patch 7
> > > tonight because of this fiasco.  To pissed off to do a decent job, so
> > > you're just going to have to wait.
> >
> > So, I was actively waiting for you to review it ever since, just like
> > you said, so I could send a v2. Were you waiting for anything?
>
> I stopped being interested in your series with the patch 5 commit
> description issue; what happened there is really demotivating.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Yes, but I mean, the fact that reviewing felix is "demotivating" can
only have 2 courses of action as far as I can see:
- I do resubmit the series with feedback that you've given so far, but
it's likely going to take a few more iterations because you haven't
reviewed the current series in its entirety, and you haven't in fact
reviewed the part which you consider as a dependency for your work yet
(the mac_link_up conversion). But this goes against your argument that
the lynx pcs will land quickly, so Michael should just wait a little
bit more.
- As per your "I'm not going to wait for Felix or Mediatek" phrase,
you might decide you just don't deal with DSA any longer, and you
proceed with the PCS patches by essentially breaking the dependency.
In this case, I'm not sure why Michael would need to wait either,
since _you_ are deciding to not wait for DSA, neither is he.

I'm fine either way, but one thing is not going to change, and that's
the ordering of my patches in the "PHYLINK integration improvements
for Felix DSA driver" series. As you know, most NXP users are not
using David's net-next directly (and that is at their! request), but a
"vendor" kernel which we try to keep as close to David's tree as
humanly possible, and which goes through a lot of testing. But if
there are going to be treewide changes in the phylink API (and there
_are_ already, that mac_link_up thing, which we haven't backported),
then there needs to be a strict ordering relationship between the
cleanup commits, which we can cherry-pick, and the adaptation to an
API which we haven't (nor we intend to) backport to 5.4, because it's
too much for little practical benefit. You seem to be hung up on that,
and we won't be making much progress if that continues, I'm afraid.

There are a lot of things to be done that depend on the lynx-pcs
thing, and there are multiple groups of people who are all waiting.
The new seville DSA driver, which _almost_ got into the previous
release cycle but missed the train due to a dependency with Mark
Brown's tree, also has a Lynx PCS integrated in it. I would like to
reuse the lynx-pcs module, but from what I can see, the bottleneck for
everybody seems to be reviewing the mac_link_up conversion of felix.

Thank you,
-Vladimir
