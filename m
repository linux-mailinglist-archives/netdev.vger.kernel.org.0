Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526B438B65
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhJXScS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:32:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhJXScS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BPIUTFNp8Gx4lZcdSls9vEdJYycDEAQ0WxbXoCcMu1I=; b=V1MafNWOFLp1JaLPZ1CWUVRfFa
        U/0VLINPMfOZxot5fbhhOEblRT+QLTfBZ60gv+N5NKzHKf+FOEAOhBCjd6RJ1iQ8v41wbwtCBK1gq
        uleluYM3Q/Mua/wFIzL6RYZ9NNQJ6Y0LNjuGeDqvABwx8KRsjD5jf1uGfMh1Gd0hkeUI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiFj-00BZxD-DD; Sun, 24 Oct 2021 20:29:51 +0200
Date:   Sun, 24 Oct 2021 20:29:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 05/14] net: phy: add qca8081 ethernet phy driver
Message-ID: <YXWmH4+vuuzP4uOc@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-6-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-6-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:29PM +0800, Luo Jie wrote:
> qca8081 is a single port ethernet phy chip that supports
> 10/100/1000/2500 Mbps mode.
> 
> Add the basic phy driver features, and reuse the at803x
> phy driver functions.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
