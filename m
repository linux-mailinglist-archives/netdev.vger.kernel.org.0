Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6622763A9E5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiK1NpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbiK1Nou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:44:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B4B1EC40;
        Mon, 28 Nov 2022 05:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pNAUCiEQQ+LrJi3r08klyncOvZManLlPM8GnBS/MGrA=; b=uZVI3SbigWjbPPM2fkkIm2FsdG
        UJ/jhBfD1b4u8Mtuh7ICevQlHWTNQMsbeC6SjoUunY9XqE/zoSFAffNZ7AdYWXi3V0oqQJf+4/9Fs
        844MVBCNUQD5s5zSZ2TV2B4lUOrdtysiTw/4Lg32pFgkPcXBl7kRPEXq3rcWKSVBjheA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeRC-003epG-Qf; Mon, 28 Nov 2022 14:44:46 +0100
Date:   Mon, 28 Nov 2022 14:44:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 5/6] can: etas_es58x: report the firmware version
 through ethtool
Message-ID: <Y4S7Th+Ze7/lnHnj@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 01:22:10AM +0900, Vincent Mailhol wrote:
> Implement ethtool_ops::get_drvinfo() in order to report the firmware
> version.
> 
> Firmware version 0.0.0 has a special meaning and just means that we
> could not parse the product information string. In such case, do
> nothing (i.e. leave the .fw_version string empty).
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
