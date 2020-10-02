Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C726281E28
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJBWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJBWSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:18:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A19BC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:18:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DDCA11E4795D;
        Fri,  2 Oct 2020 15:01:15 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:18:02 -0700 (PDT)
Message-Id: <20201002.151802.964097504724555535.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: b53: Add missing reg
 property to example
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002062051.8551-1-kurt@linutronix.de>
References: <20201002062051.8551-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:01:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Fri,  2 Oct 2020 08:20:51 +0200

> The switch has a certain MDIO address and this needs to be specified using the
> reg property. Add it to the example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied, thank you.
