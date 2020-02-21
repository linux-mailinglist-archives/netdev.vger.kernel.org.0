Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E875E166B86
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgBUAVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:21:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39808 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgBUAVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PpDpqLMI5GZaRXgjdMLLurC9v3AnJZ35dT9GSagwDBA=; b=Mqn5Q4cr15sgWQle8xS46s4G7
        2SorT2x0XVWwBVDCGflcVaP03aJ+OeYwzZUnKARGAGz4FuMoOo9gFYx4rHl9YQ5YMWDDbx0oGb54I
        aFMQsCi4PefD2UJwOeIuN08gSM+XCNUyTy69zk1lMoyVTQCvWAoccenX8EWp7Q7qbck3c+OZ82PE+
        ZQYtPa8hgPOwA7ITELHYa0E1mlSm8aHrMlFiggfeZGuTadswwkBFx1k89mpwuvH6HanPPP3qtz7pV
        FN34viBQBYtQQpG9IOu3pO8PtYV3FvEEGoJ/qtamNHekbk0SjxPQ9zShKV2KN7Lad+dkzuYT2wall
        Imk8/cmzw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50614)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4w4B-0006Me-RG; Fri, 21 Feb 2020 00:21:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4w47-0002xS-11; Fri, 21 Feb 2020 00:21:11 +0000
Date:   Fri, 21 Feb 2020 00:21:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200221002110.GE25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> Let's get your patch series merged. If you re-spin while addressing
> Vivien's comment not to use the term "vtu", I think I would be fine with
> the current approach of having to go after each driver and enabling them
> where necessary.

The question then becomes what to call it.  "always_allow_vlans" or
"always_allow_vlan_config" maybe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
