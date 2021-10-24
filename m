Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13F5438B6E
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhJXSfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:35:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbhJXSfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I9MZ7dlPl6/uU7cWL3gvbSlAousRq/Arb8iy/54R0GI=; b=er8xTX+YAlCaUJVozaOwzDnFd/
        kphTypB2PAinaZqu5i3YAIUV6MRk8lFuvcjtx42+C681vJUbhbzTCDwAw3wudzuviG65DG551uh98
        EqR/7oN5SWcykwkc8bQypr6KC5/fE72ziRBQlW3GTVzZYEIX2cPwC2r5sqQWJmne/dGg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiIO-00BZzn-Qv; Sun, 24 Oct 2021 20:32:36 +0200
Date:   Sun, 24 Oct 2021 20:32:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 09/14] net: phy: add constants for fast retrain
 related register
Message-ID: <YXWmxDKP8g39c2TP@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-10-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-10-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:33PM +0800, Luo Jie wrote:
> Add the constants for 2.5G fast retrain capability
> in 10G AN control register, fast retrain status and
> control register and THP bypass register into mdio.h.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
