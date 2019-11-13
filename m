Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC9FB6F0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:00:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfKMSAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 13:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Lw4bqwFp5X7bvyN7eab03K+voZy8RXsYqBIhStusi5w=; b=qsXzr+jaIJAEM1Fe5MjE0Azxg+
        Xu906+zG7KpNB3XynXZz+aP/CyRRJczsYxAeWZjc+qXV9D2Rqn+p8Zhc+Oqve6jfuhKE2mMh25Wtq
        pTmuWs9Ek1oqVpX1Dny8LdFrw1RnnLz5XS2AMBaWVwzIqHtCIw7lnzP2MYUtX1hXpGMs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUwvz-0008L2-O8; Wed, 13 Nov 2019 19:00:03 +0100
Date:   Wed, 13 Nov 2019 19:00:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] mscc.c: Add support for additional VSC PHYs
Message-ID: <20191113180003.GK10875@lunn.ch>
References: <1573662795-3672-1-git-send-email-Bryan.Whitehead@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573662795-3672-1-git-send-email-Bryan.Whitehead@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 11:33:15AM -0500, Bryan Whitehead wrote:
> Add support for the following VSC PHYs
> 	VSC8504, VSC8552, VSC8572
> 	VSC8562, VSC8564, VSC8575, VSC8582
> 
> Updates for v2:
> 	Checked for NULL on input to container_of
> 	Changed a large if else series to a switch statement.
> 	Added a WARN_ON to make sure lowest nibble of mask is 0
> 
> Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
