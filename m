Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F1150013
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfFXDL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:11:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfFXDL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 23:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jL5DtyJhMfDU7vOTdIf6+Fqdg5HSU1xPRGdbaQRoiJk=; b=L+nwr5pMiU5zOuxnYgJKeIW4Id
        vmH8ksMm2zbs5DCCsETSssGZau5T/WLDQPIizh26BYWRkq/E/H8ESuCA6LTlvvLQJTVbXE98oy14X
        eUD23o+sxQ+ow+7qMGVKI1AlOajPouutKse4VQ/uSuz/AP9YyFZn062LYCqW9JIb5GFE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfFO9-0002Mp-05; Mon, 24 Jun 2019 05:11:25 +0200
Date:   Mon, 24 Jun 2019 05:11:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH V3 01/10] net: dsa: microchip: Remove ksz_{read,write}24()
Message-ID: <20190624031124.GH28942@lunn.ch>
References: <20190623223508.2713-1-marex@denx.de>
 <20190623223508.2713-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623223508.2713-2-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 12:34:59AM +0200, Marek Vasut wrote:
> These functions and callbacks are never used, remove them.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
