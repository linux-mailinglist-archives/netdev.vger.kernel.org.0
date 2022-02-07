Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA1C4ACDAB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245695AbiBHBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245742AbiBGXaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:30:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479E5C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 15:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=celx2ES4IjUrlg3ujO49ac+FR0AgAhyQ5+H4uvYQYqQ=; b=YtNTflKnbjRhtIN/0ja7v5kGsl
        JZwiqfbyX6t04Jih79Dlf98ScYoDZxs5nue3Wh5PRcWKGTdRZMk2AdaX8i6YZqlToaLhwJikvwp+H
        femlTKbfcJYzH41MP5gMKAsN+1WGaIOYUE/zPAaz1HbO8774z1qX0IoVnP8LG9xBu+sA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHDSJ-004ibG-Lr; Tue, 08 Feb 2022 00:29:59 +0100
Date:   Tue, 8 Feb 2022 00:29:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v2 2/2] net: phy: micrel: add Microchip KSZ 9477 to the
 device table
Message-ID: <YgGrd2SJj5mIo5b6@lunn.ch>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <20220207174532.362781-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207174532.362781-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 06:45:36PM +0100, Enguerrand de Ribaucourt wrote:
> PHY_ID_KSZ9477 was supported but not added to the device table passed to
> MODULE_DEVICE_TABLE.
> 
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

I'm pretty sure i gave a reviewed-by: for this patch. Please add such
tags when you repost.

     Andrew
