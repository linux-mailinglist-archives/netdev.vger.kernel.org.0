Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C174F7121
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbiDGB0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbiDGBZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:25:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A330E55B6;
        Wed,  6 Apr 2022 18:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RepwD/qy2hKVR+6Z6FmCrM7P72REoqeJYemZBaGKcAU=; b=ygoj5sIiv2rObGg5DwqppacJpt
        JhCqgetiwuoVNC9T5cGvhjKoY1OHEwoZXBAXZ5nzOagRuw9+WbbI1riXcVESfGk5pTDkmZgJLy7ar
        QUDP3/tzOFL2oT8vFKvVXk2ahTprlCURPD/q3laLD60mwUi71JZ+YLr+q54Kj06WLzi8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncGpc-00EXpO-Kf; Thu, 07 Apr 2022 03:21:04 +0200
Date:   Thu, 7 Apr 2022 03:21:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Patrick Williams <patrick@stwcx.xyz>
Subject: Re: [PATCH net-next v3 3/3] net: mdio: aspeed: Add c45 support
Message-ID: <Yk48gMGh06NEIJmX@lunn.ch>
References: <20220407011738.7189-1-potin.lai@quantatw.com>
 <20220407011738.7189-4-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407011738.7189-4-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 09:17:38AM +0800, Potin Lai wrote:
> Add Clause 45 support for Aspeed mdio driver.
> 
> Signed-off-by: Potin Lai <potin.lai@quantatw.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
