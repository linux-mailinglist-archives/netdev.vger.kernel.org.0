Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E004C59B581
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiHUQpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiHUQpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:45:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CE81AD92
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yFMNSnmj7C8UmIwLtlsYTL6TUIypc0t7yTNxPd1HbSY=; b=K9uGQNnS2q2inPV+R26e08ZRlv
        etfR7CtrwlbJSxc3kds0gHj+Rbxi8xfT2yJN3KCsCPqCjRpQUHJ94AKiZH1JpLFuqKt9WeZcToKSJ
        Fjg/yTaRcJ1E0IqU7H46iao++Ewg8xn9+EG7/No4iufFEUaKNctrkTPZdncslBSksFqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPo4Y-00E9Kd-5h; Sun, 21 Aug 2022 18:45:14 +0200
Date:   Sun, 21 Aug 2022 18:45:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH] net: ftmac100: set max_mtu to allow DSA overhead setting
Message-ID: <YwJhGjCu6y/T5k79@lunn.ch>
References: <20220821160844.474277-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821160844.474277-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 07:08:44PM +0300, Sergei Antonov wrote:
> In case ftmac100 is used with a DSA switch, Linux wants to set MTU
> to 1504 to accommodate for DSA overhead. With the default max_mtu
> it leads to the error message:
>  ftmac100 92000000.mac eth0: error -22 setting MTU to 1504 to include DSA overhead
> 
> ftmac100 supports packet length 1518 (MAX_PKT_SIZE constant), so it is
> safe to report it in max_mtu.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
