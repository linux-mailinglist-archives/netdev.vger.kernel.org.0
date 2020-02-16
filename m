Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2140D16061E
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgBPT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 14:58:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgBPT6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 14:58:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QFW3UM4x+zFJDy3HjBcmX54iFSWaDym9CLwJ9v1iClc=; b=DSAyETxeHYnxA7GZ8b6sLsUMR9
        jDJqzI3RQAADii1TEA0p3AqeFD5eNj53aaKK2qgw6XVqGJqu664ywkQSnPCh6daXFPrSiqXhBHrL+
        pvrMsAT004acuxMpq8XgJ1rKbj44npoU+bDD1A5VUj7AjrDaX7QLgYhPA9X0FjU7JDZ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3Q3V-0000Ye-8C; Sun, 16 Feb 2020 20:58:17 +0100
Date:   Sun, 16 Feb 2020 20:58:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Mathieu Malaterre <malat@debian.org>
Subject: Re: [PATCH] net: ethernet: dm9000: Handle -EPROBE_DEFER in
 dm9000_parse_dt()
Message-ID: <20200216195817.GB32734@lunn.ch>
References: <20200216193943.81134-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216193943.81134-1-paul@crapouillou.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 04:39:43PM -0300, Paul Cercueil wrote:
> The call to of_get_mac_address() can return -EPROBE_DEFER, for instance
> when the MAC address is read from a NVMEM driver that did not probe yet.
> 
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Mathieu Malaterre <malat@debian.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
