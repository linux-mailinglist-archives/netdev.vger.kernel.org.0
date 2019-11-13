Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C79FB984
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKMUPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:15:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMUPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:15:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F5EF1203B454;
        Wed, 13 Nov 2019 12:15:15 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:15:14 -0800 (PST)
Message-Id: <20191113.121514.218723445139450529.davem@davemloft.net>
To:     poeschel@lemonage.de
Cc:     gustavo@embeddedor.com, kstewart@linuxfoundation.org,
        opensource@jilayne.com, tglx@linutronix.de, swinslow@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook+coverity-bot@chromium.org
Subject: Re: [PATCH net-next] nfc: pn533: pn533_phy_ops dev_[up,down]
 return int
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113135039.32086-1-poeschel@lemonage.de>
References: <20191113135039.32086-1-poeschel@lemonage.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 12:15:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>
Date: Wed, 13 Nov 2019 14:50:22 +0100

> Change dev_up and dev_down functions of struct pn533_phy_ops to return
> int. This way the pn533 core can report errors in the phy layer to upper
> layers.
> The only user of this is currently uart.c and it is changed to report
> the error of a possibly failing call to serdev_device_open.
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1487395 ("Error handling issues")
> Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Applied, thanks Lars.
