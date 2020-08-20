Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8128924C52A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHTSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgHTSRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:17:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3135C061386;
        Thu, 20 Aug 2020 11:17:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A92C127FCD0A;
        Thu, 20 Aug 2020 11:00:48 -0700 (PDT)
Date:   Thu, 20 Aug 2020 11:17:30 -0700 (PDT)
Message-Id: <20200820.111730.1183424984216190893.davem@davemloft.net>
To:     likaige@loongson.cn
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: Fix a couple of spelling mistakes
 "spcified" -> "specified"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1597906075-12787-1-git-send-email-likaige@loongson.cn>
References: <1597906075-12787-1-git-send-email-likaige@loongson.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 11:00:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>
Date: Thu, 20 Aug 2020 14:47:55 +0800

> There are a couple of spelling mistakes in comment text. Fix these.
> 
> Signed-off-by: Kaige Li <likaige@loongson.cn>

Applied.
