Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DA41B5C27
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgDWNJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:09:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgDWNJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 09:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CXopAFf+v3DrZghcT1PRn9hNXamCDAcmsSXzQpfAlnQ=; b=wml8c2wgtCH3o3UTAJH6DM83/I
        9kmXEt4J0VboFLBcECVMDa0BdH8szIhZuCREUg9mEFRUcXvfrCccH95X7rowClr6OgwPHGOYf3RtU
        UPwf6Z8xvtS0rsZxLckKYagPV/IwST/izHiMdhww9z+KB+ORh7ZJ4KzEEOZVEE/IxJwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRbbD-004Nm2-J9; Thu, 23 Apr 2020 15:09:03 +0200
Date:   Thu, 23 Apr 2020 15:09:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v3 2/2] net: phy: marvell10g: hwmon support for 2110
Message-ID: <20200423130903.GA1044545@lunn.ch>
References: <99771ceabb63b6a6a7d112197f639084f11e4aa4.1587618482.git.baruch@tkos.co.il>
 <f97e4690b4ec92598b3514f05e32dc26f37044ac.1587618482.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f97e4690b4ec92598b3514f05e32dc26f37044ac.1587618482.git.baruch@tkos.co.il>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 08:08:02AM +0300, Baruch Siach wrote:
> Read the temperature sensor register from the correct location for the
> 88E2110 PHY. There is no enable/disable bit, so leave
> mv3310_hwmon_config() for 88X3310 only.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
