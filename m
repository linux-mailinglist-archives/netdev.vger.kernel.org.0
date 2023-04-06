Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC99B6D8FE7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbjDFHAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbjDFHAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:00:41 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE86293E4
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:00:35 -0700 (PDT)
X-QQ-mid: Yeas48t1680764371t768t35378
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 14344417848988765152
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <mengyuanlou@net-swift.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com> <20230403064528.343866-3-jiawenwu@trustnetic.com> <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch> <03fc01d9669f$cb8cb610$62a62230$@trustnetic.com> <3086ecbc-2884-4743-9953-96f2a225ddbb@lunn.ch>
In-Reply-To: <3086ecbc-2884-4743-9953-96f2a225ddbb@lunn.ch>
Subject: RE: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Date:   Thu, 6 Apr 2023 14:59:29 +0800
Message-ID: <000001d96855$55648460$002d8d20$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQKwNRf195lW+I6aexcIjeJmW6Wh1gGmqyMsAIahL1wCLHqXSAHQLG4crT7r3tA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Is the I2C bus master your own IP, or have you licensed a core?
> > > Or using the open cores i2C bus master? I just want to make sure
> > > there is not already a linux driver for this.
> > >
> >
> > I use the I2C core driver, and implement my own i2c_algorithm.
> > I think it needs to configure my registers to realize the function.
> 
> I had a quick look, and it appears the hardware is not an open-cores
> derived I2C bus master.
> 
> As i tried to say, sometimes you just license an I2C bus master,
> rather than develop one from scratch. And if it was a licensed IP
> core, there is likely to be an existing driver.
> 

By consulting with hardware designers, our I2C licensed the IP of
Synopsys.
But I can't use the I2C_DESIGNWARE_CORE directly, because IRQ is not
supported in our I2C.

