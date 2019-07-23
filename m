Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AACF70E98
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfGWBWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:22:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfGWBWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:22:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 473B015305A1D;
        Mon, 22 Jul 2019 18:22:36 -0700 (PDT)
Date:   Mon, 22 Jul 2019 18:22:35 -0700 (PDT)
Message-Id: <20190722.182235.195933962601112626.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: Merge cpu_to_le32s + memcpy to
 put_unaligned_le32
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722074133.17777-1-hslester96@gmail.com>
References: <20190722074133.17777-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 18:22:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Mon, 22 Jul 2019 15:41:34 +0800

> Merge the combo uses of cpu_to_le32s and memcpy.
> Use put_unaligned_le32 instead.
> This simplifies the code.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Isn't the skb->data aligned to 4 bytes in these situations?

If so, we should use the aligned variants.

Thank you.
