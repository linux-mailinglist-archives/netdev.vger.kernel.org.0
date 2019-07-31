Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A334E7C7A9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfGaPy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:54:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGaPy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:54:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2293133F18DD;
        Wed, 31 Jul 2019 08:54:25 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:54:25 -0700 (PDT)
Message-Id: <20190731.085425.835225391467422617.davem@davemloft.net>
To:     juliana.rodrigueiro@intra2net.com
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        thomas.jarosch@intra2net.com
Subject: Re: [PATCH v2] isdn: hfcsusb: Fix mISDN driver crash caused by
 transfer buffer on the stack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2432092.e6oL0QVcq9@rocinante.m.i2n>
References: <2432092.e6oL0QVcq9@rocinante.m.i2n>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:54:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Date: Wed, 31 Jul 2019 15:17:23 +0200

> Since linux 4.9 it is not possible to use buffers on the stack for DMA transfers.
> 
> During usb probe the driver crashes with "transfer buffer is on stack" message.
> 
> This fix k-allocates a buffer to be used on "read_reg_atomic", which is a macro
> that calls "usb_control_msg" under the hood.
> 
> Kernel 4.19 backtrace:
 ...
> Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>

Applied.
