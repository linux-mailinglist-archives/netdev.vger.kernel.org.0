Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568B16C579C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjCVUao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCVUaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2600F99C3E;
        Wed, 22 Mar 2023 13:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1506F622C7;
        Wed, 22 Mar 2023 20:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2673C433D2;
        Wed, 22 Mar 2023 20:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679516106;
        bh=UucUhJKbwrEMZrCr4rSyAECp/zj+/SZPYe8j26PrTv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kkM5lo9aJ73JUabezpXGMQaJoNY/3FlSprqd7sLJ3rGUpUrOsNjqvK0AL6xFJG1vu
         z59v5GbnJogtT+yjwZkZQlxNME7fEWxYK2PRa6+9GunoZCqFmCm8vrnQOjSFUexCfA
         5dN6SUTiTGIcGhJY8YgJpJyABDb/0Pq7KvgwyrU1x1I5CRwOCmiuqFZSvtl0TPgTyP
         hs6nglja+d4AMsaWpQYTklGr6tYqHgnGbyiguKITC6aA8/5OP9YGLLKDgoGU0jEk84
         Zng3S9GvQKB2dpiTZvzp+C1tDWDoLMg7nw6R+xp5XgxxeNuaum907hQU7tuw2awx2U
         qxuVxsEp00kTA==
Date:   Wed, 22 Mar 2023 13:15:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leo Li <leoyang.li@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        David Bauer <mail@david-bauer.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viorel Suman <viorel.suman@nxp.com>,
        Wei Fang <wei.fang@nxp.com>
Subject: Re: [PATCH RESEND v2 1/2] net: phy: at803x: fix the wol setting
 functions
Message-ID: <20230322131505.132a716f@kernel.org>
In-Reply-To: <AM0PR04MB6289A4E1DA8BEAA065714B328F869@AM0PR04MB6289.eurprd04.prod.outlook.com>
References: <20230301030126.18494-1-leoyang.li@nxp.com>
        <20230303172847.202fa96e@kernel.org>
        <AM0PR04MB6289A4E1DA8BEAA065714B328F869@AM0PR04MB6289.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 19:55:56 +0000 Leo Li wrote:
> > Given the fixes tag Luo Jie <luoj@codeaurora.org> should be CCed.  
> 
> Sorry for the late response, I missed this email.  I tried to cc him,
> but the email bounced.

I see, let me add them to the ignored addresses list.
