Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A254347BD6
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbhCXPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhCXPMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:12:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70790C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:12:43 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u5so33483321ejn.8
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rpBp7AJWNevm6XgUCf8It0J8VZS6BW6Ytb0WBwtBHdg=;
        b=x11HJDqtbJl0RTpUhMaDPb+kNEbmK+x5fbaCoTlVUixv/5/HaAKw5Dd64BEzGfofMF
         LsiqJbFAT9WHMm99hUYfuEDak85bttisRRf9s3bKL1BN0APkM6sylKDQXTjUA0Krl8Ru
         CNoisLPabGDqyzctcBzGz4EvgUYvZqk2SWRCiURdFg9nCxJS8HTAaXAPUnlctXvSKYis
         c7Y1J7evNK9i4fQ+v/G861QyFoaqXSjPTaDoaVmX0cxcbv4WL0Bc/l+UY96uQjb99cE/
         JMlR8tw9iWKmc5qM/OEANq7az5sws7cbVpl3zl7rP3B3q7hxIGB489EQwO6da6fmjrlw
         TkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rpBp7AJWNevm6XgUCf8It0J8VZS6BW6Ytb0WBwtBHdg=;
        b=GYReaFhWiIlXfypuXx7k8JZE0dYHA2Vz8JaZJ+E+qZrcuNtjfjr6wym1tAD6AzFZPD
         jkiPlG7Yi/wZUbo6Oo8VxN1nThiRRzESwr+vSwgqdrByrAPVhSUVJVIR721tOYSmsOSe
         JxddH9lIm719LPDTZMG/sZYwAlNAEfDWivMMFHOvCdhWDxxnYGt5zLN4nST/wxQXUrgg
         TkDfafn/oQf/16jryJ2K2Es2vX7dy6OhskuuD6+6SG//jrhVIQXXUZPe15YkLwpYkfx+
         F1s6iz15J77u0u5htElxbTqevLnnmV619P2HzHUAsOJMxdkJ6ri3d2UoQbDFWF6n3I1z
         1T/g==
X-Gm-Message-State: AOAM5337n4tNQNY5oHOmDKiL0PJWbyTsf38Ue4CohJ96fiKImrQA3ZAZ
        9FbwC+nBeSXSugI7EKTLmo6RPQ==
X-Google-Smtp-Source: ABdhPJzg53S6lyQmMlD42NaqXRVBk89kv+dLjpRmEQhNsToTbn1tsv8VtnmWHHyP74tBd6ePTRJ0pw==
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr4234588eje.247.1616598762069;
        Wed, 24 Mar 2021 08:12:42 -0700 (PDT)
Received: from dell ([91.110.221.180])
        by smtp.gmail.com with ESMTPSA id q12sm1064411ejy.91.2021.03.24.08.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:12:41 -0700 (PDT)
Date:   Wed, 24 Mar 2021 15:12:39 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>
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
Subject: Re: [PATCH v2 00/10] Rid W=1 warnings from OF
Message-ID: <20210324151239.GP2916463@dell>
References: <20210318104036.3175910-1-lee.jones@linaro.org>
 <CAL_JsqKueTWKbXNuN+74COR1LT6XLyw61GqCLpOgv-knNtEdKg@mail.gmail.com>
 <20210323083631.GE2916463@dell>
 <CAL_JsqL_V-BgZpSCLL4JQHF3OC-60RPeExkDLf-uSohnpcBdOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqL_V-BgZpSCLL4JQHF3OC-60RPeExkDLf-uSohnpcBdOA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021, Rob Herring wrote:

> On Tue, Mar 23, 2021 at 2:36 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Mon, 22 Mar 2021, Rob Herring wrote:
> >
> > > On Thu, Mar 18, 2021 at 4:40 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > >
> > > > This set is part of a larger effort attempting to clean-up W=1
> > > > kernel builds, which are currently overwhelmingly riddled with
> > > > niggly little warnings.
> > > >
> > > > v2:
> > > >  - Provided some descriptions to exported functions
> > > >
> > > > Lee Jones (10):
> > > >   of: device: Fix function name in header and provide missing
> > > >     descriptions
> > > >   of: dynamic: Fix incorrect parameter name and provide missing
> > > >     descriptions
> > > >   of: platform: Demote kernel-doc abuse
> > > >   of: base: Fix some formatting issues and provide missing descriptions
> > > >   of: property: Provide missing member description and remove excess
> > > >     param
> > > >   of: address: Provide descriptions for 'of_address_to_resource's params
> > > >   of: fdt: Demote kernel-doc abuses and fix function naming
> > > >   of: of_net: Provide function name and param description
> > > >   of: overlay: Fix function name disparity
> > > >   of: of_reserved_mem: Demote kernel-doc abuses
> > > >
> > > >  drivers/of/address.c         |  3 +++
> > > >  drivers/of/base.c            | 16 +++++++++++-----
> > > >  drivers/of/device.c          |  7 ++++++-
> > > >  drivers/of/dynamic.c         |  4 +++-
> > > >  drivers/of/fdt.c             | 23 ++++++++++++-----------
> > > >  drivers/of/of_net.c          |  3 +++
> > > >  drivers/of/of_reserved_mem.c |  6 +++---
> > > >  drivers/of/overlay.c         |  2 +-
> > > >  drivers/of/platform.c        |  2 +-
> > > >  drivers/of/property.c        |  2 +-
> > > >  10 files changed, 44 insertions(+), 24 deletions(-)
> > >
> > > I still see some warnings (note this is with DT files added to doc
> > > build). Can you send follow-up patches:
> > >
> > > ../include/linux/of.h:1193: warning: Function parameter or member
> > > 'output' not described in 'of_property_read_string_index'
> > > ../include/linux/of.h:1193: warning: Excess function parameter
> > > 'out_string' description in 'of_property_read_string_index'
> > > ../include/linux/of.h:1461: warning: cannot understand function
> > > prototype: 'enum of_overlay_notify_action '
> > > ../drivers/of/base.c:1781: warning: Excess function parameter 'prob'
> > > description in '__of_add_property'
> > > ../drivers/of/base.c:1804: warning: Excess function parameter 'prob'
> > > description in 'of_add_property'
> > > ../drivers/of/base.c:1855: warning: Function parameter or member
> > > 'prop' not described in 'of_remove_property'
> > > ../drivers/of/base.c:1855: warning: Excess function parameter 'prob'
> > > description in 'of_remove_property'
> >
> > You don't want much do you! ;)
> 
> Hey, want to fix all the schema warnings for me? ;)

Definitely not.  I've even gone to the trouble of disabling them. :D

> > Sure, I plan to clean up all of the kernel with subsequent patches.
> >
> > > BTW, there some more which I guess W=1 doesn't find:
> > >
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:906: WARNING: Block quote ends without a blank
> > > line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1465: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1469: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1473: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1517: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1521: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1526: WARNING: Unexpected indentation.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1528: WARNING: Block quote ends without a blank
> > > line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1529: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1533: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:19:
> > > ../drivers/of/base.c:1705: WARNING: Definition list ends without a
> > > blank line; unexpected unindent.
> > > /home/rob/proj/git/linux-dt/Documentation/driver-api/devicetree:49:
> > > ../drivers/of/overlay.c:1183: WARNING: Inline emphasis start-string
> > > without end-string.
> >
> > What command did you use to find these?
> 
> make htmldocs
> 
> (with the DT files added to the docs)
> 
> These turn out to be the tip of the iceberg. There's all sorts of
> formatting issues. Tabs are a problem and the 'Return' section is
> wrong. These are only found looking at the output.

Heh!  Depends how desperate I get. :'D

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
