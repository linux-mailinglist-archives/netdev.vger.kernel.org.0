Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284E36FEB4
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhD3Qgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3Qgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 12:36:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACA9C06174A;
        Fri, 30 Apr 2021 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=K7jGaTHfEQ6kK3GTB6fc3dOj6dwW1OrNnyfsm6TT+EQ=; b=dpicyZ8dXHgppOLjyGvXVr39YO
        d1KiiZ9TwApCDNRsRYI/ddMbABvwaTMPRTM7Dh9t9xg58r2PWBTzFJT0ePykwoWcsHBJTEql26gwE
        KziTOTlO8tKVlz8Cgzu/FctuQZ5QNLuGY4x8rl7f7/h/T6zRkfT6WJem4LzdHVVP4zCEkv0Y+5W1X
        q9bpTyfBd7/Pbv/fRUaCGqciTwbS7EvcQej0IcBkwnr63oFJb5RUc3emRg6csoyVDZ51sS2T7RSd9
        WkDh5T/icOomR/bznFM97jHnL6JF28wwgsqZuvycBwjzda9NJIhnSUMGqNYbIcViw0YM9LiVix418
        ja13tioQ==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lcW5L-00BGPi-6y; Fri, 30 Apr 2021 16:34:09 +0000
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
 <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
 <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de> <YIwu+4ywaTI4+eUq@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6865cd7a-7f2e-13f5-a588-8877d771b834@infradead.org>
Date:   Fri, 30 Apr 2021 09:33:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIwu+4ywaTI4+eUq@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 9:23 AM, Andrew Lunn wrote:
>>> Thanks for the patch/option. But I think it should just default to n,
>>> not PHYLIB.
>>
>> It should be enabled by default for every device supporting this kind of
>> selftests.
> 
> I agree.
> 
> I still wonder if there is confusion about self test here. Maybe

Probably.

> putting ethtool into the description will help people understand it
> has nothing to do with the kernel self test infrastructure and kernel
> self testing.

So it's a hardware check that is required to be run if it's implemented
in a driver?

Required by who/what?

thanks.
-- 
~Randy

