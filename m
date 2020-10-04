Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410C12827AB
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgJDAf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgJDAf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:35:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3810BC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 17:35:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C04311E3E4CD;
        Sat,  3 Oct 2020 17:19:10 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:35:57 -0700 (PDT)
Message-Id: <20201003.173557.696698765782941018.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Fix full
 duplex in example
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003093051.7242-2-kurt@linutronix.de>
References: <20201003093051.7242-1-kurt@linutronix.de>
        <20201003093051.7242-2-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:19:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Sat,  3 Oct 2020 11:30:51 +0200

> There is no such property as duplex-full. It's called full-duplex. Leading to
> reduced speed when using the example as base for a real device tree.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied.
