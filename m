Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8601C437EA7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhJVTcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:32:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhJVTcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HgVKIAA515yAeb7ROT2VMFCZaimvSXqM9EMn7CWsIws=; b=lzocFMt6PO9Oi93GV7xDnCGMIL
        NZir/jSlbEHQkgtlHxWDfEXVP1eKDjhCfYioHU6HXJYl986H4s9Y0TDjjilccyl/pM5ocn+tf1nqG
        VNxs62IjunW8TkFAdbsFv/VfmQdpwgQ9ZoCpjgJ45l11YjrucgrZn0T2AuGSLexumchs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0FF-00BQF6-4t; Fri, 22 Oct 2021 21:30:25 +0200
Date:   Fri, 22 Oct 2021 21:30:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: bcm7xxx: Add EPHY entry for 7712
Message-ID: <YXMRUeOG8rEzG7S1@lunn.ch>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
 <20211022161703.3360330-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022161703.3360330-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:17:01AM -0700, Florian Fainelli wrote:
> 7712 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
> utilize the recently defined 16nm EPHY macro to configure that PHY.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
