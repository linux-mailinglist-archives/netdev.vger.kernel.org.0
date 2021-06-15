Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96E3A8643
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFOQVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:21:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhFOQVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 12:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hfcnk72xFqtUl9Z41mbQpf9TF4mim3SVDeULJYikBbw=; b=kNW2fHPsiDklsGwGz/VRvxWNBE
        0Ot4zUlzsGGELl2dM08o09GWX4+1WqUYiX49jK0Jjxhs9kjkMvVdUols1MCXR6uMvR96+icH2Yc4S
        tHziaII4vTTOUD70zkoawy4+IGLS9HMI2IeZdcVRwHF4nmHDJGAOAm5WDP5glCaLdpeY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltBmg-009Y43-CX; Tue, 15 Jun 2021 18:19:26 +0200
Date:   Tue, 15 Jun 2021 18:19:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <YMjTDkJU58E3ITCJ@lunn.ch>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615154401.1274322-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> By mistake, the of_node of the MDIO device was not setup in the patch
> linked below. As a consequence, any PHY driver that depends on the
> of_node in its probe callback was not be able to successfully finish its
> probe on a PHY

Do you mean the PHY driver was looking for things like RGMII delays,
skew values etc?

If the PHY driver fails to load because of missing OF properties, i
guess this means the PHY driver will also fail in an ACPI system?

      Andrew
