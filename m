Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C63939CA87
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFESif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 14:38:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhFESid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 14:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q9A9bTRJ/BXurUIJsUUU4JvGyPYO4HbEeNeoOZQLTfY=; b=YP0u6wrCeuDe3xcvb8vjsb5iwm
        yv362nXUTADnZDnyHXMDBwHZXNBhgUExEs57fiqnZdMRR2+4ro8MkWyfbBNlQLFLVI1PfJpcmIufA
        rdirRijazmNXcFRLThSSVR1VOAlE8aPwqbTJY1VfObTSHXMkPW9HcW0DWDPTYg8WtpaI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpb9x-007x00-9I; Sat, 05 Jun 2021 20:36:37 +0200
Date:   Sat, 5 Jun 2021 20:36:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YLvENQ/aadG0TcRp@lunn.ch>
References: <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
 <YLbqv0Sy/3E2XaVU@lunn.ch>
 <20210602141557.GA29554@linux.intel.com>
 <YLed2G1iDRTbA9eT@lunn.ch>
 <20210602235155.GA31624@linux.intel.com>
 <20210605003722.GA4979@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605003722.GA4979@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can you take a look at the latest implementation and provide
> feedback?

I think we are close, so please submit a proper patch.

       Andrew
