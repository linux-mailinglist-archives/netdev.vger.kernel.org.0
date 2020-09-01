Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD725A194
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIAWkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgIAWkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:40:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A25C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:40:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A508A13659477;
        Tue,  1 Sep 2020 15:23:13 -0700 (PDT)
Date:   Tue, 01 Sep 2020 15:39:59 -0700 (PDT)
Message-Id: <20200901.153959.1284935680059177248.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH 0/2 v2] RTL8366 stabilization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901190854.15528-1-linus.walleij@linaro.org>
References: <20200901190854.15528-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 15:23:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue,  1 Sep 2020 21:08:52 +0200

> This stabilizes the RTL8366 driver by checking validity
> of the passed VLANs and refactoring the member config
> (MC) code so we do not require strict call order and
> de-duplicate some code.
> 
> Changes from v1: incorporate review comments on patch
> 2.

Series applied, thank you.
