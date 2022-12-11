Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B62649433
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 13:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiLKMcr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Dec 2022 07:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLKMcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 07:32:46 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A30BCBE
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 04:32:42 -0800 (PST)
X-QQ-mid: bizesmtpipv601t1670761873tkcc
Received: from smtpclient.apple ( [255.227.236.1])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 11 Dec 2022 20:31:12 +0800 (CST)
X-QQ-SSF: 00400000002000M0N000B00A0000000
X-QQ-FEAT: vLOCICHxEeCY8YqoXyEX/OX9pOsSUQDhnNlhVW2C1Fc5y4EndGH7+LrQTv2Sl
        KTiDQCWWWKEJmTbiIiQkd5IvLV88kaXDf/2I7whnJVbU+rnpEMZIiIVEABUP05wBY7bPSoX
        m1VQiI7wwxo63UdU8jn8nMH2ZyUj6FPp76TeWRW1h8qrz3d+s71+6M+1q3FAHZo+Zn0kiRK
        fTYW0MEvKb/2oR8edrL9yJbk6PmELhJtbA24jEgn9OMVJnk/dWGWUEqpH5atZj0ymYnb9jG
        P6s0E2M/NS8nGeNjAtYm52YLKuX2oVNNE+C1vqRHe2Q4mwhzh7cZHDPGUXFO2y6QVNeHItW
        SHbF7QS4vhGiyh6KxX5JVNPVJgmrpquARRnVflIxbyDgIV9tJRk6rghbbVGEZG1ptHiWde1
        C6IOfcY1P/o=
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y5XG0uHwz3om0gLA@lunn.ch>
Date:   Sun, 11 Dec 2022 20:31:11 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Content-Transfer-Encoding: 8BIT
Message-Id: <53432661-8AF3-4984-A7E3-81A4441366B9@net-swift.com>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
 <Y5RjwYgetMdzlQVZ@lunn.ch>
 <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
 <Y5W+86YXppK2NocE@lunn.ch>
 <63385120-46C9-4D9E-81C7-9E72C3371C2C@net-swift.com>
 <Y5XG0uHwz3om0gLA@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpipv:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_ILLEGAL_IP,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2022年12月11日 20:02，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>>> If you don't have the I2C bus, i'm wondering how you can actually
>>> driver the SFP and the MAC. You have no idea what has been
>>> inserted. Is it actually an SFF, not an SFP? Do you have any of the
>>> GPIOs normally associated with an SFP? TX_DISABLE, LOS, TX_FAULT?
>>> 
>> 1、Yeah. We can't know what module is inserted
> 
> That is a very odd design. You are going to get all sorts of reports
> of it being broken when some random module is interested.
> 
> If it was my design, i would not use an SFP socket. I would solder
> down an SFF. They should be pin compatible. You then know exactly what
> you have, and how the MAC needs to be configured.
> 
>      Andrew
> 

The phy can tell Mac which speed needs to be configured.
just speed
Of course it's not good。

It is fully determined by the capability of the phy.

 
