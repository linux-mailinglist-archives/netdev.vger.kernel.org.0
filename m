Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF9427B7B3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgI1XOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD8C05BD40;
        Mon, 28 Sep 2020 16:04:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01CC01274F435;
        Mon, 28 Sep 2020 15:47:14 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:04:01 -0700 (PDT)
Message-Id: <20200928.160401.1369207116627698132.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: atmtcp: Constify atmtcp_v_dev_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927211042.41875-1-rikard.falkeborn@gmail.com>
References: <20200927211042.41875-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:47:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Sun, 27 Sep 2020 23:10:42 +0200

> The only usage of atmtcp_v_dev_ops is to pass its address to
> atm_dev_register() which takes a pointer to const, and comparing its
> address to another address, which does not modify it. Make it const to
> allow the compiler to put it in read-only memory.
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Applied to net-next
