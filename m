Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D71D18E9A7
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCVPcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:32:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50272 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVPcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GBWLiXIetq3iao8NDSJX3RHDoOSCZXvAQ79NXJI3pU4=; b=QuGeDcVUuQu0X4v6OZsefCf1dK
        tW1pNgnyYig8X+MjXohsFrtevqx9re+dNpQTw+xTlR7q6L5iMz4SqJ0BZS9ssV8LceXOob2qYFE/Y
        pXN4MXJ/0r2BnCh4PYHyaoPIXBOF3lCAnzLV6HH51+s5KcNrE/wXQmX7FNit14xEAMnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG2aD-0000WM-7K; Sun, 22 Mar 2020 16:32:13 +0100
Date:   Sun, 22 Mar 2020 16:32:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/9] net: phy: introduce
 phy_read_mmd_poll_timeout macro
Message-ID: <20200322153213.GL11481@lunn.ch>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-4-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322065555.17742-4-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 02:55:49PM +0800, Dejin Zheng wrote:
> it is sometimes necessary to poll a phy register by phy_read_mmd()
> function until its value satisfies some condition. introduce
> phy_read_mmd_poll_timeout() macros that do this.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
