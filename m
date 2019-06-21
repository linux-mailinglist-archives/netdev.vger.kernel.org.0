Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AAF4F0A3
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfFUWJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:09:48 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48452 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUWJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=noal6GHI820xc2hIyBVZZOEwuVzPIcsq1ZVRxOSKR2w=; b=o65eU7i1C+7edpuOZx02q/iuL
        MqafjJR/04vthXUqtYoG/QwbfrQykQ7v5Jw+AYEggxbaDNtPGuv8Dm87N0c+wgma3qCSZxc8V8K8R
        e0lOUpeNmYYgf8X98iFOZ4MwpgDpGx0bfHOPhqFOK0iwjMfBbCGrv+DXnnwIsaBabE6yooVYamF0S
        eXiaH6hij/OxcpVHIA8sn4EO+enDaOKCFKo7I5PrfykdrcFNOvz10b3E8m0pdyXCV1honZ1U4B1Kd
        yVzrBY4hbQj9TerF2MxXYLktU7Vg23JXexa7GVFHxoz+H/xDZlc2l6VRCGyYA/9T9r+Q7i+jpKHOR
        /hIPlpHQw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59872)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1heRj6-00080Z-Ab; Fri, 21 Jun 2019 23:09:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1heRj3-0003c7-IV; Fri, 21 Jun 2019 23:09:41 +0100
Date:   Fri, 21 Jun 2019 23:09:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        idosch@mellanox.com, Jiri Pirko <jiri@resnulli.us>, andrew@lunn.ch,
        davem@davemloft.net
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190621220941.zaqbaf4wpnxnvoy5@shell.armlinux.org.uk>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621172952.GB9284@t480s.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 05:29:52PM -0400, Vivien Didelot wrote:
> Russell, Ido, Florian, so far I understand that a multicast-unaware
> bridge must flood unknown traffic everywhere (CPU included);
                           ^
			multicast

> and a multicast-aware bridge must only flood its ports if their
                                              ^
				unknown multicast traffic to

> mcast_flood is on, and known traffic targeting the bridge must be
> offloaded accordingly. Do you guys agree with this?

I don't see a problem with that with the clarification that we're
talking about multicast packets here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
