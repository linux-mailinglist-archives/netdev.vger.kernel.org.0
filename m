Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C782921B283
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 11:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgGJJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 05:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJJpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 05:45:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE39C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:45:21 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so5359497ejj.5
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ltMf3HwSslUpZZu8aSOIdgX6Ki8zjkK7UWD7JrHFK4Y=;
        b=uZLEvAPIwv6rke8bVnaR5jkBjf2oLYKlTiCQLLKBhcT0rNCHXGsiqTIMnnvcE11Ao/
         cmLI+RjoNWcbzZTj4PVY3eoUOwkM/swFL8TG3B3Pfh+P6n3u+atizXcTHxNF4XJLq1YK
         2uLAEW2xKKPguSNJC3pLL3SHLg15Y5pFFQh8Q3CMLmEhMWj4upCRs4GLxTBcS55/3OlB
         ZpGkyNmxfu7Y9Z/6Plef0IqCNWW65hJ961HT+XWk1BBVHb9oB8hAZWnhYwscQwPgtwk8
         N87bR0xQ63T9NFcamdVouuvF/tCGFBiIRgOY1pdD/oBy50gDL6lYBxmyTRi9LJp6b1gd
         xdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ltMf3HwSslUpZZu8aSOIdgX6Ki8zjkK7UWD7JrHFK4Y=;
        b=D9ne7m5BiQj+unKU/YDYAkUn/gNh2iLuLRBSf7EQduJrBbKZg0BOHn1Mj0YZlvNCMu
         fddR/WN7lTkg8zDib6u+DX3qSyqCHK5jrG/mPezCb0DYKqtucXYqoDhMvnWBJ5UtOXe4
         pKZP3wew/gJ1XWjdftD+oP6+gwUG/JLhpmziwtNPzzqScC8gNXr8QAbfrz2tXaSXYBqN
         v9QBSqn8t/BInfbioUsNqnLY5S+wSfWCFw6SPLRLHLUY00Txb5aumtBVLKynooawWcSo
         9xcMgfWQSJ7VxmRWdGbgdGNWRGEqIHOvz2J4vawQs312ZVseUrjIyC0VQrzPWH4Uix0N
         Pypg==
X-Gm-Message-State: AOAM531fXM89y1+LoPSMlVZsVtND7xj+Z7VG2J+PsOym1YAa+z6aW3Q3
        CFfdVy8WJucD524Z9iLE4rg=
X-Google-Smtp-Source: ABdhPJws0hCFrcP4dFlqNi8DVhIQuGBveukBVPRy1ywS9pHLxEH6v14rTb4zwIxvhPwxqAki1fZTjw==
X-Received: by 2002:a17:906:2c53:: with SMTP id f19mr59982354ejh.523.1594374320048;
        Fri, 10 Jul 2020 02:45:20 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id w17sm3365459eju.42.2020.07.10.02.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 02:45:19 -0700 (PDT)
Date:   Fri, 10 Jul 2020 12:45:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200710094517.fiaotxw2kuvosv5s@skbuf>
References: <20200709233337.xxneb7kweayr4yis@skbuf>
 <C42U7ICFS9TP.3PIIHGICUXOC4@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C42U7ICFS9TP.3PIIHGICUXOC4@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Fri, Jul 10, 2020 at 11:30:21AM +0200, Tobias Waldekranz wrote:
> On Fri Jul 10, 2020 at 4:33 AM CEST, Vladimir Oltean wrote:
> > On Fri, Jul 10, 2020 at 01:20:35AM +0200, Andrew Lunn wrote:
> > > > Virtualization is a reasonable use case in my opinion and it would
> > > > need something like this, for the guest kernel to have access to its
> > > > PHY.
> > > 
> > > And i would like a better understanding of this use case. It seems odd
> > > you are putting the driver for a PHY in the VM. Is the MAC driver also
> > > in the VM? As you said, VM context switches are expensive, so it would
> > > seem to make more sense to let the host drive the hardware, which it
> > > can do without all these context switches, and export a much simpler
> > > and efficient API to the VM.
> > > 
> > >     Andrew
> >
> > The MAC driver is also in the VM, yes, and the VM can be given
> > pass-through access to the MAC register map. But the PHY is on a shared
> > bus. It is not desirable to give the VM access to the entire MDIO
> > controller's register map, for a number of reasons which I'm sure I
> > don't need to enumerate. So QEMU should be instructed which PHY should
> > each network interface use and on which bus, and it should fix-up the
> > device tree of the guest with a phy-handle to a PHY on a
> > para-virtualized MDIO bus, guest-side driver of which is going to be
> > accessing the real MDIO bus through this UAPI which we're talking about.
> > Then the host-side MDIO driver can ensure serialization of MDIO
> > accesses, etc etc.
> >
> > It's been a while since I looked at this, so I may be lacking some of
> > the technical details, and brushing them up is definitely not something
> > for today.
> >
> > -Vladimir
> 
> Have you considered the case where the PHY is only a slice of a quad-
> or octal PHY?
> 
> I know that on at least some of these chips, all slices have access to
> global registers that can have destructive effects on neighboring
> slices. That could make it very difficult to implement a secure
> solution using this architecture.

You raise a good point. Some quad PHYs have a sane design which is
easier to virtualize and some have a less sane design.

In principle there is nothing in this para-virtualization design that
would preclude a quirky quad PHY from being accessed in a
virtualization-safe mode. The main use case for PHY access in a VM is
for detecting when the link went down. Worst case, the QEMU host-side
driver could lie about the PHY ID, and could only expose the clause 22
subset of registers that could make it compatible with genphy. I don't
think this changes the overall approach about how MDIO devices would be
virtualized with QEMU.

Thanks,
-Vladimir
