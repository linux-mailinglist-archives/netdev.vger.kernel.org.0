Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD5E3EDEBB
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhHPUo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhHPUo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:44:28 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4303C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:43:56 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z5so35356757ybj.2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aveHwdz8XOLg5uedKS0PiRzGHECFylhR68z7BfBqvPc=;
        b=Yz3Debl4URh7iBQaqrwvr789CHA3V1EyHDhxu2XXGYZJIW1xuqiOmqsa8Byx45dLlf
         CXOKnz5LtK6XekO3z8y1bvSyeBrgFe6/qIEQbKAGcPL955y2fPFKjj2Z4hrfViOcdcwp
         CavbCcXhnlVyIW3Ap26I6sWBeZXc5SsKn477q0/+xOjBJBRMMjpuduZRoFHWMeGZp4Q7
         VXBn3wwENsqpLEBZER6LsgzlbIlc+a/+9xTiOFhh+I9+7q1N97QxBXsgsqpFGqLw3dUW
         Ep2lVPmlXZLhmK2l+nDcaOIKDLRJwAuUUylR80lmcDprUrQpumdWVRHbuQaDFM0i4OZI
         NtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aveHwdz8XOLg5uedKS0PiRzGHECFylhR68z7BfBqvPc=;
        b=IpgP/X1pvE5B6fMHH7MQ4HimQ/6OQOYbn0KPuy+Hd71DUNElkiVCbsJ3mcuYr/0DNZ
         ececYFq3hyW+2BIFwT0XcZVfDhAv0SIKZTZR+ruFJhrYGfoxVwe6XjM3939uC5Pf3iHX
         9jkB7A+sEwQ79Y+kVIQuM8FfTSzSJGW8Dh51dvh/6qYHU/1J5kyWcWgfd5JGfntDNIgF
         MPjlTYQfMPrrKVEgkpLSWP3WNWrHlUsi0FcxwP/SL3OoT4KGRRWjXTSSIi5LSwmKvExv
         OGLbxTaBpdOMWZB4jfXoQyfWsEv/mPQqFRp1V0qIjpUU7c06Uuq1+cG7upXPCaUh4Xtk
         Odrg==
X-Gm-Message-State: AOAM532PVmQfS5d/m8V0Ktg8/C3gX7PBzxRwC6qDbEWkg/wCn0hHgjMP
        JWwFBvFpOlMiLuDiNxP0kZM/8wDsKQeQRHV0LvEyjw==
X-Google-Smtp-Source: ABdhPJz+VPG5W1rq2jkWrRbzKurE6hWPrUc3BPA8am3QAN0qi5OaU9Uf/Rt7REcHo//E3hTfHV4SPbOQ8ILeRS2XNoE=
X-Received: by 2002:a25:8445:: with SMTP id r5mr437513ybm.20.1629146635725;
 Mon, 16 Aug 2021 13:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com> <YRffzVgP2eBw7HRz@lunn.ch>
In-Reply-To: <YRffzVgP2eBw7HRz@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 16 Aug 2021 13:43:19 -0700
Message-ID: <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, kernel-team@android.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 8:22 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Saravana
>
> > Hi Andrew,
> >
>
> > Also there
> > are so many phy related properties that my head is spinning. Is there a
> > "phy" property (which is different from "phys") that treated exactly as
> > "phy-handle"?
>
> Sorry, i don't understand your question.

Sorry. I was just saying I understand the "phy-handle" DT property
(seems specific to ethernet PHY) and "phys" DT property (seems to be
for generic PHYs -- used mostly by display and USB?). But I noticed
there's yet another "phy" DT property which I'm not sure I understand.
It seems to be used by display and ethernet and seems to be a
deprecated property. If you can explain that DT property in the
context of networking and how to interpret it as a human, that'd be
nice.

>
> > +     /*
> > +      * Device tree nodes pointed to by phy-handle never have struct devices
> > +      * created for them even if they have a "compatible" property. So
> > +      * return the parent node pointer.
> > +      */
>
> We have a classic bus with devices on it. The bus master is registers
> with linux using one of the mdiobus_register() calls. That then
> enumerates the bus, looking at the 32 possible address on the bus,
> using mdiobus_scan. It then gets a little complex, due to
> history.
>
> Originally, the only thing you could have on an MDIO bus was a
> PHY. But devices on MDIO busses are more generic, and Linux gained
> support for Ethernet switches on an MDIO bus, and there are a few
> other sort device. So to keep the PHY API untouched, but to add these
> extra devices, we added the generic struct mdio_device which
> represents any sort of device on an MDIO bus. This has a struct device
> embedded in it.
>
> When we scan the bus and find a PHY, a struct phy_device is created,
> which has an embedded struct mdio_device. The struct device in that is
> then registered with the driver core.
>
> So a phy-handle does point to a device, but you need to do an object
> orientated style look at the base class to find it.

Thanks for the detailed explanation. I didn't notice a phy_device had
an mdio_device inside it. Makes sense. I think my comment is not
worded accurately and it really should be:

Device tree nodes pointed to by phy-handle (even if they have a
"compatible" property) will never have struct devices probed and bound
to a driver through the driver framework. It's the parent node/device
that gets bound to a driver and initializes the PHY. So return the
parent node pointer instead.

Does this sound right? As opposed to PHYs the other generic mdio
devices seem to actually have drivers that'll bind to them through the
driver framework.

-Saravana
