Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306ED792D7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfG2SJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:09:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfG2SJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:09:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 498C014051852;
        Mon, 29 Jul 2019 11:09:06 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:09:05 -0700 (PDT)
Message-Id: <20190729.110905.966194099406946434.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        stefanc@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] mvpp2: refactor the HW checksum setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190728173549.32034-1-mcroce@redhat.com>
References: <20190728173549.32034-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 11:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Sun, 28 Jul 2019 19:35:49 +0200

> The hardware can only offload checksum calculation on first port due to
> the Tx FIFO size limitation, and has a maximum L3 offset of 128 bytes.
> Document this in a comment and move duplicated code in a function.
> 
> Fixes: 576193f2d579 ("net: mvpp2: jumbo frames support")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied.
