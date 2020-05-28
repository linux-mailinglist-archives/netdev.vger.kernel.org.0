Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4978C1E6F35
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437250AbgE1Wfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:35:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436945AbgE1Wfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dWAvR2csWZ8XjsRaR8g5wNgTpKRrLO5jtJQI1w9ud/M=; b=EmP0zkiiHIAuTG225KofGPRyDX
        hYXM1/KYI5RtqWfiYZxiQGkTbOZ0VhcuhUdSAOQdkmJ51LGtE1P7GiJYPYCnry1eBUIK5Ea/pYzES
        Y0sp0hz2IR5KUG/sSX5hTrG5qQ90KZqFAxpJJVDzWX/i42SFivwKDTfC9ZRn0OBz/iO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeR7d-003aYo-3N; Fri, 29 May 2020 00:35:33 +0200
Date:   Fri, 29 May 2020 00:35:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 18/19] net: ks8851: Implement Parallel bus operations
Message-ID: <20200528223533.GH853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-19-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-19-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:45AM +0200, Marek Vasut wrote:
> Implement accessors for KS8851-16MLL/MLLI/MLLU parallel bus variant of
> the KS8851. This is based off the ks8851_mll.c , which is a driver for
> exactly the same hardware, however the ks8851.c code is much higher
> quality. Hence, this patch pulls out the relevant information from the
> ks8851_mll.c on how to access the bus, but uses the common ks8851.c
> code. To make this patch reviewable, instead of rewriting ks8851_mll.c,
> ks8851_mll.c is removed in a separate subsequent patch.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
