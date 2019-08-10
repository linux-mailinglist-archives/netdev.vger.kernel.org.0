Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EF088C6E
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfHJRS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:18:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJRS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xmEQ5BeUS78MHTvGtuJBfQ2t3wk0cgv0NIirhWw3fiU=; b=YqcQhxJKe7KG6g1jfGv2KN68yh
        7mseMme5FUxlXUHkyVL4oCKRyYtAMdM7hK7MpNo4dP++kMnClHYLYDkd39aJMLZma3vlYxTEe5ZBW
        BlMxXoKiZvEQJKDxRxdXr/6nJCRUS12gg3rk8OtmG9PzMAcwvHajvECcq465UpgBmz6c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwV16-0000Rh-Bu; Sat, 10 Aug 2019 19:18:56 +0200
Date:   Sat, 10 Aug 2019 19:18:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 5/6] net: mscc: remove the frame_info cpuq
 member
Message-ID: <20190810171856.GH30120@lunn.ch>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807092214.19936-6-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 11:22:13AM +0200, Antoine Tenart wrote:
> In struct frame_info, the cpuq member is never used. This cosmetic patch
> removes it from the structure, and from the parsing of the frame header
> as it's only set but never used.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
