Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C8419117E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgCXNnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:43:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgCXNnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PGTJ624xy37YPjUynlw4h0mO/vuLMxq5CI5b1l8BwNQ=; b=Zigr7ijlBlsCbjDqY2gBPfgJ5B
        9NpdDRp1mpKob3tjOb3hJ91xItaccKePY5zYCNI7qw0mhN10pZPgqBq6gdfY2ALZJ0XDq8oWFTbBz
        oulDnAoomL3KCBwxFX6Z7cZ1pRfKOqHQpj8PQe54dF5f1B6VjomSzRDs+BL8el642XyI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGjqC-0002NK-Vj; Tue, 24 Mar 2020 14:43:36 +0100
Date:   Tue, 24 Mar 2020 14:43:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/14] net: axienet: Add mii-tool support
Message-ID: <20200324134336.GZ3819@lunn.ch>
References: <20200324132347.23709-1-andre.przywara@arm.com>
 <20200324132347.23709-11-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324132347.23709-11-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 01:23:43PM +0000, Andre Przywara wrote:
> mii-tool is useful for debugging, and all it requires to work is to wire
> up the ioctl ops function pointer.
> Add this to the axienet driver to enable mii-tool.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
