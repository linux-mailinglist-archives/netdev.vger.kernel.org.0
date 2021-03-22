Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D0345261
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 23:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCVWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 18:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhCVWXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 18:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDC5619A3;
        Mon, 22 Mar 2021 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616451783;
        bh=9TOm/vUdTVgkLrEcvTO6xa6y15f8WUxq5hs+UGMAt0w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U0iFIjhulmjOHIH4ZCHGXKBTlk4hg5aK/NBUps8Mp8OdMncu+JsfhCVHc7Fy3mjMN
         v5dLlyafisbAoZ8bJQoxyZnlOYisXMLnrd9/ZIM78JjzH+AN9ftQHRa2Xf233ycVwI
         BVwvGUEBoJJCDGnMeh4GCYDVHEGKBMraxikxVROOKW27S8ShtH/HbOsUp/rQQIxn28
         YjnDkmRrGWFYvA08QXRjzGxJRX742mBWY5tmsSxZgcIEVYdyMAH+Qal1CA+pnkv7d+
         ljAMmRoEzgEP06BBkCm3ndmMb3Qgxj09+pxbrlwhqkM4k0YHn2ujTtAoY2q8MEUAt6
         T/XvKWUgQgG6A==
Received: by mail-ej1-f49.google.com with SMTP id e14so5640164ejz.11;
        Mon, 22 Mar 2021 15:23:02 -0700 (PDT)
X-Gm-Message-State: AOAM5330Ufdgf6tRqDczHDez93+Fm9OxshlyUk4PN1aqi63/hogG5m9a
        I4GYE0oMM293hW9CH3X/oPzxe5457yGKLi4RlA==
X-Google-Smtp-Source: ABdhPJx3z7wXtL8KQ3NRS45wE2EUgPtOjsUMqBUiolC7/JCPmaRaai1z8yHmFPME7Qtf+AsOQ2F81DUULd1XRtw/K00=
X-Received: by 2002:a17:906:d153:: with SMTP id br19mr1849046ejb.360.1616451781529;
 Mon, 22 Mar 2021 15:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210318104036.3175910-1-lee.jones@linaro.org>
In-Reply-To: <20210318104036.3175910-1-lee.jones@linaro.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 22 Mar 2021 16:22:49 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com>
Message-ID: <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com>
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

On Thu, Mar 18, 2021 at 4:40 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
>
> v2:
>  - Provided some descriptions to exported functions
>
> Lee Jones (10):
>   of: device: Fix function name in header and provide missing
>     descriptions
>   of: dynamic: Fix incorrect parameter name and provide missing
>     descriptions
>   of: platform: Demote kernel-doc abuse
>   of: base: Fix some formatting issues and provide missing descriptions
>   of: property: Provide missing member description and remove excess
>     param
>   of: address: Provide descriptions for 'of_address_to_resource's params
>   of: fdt: Demote kernel-doc abuses and fix function naming
>   of: of_net: Provide function name and param description
>   of: overlay: Fix function name disparity
>   of: of_reserved_mem: Demote kernel-doc abuses
>
>  drivers/of/address.c         |  3 +++
>  drivers/of/base.c            | 16 +++++++++++-----
>  drivers/of/device.c          |  7 ++++++-
>  drivers/of/dynamic.c         |  4 +++-
>  drivers/of/fdt.c             | 23 ++++++++++++-----------
>  drivers/of/of_net.c          |  3 +++
>  drivers/of/of_reserved_mem.c |  6 +++---
>  drivers/of/overlay.c         |  2 +-
>  drivers/of/platform.c        |  2 +-
>  drivers/of/property.c        |  2 +-
>  10 files changed, 44 insertions(+), 24 deletions(-)

I still see some warnings (note this is with DT files added to doc
build). Can you send follow-up patches:

../include/linux/of.h:1193: warning: Function parameter or member
'output' not described in 'of_property_read_string_index'
../include/linux/of.h:1193: warning: Excess function parameter
'out_string' description in 'of_property_read_string_index'
../include/linux/of.h:1461: warning: cannot understand function
prototype: 'enum of_overlay_notify_action '
../drivers/of/base.c:1781: warning: Excess function parameter 'prob'
description in '__of_add_property'
../drivers/of/base.c:1804: warning: Excess function parameter 'prob'
description in 'of_add_property'
../drivers/of/base.c:1855: warning: Function parameter or member
'prop' not described in 'of_remove_property'
../drivers/of/base.c:1855: warning: Excess function parameter 'prob'
description in 'of_remove_property'

BTW, there some more which I guess W=1 doesn't find:

/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:906: WARNING: Block quote ends without a blank
line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1465: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1469: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1473: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1517: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1521: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1526: WARNING: Unexpected indentation.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1528: WARNING: Block quote ends without a blank
line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1529: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1533: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
../drivers/of/base.c:1705: WARNING: Definition list ends without a
blank line; unexpected unindent.
/home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:49:
../drivers/of/overlay.c:1183: WARNING: Inline emphasis start-string
without end-string.

Rob
