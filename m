Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DCA54EA14
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378211AbiFPTYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377879AbiFPTYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:24:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A822345AED
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lBT1G7RynwTp8dkQce0pOvTGiaRef51nMQ33LRkIZz8=; b=vZG+ci5Ghq6UHtpJxvwunyTfnV
        1l3Oz0OL4FMBcOt1HHVrareO8q/hcsw6iu5a5dyu3nPiWuPsunYQg2VbQhsKd8F8yDT9R1yG4RkmL
        9iN8anRKVeDZ/awLEEH4mmnUoNb22/GVhgn+jHdVBH9l7r30q8j4x7vhVWEvE1UUcQQw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1v6G-007EEF-C6; Thu, 16 Jun 2022 21:24:16 +0200
Date:   Thu, 16 Jun 2022 21:24:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: txgbe: Add build support for txgbe
Message-ID: <YquDYCltyKfEjA93@lunn.ch>
References: <20220616095308.470320-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616095308.470320-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +err_ioremap:
> +err_alloc_etherdev:
> +	pci_release_selected_regions(pdev,
> +				     pci_select_bars(pdev, IORESOURCE_MEM));
> +err_pci_reg:
> +err_dma:
> +	pci_disable_device(pdev);
> +	return err;
> +}

It is unusual to have a label without any code. I would suggest you
remove err_ioramp and err_pce_reg.

Apart from that, and assuming the compiler testing does not find
anything:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
