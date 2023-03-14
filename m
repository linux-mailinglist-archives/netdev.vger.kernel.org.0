Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826726B9F85
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCNTXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNTXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:23:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC5D32F;
        Tue, 14 Mar 2023 12:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8Sk9SDX2v/MrK/qqmdSaRVeujS37NKhzS8B9rC64iro=; b=ewTiSnoazUtv0GwuPPmr4FpUiO
        TFU/f50SQzp/k2cQXcmvkWuyeiK686xzc2NN0afJpo5sJfv5CKA8UsA39dwPfA1v8WITEeSJ8VAFJ
        fuL985WnQj38ialHdksk3SpfA0Gxr4EtC026r0Zf9bB0fgTYmwG9J+wPIDOLmak/NK0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pcAF9-007KBw-Bh; Tue, 14 Mar 2023 20:23:31 +0100
Date:   Tue, 14 Mar 2023 20:23:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Message-ID: <ab930a5c-db25-40c5-83dc-3692d3ccd1f4@lunn.ch>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
 <20230314182659.63686-5-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314182659.63686-5-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 07:26:59PM +0100, Klaus Kudielka wrote:
> To avoid excessive mdio bus transactions during probing, mask all phy
> addresses that do not exist (there is a 1:1 mapping between switch port
> number and phy address).
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
