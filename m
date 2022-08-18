Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3FA598A32
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344929AbiHRRSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345037AbiHRRR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30BD5D0E3;
        Thu, 18 Aug 2022 10:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F38DB8221B;
        Thu, 18 Aug 2022 17:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E6EC433C1;
        Thu, 18 Aug 2022 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660842873;
        bh=SO6S+nYVGgIECexcS5Q0qSJRVc5nI71LwbXLEsu+7V4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kDX/pQxIhVoeupfJNlrmSxOxh2omYdXMJCOjPQlCmtKBwF+Nf+nbtsv+j9NUUw9s9
         wGLQVYzPe1o9mrQnI+w8yL63os7AMkqPclTqjNJ+ClHkdaWOpKFU7SJad2FW9QSEOh
         x0aNo5pMxvvyfaNorfwG05lB/d+9iDlPXvI++Qk06Nf0+nkPDZsR956Imro9sqjFnw
         fUQetrTureDsy1/jfjbHtMp5odR2GKvKKebrRod1d0z3rzqf7LG7VNAkysZJa1jvZG
         8vvjYDBX04/4we97CaD5HBqkt+WxMUMs4E/obAzp8lj4Qggiuk7ZV5OwcLBeIECAIm
         20gFi1eQp0HKA==
Date:   Thu, 18 Aug 2022 10:14:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Beniamin Sandu <beniaminsandu@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <20220818101432.3b14db4b@kernel.org>
In-Reply-To: <20220818165856.GC923105@roeck-us.net>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
        <20220817085429.4f7e4aac@kernel.org>
        <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
        <20220817101916.10dec387@kernel.org>
        <Yv2UMcVUSwiaFyH6@lunn.ch>
        <20220817191916.6043f04d@kernel.org>
        <20220818165856.GC923105@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 09:58:56 -0700 Guenter Roeck wrote:
> And you expect me to dig up the actual patch ?

Sorry, I assumed we all have some form of fast lore access built 
into our email setups. Here's the link to your reply and therefore 
the thread:

https://lore.kernel.org/all/20220818165856.GC923105@roeck-us.net/

Speaking of expectations tho, I would expect you to not ask me
rhetorical passive aggressive questions.
