Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA74E972E
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbiC1M6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241825AbiC1M6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:58:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C445C867;
        Mon, 28 Mar 2022 05:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pRjaBGSTB11UhJkDLE739kF5XFXFSma1cDyuHSGvJtA=; b=a4X/O4aMdcRj0Sw0m/L3QJdUom
        QQql0acMDYQQBq18Q5XmTuwZl4/lnNeJaMK8qlSvQQqE/QpsNq05XgpKGqnYbhLBKi17gGLb58Ssg
        EdCJp7Pgum+IaE+z8ki+1ARHJE14aUOwFnpIB77LkFCuFvs2dT7Dc6ePaH+VDvFcMePY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYovO-00D17l-LF; Mon, 28 Mar 2022 14:56:46 +0200
Date:   Mon, 28 Mar 2022 14:56:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] hwmon: introduce hwmon_sanitize()
Message-ID: <YkGwjjUz+421O2E1@lunn.ch>
References: <20220328115226.3042322-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328115226.3042322-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not sure how to handle this correctly, as this touches both the
> network tree and the hwmon tree. Also, the GPY PHY temperature senors
> driver would use it.

There are a few options:

1) Get the hwmon_sanitize_name() merged into hwmon, ask for a stable
branch, and get it merged into netdev net-next.

2) Have the hwmon maintainers ACK the change and agree that it can be
merged via netdev.

Probably the second option is easiest, and since it is not touching
the core of hwmon, it is unlikely to cause merge conflicts.

    Andrew
