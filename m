Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355CD662BA6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbjAIQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjAIQuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:50:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF8E13F91
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 08:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7QJcxuFW1iROFOzz2zYlSVhBexhFj/kr5yA2w28fAhM=; b=rfX8ecD2NK7tAPErlaXhK7Ul0q
        nnZUJjD68WtOQDZ+xOhRGGXLWfpvgkqkWXXDmPFOVg0TN0uputLivWbJitdsYsCsTubII8hBgc9yC
        e2plPIbsgp8ftdwn7riBSKnJinTPcRpms4Tee3U+kblx4EBYbxYlC1FOOZhRy74Mw50A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEvKi-001aS5-LF; Mon, 09 Jan 2023 17:49:12 +0100
Date:   Mon, 9 Jan 2023 17:49:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v7] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y7xFiNoTS6FdQa97@lunn.ch>
References: <20230109153508.37084-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109153508.37084-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 11:35:08PM +0800, Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
