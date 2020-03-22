Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336AD18E9BE
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgCVPiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:38:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCVPiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7b9TqGeDRxElo8OqCp7gqOuYwOecedeDhutw75tZcS4=; b=e2qIMKl8sAY6Tzbuwuo61qJmvH
        CrZwXDmPbjPH85tW+RHISh4Cb8/p7OZjJnCCXKuXuvf/Xli4le0AuKeahxSgn5f9rVENsaGM6VsCe
        /EtsNFJgvLEPICUEhJt4YxDGfqffUi0YxaKA4k9pEBvvghThYA/QC/2pC/UAEnqSgDL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG2fs-0000ac-Ge; Sun, 22 Mar 2020 16:38:04 +0100
Date:   Sun, 22 Mar 2020 16:38:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 7/9] net: phy: introduce
 phy_read_poll_timeout macro
Message-ID: <20200322153804.GP11481@lunn.ch>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-8-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322065555.17742-8-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 02:55:53PM +0800, Dejin Zheng wrote:
> it is sometimes necessary to poll a phy register by phy_read()
> function until its value satisfies some condition. introduce
> phy_read_poll_timeout() macros that do this.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
