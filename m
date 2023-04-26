Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DDD6EF516
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbjDZNH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbjDZNHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:07:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C057420C;
        Wed, 26 Apr 2023 06:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7pvPIFfQISrvygL0NKZNTqfVqAirjXh9IfpFLCWuJSo=; b=ycUUXeftciJ9aY8sOmcjMWr725
        ++nBg+6xURirnWWwKfUHvXzJBwvCHRCy0TXZx9XfOJBUQhT4oKBDntK0NzgLjopV7qtNOVhOZcg7P
        uG/0PVcl0o69v3yktZmTQRyygFMF+CLuvHSCkunbEwrbrrAA1PC18ySMZxPGS/Rwhkck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1preen-00BGu2-75; Wed, 26 Apr 2023 14:54:01 +0200
Date:   Wed, 26 Apr 2023 14:54:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Devang Vyas <devangnayanbhai.vyas@amd.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: aquantia: Add 10mbps support
Message-ID: <7ae81127-a2aa-4f02-8c07-b8f158e0ef83@lunn.ch>
References: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 01:46:12PM +0530, Devang Vyas wrote:
> This adds support for 10mbps speed in PHY device's
> "supported" field which helps in autonegotiating
> 10mbps link from PHY side where PHY supports the speed
> but not updated in PHY kernel framework.

Are you saying it is not listed in BMSR that the PHY supports 10 Mbps?
Bits BMSR_10HALF and BMSR_10FULL are not set?

     Andrew
