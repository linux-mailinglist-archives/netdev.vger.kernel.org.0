Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CC61C1CA7
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgEASOQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 May 2020 14:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728856AbgEASOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:14:16 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13549C061A0C;
        Fri,  1 May 2020 11:14:16 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jUaAa-0007Bv-NN; Fri, 01 May 2020 20:13:52 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed_phy support / Question regarding
 proper devicetree
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <3C939186-D81B-4423-A148-6C5F104E3684@berg-solutions.de>
Date:   Fri, 1 May 2020 20:13:51 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <939467EA-9CE3-4BDC-85A4-70FFA28438B7@berg-solutions.de>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
 <20200426143116.GC1140627@lunn.ch>
 <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
 <20200427215209.GP1250287@lunn.ch>
 <3C939186-D81B-4423-A148-6C5F104E3684@berg-solutions.de>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1588356856;20b7b51d;
X-HE-SMSGID: 1jUaAa-0007Bv-NN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Working status: I added fixed_phy support to the Microchip lan743x ethernet driver and for upstream contribution I need to make it runtime configurable via the device tree.

Question:

There are, amongst other, the following devices on my target (i.mx6): 
/soc/aips-bus@2100000/ethernet@2188000
/soc/pcie@1ffc000

Where would I put my additional lan743x ethernet device in the device tree ?

a) /ethernet@0
    (Just a new root node.

b) /pci@0/ethernet@0
    (I would „invent“ pci@0 to reflect that the lan7431 is sitting on the first pci slot.

c) /soc/pcie@1ffc000/ethernet@0
    (That doesn’t feel right to me, it’s not a soc property. Or is it ?

Example:

        pci0 {
                ethernet@0 {
                        compatible = "rmtl-meu-hl“;
                        status = "okay“;
                        phy-connection-type = "rgmii“;
                        
                        fixed-link {
                                speed = <100>;
                                full-duplex;
                        };
                };
                
        }

Thanks a lot,
Roelof

> 
>> […] device tree is the way to go. […]
>> 
>> 	  Andrew
> 

