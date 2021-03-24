Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054EB347A44
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhCXOJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236024AbhCXOJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:09:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7559361A19;
        Wed, 24 Mar 2021 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616594958;
        bh=kUeduJvsn84YXK4bb+nA/McA014H6YlfcxV8YdUzx3c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g5tN3X39v4CBpYTRwQSSANQMcQAjtQ0i7a91DTY0hS1REXVgg/9mR5LrRIu3ui6nX
         +gxElPPx478f7TF0BZapsvKQjpTJIlNl20ZRNXuNa2FEDuHmI4xDyzf7x1w6cYdsWu
         c5a8G3MSsiSELCuUFNIKrgn9FUCSSAlplMKkBTj7VrAFjcoXRDZMG9oAh/z9EYVlHO
         X0kbiLI3oCDds98BmuyKZKC9fC8y4hx67dAInrZ3MEO9aHNdO5GiNPMgK5N08Na2uA
         74IU4GBpqmGirHNS6o2phbNC9sOxh/qDwPxUoCdOhx6Gf1SVz/6Cf2Kcc+UIo6ndBf
         pgTB0FFUgqjDg==
Received: by mail-ed1-f47.google.com with SMTP id x21so27785606eds.4;
        Wed, 24 Mar 2021 07:09:18 -0700 (PDT)
X-Gm-Message-State: AOAM530hk/DAqtBOJKnISE9EZEUK/4V1cWvRR9reFp9eJTvxSaitvGPp
        9RcWF8kp3DAf7LI06QAbWfzF+df5n0md3I70Tg==
X-Google-Smtp-Source: ABdhPJyX/mnmW8cOTU8Sw4MGnxx016fUPpFqLwU8o1JmDdCtaDbw6aJLQmZ4vQbXdwM/zUEMfjI7V7vjMjhQEE+N8hQ=
X-Received: by 2002:a05:6402:c88:: with SMTP id cm8mr3662119edb.62.1616594956908;
 Wed, 24 Mar 2021 07:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210318104036.3175910-1-lee.jones@linaro.org>
 <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com> <20210323083631.GE2916463@dell>
In-Reply-To: <20210323083631.GE2916463@dell>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 24 Mar 2021 08:09:04 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL_V-BgZpSCLL4JQHF3OC-60RPeExkDLf-uSohnpcBdOA@mail.gmail.com>
Message-ID: <CAL_JsqL_V-BgZpSCLL4JQHF3OC-60RPeExkDLf-uSohnpcBdOA@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Rid W=1 warnings from OF
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Anton Vorontsov <anton@enomsg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colin Cross <ccross@android.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev <netdev@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 2:36 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Mon, 22 Mar 2021, Rob Herring wrote:
>
> > On Thu, Mar 18, 2021 at 4:40 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > This set is part of a larger effort attempting to clean-up W=1
> > > kernel builds, which are currently overwhelmingly riddled with
> > > niggly little warnings.
> > >
> > > v2:
> > >  - Provided some descriptions to exported functions
> > >
> > > Lee Jones (10):
> > >   of: device: Fix function name in header and provide missing
> > >     descriptions
> > >   of: dynamic: Fix incorrect parameter name and provide missing
> > >     descriptions
> > >   of: platform: Demote kernel-doc abuse
> > >   of: base: Fix some formatting issues and provide missing descriptions
> > >   of: property: Provide missing member description and remove excess
> > >     param
> > >   of: address: Provide descriptions for 'of_address_to_resource's params
> > >   of: fdt: Demote kernel-doc abuses and fix function naming
> > >   of: of_net: Provide function name and param description
> > >   of: overlay: Fix function name disparity
> > >   of: of_reserved_mem: Demote kernel-doc abuses
> > >
> > >  drivers/of/address.c         |  3 +++
> > >  drivers/of/base.c            | 16 +++++++++++-----
> > >  drivers/of/device.c          |  7 ++++++-
> > >  drivers/of/dynamic.c         |  4 +++-
> > >  drivers/of/fdt.c             | 23 ++++++++++++-----------
> > >  drivers/of/of_net.c          |  3 +++
> > >  drivers/of/of_reserved_mem.c |  6 +++---
> > >  drivers/of/overlay.c         |  2 +-
> > >  drivers/of/platform.c        |  2 +-
> > >  drivers/of/property.c        |  2 +-
> > >  10 files changed, 44 insertions(+), 24 deletions(-)
> >
> > I still see some warnings (note this is with DT files added to doc
> > build). Can you send follow-up patches:
> >
> > ../include/linux/of.h:1193: warning: Function parameter or member
> > 'output' not described in 'of_property_read_string_index'
> > ../include/linux/of.h:1193: warning: Excess function parameter
> > 'out_string' description in 'of_property_read_string_index'
> > ../include/linux/of.h:1461: warning: cannot understand function
> > prototype: 'enum of_overlay_notify_action '
> > ../drivers/of/base.c:1781: warning: Excess function parameter 'prob'
> > description in '__of_add_property'
> > ../drivers/of/base.c:1804: warning: Excess function parameter 'prob'
> > description in 'of_add_property'
> > ../drivers/of/base.c:1855: warning: Function parameter or member
> > 'prop' not described in 'of_remove_property'
> > ../drivers/of/base.c:1855: warning: Excess function parameter 'prob'
> > description in 'of_remove_property'
>
> You don't want much do you! ;)

Hey, want to fix all the schema warnings for me? ;)

>
> Sure, I plan to clean up all of the kernel with subsequent patches.
>
> > BTW, there some more which I guess W=1 doesn't find:
> >
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:906: WARNING: Block quote ends without a blank
> > line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1465: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1469: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1473: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1517: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1521: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1526: WARNING: Unexpected indentation.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1528: WARNING: Block quote ends without a blank
> > line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1529: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1533: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > ../drivers/of/base.c:1705: WARNING: Definition list ends without a
> > blank line; unexpected unindent.
> > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:49:
> > ../drivers/of/overlay.c:1183: WARNING: Inline emphasis start-string
> > without end-string.
>
> What command did you use to find these?

make htmldocs

(with the DT files added to the docs)

These turn out to be the tip of the iceberg. There's all sorts of
formatting issues. Tabs are a problem and the 'Return' section is
wrong. These are only found looking at the output.

Rob
