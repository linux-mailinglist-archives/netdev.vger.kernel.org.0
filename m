Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F249C4BECCE
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiBUVxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:53:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBUVxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:53:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BA222BD3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U7eDbfKxdYXSMbjlowmT6wf/vufPwUwivXp4QZpmVz4=; b=stt0faZjRDiXqygyBxqExddu9l
        Ni+hMqIy0TlO9GRQM1Q5ty80LJ26OzyaMszV8VdzHJGI4NwfPML955PG0uW00yd1EbE1ttrxz/y2R
        afOz7TagyDlWyxy36f2u8MDPQuyQ9H2mWeQLZZLZxZHv4DR6765CCEL3rEK2I6+NX71Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMGbm-007R6v-UB; Mon, 21 Feb 2022 22:52:38 +0100
Date:   Mon, 21 Feb 2022 22:52:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net-next v3 2/2] net: dsa: OF-ware slave_mii_bus
Message-ID: <YhQJpkb/tPsvSS6h@lunn.ch>
References: <20220221200407.6378-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221200407.6378-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:04:07PM -0300, Luiz Angelo Daros de Luca wrote:
> If found, register the DSA internally allocated slave_mii_bus with an OF
> "mdio" child object. It can save some drivers from creating their
> custom internal MDIO bus.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
