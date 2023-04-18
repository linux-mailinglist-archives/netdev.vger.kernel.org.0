Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946B56E55F3
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDRAhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDRAhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:37:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9824244A5;
        Mon, 17 Apr 2023 17:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YgrOf//IL/1foKajTiJBQ08APBjwu9zxt5R/i72bj48=; b=F/d/Ipwfy4TmAwDG9NW0EOQ5vU
        BridkUyjwI+lkOKtxdCY6ceh3jyFu2Alw2gv/yfVTzvk+GBhLECbUFPtS1bebdo3CeTGXVhekZOQD
        ZRBmnc7W0WcXKfBJBzppAk1aoVOhDoeuCXzlPhAyNdfhByWPlLPF83BhqLWghYUgfZrI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poZL7-00AYEa-7Y; Tue, 18 Apr 2023 02:36:57 +0200
Date:   Tue, 18 Apr 2023 02:36:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Message-ID: <115a0204-1037-4615-a250-70db8d5ae300@lunn.ch>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417170741.1714310-1-shmuel.h@siklu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 08:07:38PM +0300, Shmuel Hazan wrote:
> This patch series adds support for PTP event capture on the Aramda
> 80x0/70x0. This feature is mainly used by tools linux ts2phc(3) in order
> to synchronize a timestamping unit (like the mvpp2's TAI) and a system
> DPLL on the same PCB. 
> 
> The patch series includes 3 patches: the second one implements the
> actual extts function.
> 
> Changes in v2:
> 	* Fixed a deadlock in the poll worker.
> 	* Removed tabs from comments.

The other think the NETDEV FAQ says is to wait at least 24 hours
before posting a new version. That give people time to actually review
the code, and likely the current version, not an old version.

    Andrew
