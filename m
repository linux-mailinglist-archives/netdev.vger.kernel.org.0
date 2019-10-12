Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D11D4C8C
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 05:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfJLDvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 23:51:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJLDvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 23:51:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9812D15003967;
        Fri, 11 Oct 2019 20:51:06 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:51:06 -0700 (PDT)
Message-Id: <20191011.205106.154866536890874642.davem@davemloft.net>
To:     pedro@pixelbox.red
Cc:     netdev@vger.kernel.org, pfink@christ-es.de
Subject: Re: [PATCH net-next v2] net: usb: ax88179_178a: write mac to
 hardware in get_mac_addr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570712422-32397-1-git-send-email-pedro@pixelbox.red>
References: <1570712422-32397-1-git-send-email-pedro@pixelbox.red>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 20:51:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Fink <pedro@pixelbox.red>
Date: Thu, 10 Oct 2019 15:00:22 +0200

> From: Peter Fink <pfink@christ-es.de>
> 
> When the MAC address is supplied via device tree or a random
> MAC is generated it has to be written to the asix chip in
> order to receive any data.
> 
> Previously in 9fb137aef34e ("net: usb: ax88179_178a: allow
> optionally getting mac address from device tree") this line was
> omitted because it seemed to work perfectly fine without it.
> 
> But it was simply not detected because the chip keeps the mac
> stored even beyond a reset and it was tested on a hardware
> with an integrated UPS where the asix chip was permanently
> powered on even throughout power cycles.
> 
> Fixes: 9fb137aef34e ("net: usb: ax88179_178a: allow optionally getting mac address from device tree")
> Signed-off-by: Peter Fink <pfink@christ-es.de>

Applied, thank you.
