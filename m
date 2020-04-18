Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B1C1AF5A9
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDRWu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:50:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1DEC061A0C;
        Sat, 18 Apr 2020 15:50:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4283E12783B1C;
        Sat, 18 Apr 2020 15:50:55 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:50:54 -0700 (PDT)
Message-Id: <20200418.155054.1240278818056353950.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: b53: per-port interrupts are
 optional
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417183341.8375-1-f.fainelli@gmail.com>
References: <20200417183341.8375-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:50:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 17 Apr 2020 11:33:41 -0700

> Make use of platform_get_irq_byname_optional() to avoid printing
> messages on the kernel console that interrupts cannot be found.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
