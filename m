Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9948E05B3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbfJVOA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:00:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbfJVOA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 10:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p9SnhQgYJXrU5j+i4l/4+iQdYhZXcc7Bd1NIj95Si/Q=; b=g60U/Iu5Or8wQtL8CSYCFdEQR1
        6jlbFOJPqEqR5lScGcOZnbCl+u5PZr1JG5Og+w8OSgIoSkpcedsbxBKfs5HMXotgDU8X6TnpWM+PT
        21GT0t0Eis08g4A+OM9qsqEzOY8tc7xCO1wn3zHESZESA/XYqddUkc0t0//iJWMBMLaU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMui2-0001vD-5h; Tue, 22 Oct 2019 16:00:26 +0200
Date:   Tue, 22 Oct 2019 16:00:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas =?iso-8859-1?Q?H=E4mmerle?= 
        <Thomas.Haemmerle@wolfvision.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
Message-ID: <20191022140026.GD27462@lunn.ch>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:06:35PM +0000, Thomas Hämmerle wrote:
> From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
> 
> This adds WoL support on TI DP83867 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
