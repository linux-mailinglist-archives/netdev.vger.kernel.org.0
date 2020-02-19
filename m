Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF7C1638C8
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgBSA6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:58:15 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36743 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgBSA6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:58:15 -0500
Received: by mail-qt1-f194.google.com with SMTP id t13so16019727qto.3
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 16:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=c2rM5WxPa1Iy9v7F4ov3p3K994ESx7m28o1f1SU1C14=;
        b=Abj8RqMlhHKg00ZYitrn7b4k7V8hEYuzL2Cwx2tW5QsepMH+ezsWLt1+k8ImuEeVC8
         gIfNIx1S5WOBsG73Db/FsQomfytS7wHh+X2Di45g1oFUovTMgRqj2S8O5tMrIunIXsir
         321WaSRA0uFowQaGW9wKGiMPliulpoREwZkW6lg4d+fYoVpfRrwG7sZXujUyXxbYE8Ok
         PLrhKDgdg27pkLpDPTpFlfDWqHxvcTAobQ/0V/TxQVjPxAV8w560kH9saEiHf/o2y//o
         xSDUuvLt8DqqBCR1EY1DWH9SqK7IBtkx9b6kIf9YJ5si3VsSXDgxKxkLcSOVEiv1wWK9
         wTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=c2rM5WxPa1Iy9v7F4ov3p3K994ESx7m28o1f1SU1C14=;
        b=UfEr5LDdRbcL4BI2ZjzsZCgGZsVUpddBdHPCLndWAZ6MJn1Nw2sSUxg4NA7PvrrpaO
         CQBINa7Oi+mcw8d1QwL3BL0AUIOZwFn8HurRlvI2Pby3VsC5HYQvhtIyflmHbXO4kQnp
         S9K3yKrzpU7e2BUmJvBH5DI8QwNlwjnxmasT4GNqZO3ZBJYYydVZB/r8HQiVGJQg6hMq
         knzXwDY11RH335o4laRIswHxdO7/tkUaAXMApk1KHscPdelL8K9UNyZGi8rEJXNqUXp8
         gjcz5lIgrsVAEPIwAuw2TI7DYOeNNsv3bemRUrEHrrK3B5cr0v623mKkWDgmohr+Xf+W
         JbZg==
X-Gm-Message-State: APjAAAWPy7wW/ZuT4XHLalHGHWxRiIrPtmyPXGJLTlJdaRGhxMUGo4TU
        qSbTQOzTCnZJlyki4/7vFw8=
X-Google-Smtp-Source: APXvYqz0YLCMIAwqINuC5n5ljbmCxN1yJIEbX9u3X7jmRy5DPcNchpuQ04kcs8We8eW8d79pENfszA==
X-Received: by 2002:aed:35e7:: with SMTP id d36mr20240270qte.363.1582073894046;
        Tue, 18 Feb 2020 16:58:14 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p50sm136129qtf.5.2020.02.18.16.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 16:58:13 -0800 (PST)
Date:   Tue, 18 Feb 2020 19:58:12 -0500
Message-ID: <20200218195812.GD80929@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
In-Reply-To: <20200219001737.GP25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 00:17:37 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
> > On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
> > > Hi,
> > > 
> > > This is a repost of the previously posted RFC back in December, which
> > > did not get fully reviewed.  I've dropped the RFC tag this time as no
> > > one really found anything too problematical in the RFC posting.
> > > 
> > > I've been trying to configure DSA for VLANs and not having much success.
> > > The setup is quite simple:
> > > 
> > > - The main network is untagged
> > > - The wifi network is a vlan tagged with id $VN running over the main
> > >   network.
> > > 
> > > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > > setup to provide wifi access to the vlan $VN network, while the switch
> > > is also part of the main network.
> > 
> > Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> > Don't add vlans when vlan filtering is disabled")? If a driver wants to
> > veto the programming of VLANs while it has ports enslaved to a bridge
> > that does not have VLAN filtering, it should have enough information to
> > not do that operation.
> 
> I do not have the knowledge to know whether reverting that commit
> would be appropriate; I do not know how the non-Marvell switches will
> behave with such a revert - what was the reason for the commit in
> the first place?
> 
> The commit says:
> 
>     This fixes at least one corner case. There are still issues in other
>     corners, such as when vlan_filtering is later enabled.
> 
> but it doesn't say what that corner case was.  So, presumably reverting
> it will cause a regression of whatever that corner case was...

It is hard to care about regression when we have no idea what these "corner
cases" are. Also things like ds->vlan_filtering* were added after if I'm
not mistaken, so the drivers might have enough information now to adapt to
or reject some unsupported bridge offload.

Getting rid of this limitation would definitely be another approach worth
trying.


Thanks,

	Vivien
