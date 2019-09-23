Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6EDBB332
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfIWLzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 07:55:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfIWLzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 07:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mD9HkfzY4e4h2K+fwSxRisKajYr7beYDK4lgNu3nylY=; b=5MoApGd3HRuP23t2YFLUC0wfTE
        +w4W1itHqCpC4UdlARY+9r9/BrlkhybCOKeMkU7lGjFWy0XTHJzy86V4VsY/VbbVtoBCGK9VHjwBu
        g4eq956z7R/O8I19eJxe1yt8E0tHlfV6IscFKN1wPePq/dYp8rt+oR7EIKz9foSF3Oaw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCMvv-0003zO-TP; Mon, 23 Sep 2019 13:55:11 +0200
Date:   Mon, 23 Sep 2019 13:55:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH v2 2/2][ethtool] ethtool: implement support for Energy
 Detect Power Down
Message-ID: <20190923115511.GA14477@lunn.ch>
References: <20190920094431.13806-1-alexandru.ardelean@analog.com>
 <20190920094431.13806-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920094431.13806-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 12:44:31PM +0300, Alexandru Ardelean wrote:
> This change adds control for enabling/disabling Energy Detect Power Down
> mode, as well as configuring wake-up intervals for TX pulses, via the new
> ETHTOOL_PHY_EDPD control added in PHY tunable, in the kernel.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Hi Alexandru

This is better, thanks

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
