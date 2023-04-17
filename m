Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF286E3D3B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 03:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDQBrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 21:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQBq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 21:46:59 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B41211D;
        Sun, 16 Apr 2023 18:46:49 -0700 (PDT)
X-QQ-mid: Yeas43t1681695972t617t22105
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 6726329158921540316
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Wolfram Sang'" <wsa@kernel.org>,
        "'Jarkko Nikula'" <jarkko.nikula@linux.intel.com>,
        <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com> <20230411092725.104992-3-jiawenwu@trustnetic.com> <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com> <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com> <ZDgtryRooJdVHCzH@sai> <01ec01d96ec0$f2e10670$d8a31350$@trustnetic.com> <438840fa-6e8b-44c5-8b90-be521c72b77a@lunn.ch>
In-Reply-To: <438840fa-6e8b-44c5-8b90-be521c72b77a@lunn.ch>
Subject: RE: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master driver
Date:   Mon, 17 Apr 2023 09:46:09 +0800
Message-ID: <024001d970ce$62482750$26d875f0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQJXy8bYFbRwx/PFgpvJPX7PgyT97wJCMZrbAk6D9c4BtpNb5AI7nLSFAlh8gEMBnL3xP63OQy8g
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, April 15, 2023 11:11 PM, Andrew Lunn wrote:
> > I don't quite understand how to get the clock rate. I tried to add a software
> > node of clock with property ("clock-frequency", 100000) and referenced by
> > I2C node. But it didn't work.
> 
> I've not spent the time to fully understand the code, so i could be
> very wrong....
> 
> From what you said above, you clock is fixed? So maybe you can do
> something like:
> 
> mfld_get_clk_rate_khz()
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/i2c/busses/i2c-designware-pcidrv.c#L97
> 
> How are you instantiating the driver? Can you add to
> i2_designware_pci_ids[]?
> 
>     Andrew
> 

There is no PCI ID for our I2C device, so I register the platform I2C device.

