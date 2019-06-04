Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67033D46
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFDCpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:45:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDCpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HvPa/Bkiajnopdn96Q5tQ3NDrP+yP8eZ8pbY8+AYHG0=; b=j2LwOi9Pngg1ChnWadgYKpLflq
        M5hF2t3DUykMeMwjeRQHWQ1KZkMDTICgkteaK4N5urz7l2gFO2WkxXtA68K9oEj7zA54pIdHDjDDh
        qA4Gqt/MdnnK2KR/g16D1JPHbU3p/jugvNw8mw9crWMcrpJPmxaxXif2payHXAshKDXw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXzSI-0001g8-Hr; Tue, 04 Jun 2019 04:45:42 +0200
Date:   Tue, 4 Jun 2019 04:45:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 08/18] net: axienet: Cleanup DMA device reset
 and halt process
Message-ID: <20190604024542.GN17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-9-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-9-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:07PM -0600, Robert Hancock wrote:
> The Xilinx DMA blocks each have their own reset register, but they both
> reset the entire DMA engine, so only one of them needs to be reset.
> 
> Also, when stopping the device, we need to not just command the DMA
> blocks to stop, but wait for them to stop, and trigger a device reset
> to ensure that they are completely stopped.

Given the previous patch, does this device reset also need to take the
MDIO bus into account?

     Andrew
