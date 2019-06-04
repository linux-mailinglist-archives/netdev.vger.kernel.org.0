Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECB33D25
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfFDC0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:26:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFDC0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ybAyIrjvVcElM2JiyKpz8Jn7MILuwoGyw2boCRaJUwQ=; b=gPPzXp11waFjkBVi+F0NW5xirp
        bvkVHkNx9E1dnQywoHhG/at92ocoWbl3JQdnsyXR11Ts5QrO5JPcZUYcU3d7wXPyRIc5Y+bir5c07
        HeNm855VVeLkPSwT3kvDVtG1EON8XvsgQkpqojo0RK54+HhUMoMAU5bxXO9OmVpSC2iU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXz9l-0001W3-EZ; Tue, 04 Jun 2019 04:26:33 +0200
Date:   Tue, 4 Jun 2019 04:26:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 04/18] net: axienet: add X86 and ARM as
 supported platforms
Message-ID: <20190604022633.GJ17267@lunn.ch>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
 <1559599037-8514-5-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559599037-8514-5-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:57:03PM -0600, Robert Hancock wrote:
> This driver should now build on (at least) X86 and ARM platforms, so add
> them as supported platforms for the driver in Kconfig.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
