Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836041D6C57
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgEQTcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:32:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FE8C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:32:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF78D128A0779;
        Sun, 17 May 2020 12:32:08 -0700 (PDT)
Date:   Sun, 17 May 2020 12:32:08 -0700 (PDT)
Message-Id: <20200517.123208.1215463595300778544.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        robh+dt@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: b53: Add missing size and
 address cells to example
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513140249.24900-1-kurt@linutronix.de>
References: <20200513140249.24900-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:32:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Wed, 13 May 2020 16:02:49 +0200

> Add the missing size and address cells to the b53 example. Otherwise, it may not
> compile or issue warnings if directly copied into a device tree.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied.
