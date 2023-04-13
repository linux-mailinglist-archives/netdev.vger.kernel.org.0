Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7D86E11FA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjDMQO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjDMQOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:14:19 -0400
Received: from h1.cmg2.smtp.forpsi.com (h1.cmg2.smtp.forpsi.com [81.2.195.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7947EAD15
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:14:13 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mzaKpk51av5uImzaMp3ZUA; Thu, 13 Apr 2023 18:14:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681402452; bh=iOLUp2nAXZGQFF1l6CVjSOuv0QybhfNM0n4zwmq2vW0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=C1TlYo8uBNGOWvQipy5vhvPeAjODyY9xwblgMT3XrsSghX41hFFdKQ9+IJ0zTwHpD
         BwfWrRsK3ByGrh3qKdRvYch6TmYet1ROrMGx0l33IYsibGLJnsyBhjf7Pk7TJtXflZ
         W+C+rlW+O3IyWoNva/DD5UdtCJExH0WlPW6+xc7+Yu5RinOqMBCoHhLQHAZ6ofwgBB
         bbc+gHzWAraKvKjxhgyYBz837lBHwpJSI5x8OPhWbIT2a0Eux7FFLrtov6kM4Taiik
         ARf/4YPB1pp/xnmMTlprJMoLASts60f9tEMXpb0zv7iiu0hMpPdzvTFMLpef78PILu
         PMQAMv+heOqWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681402452; bh=iOLUp2nAXZGQFF1l6CVjSOuv0QybhfNM0n4zwmq2vW0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=C1TlYo8uBNGOWvQipy5vhvPeAjODyY9xwblgMT3XrsSghX41hFFdKQ9+IJ0zTwHpD
         BwfWrRsK3ByGrh3qKdRvYch6TmYet1ROrMGx0l33IYsibGLJnsyBhjf7Pk7TJtXflZ
         W+C+rlW+O3IyWoNva/DD5UdtCJExH0WlPW6+xc7+Yu5RinOqMBCoHhLQHAZ6ofwgBB
         bbc+gHzWAraKvKjxhgyYBz837lBHwpJSI5x8OPhWbIT2a0Eux7FFLrtov6kM4Taiik
         ARf/4YPB1pp/xnmMTlprJMoLASts60f9tEMXpb0zv7iiu0hMpPdzvTFMLpef78PILu
         PMQAMv+heOqWw==
Date:   Thu, 13 Apr 2023 18:14:08 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 1/3] staging: octeon: don't panic
Message-ID: <ZDgqUP0yWYHE7McL@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgN8/IcFc3ZXkeC@lenoch>
 <c69572ba-5ecf-477e-9dbe-8b6bd5dd98e8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c69572ba-5ecf-477e-9dbe-8b6bd5dd98e8@lunn.ch>
X-CMAE-Envelope: MS4wfFD9KN3px8S4W/xQvZBV6DCYM57l78jFMSBlwSuRsQOZHCLIpD3QpFNobWpX+4ZhZVAp9k/7yCPJkuZg3PvuTaBtOy1r5Hpna0Ai5CAwzZ2HK7mepGD/
 M6X0I5Ubbz9cBzJKR8pSJVGvCFNqLJrrN86wy4CSMTO0VuFk6+1CEx+0rUZj1NlHypfq9sd54w/Olr+eWoBXJTGMKjRxueUdj+OXC8nQFffF9dhy25d9up8v
 5/oFzre1UGV/rpZZ+18xhSZ2wBCGn5nSzKTaiR8YSBtJA+ezAgs2FEkGBN8pqW8uguaJfxBqdvFcx264glxcQA==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Thu, Apr 13, 2023 at 05:57:00PM +0200, Andrew Lunn wrote:
> > -void cvm_oct_rx_initialize(void)
> > +int cvm_oct_rx_initialize(void)
> >  {
> >  	int i;
> >  	struct net_device *dev_for_napi = NULL;
> > @@ -460,8 +460,11 @@ void cvm_oct_rx_initialize(void)
> >  		}
> >  	}
> >  
> > -	if (!dev_for_napi)
> > -		panic("No net_devices were allocated.");
> > +	if (!dev_for_napi) {
> > +		pr_err("No net_devices were allocated.");
> 
> It is good practice to use dev_per(dev, ... You then know which device
> has problem finding its net_devices.

Well, it would then need few more preparation commits to use proper
logging.

> checkpatch is probably warning you about this.
> 
> Once you have a registered netdev, you should then use netdev_err(),
> netdev_dbg() etc.

Problem with this code is that it registers netdevices in for loop,
so the only device available here is parent device to all that
netdevices (which weren't registered).

Perhaps use per netdev probe function first?

> However, cvm_oct_probe() in 6.3-rc6 seems to be FUBAR. As soon as you
> call register_netdev(dev), the kernel can start using it, even before
> that call returns. So the register_netdev(dev) should be the last
> thing _probe does, once everything is set up. You can call
> netdev_err() before it is registered, but the name is less
> informative, something like "(unregistered)".

On the side note, this (panic) cannot happen in current code as
it is using DT as a guidance only, but interfaces are hardcoded.
Later on, when DT is used to provide links, it can fail and then
kernel would panic.

>       Andrew

Thank you,
	ladis
