Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2521122733
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLQJAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:00:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQJAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 04:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QD0bUtQBIYwomvuxn4SZbUREGXgcP7IB+oGOMKohp7M=; b=qw1YmDYkYe3pqm0jqKgKXzLphI
        BwWceTRV+V7OHHyTRS2z0wVTH5z+fPZO91qRBWzdj/SXjk50QouxWvKzeuiuUHU1O5dbwQ+HEmwtV
        qHwdgWgW4XqrQrr+FKv20QwanfPxA6ETk1IoPiklvepqLgCBehDvWxoChPhk+2nYuZQA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8hy-0002qG-0L; Tue, 17 Dec 2019 09:59:58 +0100
Date:   Tue, 17 Dec 2019 09:59:57 +0100
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
Subject: Re: [PATCH V6 net-next 02/11] net: macvlan: Use the PHY time
 stamping interface.
Message-ID: <20191217085957.GG6994@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <7f0669dcb222c66ea109863d5b90daf020cf54bc.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0669dcb222c66ea109863d5b90daf020cf54bc.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:17AM -0800, Richard Cochran wrote:
> The macvlan layer tests fields of the phy_device in order to determine
> whether to invoke the PHY's tsinfo ethtool callback.  This patch
> replaces the open coded logic with an invocation of the proper
> methods.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
