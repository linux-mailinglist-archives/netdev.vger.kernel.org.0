Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA57EA7B4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfJ3XVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:21:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfJ3XVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 19:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i6Pvsln+TmPFf2KJkEA+v2DyhzHB/RQzSprGrG0qFdU=; b=jKajtZqPxriYoerRSpk8QSGgYM
        4QihFeI9U0XmlNiZ09I1k3Kfqf76mZcUTdlRdm/B7lk3BB+WClAaR+6ghigPLTS9IKRmZUvjeVl2b
        C8HRqGIC8DnFrQ07hGf+q8kn6LqZIklSyy3DtJGsdnlFmrJuemeOc28DAp9842Tzs9t8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPxGu-0005aW-Hm; Thu, 31 Oct 2019 00:21:00 +0100
Date:   Thu, 31 Oct 2019 00:21:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
Message-ID: <20191030232100.GI10555@lunn.ch>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224251.21578-4-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 11:42:51PM +0100, Michael Walle wrote:
> Add support for configuring the CLK_25M pin as well as the RGMII I/O
> voltage by the device tree.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
