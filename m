Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F397313BB2
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhBHRzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233914AbhBHRxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:53:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A278764E28;
        Mon,  8 Feb 2021 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612806773;
        bh=nzY8lVhO7mU4bKq3ecM4t/jmDUrV5N1r0oZ3vfvzuYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V+e71ec/P8FoXECn2W17Thfk0Oiri+rrpm2djKqlPG1z5bM0J9/cIs9GLzlABQnek
         Iocsk7QMbkeqUVuVg0LCkpLht5udcibOnAhpcc6+ohY3SxOHCbbSLWTXTnJ0kTeuBC
         DvAJkUP+80JlfF5vyW315xRnDXSWjkjz0SYP1Y3Mbz/sh2qerhnzovxEENndfafdnX
         0efz0Go6OdV2itF8e+O3QnHBl7YzRBtyavsprZSDoSe+CxiKOwW+bTtckSm24ru9xD
         nuWZyQTdg5g3AsfHfj3JikHdZUy9ld+dfDYccdfT3voG5brU756loDZ242Xb7OfJol
         xblZ/Gq+9CQ4w==
Date:   Mon, 8 Feb 2021 09:52:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Message-ID: <20210208095252.51c0a738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YCEF3MY5Mau9TPvK@hovoldconsulting.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
        <20210205173904.13916-2-lech.perczak@gmail.com>
        <87r1lt1do6.fsf@miraculix.mork.no>
        <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
        <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YCEF3MY5Mau9TPvK@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 10:35:24 +0100 Johan Hovold wrote:
> > Send patch 2, wait for it to hit net, send 1 seems like the safest
> > option. If we're lucky Johan can still send patch 2 for 5.11, otherwise
> > we'll wait until the merge window - we're at rc7 already, it won't take
> > too long.  
> 
> I usually don't send on new device-ids this late in the release cycle,
> so I'll queue the USB-serial one up for 5.12-rc1 and you can take this
> one through net-next.

s/net-next/net/  Sound like a plan, thanks!
