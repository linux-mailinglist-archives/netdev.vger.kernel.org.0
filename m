Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0395621AB04
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGIW53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgGIW53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:57:29 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFADC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 15:57:29 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id z17so3095253edr.9
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 15:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SoRqBHHWyZgrISFV5W3Qq/uD1jjlgW+w82nM0RwwXMg=;
        b=Xv6JD3KCyVefFacB8Gwoz+FTYrQkE6CZRkhe1GNth//AWI8hJuxL3+mBaSaP0vY1Iw
         AcrN83odnrHC5I4sZQ3T4dxRik6cnPm81kT4dBjAM36Rs00kBOfN4dCysz2dELQti3zK
         6DyRYxNNQKQlbz33RT89Vf+YioDdcRnWas3JN2BigiQZ1DacdD5TcHgBYTSgvLOf0SKP
         QfMZ0zr8gVQNRkdfNtCUvCn5/DwgYE48Ahb3XYgS0si8HCKBExG5sZQEIhOJSxKkF5Sr
         +zSFcu70EskTZ7O1cUFPpRgc2Etp61Y1f5MXsblhFhGik4GjYgrDoml6fRL/3bO34Q69
         b8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SoRqBHHWyZgrISFV5W3Qq/uD1jjlgW+w82nM0RwwXMg=;
        b=OT1PV0Bdfl9xalvgXv82q4jHQdurvjZmiSiFOlydAwQOQHfrLqPxnHyU/61shLNAmN
         aEF2wI6xpnYX3vSIBFUQ/yZujHu93mjFqbbaPwqQ8rUu/meIeUXgY/Uaryo1l9kUINDn
         09jhQIWI6EWB2gDJecGAHZ3TStXZpiT4U1C2waJwxgQQu3rBPJQtqNHcZ62X1VjFWrSh
         aF68BvIVCh7UYdB4lBTgEklQy71onPDtoot+KLOBgXn3RhPAS5d9BOJaOGrA1+KGSfzc
         xUWBckD7JniseKTTOYWAe9J10LXJwwd2eeEWI0HQIaQ7fVa+BO6bH0wIKmNQIZ1MXFpC
         jQtw==
X-Gm-Message-State: AOAM532pDzcFATJ2wcvi0KpwPwbWAvTAZ0gswSwR+SgBxsxR7fEc/g3y
        xIlnhY73ktaZGkxG4pH+d8lqhhZO
X-Google-Smtp-Source: ABdhPJwnmEMXbTRTdDj4XvXJBL7AKIjbMUHcU9+YhlRWv/Fj6gA8uuI0oqXFqGEfGfe9a4McjVCWyg==
X-Received: by 2002:a05:6402:21d3:: with SMTP id bi19mr75762868edb.56.1594335447809;
        Thu, 09 Jul 2020 15:57:27 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id r17sm2944120edw.68.2020.07.09.15.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 15:57:27 -0700 (PDT)
Date:   Fri, 10 Jul 2020 01:57:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709225725.xwmyhny4hmiyb5nt@skbuf>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
 <20200709223936.GC1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709223936.GC1014141@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jul 10, 2020 at 12:39:36AM +0200, Andrew Lunn wrote:
> On Thu, Jul 09, 2020 at 10:47:54PM +0200, Tobias Waldekranz wrote:
> > Hi netdev,
> > 
> > TL;DR: Is something like https://github.com/wkz/mdio-tools a good
> > idea?
> > 
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
> 
> But the API you are suggesting sounds like it becomes an easy way for
> vendors to run their SDKs in user space, with a small bit of glue code
> to this new API. That is something we should avoid.
> 
> It is a difficult trade off. Such an API as you suggest does allow for
> nice debug tools for driver developers. And i have no problems with
> such a tool existing, being out of tree for any developer to use. But
> i'm not too happy with it being in mainline because i suspect it will
> get abused by vendors.
> 
> Something i'm want to look at soon is dumping more of the internal
> state of the mv88e6xxx switches. The full ATU and VTU, TCAM etc. I
> think devlink region could work for this. And i think the ethtool -d
> command could be made a lot better now we have a netlink API. The old
> API assumed a single address space. It would be nice to support
> multiple address spaces.
> 
> The advantage of these APIs is that they cannot be abused by vendors
> to write user space drivers. But we can still have reasonably powerful
> debug tools built on top of them.
> 
>        Andrew

Fear not, the lack of a mainline UAPI for MDIO access will not prevent
any vendor from adding a sysfs mdio_read and mdio_write, if they need it
for their user space SDK :)

The reverse also seems true: if there are things that only the kernel
can do, then there should be a kernel driver for that respective
MDIO/SPI/I2C device, regardless of whether there is also a raw UAPI
available. It is not unheard of for a user space solution to finally get
converted to a kernel implementation.

Virtualization is a reasonable use case in my opinion and it would need
something like this, for the guest kernel to have access to its PHY.

Whereas things like "devlink region" for the ATU, VTU, etc could be kept
more high-level than the interface Tobias is proposing. There is no
clash between the 2.

-Vladimir
