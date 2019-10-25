Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC0E5441
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfJYTVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:21:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfJYTVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 15:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q4/nbKU6CC3JXzz+qjJDX4qLq9bWq0sn1wPs0I/ADMw=; b=OMqzvmJg/UcKxwioDtWz+qtC3R
        aOQkcrFC214yqHx5Yeh2x99MfDZTRU05PiAqK71PeDCHgkQueRfrw4XwODU7eDxjd2D0t+rYyO+3+
        k/OTTZNO6BEoBJbgXUaGm0hWhBRAPEWbET4LqTguOKfxRGHKFNpibU9scudNkorr6fsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iO59e-0004Oq-1r; Fri, 25 Oct 2019 21:21:46 +0200
Date:   Fri, 25 Oct 2019 21:21:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: return directly from dsa_to_port
Message-ID: <20191025192146.GH30147@lunn.ch>
References: <20191025184853.1375840-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025184853.1375840-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 02:48:53PM -0400, Vivien Didelot wrote:
> Return directly from within the loop as soon as the port is found,
> otherwise we won't return NULL if the end of the list is reached.
> 
> Fixes: b96ddf254b09 ("net: dsa: use ports list in dsa_to_port")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
