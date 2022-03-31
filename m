Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B354EDC73
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiCaPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiCaPOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:14:49 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A73921592E;
        Thu, 31 Mar 2022 08:12:58 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AC95622239;
        Thu, 31 Mar 2022 17:12:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648739577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKNzYY1umw6ncPUkV/s+Z1c6c1JSxtIaTyW678gbWl4=;
        b=b/23SHrNBRL0KpkVOSOgp1o1STpMTZ7KfDVHEqv2GJhVYBMzc4/cebfO7u6CPPRLxM12p/
        eaOdYLCBN3m/lOQvt1XYdBT52cDgTIQoe3q/Th4yUvilipKtGuphh8lFIFeSe0L6/BNEIs
        1H3H+MWz6UYo7vWqef0PBrIKY2x0jvw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Mar 2022 17:12:56 +0200
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>, Xu Yilun <yilun.xu@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <YkXBgTXRIFpE+YDL@shell.armlinux.org.uk>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
 <20220330145137.GA214615@yilunxu-OptiPlex-7050>
 <4973276f-ed1e-c4ed-18f9-e8078c13f81a@roeck-us.net>
 <YkW+kWXrkAttCbsm@shell.armlinux.org.uk>
 <7b3edeabb66e50825cc42ca1edf86bb7@walle.cc>
 <YkXBgTXRIFpE+YDL@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <32e0a05294d18c88efc41ed85c082c80@walle.cc>
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

Am 2022-03-31 16:58, schrieb Russell King (Oracle):

> Note that there's another "sanitisation" of hwmon names in
> drivers/net/phy/marvell.c - that converts any non-alnum character to
> an underscore. Not sure why the different approach was chosen there.

I saw that, but I didn't touch it because it would change the
name. I guess that will be an incompatible userspace change.

-michael
