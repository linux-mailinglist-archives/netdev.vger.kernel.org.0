Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5926F55A75D
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiFYFg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiFYFg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124043EE0;
        Fri, 24 Jun 2022 22:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF0860BA2;
        Sat, 25 Jun 2022 05:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C106BC341C0;
        Sat, 25 Jun 2022 05:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135415;
        bh=6EJ0UW88YAfvJ9hKgT4WesCeHp/oC7ubM3mOpIYj6DY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oz2of+fBM+AiYW/WWZOTa40+C8b7WkfLnrtVZzP7kmnuX/m0sutnOqa/aZb/n+BGa
         ySPfA9kjjBelTXjfaP1gUwSv1WhG+4qyDDYut+VwpDKGG9cApuAv6ac2WRV5nmSvq1
         6CVLoX5ulbh3VNnbEJdJMZ7DAdGG7za2UfeOVO5FfrhFe5xbsL8dT21O5JyEnDQ06Q
         pWphVFkO8J1tiCM/xDyRKWDt4HUPZ2aqopwsWhO1YdxaW3BqGnbN6oPb79FMkLtoLy
         wX4ZDdEap3xUT46J2FreUlouiri58x7N5sD97DmTcS8y3i+W7kQutoDCpDQG4Kzm8J
         9qWKkyTNg09xQ==
Date:   Fri, 24 Jun 2022 22:36:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alexandru.tachici@analog.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <devicetree@vger.kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <gerhard@engleder-embedded.com>, <geert+renesas@glider.be>,
        <joel@jms.id.au>, <stefan.wahren@i2se.com>, <wellslutw@gmail.com>,
        <geert@linux-m68k.org>, <robh+dt@kernel.org>,
        <d.michailidis@fungible.com>, <stephen@networkplumber.org>,
        <l.stelmach@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 1/2] net: ethernet: adi: Add ADIN1110 support
Message-ID: <20220624223639.3dba304b@kernel.org>
In-Reply-To: <20220624200628.77047-2-alexandru.tachici@analog.com>
References: <20220624200628.77047-1-alexandru.tachici@analog.com>
        <20220624200628.77047-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 23:06:27 +0300 alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
> designed for industrial Ethernet applications. It integrates
> an Ethernet PHY core with a MAC and all the associated analog
> circuitry, input and output clock buffering.

Please fix the warnings when built with W=1 C=1.
