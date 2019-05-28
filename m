Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867042CF8E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfE1TfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:35:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbfE1Te7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 15:34:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rUU10bSnv0YXJiC2xFyWmRqh3IXyVKamEkmDXtM74U8=; b=rXcGLcB6GAQVoSWCWlTXafH2hR
        92ZKiRZrIkSX5EW9L3ZsQfYbnmWsehe4IscpjNS/kJY0uZ6ZHW+siXqMG6PFLIS293SsZ7Kihz1wX
        DhQIW9cqm8zVp8ACAwkIYXEXYPcj9IVyzJlCvf7JmeVpapGF3WMC2o1nBhFU9mi4aeww=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVhrx-0002ZI-VW; Tue, 28 May 2019 21:34:45 +0200
Date:   Tue, 28 May 2019 21:34:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190528193445.GU18059@lunn.ch>
References: <20190517235123.32261-1-marex@denx.de>
 <e5e36955-732f-4b5b-50f7-78609fcae888@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5e36955-732f-4b5b-50f7-78609fcae888@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:44:24AM -0700, Guenter Roeck wrote:
> >+static u32 tja11xx_hwmon_in_config[] = {
> >+	HWMON_I_LCRIT_ALARM,
> >+	0
> >+};
> >+
> >+static const struct hwmon_channel_info tja11xx_hwmon_in = {
> >+	.type		= hwmon_in,
> >+	.config		= tja11xx_hwmon_in_config,
> >+};
> >+
> >+static u32 tja11xx_hwmon_temp_config[] = {
> >+	HWMON_T_CRIT_ALARM,
> >+	0
> >+};
> >+
> >+static const struct hwmon_channel_info tja11xx_hwmon_temp = {
> >+	.type		= hwmon_temp,
> >+	.config		= tja11xx_hwmon_temp_config,
> >+};
> >+
> >+static const struct hwmon_channel_info *tja11xx_hwmon_info[] = {
> >+	&tja11xx_hwmon_in,
> >+	&tja11xx_hwmon_temp,
> >+	NULL
> >+};
> >+
> You might want to consider using the new HWMON_CHANNEL_INFO() macro
> to simplify above boilerplate code.

Hi Guenter

That is a nice simplification. Could you run the semantic patch
in drivers/net/phy and submit the results.

Thanks
	Andrew
