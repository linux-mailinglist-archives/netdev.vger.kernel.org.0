Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A295129385
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfLWJMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:12:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfLWJML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 04:12:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bAdtBwWkl2nNBi96dSw1GClQlkLNwAKXFE2bNg7I6x0=; b=yU6/pOh3Egufn+Oz3DTcUiWziF
        GJ3+ZVoRoqGzyCfP6AR5QB0vPhvlyzJMcauvG5R6aljURotY/5m8ZJSncNrcrZLzNPMvzt+w6ow0g
        rmnrzyEy2qI9pZstnshssxJYioZB3O4L+iGcXe5b1UQvMIefG4++anfM2Ljj9jhDsSEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijJkz-0000VC-SJ; Mon, 23 Dec 2019 10:12:05 +0100
Date:   Mon, 23 Dec 2019 10:12:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V8 net-next 06/12] net: phy: dp83640: Move the probe and
 remove methods around.
Message-ID: <20191223091205.GE32356@lunn.ch>
References: <cover.1576956342.git.richardcochran@gmail.com>
 <ed071a6dc40506744a7db58a4207ac8d7cdd993e.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed071a6dc40506744a7db58a4207ac8d7cdd993e.1576956342.git.richardcochran@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 11:36:32AM -0800, Richard Cochran wrote:
> An upcoming patch will change how the PHY time stamping functions are
> registered with the networking stack, and adapting this driver would
> entail adding forward declarations for four time stamping methods.
> However, forward declarations are considered to be stylistic defects.
> This patch avoids the issue by moving the probe and remove methods
> immediately above the phy_driver interface structure.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Hi Richard

Thanks for adding this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
