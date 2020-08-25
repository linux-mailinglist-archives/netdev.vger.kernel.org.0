Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFAF250E08
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHYBDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgHYBDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:03:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAEDC061796;
        Mon, 24 Aug 2020 18:03:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D62A112952B9B;
        Mon, 24 Aug 2020 17:46:57 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:03:43 -0700 (PDT)
Message-Id: <20200824.180343.1608676074239709421.davem@davemloft.net>
To:     kurt@kmk-computers.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, kurt@linutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix typo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823121836.16441-1-kurt@kmk-computers.de>
References: <20200823121836.16441-1-kurt@kmk-computers.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:46:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@kmk-computers.de>
Date: Sun, 23 Aug 2020 14:18:36 +0200

> Fix spelling mistake documenation -> documentation.
> 
> Fixes: 5a18bb14c0f7 ("dt-bindings: net: dsa: Let dsa.txt refer to dsa.yaml")
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Applied, thanks.
