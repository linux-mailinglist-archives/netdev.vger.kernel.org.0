Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC124FBB71
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiDKMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiDKMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:00:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F6E3150B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LtYxfbH/M/iuWju+J4Mk67f+vcs48sqQdxq3tkYJbow=; b=sp4a5X0R5ggbCCr02DkCOQ6hrU
        nYtSvDGXwTOZYnK5uOzjDx0w+P803WL1OuZPpgSMpC9iCKOVNhTaMwgYq4WUxhdW95iK3gODTh/95
        NVWFr5yBvKiVi345DTt6wr7k52m2JkGGwYwYidIhOcHIsDez6pFCgwPMHuKq/GCwHTro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ndsgE-00FFYK-FR; Mon, 11 Apr 2022 13:58:02 +0200
Date:   Mon, 11 Apr 2022 13:58:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH v3 net-next 2/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <YlQXyppP9TGxdHoU@lunn.ch>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <e34cc026163547c7921b1327f4846543fca17aee.1649528984.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e34cc026163547c7921b1327f4846543fca17aee.1649528984.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 08:39:11PM +0200, Lorenzo Bianconi wrote:
> Introduce support for the page_pool_get_stats API to mvneta driver
> Report page_pool stats through ethtool.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
