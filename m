Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1060BD1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfGETjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:39:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36792 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfGETjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:39:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so8701018qkl.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pUiWOs1UO7581/CK1LDulrdGq5+qTXlnhqn8K+ZlPQc=;
        b=LXsGfJK5UPpnnCBO7oDhflDkbXE+Iy8ir3Gn0uoSRkew6Rl+neaAShqJPX+jSYzsI2
         D9ETPkm37hUhgwMpowYZ96KDNLpn2yYCG0D+WIaFK4vMq3tR3sZxNLW+MvjrJODuvlX3
         TbnHFNTiywB1XHOLC/49B023mYbmB+FUVhXt5GmLwkdFHIJwU8zk0QIkKaYdkUxODg+O
         Ln+FrNYd2TIRF3s1AbRZ7DN7c21ERBuncV7bpuHi038ygwR6KUci+deHhDL8DUT9vvOo
         +FtSFOM2Ny1CDlzG9f+TAKBo+6mxhhtipwkBfiKilTxxXPqOX8BCSMl3QbGok+PwA9ja
         jhdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pUiWOs1UO7581/CK1LDulrdGq5+qTXlnhqn8K+ZlPQc=;
        b=cWSjddj1Sug3k4mI+cvIwowD6kJH58RN5XNWAy1+fFeIO65kCkKH/C5nRoI25yuo5H
         bxayzq3l4/PhXfzSIxAVj+9dA54jkXR/aHwcjr/0Bn2HPG4jIWO68UyvHnRzxvfkgsfr
         nwRXmSX3BOTvBKxiy7LTZ/26s2RIr/ZgFC9cTnNPQCyMdkCPKh6c8LfxTn7t1AEZ4eDw
         6lUIs/E1izlJX4yCHlOjVQ2I2nYwWl6FkJP1m32+3TNoh/qyX/Y0mxacCB2FKTnLkTmE
         QHv4sCXpPzWUDzVmmB8QnyTdBDX2TBScYir3rIoMSaeh4a4U1LRvSnXiwgwGtVE2RXJH
         44tg==
X-Gm-Message-State: APjAAAWaFzFiK6sOWUS4g9LMIlpGQkTosg5FsftG/PEU4CgSxeipPZD+
        fSvmwE13Ld4aTRypWmVv8dejiQ==
X-Google-Smtp-Source: APXvYqyY3ta2+dXyanZjyiYklsEHblu/UiQtUFADr+5P0pqTgA1qNMn11i9PcLlLy5xJ4QEmVZwG2g==
X-Received: by 2002:a05:620a:15cd:: with SMTP id o13mr2643932qkm.273.1562355551848;
        Fri, 05 Jul 2019 12:39:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d188sm4198274qkf.40.2019.07.05.12.39.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 12:39:11 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:39:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
 configuration attributes.
Message-ID: <20190705123907.1918581f@cakuba.netronome.com>
In-Reply-To: <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
        <20190704150747.05fd63f4@cakuba.netronome.com>
        <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 08:22:41 +0000, Sudarsana Reddy Kalluru wrote:
> > On Thu, 4 Jul 2019 06:20:11 -0700, Sudarsana Reddy Kalluru wrote:  
> > > This patch adds implementation for devlink callbacks for reading and
> > > configuring the device attributes.
> > >
> > > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>

> > > diff --git a/Documentation/networking/devlink-params-qede.txt
> > > b/Documentation/networking/devlink-params-qede.txt
> > > new file mode 100644
> > > index 0000000..f78a993
> > > --- /dev/null
> > > +++ b/Documentation/networking/devlink-params-qede.txt
> > > @@ -0,0 +1,72 @@
> > > +enable_sriov		[DEVICE, GENERIC]
> > > +			Configuration mode: Permanent
> > > +
> > > +iwarp_cmt		[DEVICE, DRIVER-SPECIFIC]
> > > +			Enable iWARP support over 100G device (CMT mode).  
> > > +			Type: Boolean
> > > +			Configuration mode: runtime
> > > +
> > > +entity_id		[DEVICE, DRIVER-SPECIFIC]
> > > +			Set the entity ID value to be used for this device
> > > +			while reading/configuring the devlink attributes.
> > > +			Type: u8
> > > +			Configuration mode: runtime  
> > 
> > Can you explain what this is?  
>
> Hardware/mfw provides the option to modify/read the config of other
> PFs. A non-zero entity id represents a partition number (or simply a
> PF-id) for which the config need to be read/updated.

Having a parameter which changes the interpretation of other parameters
makes me quite uncomfortable :(  Could it be a better idea, perhaps, to
use PCI ports?  We have been discussing PCI ports for a while now, and
they will probably become a reality soon.  You could then hang the
per-PF parameters off of the PF ports rather than the device instance? 

> > > +device_capabilities	[DEVICE, DRIVER-SPECIFIC]
> > > +			Set the entity ID value to be used for this device
> > > +			while reading/configuring the devlink attributes.
> > > +			Type: u8
> > > +			Configuration mode: runtime  
> > 
> > Looks like you copied the previous text here.  
> Will update it, thanks.
> 
> >   
> > > +mf_mode			[DEVICE, DRIVER-SPECIFIC]
> > > +			Configure Multi Function mode for the device.
> > > +			Supported MF modes and the assoicated values are,
> > > +			    MF allowed(0), Default(1), SPIO4(2), NPAR1.0(3),
> > > +			    NPAR1.5(4), NPAR2.0(5), BD(6) and UFP(7)  
> > 
> > NPAR should have a proper API in devlink port, what are the other modes?
> >   
> These are the different modes supported by the Marvell NIC. In our
> case the mf_mode is per adapter basis, e.g., it's not possible to
> configure one port in NPAR mode and the other in Default mode.

Jiri, what are your thoughts on the NPAR support?  It is effectively a
PCI split.  If we are going to support mdev split, should we perhaps
have a "depth" or "type" of split and allow for users to configure it
using the same API?

> > > +			Type: u8
> > > +			Configuration mode: Permanent
> > > +
> > > +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> > > +			Configure DCBX mode for the device.
> > > +			Supported dcbx modes are,
> > > +			    Disabled(0), IEEE(1), CEE(2) and
> > > Dynamic(3)
> > > +			Type: u8
> > > +			Configuration mode: Permanent  
> > 
> > Why is this a permanent parameter?
> >   
> This specifies the dcbx_mode to be configured in non-volatile memory.
> The value is persistent and is used in the next load of OS or the mfw.

And it can't be changed at runtime?
