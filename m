Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F262EE7B7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbhAGVmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGVmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:42:54 -0500
X-Greylist: delayed 11832 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Jan 2021 13:42:14 PST
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E36EC0612F4;
        Thu,  7 Jan 2021 13:42:14 -0800 (PST)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id DEEE9142085;
        Thu,  7 Jan 2021 22:42:11 +0100 (CET)
Date:   Thu, 7 Jan 2021 22:42:11 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: question about i2c_transfer() function (regarding mdio-i2c on
 RollBall SFPs)
Message-ID: <20210107224211.4f01c055@nic.cz>
In-Reply-To: <20210107210248.GA894@kunai>
References: <20210107192500.54d2d0f0@nic.cz>
        <20210107210248.GA894@kunai>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 22:02:48 +0100
Wolfram Sang <wsa@kernel.org> wrote:

> > My question is whether this is allowed, whether the msgs array passed
> > to the i2c_transfer() function can have multiple msgs pointing to the
> > same buffer (the one into which the original page is first stored
> > with first i2c_msg and then restored from it in the last i2c_msg).  
> 
> Sending the messages is serialized, so the buffers won't interfere. At
> first glance, I think it would work this way. But it's late evening
> here, so I will have another look again tomorrow.
> 

I thought as much, but maybe there is some driver which can offload
whole i2c_transfer to HW, and has to pass the addresses of the buffers
to the HW, and the HW can have problems if the buffers overlap
somewhere...

Marek
