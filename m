Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA3FC43B5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfJAWUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:20:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfJAWUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:20:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AE891411DCB1;
        Tue,  1 Oct 2019 15:20:12 -0700 (PDT)
Date:   Tue, 01 Oct 2019 15:20:11 -0700 (PDT)
Message-Id: <20191001.152011.508051888842248655.davem@davemloft.net>
To:     pedro@pixelbox.red
Cc:     netdev@vger.kernel.org, pfink@christ-es.de, linux@christ-es.de
Subject: Re: [PATCH net-next] net: usb: ax88179_178a: allow optionally
 getting mac address from device tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569845043-27318-2-git-send-email-pedro@pixelbox.red>
References: <1569845043-27318-1-git-send-email-pedro@pixelbox.red>
        <1569845043-27318-2-git-send-email-pedro@pixelbox.red>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 15:20:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Fink <pedro@pixelbox.red>
Date: Mon, 30 Sep 2019 14:04:03 +0200

> From: Peter Fink <pfink@christ-es.de>
> 
> Adopt and integrate the feature to pass the MAC address via device tree
> from asix_device.c (03fc5d4) also to other ax88179 based asix chips.
> E.g. the bootloader fills in local-mac-address and the driver will then
> pick up and use this MAC address.
> 
> Signed-off-by: Peter Fink <pfink@christ-es.de>

Applied.
