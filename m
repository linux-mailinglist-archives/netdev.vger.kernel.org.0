Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD25AD0E
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfF2T37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:29:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfF2T36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:29:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5986214C7E037;
        Sat, 29 Jun 2019 12:29:57 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:29:56 -0700 (PDT)
Message-Id: <20190629.122956.513705375173164712.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve handling VLAN tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <29fd564b-3279-a36d-a082-1c650168567e@gmail.com>
References: <29fd564b-3279-a36d-a082-1c650168567e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:29:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 27 Jun 2019 23:06:33 +0200

> The VLAN tag is stored in the descriptor in network byte order.
> Using swab16 works on little endian host systems only. Better play safe
> and use ntohs or htons respectively.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
