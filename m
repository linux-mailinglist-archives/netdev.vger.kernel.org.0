Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7506E513F19
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiD1Xh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiD1XhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:37:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F98A88AC
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aeU8QZBNbEsbkeRX/fTdVmrfFU9Xod785WekrrI7LZY=; b=34R7Ai0+VwiMo0N3fmmMeQZEnl
        xH11aQP7Nt5iCr+px9i+CZ41/cATr5+7+ZdrkccgTUCuwQAhjCePuTeedlShUYPVVnemg98Pb+tZI
        qaf30GG5IE2P20iKYfHK5QL5z7t+VzxOQmllMiIBIanEvqCM/zMMPJMXAhzCF88BJLwg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkDeA-000ORr-Ot; Fri, 29 Apr 2022 01:34:06 +0200
Date:   Fri, 29 Apr 2022 01:34:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 2/3] net: phy: adin: add support for clock output
Message-ID: <YmskbgGqoggSrHWR@lunn.ch>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-3-josua@solid-run.com>
 <YmqGwjGt/Fbeu2kJ@lunn.ch>
 <9a7490d2-7553-f0cb-8a57-9c8412259060@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a7490d2-7553-f0cb-8a57-9c8412259060@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thank you for the fast reply, I'll make sure to fix this in a v4, if any.
> Do you want a v4 for this? Or is it worth waiting for more feedback now?

As a general rule of thumb, wait at least one day before posting a new
version.

   Andrew
