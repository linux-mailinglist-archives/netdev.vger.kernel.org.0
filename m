Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC819EC5E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfD2V6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:58:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49159 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfD2V6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Py06+6xrOdr/1YHAv9vMJAiUP0/+fHcBXZLZ6n7QYKA=; b=kOYe6MGc2xJp9qdhl7mtDf5dot
        5Y3/hRg3OGlWmADlF6Zw8Qb6YrWrxUBNbWOwnLENsIdDhcThTPeFdLVH8tYov3W3UsQ7N8TK0mGJs
        LklFqBuYCKWK8AuyRG4LgoOfHGnl0YUN0JPBZhRJVupvcH+ZPh1B3XcdP+W+9wAeQpgE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEIR-00076v-FJ; Mon, 29 Apr 2019 23:58:47 +0200
Date:   Mon, 29 Apr 2019 23:58:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 12/13] net: dsa: b53: Use vlan_filtering
 property from dsa_switch
Message-ID: <20190429215847.GK12333@lunn.ch>
References: <20190428184554.9968-1-olteanv@gmail.com>
 <20190428184554.9968-13-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428184554.9968-13-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 09:45:53PM +0300, Vladimir Oltean wrote:
> While possible (and safe) to use the newly introduced
> dsa_port_is_vlan_filtering helper, fabricating a dsa_port pointer is a
> bit awkward, so simply retrieve this from the dsa_switch structure.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
