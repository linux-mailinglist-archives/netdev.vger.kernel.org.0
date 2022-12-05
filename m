Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D96464292D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiLENUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiLENUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:20:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23F71C110;
        Mon,  5 Dec 2022 05:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XfIznegA6qJZCWzI3fzIHBwouvJOzrpLk24zY96/t7o=; b=nXrRWpsC4aMsPa3N+TohPJGdBL
        k+j78NCONsR32nJVObh2KeI9K31mNIVLs7Hv2mq0242s/PcO951slY2zAE6sk5wxY4WB9WQaOR8EY
        SeYDo/jLMFHZKKGtyBBP6A4m5EF7DtvsgoZRNEcZN8mpbBPWD9Sc+BS02BDuYEc7D+aA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2BNd-004PFp-8B; Mon, 05 Dec 2022 14:19:33 +0100
Date:   Mon, 5 Dec 2022 14:19:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Greg Ungerer <gregungerer@westnet.com.au>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: don't reset irq coalesce settings to defaults
 on "ip link up"
Message-ID: <Y43v5UEAmZYl/T3z@lunn.ch>
References: <c69c1ff1-4da9-89f8-df2e-824cb7183fe9@westnet.com.au>
 <72eb4e63-10a8-702b-1113-7588fcade9fc@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72eb4e63-10a8-702b-1113-7588fcade9fc@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Either way, I don't know if it's too late to apply this fix, or if
> df727d4547 should just be reverted for 6.1 and then redone properly?

Since the fix is simple, do the fix. Even if it misses 6.1.0 it will
be in 6.1.1.

   Andrew
