Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382B14E26D0
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347533AbiCUMrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiCUMrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:47:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E889972B8;
        Mon, 21 Mar 2022 05:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kom58yxs7t2K4oUdufJDsnhiLyTppH8H97t+BIi+2pk=; b=slgidefFqclK1P2DulHa23qtke
        XdtDCFXKdxr6o3iNY/j5BBLZnNK0Z+vzk8r7RBzyksdnKoCWYMc7c1EE2cmB1NHA791AuDvM89EP9
        7bL01GhWrQtv0Y3iM0BiLxgv1hf23yB+6VEnT9I1Zya4p+15aU9IZ0qYmpwr69JcIKwE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWHPe-00BweU-Bh; Mon, 21 Mar 2022 13:45:30 +0100
Date:   Mon, 21 Mar 2022 13:45:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     robh+dt@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, BMC-SW@aspeedtech.com
Subject: Re: [PATCH v2 0/3]  Add reset deassertion for Aspeed MDIO
Message-ID: <YjhzatUg09SoH9DR@lunn.ch>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 05:56:45PM +0800, Dylan Hung wrote:
> Add missing reset deassertion for Aspeed MDIO. There are 4 MDIOs embedded
> in Aspeed AST2600 and share one reset control bit SCU50[3].

Hi Dylan

Please wait at least 24 hours between posting versions, to give other
people times to comment.

The danger here is that my comments on the previous version are going
to get ignored, and this version merged containing the issues i
pointed out.

	Andrew
