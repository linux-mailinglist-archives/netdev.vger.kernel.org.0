Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A280EA793
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfJ3XNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:13:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbfJ3XNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 19:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=08zRAW1fuCrOHTGj1vuy3kiI71SoEqzhE5Yn/YMo14M=; b=wvZ5ApIF9k8V2Cz22S1SmnYANH
        C+MNLbexBdrlAt+KbDTc6ZtSCDulf6O9BcQerJ1lQm/S1z2Q4I27b0ykAF++bnhDXofVbCqgvz7cI
        rzMCl9Grr5QFqwssCqZL/NTVBcsOl6ni2qu3IZefADBhv102h2aXW5XLm9Mese0SHseY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPx9J-0005Vh-FV; Thu, 31 Oct 2019 00:13:09 +0100
Date:   Thu, 31 Oct 2019 00:13:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] net: phy: at803x: fix Kconfig description
Message-ID: <20191030231309.GF10555@lunn.ch>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224251.21578-2-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 11:42:49PM +0100, Michael Walle wrote:
> The name of the PHY is actually AR803x not AT803x. Additionally, add the
> name of the vendor and mention the AR8031 support.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
