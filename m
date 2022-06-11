Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BEC5475D0
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiFKOvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 10:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiFKOvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 10:51:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87715584;
        Sat, 11 Jun 2022 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/EEge3ftYRCZN5Nh04+7KkRdYV+5milHO3YyNYaNuqY=; b=0U
        rcM6JbUZgmpprIh8gXXmSQ+tH9GHd0ii4a55+BC4iJeJ7hYNIjpzA1hutbEX6UHiqj4pYBQF3NkZV
        qmPmRDmWSzR42yedwY37gPk3ZohAu0cqDyiBnkQZVzJPSgNbDWJhVCBX8Kl13q94wb2dvNDriDyie
        Y1ZQVdwBogGd9sc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o02Rk-006W9u-Sy; Sat, 11 Jun 2022 16:50:40 +0200
Date:   Sat, 11 Jun 2022 16:50:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: networking: phy: Fix a typo
Message-ID: <YqSrwHg/JpCvmz4j@lunn.ch>
References: <20220610072809.352962-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220610072809.352962-1-j.neuschaefer@gmx.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:28:08AM +0200, Jonathan Neuschäfer wrote:
> Write "to be operated" instead of "to be operate".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
