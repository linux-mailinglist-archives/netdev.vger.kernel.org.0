Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5296C7338
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCWWlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWWlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B082CC5B;
        Thu, 23 Mar 2023 15:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 746A7628DE;
        Thu, 23 Mar 2023 22:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E32C433D2;
        Thu, 23 Mar 2023 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679611262;
        bh=o4CvFWqsStVVAmR4FhbabX1usnJSNbt8yZIqBMPkFcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPJtxx0bSxyRguQCPJCTOMwlgcECHACyesAcP9S5tZGmfB23CbDXHNiXXONAHfr1F
         kiiu5Ra6Uh23o9ANUUsnv+is0BCYtGyTGsdJ9SCvJc5UL45Zc5xhTqwFdOCT0qjm9n
         i1kLWujbIOanuaH40xXSsE701K1xm3ySF58en02St+l8cH/xIlUUF3tjc73WAkmxR9
         G2IjulwgB+RTc6bPyJwS8Z8OOlzc2wju6vB5MPU3E5ApMcidpLm7LUg/cgOhA2L4Vc
         ig3hhdXP7JE624uhLGVTFbq86MAxBisTUtmJPKKJ1/HQgCBpdcHtGniOYWi8T/VF2a
         i3uTTwskPcyKw==
Date:   Thu, 23 Mar 2023 15:41:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix
 ksz8_fdb_dump() to extract all 1024 entries
Message-ID: <20230323154101.1afd0081@kernel.org>
In-Reply-To: <20230322143130.1432106-3-o.rempel@pengutronix.de>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
        <20230322143130.1432106-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 15:31:26 +0100 Oleksij Rempel wrote:
> Fixes: d23a5e18606c ("net: dsa: microchip: move ksz8->masks to ksz_common")

The code move broke it? Looks like it was 5,0 before and 5,0 after 
the change? We need a real tag, pointing to where the code was first
added.

Any reason you didn't CC Arun, just an omission or they're no longer
@microchip?

Arun, would you be able to review this series?
