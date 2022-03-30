Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1964EC616
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346485AbiC3OAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiC3OAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:00:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D53CD316;
        Wed, 30 Mar 2022 06:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ekBWMhJOJrwEuMsGOrTITmAnhNKuavdbk+/QN6gEvTs=; b=YSvsl56WcO71Nuk3c5QDcSCxxy
        aqmLXXZtjnnXGU/x8qu7GjHoG3Gp9GlgliYoXWsgeP6v49TZjlQBa95By5+e0IYOPimXw9UdZjqAr
        gS3NTY/kV27ln73N0wWEoMsk4JzQkWtd5NEp2fVFXSH6qaRpO8TT+G+qmv0wSmRdd13g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZYqC-00DK3H-O3; Wed, 30 Mar 2022 15:58:28 +0200
Date:   Wed, 30 Mar 2022 15:58:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Guenter Roeck' <linux@roeck-us.net>,
        'Michael Walle' <michael@walle.cc>,
        Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Message-ID: <YkRiBAyw2DhIOitg@lunn.ch>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <16d8b45eba7b44e78fa8205e6666f2bd@AcuMS.aculab.com>
 <fa1f64d2-32a1-b8f9-0929-093fbd45d219@roeck-us.net>
 <cf6f672fbaf645f780ae5eab1a955871@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6f672fbaf645f780ae5eab1a955871@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So why not error the request to created the hwmon device with
> an invalid name.
> The name supplied will soon get fixed - since it is a literal
> string in the calling driver.

It is often not a literal string in the driver, but something based on
the DT description of the hardware.

    Andrew
