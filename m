Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912F3194D73
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCZXpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:45:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgCZXpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 19:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zZX+dxCsnIw31hRa82k8C5VSOBkpAWo5CH/zMMKzlf4=; b=TH6IlnDNaFI+LY6ZMz8TaOenEr
        /7HH3XbLq1exzlYqSnUZDi7PugVFrwj50JbtzxIJuzACMGuL9CaF67Y1ZDpSwHvv1f1SFE6yRAf9l
        xQTCYhAeX64C9fzyd3mBaaf77o/dYKpj8owMoiTVmOJASZ4Hj/57geED1WNoUrfo7kAY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHcBH-0004Xn-Uj; Fri, 27 Mar 2020 00:44:59 +0100
Date:   Fri, 27 Mar 2020 00:44:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: probe PHY drivers synchronously
Message-ID: <20200326234459.GI3819@lunn.ch>
References: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
 <20200326233411.GG3819@lunn.ch>
 <4a71aee8-370b-2a87-d549-a7fba5a5f873@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a71aee8-370b-2a87-d549-a7fba5a5f873@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Default still is sync probing, except you explicitly request async
> probing. But I saw some comments that the intention is to promote
> async probing for more parallelism in boot process. I want to be
> prepared for the case that the default is changed to async probing.

Right. So this should be in the commit message. This is the real
reason you are proposing the change.

       Andrew
