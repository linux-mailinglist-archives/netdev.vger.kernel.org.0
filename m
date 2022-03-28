Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83C74EA336
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiC1WsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiC1WsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:48:21 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274F4C74AA;
        Mon, 28 Mar 2022 15:46:40 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D82EF2223A;
        Tue, 29 Mar 2022 00:46:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648507598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDu381pRR0agv3tRC4rxYFKnPByM+nZCMTshkpw92fU=;
        b=UcQsgGiCk/vnobpIEFjlRmqkCrWqDsPOoAMEhpR0atrtcaJkgwtq8Ps70hTKCZuqjJ4inQ
        xMSvUGTmrjXMeOUKJPUiqbuF9N0Y1IBoxj7uDx43gkd6MAsaJUOSdqli2SpW0dFpMEYX/w
        hjeDGZN50zKJLbC06I+zAJUEpMd7ins=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Mar 2022 00:46:37 +0200
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: phy: use hwmon_sanitize_name()
In-Reply-To: <20220328115226.3042322-3-michael@walle.cc>
References: <20220328115226.3042322-1-michael@walle.cc>
 <20220328115226.3042322-3-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7e03397465a5c95cb9cd3a0f6c53b845@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-28 13:52, schrieb Michael Walle:
> Instead of open-coding it, use the new hwmon_sanitize_name() in th

s/th/the/ btw, will be fixed in the next version.

> nxp-tja11xx and sfp driver.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/nxp-tja11xx.c | 5 +----
>  drivers/net/phy/sfp.c         | 6 ++----

Andrew, do you also prefer two seperate patches?

-michael
