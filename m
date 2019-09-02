Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8709EA5C66
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfIBSr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:47:27 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46253 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbfIBSr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:47:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 061EF603;
        Mon,  2 Sep 2019 14:47:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 14:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=jvdK4Jen2RCEgg6SQll6JQs4XBc
        0TdXI2+8sajCKgts=; b=HisKgtPmjyc50Q51dI6x7O1Av5K1DiCIy1weJNbAQyw
        NfaB/lELa/xXGitPGzwxdP4YKIE5eQuWRkY8OjLThDrlGjy4wIRPCCCM0F8J5yPs
        qnP44YP0hxLE5FZeJUtyhvgNsI36Mqeol2P+TGQHDyxUlnlN4j18++cV/3tV+IE4
        sAx5isdqwoWqGWF3ztVVWl96xGEWu4nsEKeqldn2PPpiiLFAevmLCqR9yIdMbVmX
        7VabDz+NgxGWM6wbJXuNX/lmuqFw8setF43TKQVJmr81WNCjoYdQrIIVI4293eSI
        SD26MTg73bvsdM4RUMeiIIQI+q+6M7LCyMLotBZpeuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jvdK4J
        en2RCEgg6SQll6JQs4XBc0TdXI2+8sajCKgts=; b=QabHFEFQWkHTq5vl5QGksW
        rlyGRzCUhfuiZzb5RYyNPXDoPeynBP7U1fZBhwrCOiEiK9+QQuHrDu4ELhGYuMvr
        5jpPp3vdaENeP2I8C3f3+aMAaypPBSHRNU5n7/hgekMNR0Ju+G8mTyUDgV6DRznD
        c9o17kbAdA/rsu6g9nVWcUuZp7npeavjk5SgP//4v1++65Fdd6tTilrE9/Jh63vs
        YHrXAubgBr5lqclByIZogtLha5AikIG2OogvGmkCz4URX5EBABHpcHUiHhN2ddjf
        aBuGRkOyA0Md9CKU8Zqlzooni5O2EyQ39ojLYSrIO5crmHIUVbJjLVUO8DZDquPQ
        ==
X-ME-Sender: <xms:vGNtXbYhVGvIlWBwCFVBis5BFP2Resu-kSZ4wIOMT3prTAHAYErA8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vGNtXWQeoXkHmPTKTGMktd-Y0DdjZ_LkDh3cTGsR9MQgZ8NtvUJqew>
    <xmx:vGNtXWzZ87g03H-RuVlzafF7d98RTNAQ3LsZpMP0IowkOHYiAbXBdQ>
    <xmx:vGNtXaftgrtj1O4hdO2WxJX5rPxi8LAUiQvuOmN1pmZMxGdmO-BwiQ>
    <xmx:vWNtXXE9soBGrsTKaiNyfLXGB8tdSUbTNs1CLLuy4Pndc4z0fis56A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46D188005B;
        Mon,  2 Sep 2019 14:47:24 -0400 (EDT)
Date:   Mon, 2 Sep 2019 20:47:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Hui Peng <benquike@gmail.com>,
        security@kernel.org, Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
Message-ID: <20190902184722.GC5697@kroah.com>
References: <20190819220230.10597-1-benquike@gmail.com>
 <20190831181852.GA22160@roeck-us.net>
 <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
 <385361d3-048e-9b3f-c749-aa5861e397e7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <385361d3-048e-9b3f-c749-aa5861e397e7@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 01, 2019 at 07:08:29AM -0700, Guenter Roeck wrote:
> On 9/1/19 1:03 AM, Kalle Valo wrote:
> > Guenter Roeck <linux@roeck-us.net> writes:
> > 
> > > On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
> > > > `dev` (struct rsi_91x_usbdev *) field of adapter
> > > > (struct rsi_91x_usbdev *) is allocated  and initialized in
> > > > `rsi_init_usb_interface`. If any error is detected in information
> > > > read from the device side,  `rsi_init_usb_interface` will be
> > > > freed. However, in the higher level error handling code in
> > > > `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
> > > > again, in which `dev` will be freed again, resulting double free.
> > > > 
> > > > This patch fixes the double free by removing the free operation on
> > > > `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
> > > > used in `rsi_disconnect`, in that code path, the `dev` field is not
> > > >   (and thus needs to be) freed.
> > > > 
> > > > This bug was found in v4.19, but is also present in the latest version
> > > > of kernel.
> > > > 
> > > > Reported-by: Hui Peng <benquike@gmail.com>
> > > > Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> > > > Signed-off-by: Hui Peng <benquike@gmail.com>
> > > 
> > > FWIW:
> > > 
> > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
> > > of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
> > 
> > A double free in error path is considered as a critical CVE issue? I'm
> > very curious, why is that?
> > 
> 
> You'd have to ask the people assigning CVSS scores. However, if the memory
> was reallocated, that reallocated memory (which is still in use) is freed.
> Then all kinds of bad things can happen.

Yes, but moving from "bad things _can_ happen" to "bad things happen" in
an instance like this will be a tough task.  It also requires physical
access to the machine.

Anyway, that doesn't mean we shouldn't fix it, it's just that CVSS can
be crazy when it comes to kernel patches (i.e. almost all fixes should
be "critical"...)

thanks,

greg k-h
