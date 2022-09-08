Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C755B29EC
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIHXKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIHXKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:10:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA87EC774
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 16:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u5HLUiULKmNkCUdsXyAr/6Rufiszya0EB6TIB0Ka/DE=; b=lP6tASb3DJwnqHlVfUrx9KFA2+
        wgMV//BgbTSOPsFDS15xckez3Q55J5vQppJ++Lya3W++cRHoHEKHb6VjDoql0OlCRPKCuomiYGWjQ
        jzxYwYfiu2mwJhpIeqR+nieXhgDDf/Ig0w1XMlad8fKPIR8z+vAKITK7/6ziuFF14jJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWQfK-00G1Gt-CL; Fri, 09 Sep 2022 01:10:34 +0200
Date:   Fri, 9 Sep 2022 01:10:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v7 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Message-ID: <Yxp2avlamxOD7x3Y@lunn.ch>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908132109.3213080-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 03:21:04PM +0200, Mattias Forsblad wrote:
> Add RMU enable functionality for some Marvell SOHO switches.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Hi Mattias

When you receive a Reviewed-by: or Acked-by: for a patch, please add
it to future version, unless you make big changes.

   Andrew
