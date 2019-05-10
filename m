Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571621A2E4
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfEJSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:18:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60443 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfEJSSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 14:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nAU5ijCVdIe9aWJByv40Pre6BTjF7H8euZKhtffaxDA=; b=WPRHU3euv4qVJvcjFH205a0av6
        oCumXR34B12rRelkdQ9zmZVlov+zcgDweMlKTN1PXqr3tKRWJbC3pJZs+MH3GhTPX9bBk5vUW1Esz
        gxx4AodeuAzJskpEA1l2xBbsr6NjQ5K4eY3UO0d3nsNc+HDkOz50CMzGVkK43Hp9vWOc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPA5m-0004kh-2u; Fri, 10 May 2019 20:17:58 +0200
Date:   Fri, 10 May 2019 20:17:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net 2/3] of_net: add property "nvmem-mac-address" for
 of_get_mac_addr()
Message-ID: <20190510181758.GF11588@lunn.ch>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 08:24:03AM +0000, Andy Duan wrote:
> If MAC address read from nvmem cell and it is valid mac address,
> .of_get_mac_addr_nvmem() add new property "nvmem-mac-address" in
> ethernet node. Once user call .of_get_mac_address() to get MAC
> address again, it can read valid MAC address from device tree in
> directly.

I suspect putting the MAC address into OF will go away in a follow up
patch. It is a bad idea.

       Andrew
