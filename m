Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1B6ECBA6
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjDXL46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjDXL45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:56:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155BF4487;
        Mon, 24 Apr 2023 04:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MtsLW4d1n4qxZAyNGKNu8MdKeZ+rUviA1nhEexKNVKE=; b=GQURdknGFoDSPPpyJrEyNvNBaD
        smr5vVOj3hoONFSVdWuYGTWfXpW/GDSGpbeaPflQ4eYnMsS2uVo6Lo/zBjUP8eIZbcB9vqIZVmYkw
        fzKLhU8dXN37ZXn0VUHQgRVE+ZxGhmxBkLMrhuqy/Ze3g0Xb9wkzj8iWYgVAZ7v6qUCk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pquo8-00B5Cm-7G; Mon, 24 Apr 2023 13:56:36 +0200
Date:   Mon, 24 Apr 2023 13:56:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix the PTP interrupt
 enabling/disabling
Message-ID: <077d3578-4475-4195-9018-392edd34d4e5@lunn.ch>
References: <20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com>
 <20230412204414.72e89e5b@kernel.org>
 <36cab8c2-1901-a263-a7db-b7de486bfbeb@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36cab8c2-1901-a263-a7db-b7de486bfbeb@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Also why ignore the return value?
> This register might not be present on every PHY, that's why the return value
> is ignored.

Please document that, otherwise you might see people add code to check
the return value. Or better, still, differentiate between the
different versions, and only touch it when it does exist.

	  Andtrew
