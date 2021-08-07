Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848333E35DE
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 16:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhHGOXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 10:23:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232443AbhHGOXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 10:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W+yNPO8ADdU8CJbeVWbrtRNwy3j7TqGqTagO91d37wQ=; b=cwHqDgSblUEbdM5Z+/x1u4cOm6
        /mGEUKr42O49n+jAZUJODNEXU+CQ2j1B3DHHkVNrDhL/3OCMU5aIAt1KAHf73bBuZuPmzWm3gHRlB
        E2FovNGzK+bdyR/dzwU81Q1eU2SOBBkXTHcv5kbyWQkaMKT5/RN5yM88cLfjFB0lS8qs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCNEL-00GVBy-Bl; Sat, 07 Aug 2021 16:23:17 +0200
Date:   Sat, 7 Aug 2021 16:23:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] net: mdio-mux: Delete unnecessary devm_kfree
Message-ID: <YQ6XVcjkgYnjHRnc@lunn.ch>
References: <20210804214333.927985-1-saravanak@google.com>
 <20210804214333.927985-2-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804214333.927985-2-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 02:43:30PM -0700, Saravana Kannan wrote:
> The whole point of devm_* APIs is that you don't have to undo them if you
> are returning an error that's going to get propagated out of a probe()
> function. So delete unnecessary devm_kfree() call in the error return path.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
