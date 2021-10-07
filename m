Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225EB42584B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbhJGQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233631AbhJGQtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0ngutiKOJ0WudAw+k4ezPA2j8LVfCbxRAnC2tenS7FA=; b=6SCVtMyBYejWyw5X3VO/Bsv8Gx
        lD0FOEkn4CRkyZksYUz1/IDuxMD2TJp4r6jrlofA3GUGAjK/8+/4CXHKfCSFRM3LxGKFnLWz0TIsp
        iuDfNi5Vjsq0NTxqcToWYfrgr56hK0O6X9eMfFGz5QFbA3tJHB8bkOGRByl6SWBJI8gk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYWY2-009yKN-Jg; Thu, 07 Oct 2021 18:47:10 +0200
Date:   Thu, 7 Oct 2021 18:47:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 06/13] Documentation: devicetree: net: dsa:
 qca8k: document rgmii_1_8v bindings
Message-ID: <YV8kjnX2TKgESC30@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-7-ansuelsmth@gmail.com>
 <YV46wJYlJZHAZLyD@lunn.ch>
 <YV71TCksnbixsYI0@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV71TCksnbixsYI0@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Only some device require this, with these bit at 0, the internal
> regulator provide 1.5v. It's not really a on/off but a toggle of the
> different operating voltage. Some device require this and some doesn't.

Can you provide a list of devices which require it?

    Andrew
