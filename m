Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C027877C0C
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfG0V1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:27:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0V1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:27:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D57C1534FD20;
        Sat, 27 Jul 2019 14:27:10 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:27:09 -0700 (PDT)
Message-Id: <20190727.142709.1469820728325208550.davem@davemloft.net>
To:     pebolle@tiscali.nl
Cc:     tilman@imap.cc, hjlipp@web.de, arnd@arndb.de, kkeil@linux-pingi.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gigaset: stop maintaining seperately
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726220541.28783-1-pebolle@tiscali.nl>
References: <20190726220541.28783-1-pebolle@tiscali.nl>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:27:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sat, 27 Jul 2019 00:05:41 +0200

> The Dutch consumer grade ISDN network will be shut down on September 1,
> 2019. This means I'll be converted to some sort of VOIP shortly. At that
> point it would be unwise to try to maintain the gigaset driver, even for
> odd fixes as I do. So I'll stop maintaining it as a seperate driver and
> bump support to CAPI in staging. De facto this means the driver will be
> unmaintained, since no-one seems to be working on CAPI.
> 
> I've lighty tested the hardware specific modules of this driver (bas-gigaset,
> ser-gigaset, and usb-gigaset) for v5.3-rc1. The basic functionality appears to
> be working. It's unclear whether anyone still cares. I'm aware of only one
> person sort of using the driver a few years ago.
> 
> Thanks to Karsten Keil for the ISDN subsystems gigaset was using (I4L and
> CAPI). And many thanks to Hansjoerg Lipp and Tilman Schmidt for writing and
> upstreaming this driver.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
