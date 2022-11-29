Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE363C111
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiK2Ncj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiK2Nch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:32:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBAB1134;
        Tue, 29 Nov 2022 05:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4WfKFE855g4aYPWa1PlPctAvnu0Rng8EtAhvBUpBVLw=; b=TRGuiPx5Qvn4d++NVEk4kXtXAN
        LFytMrH9LvmGqwzTakP8tkNjOAOWQQvlUBSB5UilKV7TbL8D3lsomwoGk4Y441G7BmBZUkKyt91gr
        3BajQDNop3pzMpN5jM0l2YVAvmH7s7jnH0Gz2V5JsexeTcHri0lkGgMkYSjQ/2gYpj3M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p00hn-003s2I-N5; Tue, 29 Nov 2022 14:31:23 +0100
Date:   Tue, 29 Nov 2022 14:31:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chukun Pan <amadeus@jmu.edu.cn>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: motorcomm: change the phy id of yt8521 to
 lowercase
Message-ID: <Y4YJq2+6HC/F2yiz@lunn.ch>
References: <20221129080005.24780-1-amadeus@jmu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129080005.24780-1-amadeus@jmu.edu.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:00:05PM +0800, Chukun Pan wrote:
> The phy id is usually defined in lower case, also align the indents.
> 
> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
