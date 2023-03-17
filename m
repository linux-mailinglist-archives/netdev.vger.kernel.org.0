Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8B6BDFF1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCQEFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCQEF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09EF6A04C;
        Thu, 16 Mar 2023 21:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27947B823EC;
        Fri, 17 Mar 2023 04:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FDCC433D2;
        Fri, 17 Mar 2023 04:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679025921;
        bh=QmK02HmF9eVP8fqz7Q0ieikfi/zF+fBfL2iut4vh5WA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hRc9hc9/qEsrFyjz3ME5C0pDFudXhDUPNiUToEDts3BXqFf88i7FxWAJAjvCu37M6
         9o78I/Cry/xT40OBEse/NymeimU4WBCgRA4QRc8pRH3SE6Zo+uhW7iPFeDvYro+tKO
         FcNuRk2vbhcORODlw39e6CksP120jHaias3KHi46/72YGwEiqbJ+0eGRZGHhihqdAB
         IiQKMXjwmidQM5ZScgrV0bKk5sHFMWrrqh8koGS11ZOjthA83m9tRCMhup0caIQuAR
         p7ya02MLMvQXN1K1SVQ5GBS5p6YPe6loanfso7tdAzFiky8DmVbqD+KVNuWOzFNu1S
         U79w1CFEXeX0Q==
Date:   Thu, 16 Mar 2023 21:05:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in
 error messages
Message-ID: <20230316210520.5b939600@kernel.org>
In-Reply-To: <20230315130917.3633491-2-a.fatoum@pengutronix.de>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
        <20230315130917.3633491-2-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 14:09:16 +0100 Ahmad Fatoum wrote:
> Some error messages lack a new line, add them.

I thought printk() and friends automatically add a new line these days,
unless continuation is specifically requested. Is that not the case?
Have you seen these prints actually getting mangled?

> Fixes: d40f607c181f ("net: dsa: realtek: rtl8365mb: add RTL8367S support")
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
