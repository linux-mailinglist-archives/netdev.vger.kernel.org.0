Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D918A1093AD
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKYSo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:44:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfKYSo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:44:57 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2684415008C69;
        Mon, 25 Nov 2019 10:44:56 -0800 (PST)
Date:   Mon, 25 Nov 2019 10:44:40 -0800 (PST)
Message-Id: <20191125.104440.2001478537682368867.davem@davemloft.net>
To:     mail@david-bauer.net
Cc:     netdev@vger.kernel.org, geert@linux-m68k.org, andrew@lunn.ch
Subject: Re: [PATCH] mdio_bus: don't use managed reset-controller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122214451.240431-1-mail@david-bauer.net>
References: <20191122214451.240431-1-mail@david-bauer.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 10:44:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Bauer <mail@david-bauer.net>
Date: Fri, 22 Nov 2019 22:44:51 +0100

> Geert Uytterhoeven reported that using devm_reset_controller_get leads
> to a WARNING when probing a reset-controlled PHY. This is because the
> device devm_reset_controller_get gets supplied is not actually the
> one being probed.
> 
> Acquire an unmanaged reset-control as well as free the reset_control on
> unregister to fix this.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David Bauer <mail@david-bauer.net>

Applied and queued up for -stable, thanks.
