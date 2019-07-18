Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACAEE6D458
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfGRTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:06:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRTGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:06:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F4E21527DCCF;
        Thu, 18 Jul 2019 12:06:01 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:06:00 -0700 (PDT)
Message-Id: <20190718.120600.607199310950720839.davem@davemloft.net>
To:     thesven73@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy
 reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718143428.2392-1-TheSven73@gmail.com>
References: <20190718143428.2392-1-TheSven73@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:06:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>
Date: Thu, 18 Jul 2019 10:34:28 -0400

> Allowing the fec to reset its PHY via the phy-reset-gpios
> devicetree property is deprecated. To improve developer
> awareness, generate a warning whenever the deprecated
> property is used.
> 
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>

The device tree documentation in the kernel tree is where information
like this belongs.  Yelling at the user in the kernel logs is not.
