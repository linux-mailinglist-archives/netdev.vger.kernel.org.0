Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C802116A071
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgBXIvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:51:52 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39865 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXIvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:51:51 -0500
Received: by mail-ed1-f66.google.com with SMTP id m13so10969006edb.6;
        Mon, 24 Feb 2020 00:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFzRwB7BBf5XP5+OFLKMdHWONCapTDpeZv+928ShWX4=;
        b=SSfMJFQXTZjxh7uG1r9983G2qntKODxS60oAWXylxplre7Ls1BUJi3hiqsApgfGHiC
         Qs1AYwO10Pw1W9CZHeeoPn/m3VVS6ysb9cD9HYwP42cu0EGIPuaZbODmJ5vgnT9v8/5p
         ZiNGVE2dPLy2uJqbKs0HCV1ujQzo39hQRLWtiYb+xv9HdGUu2SG2dG3YDRtLCzITungk
         aVYRzqL63xqOTK6WiUeTYe3GHhj43WsvzDCrAMr3Z+rb47+fleOBRALKv9Yr+lrxFuIV
         yuQTAk/BKVfnzF2lLeWK3tjvogP0rC1E8NRTZvnlBmKLDoD5wTUQqKSHnjFOMLeGD5qL
         hG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFzRwB7BBf5XP5+OFLKMdHWONCapTDpeZv+928ShWX4=;
        b=ap0Kj+/RAdL4l9iUhbhqhOSDlf0WJBG37g5PF2wrnf8io0I5oaIQLLVa1ROOTdZf19
         97eXRbaYnHsrSaKYrPwTlJrMdY4wuIMaI84A4AhA78nEUmGh3U75ISefL9guG0FLD9am
         /10U56PAftEIxizPg3FzRxWeNs+8zd1tg4tiwfiFVqjvkrpNng6FCT7Foc/v06Rl8dSd
         hq9raIeLumznXSAqYUOxHGg6wl0m1hi5LqFnrVEDErIJpRKX9Wt0sd17h8KGrL1tohji
         joLMahu5CnCS+MT84iub3bdJK5akERQwfcvidnQl5xVl4zqF7hL5LyS0TFURQL4EItrb
         Dn7g==
X-Gm-Message-State: APjAAAXGQblh28Yx5f1hn1RKq/hjO6r3CkjYFqOhHVlMnjfS6hrRIgjf
        /m8cZna+vH/CIp3WDh2Ja4UcpXfHHeScL/D8y1E=
X-Google-Smtp-Source: APXvYqwoC1uyDhQknoARKL/WBeS6z2D7bovskBXRovKJrr7Ac9B22XojgLAAz1U59AyAVHl9V72z9MHNP47liscy5yE=
X-Received: by 2002:a17:907:2636:: with SMTP id aq22mr29749373ejc.176.1582534309832;
 Mon, 24 Feb 2020 00:51:49 -0800 (PST)
MIME-Version: 1.0
References: <20200219151259.14273-1-olteanv@gmail.com> <20200224063154.GK27688@dragon>
 <CA+h21hok4V_-uarhnyBkdXqnwRdXpgRJWLSvuuVn8K3VRMtrcA@mail.gmail.com>
 <20200224084826.GE27688@dragon> <CA+h21hop_veYT7Ru6os2iqPV_tO+6vkZPo6sqgVf9GcNAsjWuw@mail.gmail.com>
In-Reply-To: <CA+h21hop_veYT7Ru6os2iqPV_tO+6vkZPo6sqgVf9GcNAsjWuw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 24 Feb 2020 10:51:39 +0200
Message-ID: <CA+h21hr_VpU1yMNat7M=J35cQ__LB69YNvXXsuxg+t4zQS4WkA@mail.gmail.com>
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

On Mon, 24 Feb 2020 at 10:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, 24 Feb 2020 at 10:48, Shawn Guo <shawnguo@kernel.org> wrote:
> >
> > On Mon, Feb 24, 2020 at 09:59:53AM +0200, Vladimir Oltean wrote:
> > > Hi Shawn,
> > >
> > > On Mon, 24 Feb 2020 at 08:32, Shawn Guo <shawnguo@kernel.org> wrote:
> > > >
> > > > On Wed, Feb 19, 2020 at 05:12:54PM +0200, Vladimir Oltean wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > As per feedback received in v1, I've changed the DT bindings for the
> > > > > internal ports from "gmii" to "internal". So I would like the entire
> > > > > series to be merged through a single tree, be it net-next or devicetree.
> > > >
> > > > Will applying the patches via different trees as normal cause any
> > > > issue like build breakage or regression on either tree?  Otherwise, I do
> > > > not see the series needs to go in through a single tree.
> > > >
> > > > Shawn
> > > >
> > >
> > > No, the point is that I've made some changes in the device tree
> > > bindings validation in the driver, which make the driver without those
> > > changes incompatible with the bindings themselves that I'm
> > > introducing. So I would like the driver to be operational on the
> > > actual commit that introduces the bindings, at least in your tree. I
> > > don't expect merge conflicts to occur in that area of the code.
> >
> > The dt-bindings patch is supposed to go through subsystem tree together
> > with driver changes by nature.  That said, patch #1 and #2 are for
> > David, and I will pick up the rest (DTS ones).
> >
> > Shawn
>
> Ok, any further comments on the series or should I respin after your
> feedback regarding the commit message prefix and the status =
> "disabled" ordering?
>
> -Vladimir

By the way all your comments have been on v2 and I've sent v3 already.
So this series is superseded.

Regards,
-Vladimir
