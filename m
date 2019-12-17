Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADFA122744
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfLQJCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:02:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfLQJCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 04:02:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7CI2YZJ/8kkjDmWFsgWfJMjoC+U2bWASu4nzoT1xZSI=; b=AekoEEl9snBbB6iU+ExjmC5Ozo
        6t0eoS+9HRrABZqcFt2wm+2mBWRNQugDAIfWTLHnEiKurcjixzaYWU7qvH51IqAggQi96y1DadTl6
        xov3+bjQW5tqgzb740HZR3E/x5+trcdip4jAeqJ5zwY9smBzMrHhNw6CbTiR14ACjy6U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8jv-0003NU-T3; Tue, 17 Dec 2019 10:01:59 +0100
Date:   Tue, 17 Dec 2019 10:01:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 04/11] net: ethtool: Use the PHY time
 stamping interface.
Message-ID: <20191217090159.GJ6994@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <b4c9c4aa3dc766fc8cd82ad027a2e639d5d1e168.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4c9c4aa3dc766fc8cd82ad027a2e639d5d1e168.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:19AM -0800, Richard Cochran wrote:
> The ethtool layer tests fields of the phy_device in order to determine
> whether to invoke the PHY's tsinfo ethtool callback.  This patch
> replaces the open coded logic with an invocation of the proper
> methods.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
