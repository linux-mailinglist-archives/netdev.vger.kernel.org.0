Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B9C10912D
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfKYPnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:43:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfKYPna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 10:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZCf9Kkt3TeTs09/Oz9wTG0OEte/jakjzZuDoPC0XdTQ=; b=Wzz3T4LHOhbPB/Z2uRMfB7FMlX
        ss/US0QG1Kuz/iIqIcIkO4IYQG5uZm+MrG/OHq1x2xx5qgvpm7NeTWZBxIqKXOPhMzhNAtvI1uh8A
        0uNWxqaACBsG8JmPv66t8jU7G6bqiQ4ztUqimcoOu4PUiDPSQrUgdmtYN/+5+l9Ra1PI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZGWN-00081x-Gi; Mon, 25 Nov 2019 16:43:27 +0100
Date:   Mon, 25 Nov 2019 16:43:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] mdio_bus: don't use managed reset-controller
Message-ID: <20191125154327.GK6602@lunn.ch>
References: <20191122214451.240431-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122214451.240431-1-mail@david-bauer.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 10:44:51PM +0100, David Bauer wrote:
> Geert Uytterhoeven reported that using devm_reset_controller_get leads
> to a WARNING when probing a reset-controlled PHY. This is because the
> device devm_reset_controller_get gets supplied is not actually the
> one being probed.
> 
> Acquire an unmanaged reset-control as well as free the reset_control on
> unregister to fix this.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David Bauer <mail@david-bauer.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
