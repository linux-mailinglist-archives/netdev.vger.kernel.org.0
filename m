Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E7563A23B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiK1HmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiK1Hlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:41:39 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2516598
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 23:41:19 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4B9DBB8B;
        Mon, 28 Nov 2022 08:41:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669621277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWrazpDGsK4zHJAHcBdw2z9TUHQ1uhxMtTIWvvDFCU0=;
        b=H6a2JWjqu43N0pv+4DM+HhkfBCbB+GHmC4wTMBF3kqmO+hvJ9siWVAdkxuXs13NVmDjFC7
        T0V+sAuG7iIy7zwMYVb227piRBIbfj2DZ9rrgYIU+6n9NF2yYjXGUx1FZF4/EuosVkfbbA
        Z+CqQaDr+orFTLsxPKtvJMXd9mRkD01zyhn/htPGE94Ksf5eKv5zg4AUA2ERm1pJUpP2S+
        l5DyOg9VsO7h4z1aFxQE8MzM+yZ6GzZATlxZ59xZDdrfXPdCWabIPX48CJ9vQpy3f2tT4S
        RfLV3vhkVWl1A6vEZayqsKgEGoJOfbGCJeZ4hViM9KEgPGXvVTBMf63bjqyj3Q==
MIME-Version: 1.0
Date:   Mon, 28 Nov 2022 08:41:17 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
In-Reply-To: <Y4DcoTmU3nWqMHIp@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <baa468f15c6e00c0f29a31253c54383c@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-11-25 16:17, schrieb Andrew Lunn:
> Or even turn it into an input and see if you can read its
> state and poll it until it clears?

Btw, I don't think that's possible for shared interrupts. In
the worst case you'd poll while another device is asserting the
interrupt line.

-michael
