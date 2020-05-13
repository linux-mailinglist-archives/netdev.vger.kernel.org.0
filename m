Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310001D1F79
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390705AbgEMTku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390370AbgEMTkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:40:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67DC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:40:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F294C127ED14A;
        Wed, 13 May 2020 12:40:48 -0700 (PDT)
Date:   Wed, 13 May 2020 12:40:48 -0700 (PDT)
Message-Id: <20200513.124048.709311657364090444.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:40:49 -0700 (PDT)
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

Rob, do you want to take this or should I?
