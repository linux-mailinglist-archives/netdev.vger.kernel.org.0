Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56132164D50
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBSSHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:07:11 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41454 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgBSSHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:07:11 -0500
Received: by mail-qt1-f194.google.com with SMTP id l21so869776qtr.8
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 10:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=olAQ64Mtp7x/B/XUOAGl411v+1VmsprRKMTg5Mkuxns=;
        b=rwAAUpIzGwP9ogjFBOWInjRNZJ3uI7kueODEHniDmXn1Yy9nwEtI9mniUDYNyTcbQF
         O0dlujfVswLl4BK+YUb5OIjfdHzX8QOOOej0KQ0A0XSQ0dgDh+Lxdt0SSMX/fB8NGZnq
         eVDCHX598dT7HS7+dTRo6P5TBNHBUTXX7u/IHTkBTKdgIl/M4IOw7fTEVfoG7GpCkvGm
         5v+CeqnKEbQnCDiN3xKcCmU+QK5ZM0rIyvbcTFWx9JAJW0nYJKv8tvFOW3ToYmObJuDv
         TGpgEHnHDWztTHT6V6qLbBEqOdl7c++n1x5ep+DBIF/MyAFNQuww8tWDYD61afyjDEJU
         20yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=olAQ64Mtp7x/B/XUOAGl411v+1VmsprRKMTg5Mkuxns=;
        b=AVH7N+2MvmWtZMW0EblQ8GhVIYxp8pZJVAw0GWEDHsAEwmkHdQ3Xnk3JIsE2Lmzuod
         mwvwVajj2KA473fUyFo9zYKDCG2y1MotDyXYgomRdVXpRpKEtQGRyxfOK0E3yYQnoPIY
         5U4Cq5NKw3tAAG9Vv1xSaVsmTQd4OKnd6/LIR1CpW2TQXv6O9uONRckA7Y5l5rkI96pF
         31JRB/IvkiCzwcDj/Dojhjt0SN87+//li6pqVvU9SN/IOtVB6QKkxNbdBUaBV0bckIRW
         uK/W/Asl784ESQAlzwfhIwVMK7oFi0GPMM4vREYotX0BpNnhOa5uGE2utSprscOAoJQE
         Z41g==
X-Gm-Message-State: APjAAAWyCZJKa0V4EM9h/vE4lC4aodBREg95fNlg7+qPoy7jJ42PBl2K
        ech0Xp49HYErYj4stK/lzv0=
X-Google-Smtp-Source: APXvYqyYhrD+wVs8ulcCS7Hl0hvGKQjdjtz1TitH2/8fsQXaPJDVrMfojP38g8yKjCkx9JwlUS75cQ==
X-Received: by 2002:ac8:7446:: with SMTP id h6mr23237452qtr.274.1582135629721;
        Wed, 19 Feb 2020 10:07:09 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w9sm221113qka.71.2020.02.19.10.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 10:07:09 -0800 (PST)
Date:   Wed, 19 Feb 2020 13:07:07 -0500
Message-ID: <20200219130707.GB245247@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
In-Reply-To: <20200219091900.GQ25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
 <20200219034730.GE10541@lunn.ch>
 <20200219091900.GQ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 19 Feb 2020 09:19:00 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Wed, Feb 19, 2020 at 04:47:30AM +0100, Andrew Lunn wrote:
> > On Wed, Feb 19, 2020 at 12:17:37AM +0000, Russell King - ARM Linux admin wrote:
> > > On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
> > > > On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
> > > > > Hi,
> > > > > 
> > > > > This is a repost of the previously posted RFC back in December, which
> > > > > did not get fully reviewed.  I've dropped the RFC tag this time as no
> > > > > one really found anything too problematical in the RFC posting.
> > > > > 
> > > > > I've been trying to configure DSA for VLANs and not having much success.
> > > > > The setup is quite simple:
> > > > > 
> > > > > - The main network is untagged
> > > > > - The wifi network is a vlan tagged with id $VN running over the main
> > > > >   network.
> > > > > 
> > > > > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > > > > setup to provide wifi access to the vlan $VN network, while the switch
> > > > > is also part of the main network.
> > > > 
> > > > Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> > > > Don't add vlans when vlan filtering is disabled")? If a driver wants to
> > > > veto the programming of VLANs while it has ports enslaved to a bridge
> > > > that does not have VLAN filtering, it should have enough information to
> > > > not do that operation.
> > > 
> > > I do not have the knowledge to know whether reverting that commit
> > > would be appropriate; I do not know how the non-Marvell switches will
> > > behave with such a revert - what was the reason for the commit in
> > > the first place?
> > > 
> > > The commit says:
> > > 
> > >     This fixes at least one corner case. There are still issues in other
> > >     corners, such as when vlan_filtering is later enabled.
> > > 
> > > but it doesn't say what that corner case was.  So, presumably reverting
> > > it will cause a regression of whatever that corner case was...
> > 
> > Yes, sorry, bad commit message. I'm not too sure, but it could of been
> > that the switch was adding the VLANs to its tables, even though it
> > should not because filtering is disabled. And i also think the default
> > VLAN was not defined at that point, it only gets defined when
> > vlan_filtering is enabled?
> 
> It's been too long since I researched all these details, but I seem
> to remember that in the Linux software bridge, vlan 1 is always
> present even when vlan filtering is not enabled.
> 
> Looking at br_vlan_init():
> 
>         br->default_pvid = 1;
> 
> and nbp_vlan_init() propagates that irrespective of the bridge vlan
> enable state to switchdev.  nbp_vlan_init() is called whenever any
> interface is added to a bridge (in br_add_if()).
> 
> As I believe I mentioned somewhere in the commit messages or covering
> message, for at least some of the Marvell DSA switches, it is safe to
> add VTU entries - they do not even look at the VTU when the port has
> 802.1Q disabled.  Whether that is true for all Marvell's DSA switches
> I don't know without trawling every functional spec, and I was hoping
> that you guys would know.  I guess I need to trawl the specs.

Some switches like the Marvell 88E6060 don't have a VTU, so programming the
default PVID would return -EOPNOTSUPP. Switches supporting only global VLAN
filtering cannot have a VLAN filtering aware bridge as well as a non VLAN
filtering aware bridge spanning their ports at the same time. But all this
shouldn't be a problem because drivers inform the stack whether they support
ds->vlan_filtering per-port, globally or not. We should simply reject the
operation when vlan_filtering is being enabled on unsupported hardware.

Linux bridge is the reference for the implementation of an Ethernet bridge,
if it programs VLAN entries, supported DSA hardware must do so. I'm not a
fan of having our own bridge logic in DSA, so the limitation implemented by
2ea7a679ca2a ("net: dsa: Don't add vlans when vlan filtering is disabled")
needs to go in my opinion.


Thanks,

	Vivien
