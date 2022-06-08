Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4D54310A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240011AbiFHNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbiFHNJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:09:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30575299787;
        Wed,  8 Jun 2022 06:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nuHXCEhg95WUaPjY5z9jSwtv8QinU/1nDQWrwV1T6U0=; b=NM/jg9HTCgbFQKIeomJDugImBI
        tcziUH/30eTmMm5P/IkTtDAIoQ02diRvIPaVtGQBv6s16YdnDK9dM07PO7UGtAB7/7v8pJjRstTO7
        vbfILdHQiaBvX8qSSMNi+XJ9uyRHzkN4OwUyOdTpHwLis2uP8dtXNPIJaVoHQaUjDM2o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyvQf-0064wm-0q; Wed, 08 Jun 2022 15:08:57 +0200
Date:   Wed, 8 Jun 2022 15:08:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: add remote fault support
Message-ID: <YqCfaXmQngTsYnsF@lunn.ch>
References: <20220608122322.772950-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608122322.772950-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 02:23:20PM +0200, Oleksij Rempel wrote:
> changes v2:
> - add missing genphy_c45_aneg_done_lp_clean() patch

FYI:

It will be the weekend before i get to reviewing patches.

   Andrew
