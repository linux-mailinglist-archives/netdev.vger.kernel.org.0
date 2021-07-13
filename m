Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B193C75FE
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 19:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhGMR4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 13:56:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGMR4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 13:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fwSEUPKLIXDYdatZtRYzvhcsqODqbAeg+WW5QkFpprg=; b=UbzJXkk4Ffkjzb9vhNhUMiuLGj
        5g9Lm8acdQp/yKLwGg15cSthbLsu5mCiOJLpekx9WyR6Iz95xYaIN7YQk3JGGaREMKvxMsOuS4LZw
        XJgPxMvEC/6qUeyDcZvUL3oTTExvipYlmfwmJJRyfTGeltPPGulzDcPexhtZPjd91R9s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3May-00DEt7-BI; Tue, 13 Jul 2021 19:53:24 +0200
Date:   Tue, 13 Jul 2021 19:53:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH v2 5/7] net: phy: adin1100: Add ethtool master-slave
 support
Message-ID: <YO3TFLTph38WYX0e@lunn.ch>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-6-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-6-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:06:29PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Allow user to select the advertised master-slave
> configuration through ethtool.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
