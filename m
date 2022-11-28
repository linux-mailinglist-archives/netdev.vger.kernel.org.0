Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2FB63A9DE
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiK1Noc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiK1NoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:44:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC861F9E6;
        Mon, 28 Nov 2022 05:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qS8ODEKev60YHO+6HrwBxTfZFnl00UJ2Q77ODdQB6PA=; b=pJV1Pldne+PlQo6f8I86laTRrD
        Drh7PP1I3aJM6mAF0JzcAC1vpSgN68sf/c4xvjToI2jldULH9ij4oAHWDf7jV7A1oXWvJCr9eEO4t
        IDaxpwg2Yim1nInuT4769jsz2KkzIi5Vd26yITcJI/VaGyZFbjb98DA74zOTIzTyjCgk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeQe-003eoc-Kl; Mon, 28 Nov 2022 14:44:12 +0100
Date:   Mon, 28 Nov 2022 14:44:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 4/6] can: etas_es58x: remove es58x_get_product_info()
Message-ID: <Y4S7LB0ThF4jZ0Bj@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126162211.93322-5-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 01:22:09AM +0900, Vincent Mailhol wrote:
> Now that the product information is available under devlink, no more
> need to print them in the kernel log. Remove es58x_get_product_info().
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

There is a slim chance this will break something paring the kernel
log, but you are not really supposed to do that.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
