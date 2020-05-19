Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950801D9F80
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgESS30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:29:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgESS3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 14:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6uCQIOARttavPA6jMK2O27q7AM5rPupXUJtqotwWi1Q=; b=1XVZ5oVE7XtBh5zBkgH16yxly3
        xp6tfNbcdSexEsqB5s7AEL7MkxuYEty1CC6UvPZUUq6Szy9LXuMzbIn55KqlHvn2U5ufQxSaaA3Pf
        l3hZiuWdZwbempjBz5K+jItnAO5s+IzBS3qxDa+/xnBOtl02rgMMs5TVRzptC6dbvYCY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jb6zM-002jfC-Pp; Tue, 19 May 2020 20:29:16 +0200
Date:   Tue, 19 May 2020 20:29:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dan Murphy <dmurphy@ti.com>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
Message-ID: <20200519182916.GM624248@lunn.ch>
References: <20200519141813.28167-1-dmurphy@ti.com>
 <20200519141813.28167-3-dmurphy@ti.com>
 <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519095818.425d227b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 09:58:18AM -0700, Jakub Kicinski wrote:
> On Tue, 19 May 2020 09:18:11 -0500 Dan Murphy wrote:
> > If the op-mode for the device is not set in the device tree then set
> > the strapped op-mode and store it for later configuration.
> > 
> > Signed-off-by: Dan Murphy <dmurphy@ti.com>
> 
> ../drivers/net/phy/dp83869.c: In function0 dp83869_set_strapped_mode:
> ../drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
>   171 |  if (val < 0)
>       |          ^

Hi Jakub

This happens a lot with PHY drivers. The register being read is a u16,
so that is what people use.

Is this now a standard GCC warning? Or have you turned on extra
checking?

	Andrew
