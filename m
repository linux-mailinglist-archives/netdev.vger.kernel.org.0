Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E18FE9449
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfJ3A52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:57:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfJ3A51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:57:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BFC2140F6FBE;
        Tue, 29 Oct 2019 17:57:27 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:57:26 -0700 (PDT)
Message-Id: <20191029.175726.406152531378673130.davem@davemloft.net>
To:     Anson.Huang@nxp.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-imx@nxp.com
Subject: Re: [PATCH RESEND 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572313999-23317-1-git-send-email-Anson.Huang@nxp.com>
References: <1572313999-23317-1-git-send-email-Anson.Huang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:57:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>
Date: Tue, 29 Oct 2019 09:53:18 +0800

> Failed to get irq using name is NOT fatal as driver will use index
> to get irq instead, use platform_get_irq_byname_optional() instead
> of platform_get_irq_byname() to avoid below error message during
> probe:
> 
> [    0.819312] fec 30be0000.ethernet: IRQ int0 not found
> [    0.824433] fec 30be0000.ethernet: IRQ int1 not found
> [    0.829539] fec 30be0000.ethernet: IRQ int2 not found
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> Acked-by: Fugang Duan <fugang.duan@nxp.com>
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>

Applied.
