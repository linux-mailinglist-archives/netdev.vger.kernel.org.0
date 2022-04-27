Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A3510D37
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356367AbiD0AhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiD0AhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:37:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D603585A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A89D61A8E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00051C385A4;
        Wed, 27 Apr 2022 00:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651019650;
        bh=w8xOCgz07U6QLDdN1TlVIYIPxUDnYGMJhvye/e+Xq+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9r5Swi9RF5uZq/NT+5UF3nO28x9iQj0yhn1AYSzHRrk56Fx4JQMatRTMp/kiXZ9E
         kJcDheQ/d1uxHds9JWEt1NlA1kyH07azSfZF0pZ3R1QbafOHBovFZagC5/j9Wpo2Iy
         peLf1f2GQXjI/vvxLlYJ9yovB/xCBulmqYBSRoHj3UGWg2evkuuUzenyYCKSxIor8l
         LuqBLLpqC6jkBo1Zm7ui2ookfgRfMQmVdWRw9r+svF4uo58J+Wa2sONpWWy6qJb0XW
         Ws+fTi4FsnzMufJ/k4Y8PrvIXed5fXAKWL+0VHvurBQcu1AsJ1kxh303j6mFHGqJX5
         rFVCYMk69V7Jw==
Date:   Tue, 26 Apr 2022 17:34:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next] net: dsa: mt753x: fix pcs conversion
 regression
Message-ID: <20220426173408.24ddf574@kernel.org>
In-Reply-To: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
References: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 22:28:02 +0100 Russell King (Oracle) wrote:
> Reported-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Fixes: cbd1f243bc41 ("net: dsa: mt7530: partially convert to phylink_pcs")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> 
> Fixes line added so people know which net-next commit is affected;
> this is only in net-next at present. If you think it's unnecessary,
> please remove when applying the patch, or let me know and I will
> resend.

Not at all, FWIW it's very useful.
