Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8D7F32EF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfKGP02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:26:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfKGP02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 10:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wQULOKk/lYVpa1JN10WGq8H7gdCGjWrbJlOQtCbxYK8=; b=ZWHlsoZtqiBRKQfcH2Kog17SXl
        ulZFYGi6O+/o85fpp48CP2NTxg4tAOvWrSZK767f7sQ8xDhJXHz5gizB45tQVRDw4LsiTkM5aqmU2
        1shfD0/HcgfllvxDJR3t5r+hyv9hz7qUoBubQQbOXWHyj0Phx2xYqOF6ThUJUXMpnB5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSjg2-0006jp-Ev; Thu, 07 Nov 2019 16:26:26 +0100
Date:   Thu, 7 Nov 2019 16:26:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] enetc: ethtool: add wake-on-lan callbacks
Message-ID: <20191107152626.GE7344@lunn.ch>
References: <20191107084000.18375-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107084000.18375-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 09:40:00AM +0100, Michael Walle wrote:
> If there is an external PHY, pass the wake-on-lan request to the PHY.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
