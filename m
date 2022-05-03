Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFCF519142
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiECWWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243568AbiECWWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:22:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4E33ED27;
        Tue,  3 May 2022 15:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5nRXX6634CQNLfZ6ipk0BQhlHcwJJYgAi8oMmRtAiuU=; b=CTRSbushjLoNRV4SKIDr693kYb
        zHLnUihRmklsiEH8B82ZMzVhj0/P+4RdrYcCYHn3kx32ctc3EbUQAwT7VGk71WOLRjhZZtFntsmfK
        81GeRGBWO9ESaFiQX39VzUDSTG2EHPythdbDVdKWYGP1UmHx5USfIU/HgK5Lc4EzsBeA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0r1-0016xO-It; Wed, 04 May 2022 00:18:47 +0200
Date:   Wed, 4 May 2022 00:18:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sfp: Add tx-fault workaround for Huawei MA5671A
 SFP ONT
Message-ID: <YnGqR2fMdk/dglm7@lunn.ch>
References: <20220502223315.1973376-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502223315.1973376-1-mnhagan88@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 11:33:15PM +0100, Matthew Hagan wrote:
> As noted elsewhere, various GPON SFP modules exhibit non-standard
> TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
> in combination with a Marvell mv88e6085 switch, was found to
> persistently assert TX-fault, resulting in the module being disabled.
> 
> This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
> module to function.
> 
> Change from v1: removal of erroneous return statment (Andrew Lunn)
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
