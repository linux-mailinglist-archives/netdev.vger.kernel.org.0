Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7D438B77
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJXSnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:43:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJXSnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wopM+PJR8GdqDE88xMRHK3A1IAz7EhhxxZPE4H3rngU=; b=6L7v/c3QxWb/TFRQQocNmv7DfJ
        25ESCWucfWJv5A9/mR64ODcH7xWKzL6ckvA1kaqFM5RGpS+2vVHL8P80MOZozOWjIKiaIT1MNyTR0
        BMd29PXyDCCD2SBKWO2TLpEGgXEQwj25g5VDY5DDvXhnKmH0H4o6mupw6a0cS2n1aC2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiQV-00Ba3o-Uo; Sun, 24 Oct 2021 20:40:59 +0200
Date:   Sun, 24 Oct 2021 20:40:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 12/14] net: phy: add qca8081 soft_reset and enable
 master/slave seed
Message-ID: <YXWou5mDg3UmB8kH@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-13-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-13-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:36PM +0800, Luo Jie wrote:
> qca8081 phy is a single port phy, configure
> phy the lower seed value to make it linked as slave
> mode easier.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
