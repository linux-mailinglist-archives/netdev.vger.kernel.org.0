Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB1040AD79
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhINMZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:25:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232030AbhINMZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:25:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gX7VWtJFHvrtg+r8F7qBL1Fs6/uueMeDb/1HgLJEGqw=; b=oIP1+/vN5wjrnXNSoX+SI5Udgk
        T9jeyYkU0vosWkWKPEnCMlg+5N/s6lW9Ga7FL9UDTU81qbh8+sVPK09WYCQNtVGonvCsI3VCsPBUi
        79HIjCXanu/dpnf4o6kRJoNzFl2QHq5/PABFaE3vHQi4JAvWnTAj3us8KuDW0gre7e64=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQ7Tu-006a7u-4j; Tue, 14 Sep 2021 14:24:10 +0200
Date:   Tue, 14 Sep 2021 14:24:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: add support for qca 8327
 internal phy
Message-ID: <YUCUar+c28XLOCXV@lunn.ch>
References: <20210914071141.2616-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914071141.2616-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 09:11:41AM +0200, Ansuel Smith wrote:
> Add support for qca8327 internal phy needed for correct init of the
> switch port. It does use the same qca8337 function and reg just with a
> different id.

Hi Ansuel

Please also add it to the atheros_tbl array. It looks like the 8337 is
also missing as well.

Have you tried the cable test code on this PHY?

     Andrew
