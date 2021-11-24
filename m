Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956D645C8A7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhKXPdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:33:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236235AbhKXPdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 10:33:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0zu8tn9ID6lGE9Wj4S3+hQxg37uXJ+G7Hgh7Z/fOwio=; b=Uxsr5etidZqxHt8nHq80cd6Snu
        Z74UakM3yLNj+6bfq0dJJlTr5bbsU+71jryH/6R7fVnFufcLXqAvHhgOBxXdJXZq8DT1rgMjDBJ0N
        Lc6l+ENvyNzzKe2U9g0Zz/CxEB15ubVX/E1Al8rIPDPhYjKGNlBFQELT4ZSmWjlS9Xc4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpuDc-00EWEE-3v; Wed, 24 Nov 2021 16:29:56 +0100
Date:   Wed, 24 Nov 2021 16:29:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, hkallweit1@gmail.com,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH] net:phy: Fix "Link is Down" issue
Message-ID: <YZ5adFBpaJzPwfvc@lunn.ch>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
 <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We should cc stable too.

https://www.kernel.org/doc/html/v5.12/networking/netdev-FAQ.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

	Andrew
