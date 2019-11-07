Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF50F33AF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfKGPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:44:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbfKGPo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 10:44:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BzsWSPPGkgR4hQTPbOdZs9dtqpvNFQEh1bKmPx7WeLQ=; b=oLUAYdff7Ko0QZqQTfkdi/5L8K
        D32N7iKfGgTaET9vXVXl7147L7LAJ1Ch7t1/fhdPy2PSv7S+1zDh61/VwhjNDMmmB5V+nKX/7Xp30
        ZlVRIsYDKL7oNGuQzyptit3oJJROHD221RwzWAd/N0cLb+dgwq26J8t+EQIWKaDXNfoc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSjxv-0006pT-Bp; Thu, 07 Nov 2019 16:44:55 +0100
Date:   Thu, 7 Nov 2019 16:44:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de
Subject: Re: [PATCH v1 2/4] net: tag: ksz: Add KSZ8863 tag code
Message-ID: <20191107154455.GG7344@lunn.ch>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
 <20191107110030.25199-3-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-3-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 12:00:28PM +0100, Michael Grzeschik wrote:
> Add DSA tag code for the Microchip KSZ8863 switch.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
