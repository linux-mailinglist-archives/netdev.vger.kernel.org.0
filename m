Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8421F21B249
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 11:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgGJJ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgGJJ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 05:29:06 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE80EC08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:29:05 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id t9so2824638lfl.5
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=S/uivifO5g9FxfRNSpxatx43xdheAZQQW9+Fbj995qs=;
        b=zfFFSX+0JHBSlvr5go8MBOrurf/N7Uk7+Tk1fgZjL0V08pN5EDU8fCIjjwuiUMlZHP
         HSH2THaQKGTR9BF6u7Z4FrWC5ok5PYr9X5YQwrLnuF1siFS3MBvk9g8rOZ0ZGwNXBPeW
         srjKgc5QLo1ashdkAYmAVzNUY1C1rbNNqOtx4m1R26AdS9+vYLh2Nt5UNy68O6LwUcYl
         flMYmSeyHPo15z9S99kz93JJNPBx3zDsudFnz9XyYRYIrqx66iYzNPJa+uxymTK4+dFQ
         aVKDeY/Cxa3A/eIps3Ws/zP+WOmjri0ORFZTCW3ibmDyo+HsIvqUIfER/1I2H/HwS6pV
         1I1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=S/uivifO5g9FxfRNSpxatx43xdheAZQQW9+Fbj995qs=;
        b=TxDbUMo5BCCGd5nDRGsG3w/Y1Uo+iMIHTjIlnbS0nLwoKPJsdbq1mp/+3rMhVpPXpp
         DyTGz+wRMwr2EkZVcee1YTy5R7Cp9zJPpSAD4XZFJV4QBpU0/NBwCF+MHxDpw2/W8z2K
         ps6iOq5cz444Qq3pqptPO5fYg8O1bH0C3q6xMTjZDN4oo3s19MEJIGRMdowwgp3sFfuB
         dOFlJafbPmZINYsm+mjYPeBQ+o9hr2vFIys/URyVApIsh1i+6z3Mbvvc7VAw6ESvD7zi
         Y12GmmE4oIizRJXFtdjOHRb7Pp6YUJlz+UznhQsyXdfsNIxgqk/6YE/5xqWfBxi5WJ20
         P0nA==
X-Gm-Message-State: AOAM5327dUkj8dCVnemHkXSP35kvKC7RUgUmSD2Luh4V0Mjyq49yGSQF
        pCECdmWCn/WXCPbrKgu5MfTcI60PRMM4lw==
X-Google-Smtp-Source: ABdhPJz1yAgAkQ3ufvmXAvN2jqiA+Y1RBLdv9C/maJKC9BG8lAFlme8eOmHmwXr7e65X928REVUE9A==
X-Received: by 2002:ac2:544c:: with SMTP id d12mr42360572lfn.97.1594373343568;
        Fri, 10 Jul 2020 02:29:03 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id v10sm1695059ljg.113.2020.07.10.02.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 02:29:02 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
Subject: Re: MDIO Debug Interface
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Fri, 10 Jul 2020 10:51:40 +0200
Message-Id: <C42TDW0HKHP7.1W0IVO67UCM4R@wkz-x280>
In-Reply-To: <20200709223936.GC1014141@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jul 10, 2020 at 2:39 AM CEST, Andrew Lunn wrote:
> On Thu, Jul 09, 2020 at 10:47:54PM +0200, Tobias Waldekranz wrote:
> > Hi netdev,
> >=20
> > TL;DR: Is something like https://github.com/wkz/mdio-tools a good
> > idea?
> >=20
> > The kernel does not, as far as I know, have a low-level debug
> > interface to MDIO devices. I.e. something equivalent to i2c-dev or
> > spi-dev for example.
>
> Hi Tobias
>
> These APIs exist to allow user space drivers. I don't know how much
> that happens now a days, there seems to be a lot of kernel space
> drivers for SPI and I2C, but it is still possible to write user space
> drivers.
>
> We have never allowed user space drivers for MDIO devices. As a
> result, we have pretty good kernel support for PHYs and quite a few L2
> switches, and the numbers keep increasing.

I'd be hesitant to claim any causality between those two statements
though. The way I see it, userspace drivers make sense for
"leaf-devices" i.e. devices which can be used by applications
directly. PHYs are not leaf-devices as they're intimately tied to a
netdev. Switches are doable as leaf-devices, which is why we have
vendor SDKs, but as the plethora of switchdev-ready applications grows
any single vendor won't be able to keep up with the community.

It is not the stick but the carrots that will kill the vendor SDKs.

> But the API you are suggesting sounds like it becomes an easy way for
> vendors to run their SDKs in user space, with a small bit of glue code
> to this new API. That is something we should avoid.
>
> It is a difficult trade off. Such an API as you suggest does allow for
> nice debug tools for driver developers. And i have no problems with
> such a tool existing, being out of tree for any developer to use. But
> i'm not too happy with it being in mainline because i suspect it will
> get abused by vendors.

Five years ago I would have signed on to that. No vendor had even
heard of switchdev and you were laughed out of the room for suggesting
they take that route. These days, they'll typically show switchdev
support as a target on marketing slides etc. Their primary target is
still their own SDK (which makes sense since that's where most of
their customers are), but they see the writing on the wall.

> Something i'm want to look at soon is dumping more of the internal
> state of the mv88e6xxx switches. The full ATU and VTU, TCAM etc. I
> think devlink region could work for this. And i think the ethtool -d
> command could be made a lot better now we have a netlink API. The old
> API assumed a single address space. It would be nice to support
> multiple address spaces.

Yes! I really like this part of devlink as well. I see it as a great
way to add production safe ways of extracting debug information.

> The advantage of these APIs is that they cannot be abused by vendors
> to write user space drivers. But we can still have reasonably powerful
> debug tools built on top of them.

Agreed. The drawback is that they are really only geared towards
non-destructive debugging. Sometimes, especially during development,
that is not enough.

> Andrew

