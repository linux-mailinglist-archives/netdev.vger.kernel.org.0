Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420E05BD959
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiITB2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiITB2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:28:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288684F67A;
        Mon, 19 Sep 2022 18:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC977B822ED;
        Tue, 20 Sep 2022 01:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA62EC433D7;
        Tue, 20 Sep 2022 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663637314;
        bh=LlrwWSwwrQOfWqYPNpbzQ2CryxaZH3SQQFaCez0aRis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZxYdHRWpGsLmCHTKJt7E7vueXYe4kLYCFoNtNt97TAc0uK4oYLcaOHIzmynn6unWt
         DBH+X/iCSR1UsAfMyC6N7/97BBASa+qV+N0MGXV4R2c+b3T5jSNdyM9idQEPb2c+WM
         vcxOykq2Ao0k2n41jFN16kOL0IZAcDaldqhEh7FrxlS/G2TAaZfw6yDdLtD4ZLYW21
         HqOOhVCzgWgwhos/Gga8ML46gl75tG9NcWH+ZK3ZOo98G6yyeg6ziIL1gHrH8V+H95
         5hE+gnYHqQiiN7urvPRX6Vxuxuzm6iAK5z4HF+Z9UBuQ0OZ1MLnR8fU0OgYYxdqtiO
         9priXpCj3LPBA==
Date:   Mon, 19 Sep 2022 18:28:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mana: Fix return type of mana_start_xmit
Message-ID: <20220919182832.158c0ea2@kernel.org>
In-Reply-To: <20220912214357.928947-1-nhuck@google.com>
References: <20220912214357.928947-1-nhuck@google.com>
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

On Mon, 12 Sep 2022 14:43:53 -0700 Nathan Huckleberry wrote:
> -int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)

This one has a prototype.
