Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7254E9E7
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347011AbiFPTSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiFPTSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:18:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5117318B3C;
        Thu, 16 Jun 2022 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jZfgSA9v1Z1Su+Cx12W2LoS3FKWSJpZxzn6jLGZg2J8=; b=H2Xtnn9Pn5dFGav+8HY1WP0R8d
        VFfJsUAZ4Au8S5z/MjVXvQ+ehiWJcT3xmIqa+AZdfq4tJ6Qm20B0WAQSbqn73by3yTlYEhvtqQrHg
        4QNM1o6mURhDnNXAqQP2Rtg6LEYADPJcCfCNTP7wSiCYk92RoDg71o2oR9qnhN4dXMNU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1v0y-007ECY-Kh; Thu, 16 Jun 2022 21:18:48 +0200
Date:   Thu, 16 Jun 2022 21:18:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, lxu@maxlinear.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        bryan.whitehead@microchip.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next V2 4/4] net: phy: add support to get
 Master-Slave configuration
Message-ID: <YquCGCJIlmQ3B/H4@lunn.ch>
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
 <20220616041226.26996-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616041226.26996-5-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\On Thu, Jun 16, 2022 at 09:42:26AM +0530, Raju Lakkaraju wrote:
> Add support to Master-Slave configuration and state
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
> Changes:                                                                        
> V0 -> V1:                                                                       
>   1. Remove the gpy_master_slave_cfg_get() function and use the                 
> genphy_read_master_slave() funtion.

So much easier isn't it to make use of existing helpers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
