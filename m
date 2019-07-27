Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7358C77BC9
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbfG0UYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:24:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0UYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:24:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A30C1533FE7C;
        Sat, 27 Jul 2019 13:24:14 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:24:14 -0700 (PDT)
Message-Id: <20190727.132414.1618042108645535246.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        stefanc@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mvpp2: refactor MTU change code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725231931.24073-1-mcroce@redhat.com>
References: <20190725231931.24073-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:24:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Fri, 26 Jul 2019 01:19:31 +0200

> The MTU change code can call napi_disable() with the device already down,
> leading to a deadlock. Also, lot of code is duplicated unnecessarily.
> 
> Rework mvpp2_change_mtu() to avoid the deadlock and remove duplicated code.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Please resubmit with the Fixes: tag.

Please do not line break the Fixes: tag no matter how many characters
it ends up being in total.

Thanks.
