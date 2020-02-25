Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A127616F275
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgBYWMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:12:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBYWMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qlW98hTIwGDZZ8hfou8pBRvumuSRk/WMKT22BYcU3TA=; b=I+cLWs1cqCJzfss1fUdZ6oabMy
        Shzb95kJ2UHK7aiRQ+lLCPz7/0THxiSo6Jvw8ju7QgY4ck8l95rnjO+Wka9kwDMrlFtC+ojR7R8jo
        0DZo9O4NBje4xcaePtQDqVQ+/dS31jIc7/QvRZ3le0cARIk2bQvpx6CzQJZ8cyJVMAn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6iR5-0001fD-HM; Tue, 25 Feb 2020 23:12:15 +0100
Date:   Tue, 25 Feb 2020 23:12:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200225221215.GI7663@lunn.ch>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> CPU RX/TX support will be provided in the next contribution.

Hi Vadym

This is a core feature which needs to be in the first version merged
into the kernel. Basically, the driver first needs to offer 24
individual interfaces which can send and receive packets. The Linux
stack does everything else. You then add offloads, like bridges,
vlans, etc, allowing the hardware to accelerate what Linux is doing.

	Andrew
