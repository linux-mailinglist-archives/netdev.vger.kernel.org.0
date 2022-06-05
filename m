Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11DF53DD73
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 19:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346653AbiFERx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiFERx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 13:53:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB01F40A35;
        Sun,  5 Jun 2022 10:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eXNU6b6SywjnS70XKysBsjZn8R5pjBPGBIyQlaViQYU=; b=PIBXGS3Cpeww7RqmPi6gB85jyv
        bDwmM5Y6/HXpinAT9pqz/xuBVyLPXSsZORCvZiQOm7QZYzGNeRH+vYfgbjTrnxvG4TKYOqOfm5Fee
        yjO9XxKWrVw2KxsuoRlxPXGY8rMinmS6j8M9EgstQZyRPKisg9Qlv0eqGHpidzOyAZwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxuRU-005fKJ-Rg; Sun, 05 Jun 2022 19:53:36 +0200
Date:   Sun, 5 Jun 2022 19:53:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: bgmac: Fix refcount leak in
 bcma_mdio_mii_register
Message-ID: <YpztoGkCxT4KhXL5@lunn.ch>
References: <20220603133238.44114-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603133238.44114-1-linmq006@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 05:32:38PM +0400, Miaoqian Lin wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when not need anymore.
> Add missing of_node_put() to avoid refcount leak.
> 
> Fixes: 55954f3bfdac ("net: ethernet: bgmac: move BCMA MDIO Phy code into a separate file")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
