Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567B44EE1A0
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiCaT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 15:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiCaT2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 15:28:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BF41DFDDD;
        Thu, 31 Mar 2022 12:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=c8FmVBdt6Jnzl7SDITKyEi60UppjZVvKYYqaw2AjDWA=; b=19GQ3hzcfr4rfFv6SVV1xR5zXI
        ij9AVR4IO8Nn99RkocDZlH52AC0aJRzZrhcBKdpm1wgi9fH9N8qkn/t9npXNa2GddA4yu3QSi9IHh
        sj6M7keW5z7QzGdK92cy1dy99MZFjpZrw7ZmdWItQQATkDda3SNflkAT/Zspi9YcRjJ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1na0QW-00DWSn-AE; Thu, 31 Mar 2022 21:25:48 +0200
Date:   Thu, 31 Mar 2022 21:25:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH RESEND2] net: stmmac: Fix unset max_speed difference
 between DT and non-DT platforms
Message-ID: <YkYAPBA7j1XiohFn@lunn.ch>
References: <20220331184832.16316-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331184832.16316-1-wens@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Resend2: CC Srinivas at Linaro instead of ST. Collected Russell's ack.
> Resend: added Srinivas (author of first fixed commit) to CC list.

Please don't resend very quickly in general, and specifically not to
just add a reviewed-by. Patchwork will keep track for reviewed-by:s so
if this patch was to be picked up, they would be automatically
added. You only need to add them if you need to resend for another
reason.

In general, wait for at least 24 hours before doing a resend, so
others who are interested can review the patch and comment.

       Andrew
