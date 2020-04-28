Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7930C1BBE87
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgD1NGc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 09:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726909AbgD1NGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 09:06:31 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29163C03C1A9;
        Tue, 28 Apr 2020 06:06:31 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jTPw8-00082n-TE; Tue, 28 Apr 2020 15:06:08 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] lan743x: Added fixed_phy support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200427215209.GP1250287@lunn.ch>
Date:   Tue, 28 Apr 2020 15:06:07 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1AD2250A-45D3-43D7-926C-829094F1721A@berg-solutions.de>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
 <20200426143116.GC1140627@lunn.ch>
 <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
 <20200427215209.GP1250287@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1588079191;8ccd58ed;
X-HE-SMSGID: 1jTPw8-00082n-TE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> What is the MCU? ARM?

Yes, i.mx6 with ARM.

> 
>> […]
> 
> If you are using ARM, device tree is the way to go.
> 	  Andrew
> 

Sounds reasonable, I’ll move the fixed_phy configuration for lan743x from .config to the device tree, thanks a lot Andrew.

Roelof
