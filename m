Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FDF513FE8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353626AbiD2BGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244954AbiD2BGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:06:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810B6B9F38;
        Thu, 28 Apr 2022 18:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7Kgksz1U+mpR5yolnT7/amlugtDRmACOMUcwglvKJUc=; b=qKdUTEd5nyy93U0dp1Dz1gWDVZ
        gF+ddv0L6PzIaNwv4iRlOuv9idXs1gNYlZzsEYCl3Azlk9WGiwxoUDeysOdMcKgGw85BfX3YdAYcC
        taV00TYA8wNY0fupmJwcH8YGrUiH1W+Zh6rK0oKVhKo6mpA8ar5Mx8zbPEBOZZ5RUheo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkF1j-000Oz9-FZ; Fri, 29 Apr 2022 03:02:31 +0200
Date:   Fri, 29 Apr 2022 03:02:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>, openbmc@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Wilder <wilder@us.ibm.com>
Subject: Re: [PATCH net] net: ftgmac100: Disable hardware checksum on AST2600
Message-ID: <Yms5JzcVMKDYpR5H@lunn.ch>
References: <20220428082858.545176-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428082858.545176-1-joel@jms.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> Reported-by: David Wilder <wilder@us.ibm.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> Net maintainers, if no one has a counter proposal I would like this
> merged as a fix. Please give Dylan from Aspeed a chance to reply before
> applying the patch.

What has phy-handle got to do with this? You might want to add an
explanation why you picked that as a Fixes: commit, if it is in fact
correct.


     Andrew
