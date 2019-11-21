Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D01104EC5
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUJL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:11:28 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54004 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2m8sHqxbMuus5FLhodLrWPaA0QvExavFaEJfRF0MuCg=; b=HZn/Zk7BPxTNkgGTln9E/zbp9
        8N/z2atvyAJ7k0ZRfll3u8QcN+D84n6MeULGjNBLBWvAK7ivYvZchezg3cEigqjXvuT5YBhZj3S/W
        S6YB13gHLLhpFNhNmWOIyfsH4uqwgxh571TdwjAO10ORg6XcXIT/wokXR5aprZkm/g7+dmiV8XxQV
        fE/4IgMC1YjwNHFwJxfkPieGbwroVH5ZgNhtNaxFqJNd9ngX5hilE7cZCtGtH2+QTNZH8sMbMMDS9
        U8cglrKgImSp2uffcF7soSbSrP+THudjxE9RTLjupSc/xf6O+G3BMcda53lAlYxTyASYVNlURPqA9
        PiPwFZt5A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59152)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXiUi-0005hb-Ld; Thu, 21 Nov 2019 09:11:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXiUf-0002cL-PO; Thu, 21 Nov 2019 09:11:17 +0000
Date:   Thu, 21 Nov 2019 09:11:17 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: add support for module quirks
Message-ID: <20191121091117.GY25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
 <E1iXONe-0005el-H8@rmk-PC.armlinux.org.uk>
 <20191121022452.GF18325@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121022452.GF18325@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:24:52AM +0100, Andrew Lunn wrote:
> > +static size_t sfp_strlen(const char *str, size_t maxlen)
> > +{
> > +	size_t size, i;
> > +
> > +	/* Trailing characters should be filled with space chars */
> > +	for (i = 0, size = 0; i < maxlen; i++)
> > +		if (str[i] != ' ')
> > +			size = i + 1;
> 
> Hi Russell
> 
> Is this space padding part of the standard? What's the bet there are
> some with a NULL character?

Yes, it's specified.  I haven't yet seen a module not space-pad.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
