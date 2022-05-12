Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE7524C81
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353587AbiELMRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352872AbiELMRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:17:19 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A1F51318
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:17:18 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 5911210045BFD;
        Thu, 12 May 2022 14:17:17 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3FC192E4EB2; Thu, 12 May 2022 14:17:17 +0200 (CEST)
Date:   Thu, 12 May 2022 14:17:17 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/7] net: phy: smsc: Cache interrupt mask
Message-ID: <20220512121717.GD4703@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <cf9f1b5d1b07e0fa5f78bc8557216ef04f401af5.1652343655.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf9f1b5d1b07e0fa5f78bc8557216ef04f401af5.1652343655.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:42:06AM +0200, Lukas Wunner wrote:
> Cache the interrupt mask to avoid re-reading it from the PHY upon every
> interrupt.
> 
> This will simplify a subsequent commit which detects hot-removal in the
> interrupt handler and bails out.
> 
> Analyzing and debugging PHY transactions also becomes simpler if such
> redundant reads are avoided.
> 
> Last not least, interrupt overhead and latency is slightly improved.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Andrew kindly provided this tag here:
https://lore.kernel.org/netdev/YnGsDtscYkh28PFm@lunn.ch/

Forgot to add it to the commit.
Sending it in separately so patchwork picks it up.
My apologies for the inconvenience.
