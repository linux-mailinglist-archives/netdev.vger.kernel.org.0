Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3DA169FAA
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBXIAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:00:07 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34421 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgBXIAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:00:06 -0500
Received: by mail-ed1-f66.google.com with SMTP id r18so10833991edl.1;
        Mon, 24 Feb 2020 00:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3TPleAUgNgDX1i0JZ6Z1GuDFF1HhSm02+337vlCwag=;
        b=cNbz54fCDHS0ScreqVr2XdbiQm37Mqfx2V04lxIzVjWe3oz2yJ4Pu41ykDpr4oKj6G
         EbVkRRpVHHsF5lq0Lu2MgD7786NjqoapCJV0AnfZW+6ca2DvWd7Q2/8sMpW4NfwPuXfc
         dhDDeAUEILQ3KsCghE18Wks9LiucmdnRa6aT60JUUZPS6FOKEjblKNxy9IydYIF+vnPO
         AzStqdgvpkUw6SmSxRrzYdC0sIzQGZi7llTpWYG1WDUW6gfpHWc36Dr1ku3Ro3CjWpCx
         06ncrTh1ioW3stGGhzx9p3yDBv33n1JheXwOeaZbi/Ah8SlF9sRzn5kHsuhQQ9kD4GMU
         lO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3TPleAUgNgDX1i0JZ6Z1GuDFF1HhSm02+337vlCwag=;
        b=fxq1g66dUe+aIyI3dBYFiEHNFWgfq4d4ThAydd8wwPzeu5wX8ZK6zXc7q/LIOY3LNJ
         /TVLa6eX54bzJZWBlRHlq6eoqchAhMAUqo27cgNJqcCYv/Vh+wYP4u/s3lIYFuxNOv+J
         ArINcJpEzRPlA+tooEabTUl/RA8i8NaBQDG6xESApt0Ll2VeufMSEPrO7fgYetY5eBEm
         OB352piFvOvcqIcBvPqjEeBkCgws8fypQUqOUnqPgWf4AoaeLOljBkkcoxDBhJkR4fe2
         wp4OkKbPShdjaVIQTwXeumtAehCF04qCa23xiKcbBrZAKry9B7/338wiPO5kWN4GCigd
         5zeQ==
X-Gm-Message-State: APjAAAU5Jo3Su1uayBXfYwePCEcs7RrjgZyMGEtN+0hvdIVKPc6J4+bz
        OFq9J8kMVQopo+Wj/QW0EBgZxoVnzZhlhzcHH1M=
X-Google-Smtp-Source: APXvYqzDKsSr/zLMTMBZjkKh+5oYwQrP1dYhAZyVY4mr7r0/enepGxWhN24WjF6NFK73tr+1TthN5WZoEpPLDPoHixs=
X-Received: by 2002:aa7:d145:: with SMTP id r5mr45319685edo.337.1582531204774;
 Mon, 24 Feb 2020 00:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20200219151259.14273-1-olteanv@gmail.com> <20200224063154.GK27688@dragon>
In-Reply-To: <20200224063154.GK27688@dragon>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 24 Feb 2020 09:59:53 +0200
Message-ID: <CA+h21hok4V_-uarhnyBkdXqnwRdXpgRJWLSvuuVn8K3VRMtrcA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next/devicetree 0/5] DT bindings for Felix DSA
 switch on LS1028A
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

On Mon, 24 Feb 2020 at 08:32, Shawn Guo <shawnguo@kernel.org> wrote:
>
> On Wed, Feb 19, 2020 at 05:12:54PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > As per feedback received in v1, I've changed the DT bindings for the
> > internal ports from "gmii" to "internal". So I would like the entire
> > series to be merged through a single tree, be it net-next or devicetree.
>
> Will applying the patches via different trees as normal cause any
> issue like build breakage or regression on either tree?  Otherwise, I do
> not see the series needs to go in through a single tree.
>
> Shawn
>

No, the point is that I've made some changes in the device tree
bindings validation in the driver, which make the driver without those
changes incompatible with the bindings themselves that I'm
introducing. So I would like the driver to be operational on the
actual commit that introduces the bindings, at least in your tree. I
don't expect merge conflicts to occur in that area of the code.

Thanks,
-Vladimir
