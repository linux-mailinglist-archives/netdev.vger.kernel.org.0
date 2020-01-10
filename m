Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B55136F01
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgAJOJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:09:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgAJOJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:09:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lSOHgxO9xGTW5vCvNg94uyQaSJjUVatF+1rMZ+Ag+x0=; b=Dt9bZeXw47aG1JE5UIOyOiMZUx
        kbqejHoDOftUS3Cf1nHos/uaQgedu7iOkF1mMW0geussbppQHn4awtXlK5K/Mne83cpC6XQELBTSM
        2N1zuXtcKTblIaV5ic4F0BuAkn6gIoYwlGU2XdS8fJuG7/5RB5rgBgmMXBcSiZI7hhLc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipuy4-0007ME-1M; Fri, 10 Jan 2020 15:08:52 +0100
Date:   Fri, 10 Jan 2020 15:08:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Message-ID: <20200110140852.GF19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-13-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115415.75683-13-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> To autodetect this configuration, at probe time we write all 1's to such
> an MSB register, and see if any bits stick.

So there is no register you can read containing the IP version?

   Andrew
