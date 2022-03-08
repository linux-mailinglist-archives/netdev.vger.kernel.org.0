Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5921E4D18E6
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbiCHNQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiCHNQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:16:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE5B28E20;
        Tue,  8 Mar 2022 05:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4AMo7a+1jYhUbTd5eXCuX2jQ4/Cx5HSKuDlGnN/Zuvc=; b=j8zjA6LQrLmR/0SSpgvvXDpFpZ
        XXUplKADfDcwPXoPqfWxYyyKVNd81HyV5gPQG6Grb9n91cu4j3mq1cu1y2s+MOXlaKAnPch9ITD1I
        ur3+4UYRTIJHEVhGCgRPvxdyi466bFAMkiTcxbPoc40FsG7IXTuAqFsZUlt5vRwx1T54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRZgI-009naD-7D; Tue, 08 Mar 2022 14:15:14 +0100
Date:   Tue, 8 Mar 2022 14:15:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        YueHaibing <yuehaibing@huawei.com>,
        John Linn <john.linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sadanand Mutyala <Sadanand.Mutyala@xilinx.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: Fix error handling in xemaclite_of_probe
Message-ID: <YidW4rzNQ3ckkO1Y@lunn.ch>
References: <20220308024751.2320-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308024751.2320-1-linmq006@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 02:47:49AM +0000, Miaoqian Lin wrote:
> This node pointer is returned by of_parse_phandle() with refcount
> incremented in this function. Calling of_node_put() to avoid the
> refcount leak. As the remove function do.
> 
> Fixes: 5cdaaa12866e ("net: emaclite: adding MDIO and phy lib support")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
