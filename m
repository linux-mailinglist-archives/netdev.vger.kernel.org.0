Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5682486A0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfFQPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:08:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfFQPIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 11:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/5PqyvjNF2W27ksBvWjxUm331XfxXuSMNjc6BSLqVVs=; b=5MS2PJ5Nws2jTG28a5RDCvO/u9
        Dbpzha70VmzIJhtCxIFAMmQclpyQoor+TOASJ5WgZslrhTlo5SmWgcm7wYGGQSRaAmRcfkhusROXl
        C+phE+PjCow2ItKX0yzHAg92MF3qbSLXbeh0FHmhyv5S4ocEYAyTQj1SYTJFTzpoKFRc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hctF2-0008ME-6k; Mon, 17 Jun 2019 17:08:16 +0200
Date:   Mon, 17 Jun 2019 17:08:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH 0/6] net: macb patch set cover letter
Message-ID: <20190617150816.GH25211@lunn.ch>
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

> 5. 0005-net-macb-add-support-for-high-speed-interface
>    This patch add support for 10G USXGMII PCS in fixed mode.
>    Since emulated PHY used in fixed mode doesn't seems to
>    support anything above 1G, additional parameter is used outside
>    "fixed-link" node for selecting speed and "fixed-link"
>    node speed is still set at 1G.

PHYLINK does support higher speeds for fixed-link.

	Andrew
