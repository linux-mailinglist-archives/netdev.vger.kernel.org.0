Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1D5A652
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF1VdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:33:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1VdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:33:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B2A413AECA12;
        Fri, 28 Jun 2019 14:33:07 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:33:04 -0700 (PDT)
Message-Id: <20190628.143304.1948683616085766786.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, ivan.khoronzhuk@linaro.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw: Assign OF node to slave
 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623121143.3492-1-marex@denx.de>
References: <20190623121143.3492-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:33:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 23 Jun 2019 14:11:43 +0200

> Assign OF node to CPSW slave devices, otherwise it is not possible to
> bind e.g. DSA switch to them. Without this patch, the DSA code tries
> to find the ethernet device by OF match, but fails to do so because
> the slave device has NULL OF node.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
