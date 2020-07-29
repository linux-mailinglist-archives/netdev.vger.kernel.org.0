Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EBC2316E7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgG2Aop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgG2Aoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:44:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF257C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:44:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48930128D4974;
        Tue, 28 Jul 2020 17:27:59 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:44:43 -0700 (PDT)
Message-Id: <20200728.174443.2030320484607414020.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH 0/2 v2] RTL8366 VLAN callback fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200726233440.374390-1-linus.walleij@linaro.org>
References: <20200726233440.374390-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:27:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 27 Jul 2020 01:34:38 +0200

> While we are pondering how to make the core set up the VLANs
> the right way, let's merge the uncontroversial fixes.

Series applied, thanks.
