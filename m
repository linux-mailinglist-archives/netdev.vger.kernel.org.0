Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585DFE9594
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfJ3EMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:12:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfJ3EMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:12:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1544B14B7B60B;
        Tue, 29 Oct 2019 21:11:59 -0700 (PDT)
Date:   Tue, 29 Oct 2019 21:11:58 -0700 (PDT)
Message-Id: <20191029.211158.1584843573342050158.davem@davemloft.net>
To:     poeschel@lemonage.de
Cc:     kstewart@linuxfoundation.org, tglx@linutronix.de,
        opensource@jilayne.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, swinslow@gmail.com,
        gustavo@embeddedor.com, keescook@chromium.org, allison@lohutok.net,
        johan@kernel.org, horms@verge.net.au
Subject: Re: [PATCH v11 0/7] nfc: pn533: add uart phy driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029144320.17718-1-poeschel@lemonage.de>
References: <20191029144320.17718-1-poeschel@lemonage.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 21:11:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>
Date: Tue, 29 Oct 2019 15:43:13 +0100

> The purpose of this patch series is to add a uart phy driver to the
> pn533 nfc driver.
> It first changes the dt strings and docs. The dt compatible strings
> need to change, because I would add "pn532-uart" to the already
> existing "pn533-i2c" one. These two are now unified into just
> "pn532". Then the neccessary changes to the pn533 core driver are
> made. Then the uart phy is added.
> As the pn532 chip supports a autopoll, I wanted to use this instead
> of the software poll loop in the pn533 core driver. It is added and
> activated by the last to patches.
> The way to add the autopoll later in seperate patches is chosen, to
> show, that the uart phy driver can also work with the software poll
> loop, if someone needs that for some reason.
> In v11 of this patchseries I address a byte ordering issue reported
> by kbuild test robot in patch 5/7.

Series applied to net-next.
