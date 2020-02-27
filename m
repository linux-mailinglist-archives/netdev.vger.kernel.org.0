Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11147171059
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 06:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgB0Fc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 00:32:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgB0Fc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 00:32:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0695415B4B077;
        Wed, 26 Feb 2020 21:32:55 -0800 (PST)
Date:   Wed, 26 Feb 2020 21:32:53 -0800 (PST)
Message-Id: <20200226.213253.783165643569528403.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        idosch@idosch.org, vivien.didelot@gmail.com, ivecera@redhat.com,
        kuba@kernel.org, jiri@resnulli.us, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] VLANs, DSA switches and multiple
 bridges
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226171349.GD25745@shell.armlinux.org.uk>
References: <20200226171349.GD25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 21:32:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 26 Feb 2020 17:13:49 +0000

> This is a repost of the previously posted RFC back in December, which
> did not get fully reviewed.  I've dropped the RFC tag this time as no
> one really found anything too problematical in the RFC posting.
> 
> I've been trying to configure DSA for VLANs and not having much success.
> The setup is quite simple:
> 
> - The main network is untagged
> - The wifi network is a vlan tagged with id $VN running over the main
>   network.
> 
> I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> setup to provide wifi access to the vlan $VN network, while the switch
> is also part of the main network.
> 
> However, I'm encountering problems:
...
> v2: dropped patch 3, since that has an outstanding issue, and my
> question on it has not been answered.  Otherwise, these are the
> same patches.  Maybe we can move forward with just these two?
> 
> v3: include DSA ports in patch 2

Applied, thanks.
