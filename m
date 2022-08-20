Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D17859B009
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 21:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiHTT5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 15:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHTT5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 15:57:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807503DBDA;
        Sat, 20 Aug 2022 12:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jCL32R3omIa/bFxZYTayIC3hc5d8VijYswMvdRt0kfM=; b=v/rh+RtBn12Gb7zcHBZ7kKjLCS
        4W8uInYkNK3LuwJWjlm88cS1csGVSeRyrFzhz3xOUxy5jbq2e6owu/qfCdTsdhilejcUsbx9MYyKq
        3Hu7Vv7+GajcJgL5uH82bV0RMvtElOtv3yFA7Qua19+ggM6wcsYyzOebERzf+qMhK7NA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPUb0-00E4F9-CG; Sat, 20 Aug 2022 21:57:26 +0200
Date:   Sat, 20 Aug 2022 21:57:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com, vigneshr@ti.com, lkp@intel.com
Subject: Re: [PATCH v3 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Message-ID: <YwE8pob0SOiHZ7K7@lunn.ch>
References: <20220817094406.10658-1-r-gunasekaran@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817094406.10658-1-r-gunasekaran@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:14:06PM +0530, Ravi Gunasekaran wrote:
> On the CPSW and ICSS peripherals, there is a possibility that the MDIO
> interface returns corrupt data on MDIO reads or writes incorrect data
> on MDIO writes. There is also a possibility for the MDIO interface to
> become unavailable until the next peripheral reset.
> 
> The workaround is to configure the MDIO in manual mode and disable the
> MDIO state machine and emulate the MDIO protocol by reading and writing
> appropriate fields in MDIO_MANUAL_IF_REG register of the MDIO controller
> to manipulate the MDIO clock and data pins.
> 
> More details about the errata i2329 and the workaround is available in:
> https://www.ti.com/lit/er/sprz487a/sprz487a.pdf
> 
> Add implementation to disable MDIO state machine, configure MDIO in manual
> mode and achieve MDIO read and writes via MDIO Bitbanging
> 
> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
> Reported-by: kernel test robot <lkp@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
