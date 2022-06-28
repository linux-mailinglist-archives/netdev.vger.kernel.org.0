Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71F55E66C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345890AbiF1OeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiF1OeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:34:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40292A429;
        Tue, 28 Jun 2022 07:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QcHAX7nHpBneq3UIwEwjAceE+HmpznszOZ6o9vu/Z2M=; b=ZG5zxHXiojsrlvoSfVuxq6M4El
        UeEm+ez/Hcz7oBN04f42ZprYq4CB7iUtlnAxFcO49IiyI6/XrQN6eqWa9gmLXJLvZH4OLSFm/fuNe
        rbU5s4PzcRFpkal6HrPADSgKJWLnYBQpbDEy7VRbRWD8oyIpHf+u5z3OUxaZw/7wxqm4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6CHp-008a0S-9a; Tue, 28 Jun 2022 16:33:53 +0200
Date:   Tue, 28 Jun 2022 16:33:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding LED feature for
 LAN8814 PHY
Message-ID: <YrsRUd6GPG0qCJsw@lunn.ch>
References: <20220628054925.14198-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628054925.14198-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 11:19:25AM +0530, Divya Koppera wrote:
> LED support for extended mode where
> LED 1: Enhanced Mode 5 (10M/1000M/Activity)
> LED 2: Enhanced Mode 4 (100M/1000M/Activity)
> 
> By default it supports KSZ9031 LED mode

You need to update the binding documentation.

    Andrew
