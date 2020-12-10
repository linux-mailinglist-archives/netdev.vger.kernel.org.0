Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95A12D5812
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgLJKSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgLJKSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:18:00 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D5FC0613CF;
        Thu, 10 Dec 2020 02:17:20 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so3622869pfu.1;
        Thu, 10 Dec 2020 02:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1GNlk+sMt03zW3RJz1MQRTqkMVaVyhGe/dSlf7Cqn4=;
        b=pIY+tLvtWWNfOAXPaSavrpTgFYmDboG6IC8Pppte6rzX0gQ8GPCAH4ZgKv5h5uBQYG
         gvaEcy3wF9hdBPqwShxn/oORarKmYqVW7SeU73zjrLCnisgdJKUlNk+mxx8GhrUpXpkQ
         3tqMjcvy15ECZImd81vCbh3OI7f7B5MibU+mUH2TvQsZ0orhfq+KTmNfvHOOA5IOphoV
         UiBX74wWV2bKL3/z7hYKlXN+rrAQuvq3rV7z5oR05QJXKBb/jtYX2LIePEZkgqRgdEvR
         D6V6LKPEp+f76yOYs/NuXKOogYLS6fHHy9NYBc7FelEMpup5invXi/hUFq77lKhYUX0q
         73kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1GNlk+sMt03zW3RJz1MQRTqkMVaVyhGe/dSlf7Cqn4=;
        b=Zfz7d1vFlu1chIjvJPhqTETmfQypBd3zc/BbYXcuI3OR/Bjt02LssXCSvQ57q/pire
         jW6tHczZTq0pJ99Vmv+2rjfeDLvRdR8OFtF5pkVOi1VdLWYq3mF7XUiWVyApk2iqTKA/
         701wZmC0+c83Gc2qJUb8SIC8KC/pZVvb3omyfu7ay7hGkX6XdBCS+tLXauGY74k2P/Uf
         4qVwg4e+XqZj/cMCnsMsoR/VRqn7jFOmPsyC3tU6aQl7g8DS93dSsCTCwmCp3buEjHH4
         Mg5VCvmcsHz3O6QJtqKCIN2QaYpOsDj3hBbx933FsZNLhj0/xZ4Q23I/coam+msUn6N2
         Huig==
X-Gm-Message-State: AOAM533HYUOEdFVV1wFfEpQy4YOZFiZr48VKxHMPod8OdW7D/XELfYVc
        DI4Qu9k29g5DthnR2pUm7+Mxxftv/vxyn2oU2lQ=
X-Google-Smtp-Source: ABdhPJz5VphjndpowVyThCko817PLagCO8ZMN3OGxx5tp7Ctt7Riay98gM8Rn6Q/PdQpQusBYvhFSLs1r97UgiL6WGQ=
X-Received: by 2002:a63:d312:: with SMTP id b18mr6003383pgg.233.1607595440348;
 Thu, 10 Dec 2020 02:17:20 -0800 (PST)
MIME-Version: 1.0
References: <20201209033346.83742-1-xie.he.0141@gmail.com> <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
 <CAJht_EMQFtR_-QH=QMHt9+cLcNO6LHBSy2fy=mgbic+=JUsR-Q@mail.gmail.com> <3e7fb08afd624399a7f689c2b507a01e@AcuMS.aculab.com>
In-Reply-To: <3e7fb08afd624399a7f689c2b507a01e@AcuMS.aculab.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 10 Dec 2020 02:17:09 -0800
Message-ID: <CAJht_EMqO8cS3BSnqHA=ROqbkpum8JB_FjzRgPuW=up+e4bO1w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 1:14 AM David Laight <David.Laight@aculab.com> wrote:
>
> > To me, LLC1 and LLC2 are to Ethernet what UDP and TCP are to IP
> > networks. I think we can use LLC1 and LLC2 wherever UDP and TCP can be
> > used, as long as we are in the same LAN and are willing to use MAC
> > addresses as the addresses.
>
> Except that you don't have any where near enough 'ports' so you need
> something to demultiplex messages to different applications.

Yes, LLC only has 256 "ports" compared to more than 60000 for UDP/TCP.

> We (ICL) always ran class 4 transport (which does error recovery)
> directly over LLC1 using MAC address (a NUL byte for the network layer).
> This requires a bridged network and globally unique MAC addresses.
> Sending out an LLC reflect packet to the broadcast MAC address used to
> generate a couple of thousand responses (many would get discarded
> because the bridges got overloaded).

Wow, You have a really big LAN!

> > X.25 layer 3 certainly can also run over LLC2.
>
> You don't need X.25 layer 3.
> X.25 layer 2 does error recovery over a point-to-point link.
> X.25 layer 3 does switching between machines.
> Class 2 transport does multiplexing over a reliable lower layer.
> So you normally need all three.

Yes, I was just saying X.25 layer 3 can run over any reliable
point-to-point links, including X.25 layer 2, LLC2 and TCP.

> However LLC2 gives you a reliable connection between two machines
> (selected by MAC address).
> So you should be able to run Class 2 transport (well one of its
> 4 variants!) directly over LL2.

Yes.

> The advantage over Class 4 transport over LLC1 is that there is
> only one set of retransmit buffers (etc) regardless of the number
> of connections.

Right. But nowadays we have big enough memories for many buffers, so
it may be preferable to make connections operate independent of each
other. This way one lost frame wouldn't affect all connections. This
is also why HTTP3 moved to QUIC instead of using TCP.

> But this is all 30 year old history...

Haha, we are talking about really old technologies.
