Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E3848686
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfFQPE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:04:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfFQPE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 11:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N+nXDWqrqihqw6MNyCyPhz3odKcZAF6q0IHy8eM5AP8=; b=uzePms7NJchIgkuCaNZY10Sd5V
        CxYE+7R4WzfoZHHoOfOLGnU8lk5TPGmDfBF+A6HoXN8H2mKZy3rom6VQx12KyOnmIEIKamaIJv+M9
        Dt1Uz/DE4ZFQc9ewYCWZuHZxYHVL7m3Rybx06nCwYC77K1wG1MJ1dy5/D3iSbsBZencw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hctBj-0008IL-DR; Mon, 17 Jun 2019 17:04:51 +0200
Date:   Mon, 17 Jun 2019 17:04:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH 0/6] net: macb patch set cover letter
Message-ID: <20190617150451.GG25211@lunn.ch>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 3. 003-net-macb-add-PHY-configuration-in-MACB-PCI-wrapper.patch
>    This patch is to configure TI PHY DP83867 in SGMII mode from
>    our MAC PCI wrapper driver. 
>    With this change there is no need of PHY driver and dp83867
>    module must be disabled. Users wanting to setup DP83867 PHY	
>    in SGMII mode can disable dp83867.ko driver, else dp83867.ko
>    overwrite this configuration and PHY is setup as per dp83867.ko.

This sounds very wrong. Why not make the dp83867 driver support SGMII?

     Andrew
