Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6541B11A056
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfLKBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:06:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfLKBGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:06:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC7861502742B;
        Tue, 10 Dec 2019 17:06:43 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:06:41 -0800 (PST)
Message-Id: <20191210.170641.436017083129647530.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     gregkh@linuxfoundation.org, acj@cisco.com, peppe.cavallaro@st.com,
        netdev@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX
 descriptor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210214014.GV20426@zorba>
References: <20191210170659.61829-1-acj@cisco.com>
        <20191210205542.GB4080658@kroah.com>
        <20191210214014.GV20426@zorba>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:06:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
Date: Tue, 10 Dec 2019 21:40:17 +0000

> On Tue, Dec 10, 2019 at 09:55:42PM +0100, Greg KH wrote:
>> On Tue, Dec 10, 2019 at 09:06:58AM -0800, Aviraj CJ wrote:
>> > We always program the maximum DMA buffer size into the receive descriptor,
>> > although the allocated size may be less. E.g. with the default MTU size
>> > we allocate only 1536 bytes. If somebody sends us a bigger frame, then
>> > memory may get corrupted.
>> > 
>> > Program DMA using exact buffer sizes.
>> > 
>> > [Adopted based on upstream commit c13a936f46e3321ad2426443296571fab2feda44
>> > ("net: stmmac: use correct DMA buffer size in the RX descriptor")
>> > by Aaro Koskinen <aaro.koskinen@nokia.com> ]
>> 
>> Adopted to what?
>> 
>> What is this patch for, it looks just like the commit you reference
>> here.
>> 
>> totally confused,
> 
> 
> We're using the patches on the v4.4 -stable branch. It doesn't have these patches and
> the backport had rejects.

As submitted the patch looks like something destined for mainline.

Not specifying the context into which the change is meant to be placed
wastes a lot of precious developer time.
