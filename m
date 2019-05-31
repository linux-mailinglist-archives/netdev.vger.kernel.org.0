Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41D83167E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfEaVQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:16:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfEaVQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 17:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6ApOL3sAyz6nBZLkNAPGP4Vhv9BamdXO6wZ0GSw6Q3Q=; b=dM/1Sh74KxsBFkTuluA5ZKjl7n
        OasOjTgN+5a06cFQXc7HwRoXS0E+HYYPIEPJLQ1Yc2n9jcq7BtpH8xuDiCOsUXTdZnclWEGd9FLoI
        rwBtkc0KDDiPLkABQgEcabLRpMLvLkPcffqC6LLfkam/CRgloPo/hJUygJg4AJudGd6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWotP-0001Yl-9I; Fri, 31 May 2019 23:16:51 +0200
Date:   Fri, 31 May 2019 23:16:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 09/13] net: axienet: Make missing MAC address
 non-fatal
Message-ID: <20190531211651.GF3154@lunn.ch>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-10-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559326545-28825-10-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 12:15:41PM -0600, Robert Hancock wrote:
> Failing initialization on a missing MAC address property is excessive.
> We can just fall back to using a random MAC instead, which at least
> leaves the interface in a functioning state.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
