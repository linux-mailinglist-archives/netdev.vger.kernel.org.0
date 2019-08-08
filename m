Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7D986613
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390113AbfHHPk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:40:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfHHPk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ykWdIZHW1UxomrUDZeNASp7QR/Ua4nkb9JcxElf/Skw=; b=Iho3v8FcNt3PT6dGV1NmpO2Zvc
        gEoHz2ACz22WvqJ+n0keCnO5dh4JbJqo7R3TiXaKkTMfMM/ILGMI98WTGY9ta9TCCIYz+eHgGzLy3
        F4+tye7TmohyT53VVteS48ooDiQmSxjq2Ti7WgdYF2UrVvsB8JCO8xVp2tJU9+wNBFJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvkX9-0003xO-BR; Thu, 08 Aug 2019 17:40:55 +0200
Date:   Thu, 8 Aug 2019 17:40:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 07/15] net: phy: adin: make RGMII internal delays
 configurable
Message-ID: <20190808154055.GG27917@lunn.ch>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-8-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808123026.17382-8-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:30:18PM +0300, Alexandru Ardelean wrote:
> The internal delays for the RGMII are configurable for both RX & TX. This
> change adds support for configuring them via device-tree (or ACPI).
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
