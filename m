Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB59117309
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLIRoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:44:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfLIRoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:44:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jzSSPrR7j6JLe5RwgZF7plB1QaVWgO/6Hk0xOcHGWq0=; b=rFVnU/qanLk507xuAGMPnEeqYl
        C+l0JQHei0OskyjaFnHyK2SVmjZt3IHhftbDFLcJS+93U+9pFo8/8hS5QXTSaRyFBp/LCpodmIuTv
        T7q7P4mEszlXHaMrqRTLOkU7yDWggaCdLrI0NFiRGdkrHkMcRVRBxZjhIm9CTBMkfxtc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieN4x-0006rJ-2E; Mon, 09 Dec 2019 18:44:15 +0100
Date:   Mon, 9 Dec 2019 18:44:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: sfp: rename sm_retries
Message-ID: <20191209174415.GH9099@lunn.ch>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
 <E1ieJpQ-0004UX-OH@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieJpQ-0004UX-OH@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:16:00PM +0000, Russell King wrote:
> Rename sm_retries as sm_fault_retries, as this is what this member is
> tracking.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
